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

    class MockUserSetRepository: RepositoryProtocol {

        var fetchCalled = false

        var repoResult: Result<Any, URLError> = .failure(URLError(.badServerResponse))

        func fetch(itemWithID itemID: String, then handler: @escaping AnyResultBlock) {
            fetchCalled = true
            handler(repoResult)
        }
    }
    
    var viewModelUnderTesting: SetDetailsViewModel!
    var mockDelegate: SetsDetailViewModelDelegate!
    let mockPokemonSet = PokemonCollectionSet(pokemonSetsData: mockSetData.first!)
    let mockUserSet = UserSetData(id: "", collectedCards: 0)
    var mockSetDetails: SetDetails!
    var mockUserSetRepository = MockUserSetRepository()

    override func setUp() {
        mockDelegate = MockDelegate()
        viewModelUnderTesting = SetDetailsViewModel(delegate: mockDelegate, userSetRepository: mockUserSetRepository)
        mockSetDetails = SetDetails(id: mockPokemonSet.id, userSet: mockUserSet, pokemonCollectionSet: mockPokemonSet)
        viewModelUnderTesting.updateSetDetailsData(withPokemonSet: mockPokemonSet)
    }

    func testCollectedFractionStringIsFormattedCorrectly() {
        let expectedResult = "\(mockSetDetails.userSet!.collectedCards)/\(mockSetDetails.pokemonCollectionSet.total)"
        let actualResult = viewModelUnderTesting.collectedFraction

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testCollectedPercentageStringIsFormattedCorrectly() {
        //assumation that number of cards to collect is always > 0
        let expectedResult = "0%"
        let actualResult = viewModelUnderTesting.collectedPercentage

        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testReleaseDateStringIsFormattedCorrectly() {
        let expectedResult = "RELEASE DATE: " + mockSetDetails.pokemonCollectionSet.releaseDate
        let actualResult = viewModelUnderTesting.formatedReleaseDate

        XCTAssertEqual(expectedResult, actualResult)
    }
}
