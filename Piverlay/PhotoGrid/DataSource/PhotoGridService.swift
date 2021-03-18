//
//  PhotoGridService.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/18.
//

import Foundation
import Photos

class PhotoGridService {
    var photoGridList : PHFetchResult<PHAsset>!
    
    func getPhotoGridList(_ callBack:@escaping (PHFetchResult<PHAsset>) -> Void) {
        callBack(self.photoGridList)
    }
    
    func setPhotoGridList(photoGridList: PHFetchResult<PHAsset>) {
        self.photoGridList = photoGridList
    }
}
