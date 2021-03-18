//
//  PhotoAlbumPresenter.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/08.
//

import Photos

protocol PhotoAlbumViewDelegate: NSObjectProtocol {
    //ActivityIndicator 함수
    func startLoading()
    func finishLoading()
    
    //앨범이 존재하는 경우 처리 함수
    func setPhotoAlbumList(photoAlbumList: [PhotoAlbum])
    
    //앨범이 비어있는 경우 처리 함수
    func setEmptyPhotoAlbumList()
    
    //앨범 선택 시 포토리스트 화면전환 함수
    func pushPhotoList(nextPresenter: PhotoGridPresenter, title:String)
    
    func reload()
}

class PhotoAlbumPresenter {
    private let photoAlbumService: PhotoAlbumService
    private var photoAlbumViewDelegate: PhotoAlbumViewDelegate!
    private var imageMannger: PHCachingImageManager
    
    init(photoAlbumService: PhotoAlbumService) {
        self.photoAlbumService = photoAlbumService
        imageMannger = PHCachingImageManager()
    }
    
    func setViewDelegate(photoAlbumViewDelegate: PhotoAlbumViewDelegate) {
        self.photoAlbumViewDelegate = photoAlbumViewDelegate
    }
    
    func getPhotoAlbumList() {
        //photoAlbumViewDelegate.startLoading()
        photoAlbumService.getPhotoAlbumList { [weak self] photoAlbumList in
            //self?.photoAlbumViewDelegate?.finishLoading()
            if(photoAlbumList.count == 0) {
                //앨범이 없는 경우
                self?.photoAlbumViewDelegate?.setEmptyPhotoAlbumList()
            } else {
                //앨범이 있는 경우
                self?.photoAlbumViewDelegate?.setPhotoAlbumList(photoAlbumList: photoAlbumList)
            }
        }
    }
    
    var photoAlbumListCount: Int {
        return photoAlbumService.photoAlbumList.count;
    }
    
    func configure(cell: PhotoAlbumCell, row: Int) {
        let photoAlbum = photoAlbumService.photoAlbumList[row]
        let firstPhoto = photoAlbum.fetchResult.firstObject!
        imageMannger.requestImage(for: firstPhoto, targetSize: CGSize(width: 40.0, height: 40.0), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
            cell.photoImageView.image = image
        }
        let itemDic: Dictionary<String, String> = ["title" : photoAlbum.title!, "count" : "(\(photoAlbum.fetchResult.count))"]
        
        //UITest를 위한 cell의 accessibilityIdentifier 세팅
        cell.accessibilityIdentifier = "PhotoAlbumCell_\(row)"
        
        //Cell 데이터 세팅 함수 호출
        cell.setupWithDictionary(itemDic)
    }
}
