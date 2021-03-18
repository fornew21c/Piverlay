//
//  PhotoPickerViewController.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/07.
//

import UIKit
import Photos

class PhotoAlbumViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    fileprivate let photoAlbumPresenter = PhotoAlbumPresenter(photoAlbumService: PhotoAlbumService())
    fileprivate var albumsToDisplay = [PhotoAlbum]()
//    fileprivate albumsToDisplay:[PhotoAlbum] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        //observer 등록
        PHPhotoLibrary.shared().register(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        //observer 해제
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //앨범 접근 permission 사스템 얼럿 노출
        checkPhotoLibraryPermission()
        
        //tableView Delegate,Datasource 세팅
        tableView.delegate = self
        tableView.dataSource = self
        
        //reuseable TableCell 등록
        tableView.register(PhotoAlbumCell.self, forCellReuseIdentifier: "PhotoAlbumCell")
        
        //UITest를 위한 uiTable의 accessibilityIdentifier 세팅
        tableView.accessibilityIdentifier = "photoAlbumTableViewIdentifier"
        
        //tableView 관련 세팅
        tableView.separatorInset = UIEdgeInsets.zero

        //presenter를 이용한 View와 Data 세팅
        photoAlbumPresenter.setViewDelegate(photoAlbumViewDelegate: self)
        photoAlbumPresenter.getPhotoAlbumList()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //앨범 접근 permission 얼럿 노출 함수 구현: 최초 허용 후 바로 앨범리스트 가져 올 수 있도록 구현
    func checkPhotoLibraryPermission() {
        let photoPermission = PHPhotoLibrary.authorizationStatus()
        if photoPermission == .notDetermined {
             PHPhotoLibrary.requestAuthorization({status in
                 if status == .authorized {
                    //동의 callBack 후 UI를 Main Thread에서 처리하기 위해 DispatchQueue.main.async 사용
                    DispatchQueue.main.async {
                        self.photoAlbumPresenter.setViewDelegate(photoAlbumViewDelegate: self)
                        self.photoAlbumPresenter.getPhotoAlbumList()
                    }
                 }
             })
         }
    }
}

// 앨범 내 사진의 변경(추가, 삭제)을 감지하는 observer
extension PhotoAlbumViewController: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.global().async {
            let updateSectionFetchResults = self.albumsToDisplay
            var reloadRequired = false
            for (index, item) in self.albumsToDisplay.enumerated() {
                if let changeDetails = changeInstance.changeDetails(for: item.fetchResult as! PHFetchResult<PHObject>) {
                    updateSectionFetchResults[index].fetchResult = changeDetails.fetchResultAfterChanges as! PHFetchResult<PHAsset>
                    reloadRequired = true
                }
            }
            if reloadRequired {
                DispatchQueue.main.async(execute: {
                    self.albumsToDisplay = updateSectionFetchResults
                    self.tableView.reloadData()
                })
            }
        }
    }
}

//MARK: - UITableViewDelegate & UItableVIewDataSource
extension PhotoAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoAlbumPresenter.photoAlbumListCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "PhotoAlbumCell", for: indexPath) as! PhotoAlbumCell
        photoAlbumPresenter.configure(cell: cell, row: indexPath.row)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
   
        // presenter 세팅
        let photoGridService = PhotoGridService()
        photoGridService.setPhotoGridList(photoGridList: albumsToDisplay[indexPath.row].fetchResult)
        let photoGridPresenter: PhotoGridPresenter = PhotoGridPresenter(photoGridService: photoGridService)
        let albumTitle = albumsToDisplay[indexPath.row].title!
        
        pushPhotoList(nextPresenter: photoGridPresenter, title:albumTitle)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalVariables.sharedInstance.photoAlbumTableViewCellHeight
    }
}

extension PhotoAlbumViewController: PhotoAlbumViewDelegate {
    //start indicator
    func startLoading() {
        startIndicator()
    }

    //finish indicator
    func finishLoading() {
        stopIndicator()
    }

    //앨범 세팅 & 테이블 로딩
    func setPhotoAlbumList(photoAlbumList: [PhotoAlbum]) {
        albumsToDisplay = photoAlbumList
        tableView.isHidden = false
        tableView.reloadData()
    }

    //Empty 화면
    func setEmptyPhotoAlbumList() {
        tableView?.isHidden = true
        emptyView?.isHidden = false
    }
    
    func pushPhotoList(nextPresenter: PhotoGridPresenter, title:String) {
        // photoGridVC 선언 & presenter 세팅
        let photoGridVC = PhotoGridViewController()
        photoGridVC.photoGridPresenter = nextPresenter
        photoGridVC.albumTitle = title
        
        // push VewController
        navigationController?.pushViewController(photoGridVC, animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
}
