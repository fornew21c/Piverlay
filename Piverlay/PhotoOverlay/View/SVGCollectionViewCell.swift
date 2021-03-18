//
//  SVGCollectionViewCell.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//

import UIKit

class SVGCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
    }

}
