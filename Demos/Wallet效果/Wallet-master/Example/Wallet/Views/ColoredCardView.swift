
import UIKit
import Wallet

import RandomColorSwift
import DynamicColor

class ColoredCardView: CardView {

    @IBOutlet weak var contentView: UIView!
    
    let presentedCardViewColor:          UIColor = randomColor(hue: .random, luminosity: .dark).lighter()
    
    lazy var depresentedCardViewColor:   UIColor = { return self.presentedCardViewColor.lighter() }()
    
    @IBOutlet weak var indexLabel: UILabel!
    var index: Int = 0 {
        didSet {
            indexLabel.text = "# \(index)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius  = 10
        contentView.layer.masksToBounds = true
        
        presentedDidUpdate()
        
    }
    
    override var presented: Bool { didSet { presentedDidUpdate() } }
    
    func presentedDidUpdate() {
        
        removeCardViewButton.isHidden = !presented
        contentView.backgroundColor = presented ? presentedCardViewColor : depresentedCardViewColor
        contentView.addTransitionFade()
        
    }
    
    @IBOutlet weak var removeCardViewButton: UIButton!
    @IBAction func removeCardView(_ sender: Any) {
        walletView?.remove(cardView: self, animated: true)
    }
    
}
