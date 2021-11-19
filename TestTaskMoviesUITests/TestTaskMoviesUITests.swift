//
//  TestTaskMoviesUITests.swift
//  TestTaskMoviesUITests
//
//  Created by Roman Gorshkov on 19.11.2021.
//

import XCTest

class TestTaskMoviesUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStart() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        app.buttons["Close"].tap()
    }
    
    func testStarTap() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let collectionViewsQuery = app.collectionViews
        let cell = collectionViewsQuery.children(matching: .cell).element(boundBy: 0)

        let cell2 = collectionViewsQuery.children(matching: .cell).element(boundBy: 1)
        cell2.buttons["favorite"].tap()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Избранное"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
