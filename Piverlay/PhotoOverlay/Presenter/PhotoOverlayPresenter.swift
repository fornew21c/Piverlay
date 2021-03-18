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
    var receivedOverlayOrgImgaeList : [UIImage] = []
    
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
        photoOverlayView?.startLoading()
        photoOverlayService.getOverlayImageList { [weak self] overlayImageList in
            photoOverlayView?.finishLoading()
            if(overlayImageList.count != 0) {
                //합성할 이미지가 있는 경우
                self?.photoOverlayView?.setOverlayImageList(overlayImageList: overlayImageList)
            }
        }
    }
    
    func getOrgOverlayImageList() {
        photoOverlayView?.startLoading()
        if( GlobalVariables.sharedInstance.overlayOrgImgaeList.count == 0) {
            // 이미지 가져오기 비동기 처리
            DispatchQueue.global(qos: .default).async(execute: { [self] in
                // 작업이 오래 걸리는 API를 백그라운드 스레드에서 실행한다.
                self.photoOverlayService.getOrgOverlayImageList { [weak self] overlayOrgImageList in
                    self?.photoOverlayView?.finishLoading()
                    GlobalVariables.sharedInstance.overlayOrgImgaeList = overlayOrgImageList
                }
                DispatchQueue.main.async(execute: { [self] in
                    // 이 블럭은 메인스레드(UI)에서 실행
                    if(GlobalVariables.sharedInstance.overlayOrgImgaeList.count != 0) {
                        //합성할 이미지가 있는 경우
                        self.photoOverlayView?.finishLoading()
                        self.photoOverlayView?.setOverlayOrgImageList(overlayOrgImageList: GlobalVariables.sharedInstance.overlayOrgImgaeList)
                    }
                })
            })
        } else {
            self.photoOverlayView?.finishLoading()
            self.photoOverlayView?.setOverlayOrgImageList(overlayOrgImageList: GlobalVariables.sharedInstance.overlayOrgImgaeList)
        }
    }
}
