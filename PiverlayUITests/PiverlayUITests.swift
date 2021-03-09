//
//  PiverlayUITests.swift
//  PiverlayUITests
//
//  Created by Woncheol Heo on 2021/03/09.
//

import XCTest

class PiverlayUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()

        //사집 접근 제어 허용 시스템 얼럿 허용버튼 탭
        addUIInterruptionMonitor(withDescription: "Photos permission alert") { (alert) in
            alert.buttons["Allow Access to All Photos"].tap()
            return true // The interruption has been handled
        }
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        //앨범리스트 테이블의 첫번째 셀 탭
        let photoAlbumTable = app.tables.matching(identifier: "photoAlbumTableViewIdentifier")
        let cell = photoAlbumTable.cells.element(matching: .cell, identifier: "PhotoAlbumCell_0")
        cell.tap()
      
        //사진리스트 컬렉션뷰의 네번째 셀 탭
        let photoGridListCollection = app.collectionViews.matching(identifier: "photoGridListCollectionViewIdentifier")
        let cell2 = photoGridListCollection.cells.element(matching: .cell, identifier: "PhotoGridListCell_3")
        cell2.tap()
        
        //이미지리스트 컬렉션뷰의 세번째 셀 탭
        let overlayImageListCollection = app.collectionViews.matching(identifier: "overlayImageListCollectionViewIdentifier")
        let cell3 = overlayImageListCollection.cells.element(matching: .cell, identifier: "overlayImageListCell_2")
        cell3.tap()
        
        //overlay 버튼 탭
        app.buttons["overlayButton"].tap()
        
        //앱종료
        app.terminate()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

