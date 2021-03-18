//
//  PhotoGridCell.swift
//  Photos
//
//  Created by 张晓鑫 on 2017/6/1.
//  Copyright © 2017年 Wang. All rights reserved.
//

import UIKit

class PhotoGridCell: UICollectionViewCell {
    
    var imageView: UIImageView! = UIImageView()
    var assistantLabel: UILabel = UILabel()
    
    var duration: TimeInterval = 0 {
        didSet {
            let newValue = Int(ceil(duration))
            assistantLabel.text = String(format: "%d:%02d", arguments: [newValue / 60, newValue % 60])
            assistantLabel.isHidden = false            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        assistantLabel.textColor = PLUtil.UIColorFromRGB(rgbValue: 0xffffff)
        addSubview(assistantLabel)
        assistantLabel.isHidden = true
        assistantLabel.translatesAutoresizingMaskIntoConstraints = false

        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: assistantLabel, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: assistantLabel, attribute: .bottom, multiplier: 1, constant: 8))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
