//
//  PhotoOverlayViewController.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//

import UIKit
import Photos
import SVGKit

enum OverlayImageListType : String {
    case str = "string"
    case org = "origin"
}

class PhotoOverlayViewController: BaseViewController {
    //IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var overlayButton: UIButton!
    
    // 선택된 사진
    var selectedPhoto: PHAsset!
    var overlayImages:[String] = []
    var overlayOrgImages:[UIImage] = []
    var overlayImageListType:OverlayImageListType!
    // 이미지 매니저
    var imageMannger: PHCachingImageManager!
    
    //photoOverlayPresenter
    private let photoOverlayPresenter = PhotoOverlayPresenter(photoOverlayService: PhotoOverlayService())
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set viewDelegate
        photoOverlayPresenter.setViewDelegate(photoOverlayViewDelegate: self)
        
        //svg image를 번들에서 가져오는 방식
        //photoOverlayPresenter.getOverlayImageList()
        
        //svg image를 서버에서 url을 통해 가져오는 방식
        photoOverlayPresenter.getOrgOverlayImageList()

        // imageManager를 사용해 선택된 포토를 iMageView에 세팅
        imageMannger = PHCachingImageManager()
        imageMannger.requestImage(for: selectedPhoto, targetSize: CGSize(width: imageView.frame.width, height: imageView.frame.height), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
            self.imageView.image = image
        }
        
        //이미지뷰 컨텐츠모드 설정
        imageView.contentMode = .scaleAspectFill
       
        //collectionView 설정
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //reuseable cell 설정
        collectionView.register(UINib.init(nibName: "SVGCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SVGCollectionViewCell")
        
        //UITest를 위한 collectionView의 accessibilityIdentifier 세팅
        collectionView.accessibilityIdentifier = "overlayImageListCollectionViewIdentifier"
    }

    @IBAction func closeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //Overlay Button Touch
    @IBAction func overlayButtonTouched(_ sender: UIButton) {
        // 사진앨범에 저장
        if let unwrappedImage = imageView.image {
            UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //Export Button Touch
    @IBAction func exportButtonTouched(_ sender: UIButton) {
        if let unwrappedImage = imageView.image {
            showResizeInputViewWith(image:unwrappedImage)
        }
    }
    
    func showResizeInputViewWith(image:UIImage) {
        let riV = Bundle.main.loadNibNamed("ResizeInputView", owner: nil, options: nil)?[0] as! ResizeInputView
        let windowView = UIApplication.shared.keyWindow
        if let windowView = windowView {
            riV.frame = windowView.bounds
        }
        windowView?.addSubview(riV)
        
        riV.alpha = 0.0
        riV.beforeImage = image
        UIView.animate(withDuration: 0.25, animations: {
            riV.alpha = 1.0
        })
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            PLUtil.showToastBlackBottomWith(message: "Overlayed Photo Save Error! " + error.localizedDescription, bottomHeight: 220)
        } else {
            PLUtil.showToastBlackBottomWith(message: "Overlayed Photo Save Done!", bottomHeight: 220)
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PhotoOverlayViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(overlayImageListType == .str) {
            return overlayImages.count
        } else {
            return overlayOrgImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SVGCollectionViewCell", for: indexPath) as! SVGCollectionViewCell
        photoOverlayPresenter.configure(cell: cell, row: indexPath.row, overlayImageListType: overlayImageListType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 합성할 사진 가져오기
        let bottomImage = imageView.image!
        var topImage: UIImage!
        
        if(overlayImageListType == .str) {
            topImage = UIImage(named: overlayImages[indexPath.row])
        } else {
            topImage = overlayOrgImages[indexPath.row]
        }
        
        // 이미지 합성 함수 호출
        imageView.image = photoOverlayPresenter.makeOverlayedImage(bottomImage: bottomImage, topImage: topImage)
    }
}

extension PhotoOverlayViewController: PhotoOverlayViewDelegate {
    //start indicator
    func startLoading() {
        startIndicator()
    }

    //finish indicator
    func finishLoading() {
        stopIndicator()
    }

    func setOverlayImageList(overlayImageList:[String]) {
        overlayImages = overlayImageList
        overlayImageListType = OverlayImageListType.str
        collectionView.reloadData()
    }
    
    func setOverlayOrgImageList(overlayOrgImageList:[UIImage]) {
        overlayOrgImages = overlayOrgImageList
        overlayImageListType = OverlayImageListType.org
        collectionView.reloadData()
    }
}
