//
//  PhotoAlbumService.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/08.
//

import Photos

class PhotoAlbumService {
    var albumList : [PhotoAlbum] = []
    
    func getPhotoAlbumList(_ callBack:@escaping ([PhotoAlbum]) -> Void) {
        let smartOptions = PHFetchOptions()
        
        // 기본 스마트 앨범 추가
        let smartAlbumbs = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: smartOptions)
        self.makeAlbumList(smartAlbumbs as! PHFetchResult<AnyObject>)
        
        // 사용자가 사용하는 앱의 앨범 추가
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.makeAlbumList(topLevelUserCollections as! PHFetchResult<AnyObject>)
        
        // 앨범 사진갯수로 내림차순 정렬
        albumList.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }
        callBack(self.albumList)
    }
    
    // 앨범리스트 생성 함수
    func makeAlbumList(_ collection:PHFetchResult<AnyObject>) {
        // 앨범리스트 생성
        for i in 0 ..< collection.count {
            let resultsOptions = PHFetchOptions()
            //생성날짜로 내림차순 정렬
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            guard let c = collection[i] as? PHAssetCollection else { return
            }
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            if assetsFetchResult.count > 0 {
                albumList.append(PhotoAlbum.init(title: c.localizedTitle, fetchResult: assetsFetchResult))
            }
        }
    }
}
