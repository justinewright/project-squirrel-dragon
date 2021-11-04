//
//  SearchBarTests.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/24.
//

import XCTest

class SearchBarTests: XCTestCase {

    class MockSearchViewModelDelegate: NSObject, CustomSearchbarViewModelDelegate {
        var updateDisplayCalled = false
        var showSelectMenuCalled = false

        func showSelectMenu(_ sender: CustomSearchBarViewModel!) {
            showSelectMenuCalled = true
        }

        func updateDisplay(_ sender: CustomSearchBarViewModel!, withSearchFilter searchFilter: String!) {
            updateDisplayCalled = true
        }

    }

    var viewModelUnderTesting: CustomSearchBarViewModel!
    var mockDelegate =  MockSearchViewModelDelegate()

    override func setUp() {
        viewModelUnderTesting = CustomSearchBarViewModel(list: ["a", "ab", "b", "c"], andDelegate: mockDelegate)
    }

    func testWhenSearchWordIsEmptyThenFilteredListIsEmpty(){
        let searchWord = ""
        viewModelUnderTesting.filter(searchWord)

        let expectedResult: [String] = []
        let actualResult = viewModelUnderTesting.filteredList as? [String] ?? []

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenSearchWordIsSubstringOfWordInListThenMatchesAreReturned() {

        let searchWord = "a"
        viewModelUnderTesting.filter(searchWord)

        let expectedResult: [String] = ["a", "ab"]
        let actualResult = viewModelUnderTesting.filteredList as? [String] ?? []

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenSearchWordIsExactMatchThenOnlyFilteredListContainsOneElement() {

        let searchWord = "c"
        viewModelUnderTesting.filter(searchWord)

        let expectedResult: [String] = ["c"]
        let actualResult = viewModelUnderTesting.filteredList as? [String] ?? []

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenSearchWordIsEnteredFilteredListIsUpdated() {
        let searchWord = "c"
        let countBefore = viewModelUnderTesting.filteredList.count
        viewModelUnderTesting.filter(searchWord)

        let countAfter = viewModelUnderTesting.filteredList.count

        XCTAssertNotEqual(countBefore, countAfter)
    }

    func testWhenSearchWordIsEnteredDelegateUpdateDisplayMethodIsCalled() {
        let searchWord = "c"
        viewModelUnderTesting.filter(searchWord)

        let expectedResult = true
        let actualResult = mockDelegate.updateDisplayCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

}
