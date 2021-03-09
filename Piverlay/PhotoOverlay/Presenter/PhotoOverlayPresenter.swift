//
//  PhotoOverlayPresenter.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/09.
//

import Foundation
import Photos
import UIKit

protocol PhotoOverlayView: NSObjectProtocol {
    //ActivityIndicator 함수
    func startLoading()
    func finishLoading()
    //합성이미지 세팅함수
    func setOverlayImageList(overlayImageList:[String])
    func setOverlayOrgImageList(overlayOrgImageList:[UIImage])
}

class PhotoOverlayPresenter {
    private let photoOverlayService: PhotoOverlayService
    private var photoOverlayView: PhotoOverlayView?
    
    //init 함수
    init(photoOverlayService: PhotoOverlayService) {
        self.photoOverlayService = photoOverlayService
    }
    
    func attachView(view: PhotoOverlayView) {
        photoOverlayView = view
    }
    
    func detachView() {
        photoOverlayView = nil
    }
    
    //합성이미지 리스트 get함수
    func getOverlayImageList() {
        self.photoOverlayView?.startLoading()
        photoOverlayService.getOverlayImageList { [weak self] overlayImageList in
            self?.photoOverlayView?.finishLoading()
            if(overlayImageList.count != 0) {
                //합성할 이미지가 있는 경우
                self?.photoOverlayView?.setOverlayImageList(overlayImageList: overlayImageList)
            }
        }
    }
    
    func getOrgOverlayImageList() {
        self.photoOverlayView?.startLoading()
        photoOverlayService.getOrgOverlayImageList { [weak self] overlayOrgImageList in
            self?.photoOverlayView?.finishLoading()
            if(overlayOrgImageList.count != 0) {
                //합성할 이미지가 있는 경우
                self?.photoOverlayView?.setOverlayOrgImageList(overlayOrgImageList: overlayOrgImageList)
            }
        }
    }
}
