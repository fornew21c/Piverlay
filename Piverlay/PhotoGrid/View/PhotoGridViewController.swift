//
//  PhotoGridViewController.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//

import UIKit
import Photos

let screenWidth:CGFloat = UIScreen.main.bounds.width
let screenHeigth:CGFloat = UIScreen.main.bounds.height

class PhotoGridViewController: UIViewController {

    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UIView!
    
    private let photoGridPresenter = PhotoGridPresenter()

    var albumTitle: String!
    var photos: PHFetchResult<PHAsset>!
    
    //이미지매니저 선언
    var imageMannger: PHCachingImageManager!
    ///썸네일 이미지 사이즈
    open var assetGridThumbnailSize: CGSize!
    //원본이미지 사이즈
    var realImageSize: CGSize!
    ///与缓存Rect
    var previousPreheatRect: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageMannger = PHCachingImageManager()
        albumTitleLabel.text = albumTitle
        
        //collectionView delegate, dataSource 세팅
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //UITest를 위한 collectionView의 accessibilityIdentifier 세팅
        collectionView.accessibilityIdentifier = "photoGridListCollectionViewIdentifier"
        
        //CollectionViewLayout 세팅
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 20
        collectionLayout.minimumInteritemSpacing = 5
        collectionLayout.sectionInset =  UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        collectionLayout.itemSize = CGSize(width:(screenWidth-30)/3.0-5, height:(screenWidth-30)/3.0-5)
        collectionView.collectionViewLayout = collectionLayout
        
        //collectionView reusable Cell 등록
        collectionView.register(PhotoGridCell.self, forCellWithReuseIdentifier: "PhotoGridCollectionCell")
  
        activityIndicator.hidesWhenStopped = true

        //presenter를 이용한 View와 Data 세팅
        photoGridPresenter.attachView(view: self)
        
        if photos == nil {
            //사진데이터를 정상적으로 가져오지 못한 경우 모든 옵션의 사진을 가져옴
            let allPhotoOption = PHFetchOptions()
            allPhotoOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            photos = PHAsset.fetchAssets(with: allPhotoOption)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //썸네일 사이즈 세팅
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    @IBAction func backButtonTouched(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PhotoGridViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGridCollectionCell", for: indexPath) as! PhotoGridCell
        cell.imageView.layer.cornerRadius = 15
        
        //UITest를 위한 cell의 accessibilityIdentifier 세팅
        cell.accessibilityIdentifier = "PhotoGridListCell_\(indexPath.row)"
        
        let asset = self.photos[indexPath.row]
        imageMannger.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
            cell.imageView.image = image
            //비디오인 경우 플레잉시간 표시
            switch asset.mediaType {
                case .video:
                    cell.duration = asset.duration
                default:
                    break
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //photoOverlayVC 선언
        let photoOverlayVC = PhotoOverlayViewController()
        let asset = self.photos[indexPath.row]
        photoOverlayVC.selectedAsset = asset;
      
        //present photoOverlayVC
        present(photoOverlayVC, animated: true, completion: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension PhotoGridViewController: PhotoGridView {
    func setPhotoGrid(photoGrid: PHFetchResult<PHAsset>) {
        self.photos = photoGrid
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    func setEmptyPhotoGrid() {
        collectionView?.isHidden = true
        emptyView?.isHidden = false;
    }
    
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
}
