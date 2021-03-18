//
//  PhotoGridViewController.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//

import UIKit
import Photos


class PhotoGridViewController: BaseViewController {

    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    var photoGridPresenter = PhotoGridPresenter(photoGridService: PhotoGridService())
    fileprivate var photosToDisplay = PHFetchResult<PHAsset>()
    //fileprivate var photosToDisplay: PHFetchResult<PHAsset>?
    var albumTitle: String!

    //이미지매니저 선언
    var imageMannger: PHCachingImageManager!
    ///썸네일 이미지 사이즈
    open var photoGridThumbnailSize: CGSize!
    //원본이미지 사이즈
    var realImageSize: CGSize!
    
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
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 20
        collectionLayout.minimumInteritemSpacing = 5
        collectionLayout.sectionInset =  UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        collectionLayout.itemSize = CGSize(width:(screenWidth-30)/3.0-5, height:(screenWidth-30)/3.0-5)
        collectionView.collectionViewLayout = collectionLayout
        
        //collectionView reusable Cell 등록
        collectionView.register(PhotoGridCell.self, forCellWithReuseIdentifier: "PhotoGridCollectionCell")

        //presenter를 이용한 View와 Data 세팅
        photoGridPresenter.setViewDelegate(photoGridViewDelegate: self)
        photoGridPresenter.getPhotoAlbumList()
//        if photosToDisplay == nil {
//            //사진데이터를 정상적으로 가져오지 못한 경우 모든 옵션의 사진을 가져옴
//            let allPhotoOption = PHFetchOptions()
//            allPhotoOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//            photosToDisplay = PHAsset.fetchAssets(with: allPhotoOption)
//        }
        let scale = UIScreen.main.scale
        let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        photoGridThumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //썸네일 사이즈 세팅
    }
    
    @IBAction func backButtonTouched(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PhotoGridViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGridPresenter.photoGridListCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGridCollectionCell", for: indexPath) as! PhotoGridCell
        photoGridPresenter.configure(cell: cell, row: indexPath.row, photoGridThumbnailSize: photoGridThumbnailSize)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedPhoto = photosToDisplay[indexPath.row]
        presentOverlayView(selectedPhoto: selectedPhoto)
    }
}

extension PhotoGridViewController: PhotoGridViewDelegate {    
    func setPhotoGridList(photoGridList: PHFetchResult<PHAsset>) {
        photosToDisplay = photoGridList
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    func setEmptyPhotoGridList() {
        collectionView?.isHidden = true
        emptyView?.isHidden = false
    }
    
    //start indicator
    func startLoading() {
        startIndicator()
    }

    //finish indicator
    func finishLoading() {
        stopIndicator()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func presentOverlayView(selectedPhoto: PHAsset!) {
        //present photoOverlayVC
        let photoOverlayVC = PhotoOverlayViewController()
        photoOverlayVC.selectedPhoto = selectedPhoto
        present(photoOverlayVC, animated: true, completion: nil)
    }
}
