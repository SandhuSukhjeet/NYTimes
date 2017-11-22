//
//  NYTimesUITests.swift
//  NYTimesUITests
//
//  Created by sukhjeet singh sandhu on 20/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import XCTest

class NYTimesUITests: XCTestCase {

    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    func testScrollingAndDetailVC() {
        app.launch()
        let tablesQuery = app.tables
        let table = tablesQuery.element
        table.swipeUp()

        tablesQuery.cells.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Detail"].exists)

        app.navigationBars.buttons.element(boundBy: 0).tap()
        let titleText = app.navigationBars.element.identifier
        XCTAssertTrue(titleText == "Articles")
    }
}
