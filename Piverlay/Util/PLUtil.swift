//
//  PLUtil.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//

import UIKit

//Util Class
class PLUtil: NSObject {
    // Color RGB get함수
    @objc public class func UIColorFromRGB(rgbValue : Int, alphaDegree : CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0 ,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0 ,
                       blue: CGFloat((rgbValue & 0x0000FF)) / 255.0 ,
                       alpha: alphaDegree)
    }

    //토스트 함수
    @objc public class func showToastBlackWith(message: String){
        var topController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!
        }

        //토스트뷰 세팅
        let toastView = UILabel(frame: CGRect(x: 20, y: topController.view.frame.size.height - 120, width: topController.view.frame.size.width - 40, height: 80))
        toastView.backgroundColor = UIColorFromRGB(rgbValue: 0x3d3a45)
        toastView.alpha = 1
            //UIColor.black.withAlphaComponent(0.85)
        toastView.layer.cornerRadius = 10;
        toastView.clipsToBounds  =  true
        
        //토스트라벨 세팅
        let toastLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 280, height: 80))
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "SourceHanSansKR-Bold", size: 11)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        
        toastView.addSubview(toastLabel)
        topController.view.addSubview(toastView)
        
        UIView.animate(withDuration: 3, animations: {
             toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
    
    //bottom 토스트 함수
    @objc public class func showToastBlackBottomWith(message: String, bottomHeight: CGFloat){
        var topController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!
        }
        //토스트뷰 세팅
        let toastView = UILabel(frame: CGRect(x: topController.view.frame.size.width/2 - 120, y: topController.view.frame.size.height - bottomHeight, width: 240, height: 40))
        toastView.backgroundColor = UIColorFromRGB(rgbValue: 0x3d3a45)
        toastView.alpha = 1
            //UIColor.black.withAlphaComponent(0.85)
        toastView.layer.cornerRadius = 10;
        toastView.clipsToBounds  =  true
        
        //토스트라벨 세팅
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "SourceHanSansKR-Bold", size: 14)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        
        toastView.addSubview(toastLabel)
        topController.view.addSubview(toastView)
        
        UIView.animate(withDuration: 3, animations: {
             toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
}
