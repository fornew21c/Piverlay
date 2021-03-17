//
//  PhotoAlbumCell.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//


import UIKit

class PhotoAlbumCell: UITableViewCell {

    //Cell 내부 UI멤버변수
    var titleLabel: UILabel = UILabel()
    var countLabel: UILabel = UILabel()
    var photoImageView: UIImageView! = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func setupWithDictionary(_ dic: Dictionary<String, String>) {
        //Cell내 UI에 데이터 세팅
        photoImageView.frame = CGRect(x: 16, y: 10, width:60, height:60)
        photoImageView.layer.cornerRadius = 10
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        self.addSubview(photoImageView)
        
        titleLabel.text = dic["title"]
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.frame = CGRect(x: 85, y: 30, width:0, height:0)
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        countLabel.text = dic["count"]
        countLabel.font = UIFont.systemFont(ofSize: 15)
        countLabel.frame = CGRect(x: 85 + titleLabel.bounds.size.width + 5, y: titleLabel.frame.minY, width:0, height: 0)
        countLabel.sizeToFit()
        self.addSubview(countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
