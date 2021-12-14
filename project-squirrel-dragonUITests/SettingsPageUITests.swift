//
//  SettingsPageUITests.swift
//  project-squirrel-dragonUITests
//
//  Created by Justine Wright on 2021/12/14.
//

import XCTest

class SettingsPageUITests: XCTestCase {

    var app: XCUIApplication!

    override class func setUp() {
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAccountSettingExists() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        let accountLabel = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Account"]/*[[".cells.staticTexts[\"Account\"]",".staticTexts[\"Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(accountLabel.exists)
    }

    func testCurrencySettingExists() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        let accountLabel = app.tables.staticTexts["Currency"]
        accountLabel.tap()
        XCTAssertTrue(accountLabel.exists)
    }

    func testWatchSettingExists() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        let watchLabel = app.tables.staticTexts["Watch"]
        watchLabel.tap()
        XCTAssertTrue(watchLabel.exists)
    }

    func testLogoutCellExists() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        let logoutCell = app.tables.staticTexts["Logout"]
        logoutCell.tap()
        XCTAssertTrue(logoutCell.exists)
    }

    func testWatchToggleExists() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        let toggle = app.tables.switches["toggle"]
        toggle.tap()
        XCTAssertTrue(toggle.exists)
    }

    func testCurrencyDetailsLabelExists() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        let detailsLabel = app.tables.staticTexts["KMF"]
        detailsLabel.tap()
        XCTAssertTrue(detailsLabel.exists)
    }

    func testClickOnCurrencyTransitationToCurrencyView() throws {

        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()
        // swiftlint:disable line_length
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["details"]/*[[".cells",".staticTexts[\"KMF\"]",".staticTexts[\"details\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let currencyTitle = app.navigationBars["Currency"].staticTexts["Currency"]
        XCTAssertTrue(currencyTitle.exists)
    }

    func testChangingUserCurrencyChangesDetailsLabel() throws {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["settings"].tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["details"]/*[[".cells",".staticTexts[\"KMF\"]",".staticTexts[\"details\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.windows.children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .searchField).element.tap()
        tablesQuery.cells.containing(.staticText, identifier:"KMF").element.tap()
        let detailsLabel = app.tables.staticTexts["KMF"]
        detailsLabel.tap()
        XCTAssertTrue(detailsLabel.exists)
        // swiftlint:enable line_length
    }

}
