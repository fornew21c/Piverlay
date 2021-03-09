//
//  PhotoGridPresenter.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/08.
//

import Foundation
import Photos

protocol PhotoGridView: NSObjectProtocol {
    //ActivityIndicator 함수
    func startLoading()
    func finishLoading()
    
    //사진이 존재하는 경우 처리 함수
    func setPhotoGrid(photoGrid: PHFetchResult<PHAsset>)
    
    //사진이 비어있는 경우 처리 함수
    func setEmptyPhotoGrid()
}

class PhotoGridPresenter {
    private var photoGridView: PhotoGridView?
    
    func attachView(view: PhotoGridView) {
        photoGridView = view
    }
    
    func detachView() {
        photoGridView = nil
    }
}
