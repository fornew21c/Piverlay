//
//  PhotoAlbumPresenter.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/08.
//

import Photos

protocol PhotoAlbumView: NSObjectProtocol {
    //ActivityIndicator 함수
    func startLoading()
    func finishLoading()
    
    //앨범이 존재하는 경우 처리 함수
    func setPhotoAlbumList(photoAlbumList: [PhotoAlbum])
    
    //앨범이 비어있는 경우 처리 함수
    func setEmptyPhotoAlbumList()
}

class PhotoAlbumPresenter {
    private let photoAlbumService: PhotoAlbumService
    private var photoAlbumView: PhotoAlbumView?
    
    init(photoAlbumService: PhotoAlbumService) {
        self.photoAlbumService = photoAlbumService
    }
    
    func attachView(view: PhotoAlbumView) {
        photoAlbumView = view
    }
    
    func detachView() {
        photoAlbumView = nil
    }
    
    func getPhotoAlbumList() {
        self.photoAlbumView?.startLoading()
        photoAlbumService.getPhotoAlbumList { [weak self] photoAlbumList in
            self?.photoAlbumView?.finishLoading()
            if(photoAlbumList.count == 0) {
                //앨범이 없는 경우
                self?.photoAlbumView?.setEmptyPhotoAlbumList()
            } else {
                //앨범이 있는 경우
                self?.photoAlbumView?.setPhotoAlbumList(photoAlbumList: photoAlbumList)
            }
        }
    }
}
