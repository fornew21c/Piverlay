//
//  PhotoOverlayService.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/09.
//

import Foundation
import SVGKit

class PhotoOverlayService {
    // 합성이미지 svg String 배열
    var overlayImageList : [String] = []
    // 합성이미지 uiimage 배열: url을 통해 가져온 svg image자체를 저장하기 위한 용도
    var overlayOrgImgaeList : [UIImage] = []
    
    func getOverlayImageList(_ callBack: ([String]) -> Void) {
        overlayImageList = ["001", "002", "003", "004", "005", "006", "007", "008", "009", "010", "011", "012", "013", "014"]
        callBack(overlayImageList)
    }
    
    func getOrgOverlayImageList(_ callBack: ([UIImage]) -> Void) {
        var formattingNum : String
        var index : Int = 1
        while true {
            formattingNum = String(format: "%03d", index)
            let svgUrl = URL(string: GlobalVariables.sharedInstance.svgImgURL + formattingNum + ".svg")!
            let data = try? Data(contentsOf: svgUrl)
            if(data == nil) {
                break;
            }
            let receivedimage: SVGKImage = SVGKImage(data: data)
            overlayOrgImgaeList.append(receivedimage.uiImage)
            index = index + 1
        }
        callBack(overlayOrgImgaeList)
    }
}
