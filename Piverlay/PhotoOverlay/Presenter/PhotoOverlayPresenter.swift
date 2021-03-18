//
//  PhotoOverlayPresenter.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/09.
//

import Foundation
import Photos
import UIKit

protocol PhotoOverlayViewDelegate: NSObjectProtocol {
    //ActivityIndicator 함수
    func startLoading()
    func finishLoading()
    //합성이미지 세팅함수
    func setOverlayImageList(overlayImageList:[String])
    func setOverlayOrgImageList(overlayOrgImageList:[UIImage])
}

class PhotoOverlayPresenter {
    private let photoOverlayService: PhotoOverlayService
    private var photoOverlayViewDelegate: PhotoOverlayViewDelegate?
    var receivedOverlayOrgImgaeList : [UIImage] = []
    
    //init 함수
    init(photoOverlayService: PhotoOverlayService) {
        self.photoOverlayService = photoOverlayService
    }
    
   
    func setViewDelegate(photoOverlayViewDelegate: PhotoOverlayViewDelegate) {
        self.photoOverlayViewDelegate = photoOverlayViewDelegate
    }
    
    //합성이미지 리스트 get함수
    func getOverlayImageList() {
        photoOverlayViewDelegate?.startLoading()
        photoOverlayService.getOverlayImageList { [weak self] overlayImageList in
            photoOverlayViewDelegate?.finishLoading()
            if(overlayImageList.count != 0) {
                //합성할 이미지가 있는 경우
                self?.photoOverlayViewDelegate?.setOverlayImageList(overlayImageList: overlayImageList)
            }
        }
    }
    
    func getOrgOverlayImageList() {
       
        if( GlobalVariables.sharedInstance.overlayOrgImgaeList.count == 0) {
            photoOverlayViewDelegate?.startLoading()
            // 이미지 가져오기 비동기 처리
            DispatchQueue.global(qos: .default).async(execute: { [self] in
                // 작업이 오래 걸리는 API를 백그라운드 스레드에서 실행한다.
                self.photoOverlayService.getOrgOverlayImageList { [weak self] overlayOrgImageList in
                    self?.photoOverlayViewDelegate?.finishLoading()
                    GlobalVariables.sharedInstance.overlayOrgImgaeList = overlayOrgImageList
                }
                DispatchQueue.main.async(execute: { [self] in
                    // 이 블럭은 메인스레드(UI)에서 실행
                    if(GlobalVariables.sharedInstance.overlayOrgImgaeList.count != 0) {
                        //합성할 이미지가 있는 경우
                        self.photoOverlayViewDelegate?.finishLoading()
                        self.photoOverlayViewDelegate?.setOverlayOrgImageList(overlayOrgImageList: GlobalVariables.sharedInstance.overlayOrgImgaeList)
                    }
                })
            })
        } else {
            photoOverlayViewDelegate?.setOverlayOrgImageList(overlayOrgImageList: GlobalVariables.sharedInstance.overlayOrgImgaeList)
        }
    }
    
    // 이미지 합성 함수
    func makeOverlayedImage(bottomImage: UIImage, topImage: UIImage) -> UIImage {
        let size = CGSize(width: bottomImage.size.width, height: bottomImage.size.height)
        UIGraphicsBeginImageContext(size)
    
        let bottomAreaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let topAreaSize = CGRect(x: bottomImage.size.width/2 - 150, y: bottomImage.size.height/2 - 150, width: 300, height: 300)
        bottomImage.draw(in: bottomAreaSize)
        topImage.draw(in: topAreaSize, blendMode: .normal, alpha: 1)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func configure(cell: SVGCollectionViewCell, row: Int, overlayImageListType: OverlayImageListType) {
        //UITest를 위한 cell의 accessibilityIdentifier 세팅
        cell.accessibilityIdentifier = "overlayImageListCell_\(row)"
        if(overlayImageListType == .str) {
            cell.imageView.image = UIImage(named: photoOverlayService.overlayImageList[row])
        } else {
            cell.imageView.image = GlobalVariables.sharedInstance.overlayOrgImgaeList[row]
        }
    }
    
    //image 사이즈 조절 함수
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        // 새롭게 변경될 사이즈
        var newSize: CGSize
        if(widthRatio > heightRatio){
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio) }
        else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // 새로운 사이즈의 rect
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // 리사이징 작업
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        // 리사이징한 이미지
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


