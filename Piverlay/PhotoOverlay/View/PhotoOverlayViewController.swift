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

class PhotoOverlayViewController: UIViewController {
    //IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var overlayButton: UIButton!
    // 선택된 이미지 Asset
    var selectedAsset: PHAsset!
    var overlayImages:[String] = []
    var overlayOrgImages:[UIImage] = []
    var overlayImageListType:OverlayImageListType!
    // 이미지매니저
    var imageMannger: PHCachingImageManager!
    
    //photoOverlayPresenter
    private let photoOverlayPresenter = PhotoOverlayPresenter(photoOverlayService: PhotoOverlayService())
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // imageManager를 사용해 선택된 포토를 iMageView에 세팅
        imageMannger = PHCachingImageManager()
        imageMannger.requestImage(for: selectedAsset, targetSize: CGSize(width: imageView.frame.width, height: imageView.frame.height), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
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
        
        //present를 통해 뷰 어태치
        photoOverlayPresenter.attachView(view: self)
        
        //svg image를 번들에서 가져오는 방식
        //photoOverlayPresenter.getOverlayImageList()
        
        //svg image를 서버에서 url을 통해 가져오는 방식
        photoOverlayPresenter.getOrgOverlayImageList()
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
       // showResizeInputView()
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
        if(self.overlayImageListType == .str) {
            return overlayImages.count
        } else {
            return overlayOrgImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SVGCollectionViewCell", for: indexPath) as! SVGCollectionViewCell
        //UITest를 위한 cell의 accessibilityIdentifier 세팅
        cell.accessibilityIdentifier = "overlayImageListCell_\(indexPath.row)"
        if(self.overlayImageListType == .str) {
            cell.imageView.image = UIImage(named: overlayImages[indexPath.row])
        } else {
            cell.imageView.image = overlayOrgImages[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 사진 합성
        let bottomImage = imageView.image!
        var topImage: UIImage!
        
        if(self.overlayImageListType == .str) {
            topImage = UIImage(named: overlayImages[indexPath.row])
        } else {
            topImage = overlayOrgImages[indexPath.row]
        }

        let size = CGSize(width: bottomImage.size.width, height: bottomImage.size.height)
        UIGraphicsBeginImageContext(size)
    
        let bottomAreaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let topAreaSize = CGRect(x: bottomImage.size.width/2 - 150, y: bottomImage.size.height/2 - 150, width: 300, height: 300)
        bottomImage.draw(in: bottomAreaSize)
        topImage!.draw(in: topAreaSize, blendMode: .normal, alpha: 1)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        imageView.image = newImage
    }
}

extension PhotoOverlayViewController: PhotoOverlayView {
    //start indicator
    func startLoading() {
        activityIndicator.startAnimating()
        activityIndicator.color = PLUtil.UIColorFromRGB(rgbValue: 0x3B8BF8)
        activityIndicator.alpha = 1
        activityIndicator.isHidden = false
    }

    //finish indicator
    func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }

    func setOverlayImageList(overlayImageList:[String]) {
        self.overlayImages = overlayImageList
        self.overlayImageListType = OverlayImageListType.str
        self.collectionView.reloadData()
    }
    
    func setOverlayOrgImageList(overlayOrgImageList:[UIImage]) {
        self.overlayOrgImages = overlayOrgImageList
        self.overlayImageListType = OverlayImageListType.org
        self.collectionView.reloadData()
    }
}
