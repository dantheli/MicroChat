//
//  Classes+Extensions.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit

extension UIView {
    func fadeHide() {
        UIView.animateWithDuration(UIViewFadeDuration, animations: {
            self.alpha = 0.0
            }, completion: { Void in
                self.hidden = true
        })
    }
    func fadeShow() {
        self.alpha = 0.0
        self.hidden = false
        UIView.animateWithDuration(UIViewFadeDuration) {
            self.alpha = 1.0
        }
    }
    func fadeRemoveFromSuperView() {
        UIView.animateWithDuration(UIViewFadeDuration, animations: {
            self.alpha = 0.0
            }, completion: { Void in
                self.removeFromSuperview()
        })
    }
}

extension UINavigationController {
    func setTheme() {
        navigationBar.barTintColor = UIColor.navigationBar()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barStyle = .Black
        navigationBar.translucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        extendedLayoutIncludesOpaqueBars = true
    }
}

extension UIViewController {
    func displayError(error: NSError, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { Void in
            completion?()
            })
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func fadeCells(cells: [UITableViewCell]) {
        for (index, cell) in cells.enumerate() {
            UIView.animateWithDuration(UITableViewCellFadeDuration, delay: UITableViewCellFadeDelay * Double(index), options: [.AllowUserInteraction], animations: {
                cell.alpha = 1.0
                }, completion: nil)
        }
    }
}