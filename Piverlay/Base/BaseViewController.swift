//
//  BaseViewController.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/17.
//

import UIKit

class BaseViewController: UIViewController {

    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView?.hidesWhenStopped = true
    }
    
    func startIndicator() {
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView?.color = PLUtil.UIColorFromRGB(rgbValue: 0x3B8BF8)
        activityView?.center = view.center
        view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func stopIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.activityView?.stopAnimating()
            self.activityView?.isHidden = true
        }
    }
}
