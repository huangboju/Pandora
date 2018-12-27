//
//  CardsManager.swift
//  DynamicStackOfCards
//
//  Created by Pritesh Nandgaonkar on 9/24/16.
//  Copyright © 2016 pritesh. All rights reserved.
//

import Foundation
import UIKit

internal enum CardState {
    case expanded
    case inTransit
    case collapsed
}

class CardsManager: NSObject, CardLayoutDelegate {
    
    var fractionToMove: CGFloat = 0
    var cardState: CardState {
        didSet {
            switch cardState {
            case .inTransit:
                tapGesture.isEnabled = false
                
            case .collapsed:
                cardsDelegate?.position = .collapsed
                tapGesture.isEnabled = true
                
            case .expanded:
                cardsDelegate?.position = .expanded
                tapGesture.isEnabled = false
            }
        }
    }
    var configuration: Configuration
    
    weak var delegate: CardsManagerDelegate?
    weak var collectionView: UICollectionView?
    weak var cardsCollectionViewHeight: NSLayoutConstraint?
    weak var cardsDelegate: CardStack? = nil

    var panGesture = UIPanGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    
    var previousTranslation: CGFloat = 0

    convenience override init() {
        
        let configuration = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: 500, cardHeight: 200, downwardThreshold: 20, upwardThreshold: 20)
        
        self.init(cardState: .collapsed, configuration: configuration, collectionView: nil, heightConstraint: nil)
    }
    
    func cardsStateFromCardsPosition(position: CardsPosition) -> CardState {
        switch position {
        case .expanded:
            return CardState.expanded
        case .collapsed:
            return CardState.collapsed
        }
    }
    
    func cardsPositionFromCardsState(state: CardState) -> CardsPosition? {
        switch state {
        case .collapsed:
            return CardsPosition.expanded
        case .expanded:
            return CardsPosition.collapsed
        default:
            return nil
        }
    }

    init(cardState: CardsPosition, configuration: Configuration, collectionView: UICollectionView?, heightConstraint: NSLayoutConstraint?) {
        
        switch cardState {
        case .expanded:
            self.cardState = CardState.expanded
        case .collapsed:
            self.cardState = CardState.collapsed
        }

        self.configuration = configuration
        cardsCollectionViewHeight = heightConstraint
        self.collectionView = collectionView
        super.init()
        guard let cardsView = self.collectionView else {
            return
        }
        let cardLayout = CardLayout()
        cardLayout.delegate = self
        cardsView.collectionViewLayout = cardLayout
        cardsView.bounces = true
        cardsView.alwaysBounceVertical = true
        cardsView.delegate = self
        
        panGesture = UIPanGestureRecognizer(target: self, action:#selector(pannedCard))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCard))
        cardsView.addGestureRecognizer(panGesture)
        cardsView.addGestureRecognizer(tapGesture)
        panGesture.isEnabled = cardState == .collapsed
        tapGesture.isEnabled = cardState == .collapsed
    }
    
    @objc func tappedCard(tapGesture: UITapGestureRecognizer) {
        guard let cardsCollectionView = collectionView else {
            return
        }
        delegate?.tappedOnCardsStack?(cardsCollectionView: cardsCollectionView)
    }
    
    @objc func pannedCard(panGesture: UIPanGestureRecognizer) {

        guard let collectionView = self.collectionView else {
            return
        }
        let translation = panGesture.translation(in: collectionView.superview!)
        collectionView.collectionViewLayout.invalidateLayout()
        
        let distanceMoved = translation.y
            guard let heightConstraint = self.cardsCollectionViewHeight else {
                return
            }
            
            switch panGesture.state {
            case .changed:
                heightConstraint.constant -= distanceMoved
                
                heightConstraint.constant = Swift.min(heightConstraint.constant, configuration.expandedHeight)
                heightConstraint.constant = Swift.max(heightConstraint.constant, configuration.collapsedHeight)
                
                self.cardState = .inTransit
                self.fractionToMove = heightConstraint.constant - configuration.collapsedHeight
                self.collectionView?.isScrollEnabled = false
                
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionView?.superview?.layoutIfNeeded()
                
            case .cancelled:
                fallthrough
            case .ended:
                
                if self.previousTranslation < 0 {
                    if heightConstraint.constant > CGFloat(self.configuration.collapsedHeight + self.configuration.upwardThreshold) {
                        heightConstraint.constant = CGFloat(self.configuration.expandedHeight)
                        self.cardState = .expanded
                        self.panGesture.isEnabled = false
                    }
                    else {
                        heightConstraint.constant = CGFloat(self.configuration.collapsedHeight)
                        self.cardState = .collapsed
                        self.panGesture.isEnabled = true
                    }
                }
                else {
                    if heightConstraint.constant < CGFloat(self.configuration.expandedHeight - self.configuration.downwardThreshold) {
                        heightConstraint.constant = CGFloat(self.configuration.collapsedHeight)
                        self.cardState = .collapsed
                        self.panGesture.isEnabled = true
                    }
                    else {
                        
                        heightConstraint.constant = CGFloat(self.configuration.expandedHeight)
                        self.cardState = .expanded
                        self.panGesture.isEnabled = false
                    }
                    
                }
                self.collectionView?.isScrollEnabled = !panGesture.isEnabled
                
                UIView.animate(withDuration: 0.3, animations: { 
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                    self.collectionView?.superview?.layoutIfNeeded()
                    }, completion: { (finished) in
                        self.triggerStateCallBack()
                })
            default:
                break
            }
            
            self.previousTranslation = translation.y
            self.panGesture.setTranslation(CGPoint.zero, in: self.collectionView?.superview)
        }
    
    func triggerStateCallBack() {
        guard let position = cardsPositionFromCardsState(state: cardState) else {
            return
        }
        delegate?.cardsPositionChangedTo?(position: position)
    }
    
    func updateView(with position: CardsPosition) {
        var ht: CGFloat = 0.0
        cardState = cardsStateFromCardsPosition(position: position)
        switch cardState {
        case .collapsed:
            ht = configuration.collapsedHeight
            
        case .expanded:
            ht = configuration.expandedHeight
        default:
            return
        }
        
        DispatchQueue.main.async {
            self.cardsCollectionViewHeight?.constant = ht
            
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionView?.superview?.layoutIfNeeded()
            }, completion: { (finished) in
                self.triggerStateCallBack()
            })
        }
    }
}

extension CardsManager: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

            if scrollView.contentOffset.y < 0 {
                panGesture.isEnabled = true
                scrollView.isScrollEnabled = false
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate?.cardsCollectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.cardsCollectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
