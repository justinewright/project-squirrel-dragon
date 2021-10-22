//
//  SetDetailsViewModelTests.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/22.
//

import XCTest
@testable import project_squirrel_dragon

class SetDetailsViewModelTests: XCTestCase {

    class MockDelegate: SetsDetailViewModelDelegate {
        var didLoadCalled = false
        var didFailCalled = false

        func didLoadSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel) {
            didLoadCalled = true
        }

        func didFailWithError(message: String) {
            didFailCalled = true
        }

    }

    var viewModelUnderTesting: SetDetailsViewModel!
    var mockDelegate: SetsDetailViewModelDelegate!
    let mockPokemonSet = PokemonCollectionSet(pokemonSetsData: mockData.first!)
    let mockUserSet = DummyData.userSet
    var mockSetDetails: SetDetails!

    override func setUp() {
        mockDelegate = MockDelegate()
        viewModelUnderTesting = SetDetailsViewModel(delegate: mockDelegate)
        mockSetDetails = SetDetails(id: mockPokemonSet.id, userSet: mockUserSet, pokemonCollectionSet: mockPokemonSet)
        viewModelUnderTesting.updateSetDetails(withPokemonSet: mockPokemonSet)
    }

    func testCollectedFractionStringIsFormattedCorrectly() throws {

        let expectedResult = "\(mockSetDetails.userSet.cardsCollected)/\(mockSetDetails.pokemonCollectionSet.total)"
        let actualResult = viewModelUnderTesting.collectedFraction

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testCollectedPercentageStringIsFormattedCorrectly() throws {
        //assumation that number of cards to collect is always > 0
        let expectedResult = "0%"
        let actualResult = viewModelUnderTesting.collectedPercentage

        XCTAssertEqual(expectedResult, actualResult)
    }
    func testReleaseDateStringIsFormattedCorrectly() throws {
        let expectedResult = "RELEASE DATE: " + mockSetDetails.pokemonCollectionSet.releaseDate
        let actualResult = viewModelUnderTesting.formatedReleaseDate

        XCTAssertEqual(expectedResult, actualResult)
    }
}
