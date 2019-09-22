//
//  AnimationMethods.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

extension MuralViewController {

    // MARK: Animation Methods
    
    
    /// Show or Close menu with an animation
    func showOrHideMenu(){
        menuIsClose = !menuIsClose
        compassMenuViewheightContraint.constant = menuIsClose ? 260 : 0
        typeMenuViewWidhContraint.constant = menuIsClose ? 260 : 0
        animateOpenCloseMenuButton(menuIsOpen: menuIsClose)
    }
    
    /// methods that animate menuButton
    func animateOpenCloseMenuButton(menuIsOpen: Bool) {
        UIView.animate(
            withDuration: 0.9,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 10,
            options: .allowUserInteraction,
            animations: {
                // Rotation of menuButton + to X
                let angle: CGFloat = self.menuIsClose ? .pi / 4 : 0.0
                
                self.menuButton.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded() // we update change
        },
            completion: nil
        )
    }
    
    /// methods that animate CompassMainButton
    func animateFadeCompassDirectionButton(toImage: UIImage) {
        //Create & set up temp view
        let temporyView = UIImageView(frame: compassDirectionButton.frame)
        temporyView.image = toImage
        temporyView.alpha = 0.0
        temporyView.center.y += 20
        temporyView.bounds.size.width = compassDirectionButton.bounds.width * 1.3
        compassDirectionButton.superview?.insertSubview(temporyView, aboveSubview: compassDirectionButton)
        
        UIView.animate(
            withDuration: 0.5,
            animations: {
                //Fade temp view in
                temporyView.alpha = 1.0
                temporyView.center.y -= 20
                temporyView.bounds.size = self.compassDirectionButton.bounds.size
        },
            completion: { _ in
                //Update background view & view temp view
                self.compassDirectionButton.setImage(toImage, for: .normal)
                self.compassDirectionButton.alpha = 1
                temporyView.removeFromSuperview()
        }
        )
    }

}
