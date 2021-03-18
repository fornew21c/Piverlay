//
//  PhotoGridPresenter.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/08.
//

import Foundation
import Photos

protocol PhotoGridViewDelegate: NSObjectProtocol {
    //ActivityIndicator 함수
    func startLoading()
    func finishLoading()
    
    //사진이 존재하는 경우 처리 함수
    func setPhotoGridList(photoGridList: PHFetchResult<PHAsset>)
    
    //사진이 비어있는 경우 처리 함수
    func setEmptyPhotoGridList()
    
    func reload()
    
    func presentOverlayView(selectedPhoto: PHAsset!)
}

class PhotoGridPresenter {
    private let photoGridService: PhotoGridService
    private var photoGridViewDelegate: PhotoGridViewDelegate?
    private var imageMannger: PHCachingImageManager
    
    init(photoGridService: PhotoGridService ) {
        self.photoGridService = photoGridService
        imageMannger = PHCachingImageManager()
    }
    
    func setViewDelegate(photoGridViewDelegate: PhotoGridViewDelegate) {
        self.photoGridViewDelegate = photoGridViewDelegate
    }
    
    func getPhotoAlbumList() {
       // photoGridViewDelegate?.startLoading()
        photoGridService.getPhotoGridList { [weak self] photoGridList in
         //   self?.photoGridViewDelegate?.finishLoading()
            if(photoGridList.count == 0) {
                //사진이 없는 경우
                self?.photoGridViewDelegate?.setEmptyPhotoGridList()
            } else {
                //사진이 있는 경우
                self?.photoGridViewDelegate?.setPhotoGridList(photoGridList: photoGridList)
            }
        }
    }
    
    var photoGridListCount: Int {
        return photoGridService.photoGridList.count;
    }
    
    func configure(cell: PhotoGridCell, row: Int, photoGridThumbnailSize: CGSize) {
        let photoGrid = photoGridService.photoGridList[row]
        cell.imageView.layer.cornerRadius = 15
        //UITest를 위한 cell의 accessibilityIdentifier 세팅
        cell.accessibilityIdentifier = "PhotoGridListCell_\(row)"
        imageMannger.requestImage(for: photoGrid, targetSize: photoGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
            cell.imageView.image = image
            //비디오인 경우 플레잉시간 표시
            switch photoGrid.mediaType {
                case .video:
                    cell.duration = photoGrid.duration
                default:
                    break
            }
        }
    }
}
