//
//  PhotoAlbum.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/08.
//

import Photos

//PhotoAlbum Model Class
class PhotoAlbum {
    // 앨범제목
    var title:String?
    // 앨범 PHFetchResult
    var fetchResult:PHFetchResult<PHAsset>
    //var representImage:UIImage?
   
   init(title:String?, fetchResult: PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
   }
}
