//
//  GlovalVariables.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//  Copyright © 2021년 wisetracker. All rights reserved.
//

import UIKit

// 프로젝트 전역에서 사용될 글로벌 변수 : 싱글톤 방식
class GlobalVariables: NSObject {
    static let sharedInstance = GlobalVariables()
    
    var overlayOrgImgaeList : [UIImage] = []
    let svgImgURL: String = "https://mysvgimage.s3.ap-northeast-2.amazonaws.com/"
    let photoAlbumTableViewCellHeight : CGFloat = 80
}
