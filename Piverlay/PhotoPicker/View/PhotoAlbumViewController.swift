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
    
    private let photoAlbumPresenter = PhotoAlbumPresenter(photoAlbumService: PhotoAlbumService())
    var items:[PhotoAlbum] = []
    var imageMannger: PHCachingImageManager!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        //이미지매니저 초기화
        imageMannger = PHCachingImageManager()
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
        photoAlbumPresenter.attachView(view: self)
        photoAlbumPresenter.getPhotoAlbumList()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //앨범 접근 퍼미션 permission 얼럿 노출 함수 구현: 최초 허용 후 바로 앨범리스트 가져 올 수 있도록 구현
    func checkPhotoLibraryPermission() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
             PHPhotoLibrary.requestAuthorization({status in
                 if status == .authorized {
                    //동의 callBack 후 UI를 Main Thread에서 처리하기 위해 DispatchQueue.main.async 사용
                    DispatchQueue.main.async {
                        self.photoAlbumPresenter.attachView(view: self)
                        self.photoAlbumPresenter.getPhotoAlbumList()
                    }
                 } else {
                    
                 }
             })
         }
    }
}

// 앨범 내 사진의 변경(추가, 삭제)을 감지하는 observer
extension PhotoAlbumViewController: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.global().async {
            let updateSectionFetchResults = self.items
            var reloadRequired = false
            for (index, item) in self.items.enumerated() {
                if let changeDetails = changeInstance.changeDetails(for: item.fetchResult as! PHFetchResult<PHObject>) {
                    updateSectionFetchResults[index].fetchResult = changeDetails.fetchResultAfterChanges as! PHFetchResult<PHAsset>
                    reloadRequired = true
                }
            }
            if reloadRequired {
                DispatchQueue.main.async(execute: {
                    self.items = updateSectionFetchResults
                    self.tableView.reloadData()
                })
            }
        }
    }
}

//MARK: - UITableViewDelegate & UItableVIewDataSource
extension PhotoAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "PhotoAlbumCell", for: indexPath) as! PhotoAlbumCell
        let item = self.items[indexPath.row]
        let asset = self.items[indexPath.row].fetchResult.firstObject!
        imageMannger.requestImage(for: asset, targetSize: CGSize(width: 40.0, height: 40.0), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, info) in
            cell.photoImageView.image = image

        }
        let itemDic: Dictionary<String, String> = ["title" : item.title!, "count" : "(\(item.fetchResult.count))"]
        
        //UITest를 위한 cell의 accessibilityIdentifier 세팅
        cell.accessibilityIdentifier = "PhotoAlbumCell_\(indexPath.row)"
        
        //Cell 데이터 세팅 함수 호출
        cell.setupWithDictionary(itemDic)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // photoGridVC 선언
        let photoGridVC = PhotoGridViewController()
        
        // 사진리스트와 앨범제목 세팅
        photoGridVC.photos = self.items[indexPath.row].fetchResult
        photoGridVC.albumTitle = self.items[indexPath.row].title!
        
        // push VewController
        self.navigationController?.pushViewController(photoGridVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension PhotoAlbumViewController: PhotoAlbumView {
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
        items = photoAlbumList
        tableView.isHidden = false
        tableView.reloadData()
    }

    //Empty 화면
    func setEmptyPhotoAlbumList() {
        tableView?.isHidden = true
        emptyView?.isHidden = false
    }
}
