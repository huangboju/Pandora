//
//  ShadowView.swift
//  Aiolos
//
//  Created by Matthias Tretter on 04/08/2017.
//  Copyright © 2017 Matthias Tretter. All rights reserved.
//

import Foundation


/// Internal class that is used to display a shadow around the Panel
final class ShadowView: UIView {

    // MARK: - Lifecycle

    init(configuration: Panel.Configuration) {
        super.init(frame: .zero)

        self.configure(with: configuration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let padding: CGFloat = 15.0
        let extendedBounds = self.bounds.inset(by: UIEdgeInsets(top: -padding, left: 0.0, bottom: 0.0, right: 0.0))

        return extendedBounds.contains(point)
    }

    // MARK: - ShadowView

    func configure(with configuration: Panel.Configuration) {
        // configure shadow
        self.layer.shadowOpacity = configuration.appearance.shadowOpacity
        self.layer.shadowColor = configuration.appearance.shadowColor.cgColor
        self.layer.shadowOffset = CGSize(offset: configuration.appearance.shadowOffset)

        // configure border
        self.layer.cornerRadius = configuration.appearance.cornerRadius
        self.layer.maskedCorners = configuration.appearance.maskedCorners
        self.layer.borderColor = configuration.appearance.borderColor.cgColor
        self.layer.borderWidth = configuration.appearance.borderColor == .clear ? 0.0 : 1.0 / UIScreen.main.scale
    }
}

// MARK: - Private

private extension CGSize {

    init(offset: UIOffset) {
        self.init(width: offset.horizontal, height: offset.vertical)
    }
}
