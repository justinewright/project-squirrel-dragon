//
//  PokemonCollectionSetsViewModel.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/22.
//

import XCTest

class PokemonCollectionSetsViewModelTest: XCTestCase {

    let mockPokemonSet = PokemonCollectionSet(pokemonSetsData: mockData.first!)

    class MockRepository: RepositoryProtocol {
        var fetchCalled = false
        var repoResult: Result<Any, URLError> = .failure(URLError(.badServerResponse))

        func fetch(then handler: @escaping AnyResultBlock) {
            fetchCalled = true

            handler(repoResult)
        }

    }

    class MockDelegate: PokemonCollectionViewModelDelegate {
        var didLoadCalled = false
        var didFailCalled = false

        func didLoadPokemonCollectionSetsViewModel(_ pokemonCollectionSetsViewModel: PokemonCollectionSetsViewModel) {
            didLoadCalled = true
        }

        func didFailWithError(message: String) {
            didFailCalled = true
        }

    }

    var viewModelUnderTesting: PokemonCollectionSetsViewModel!
    var mockDelegate: MockDelegate!
    var mockRepo: MockRepository!

    override func setUp() {
        mockRepo = MockRepository()
        mockDelegate = MockDelegate()
        viewModelUnderTesting = PokemonCollectionSetsViewModel(pokemonCollectionViewModelDelegate: mockDelegate, repository: mockRepo)
    }

    func testUpdateViewCallsRepositoryFetch() {
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockRepo.fetchCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testOnSuccessfulRepositoryFetchResultUpdatesPopulatesPokemonCollectionSet() {
        mockRepo.repoResult = .success([mockPokemonSet])
        viewModelUnderTesting.fetchViewData()
        let expectedResult = 1
        let actualResult = viewModelUnderTesting.sets.count
        XCTAssertEqual(expectedResult, actualResult)

    }

    func testOnSuccessfulRepositoryFetchResultDelegateDidLoadIsCalled() {
        mockRepo.repoResult = .success([mockPokemonSet])
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockDelegate.didLoadCalled
        XCTAssertEqual(expectedResult, actualResult)
   }

    func testOnFailedRepositoryFetchResultPokemonCollectionSetIsEmpty() {
        viewModelUnderTesting.fetchViewData()
        let expectedResult = 0
        let actualResult = viewModelUnderTesting.sets.count
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testOnFailedRepositoryFetchResultDelegateDidFailIsCalled() {
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockDelegate.didFailCalled
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testSearchListReturnsCorrectlyFormattedStringForEachElement() {
        mockRepo.repoResult = .success([mockPokemonSet])
        viewModelUnderTesting.fetchViewData()
        let expectedResult =
            """
            name: \(mockPokemonSet.name)
            series: \(mockPokemonSet.series)
            id: \(mockPokemonSet.id)
            """
        let actualResult = viewModelUnderTesting.searchList.first!
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenFilteredAFilteredSetIsReturned() {
        mockRepo.repoResult = .success([mockPokemonSet])
        viewModelUnderTesting.filteredList =
                        ["""
                        name: \(mockPokemonSet.name)
                        series: \(mockPokemonSet.series)
                        id: "invalid"
                        """]
        viewModelUnderTesting.fetchViewData()
        let expectedResult = 0
        let actualResult = viewModelUnderTesting.sets.count
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenNotFilteredFullSetIsReturned() {
        mockRepo.repoResult = .success([mockPokemonSet])
        viewModelUnderTesting.filteredList = []
        viewModelUnderTesting.fetchViewData()
        let expectedResult = 1
        let actualResult = viewModelUnderTesting.sets.count
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testViewModelReturnsArrayOfCurrentSetsKeys() {
        mockRepo.repoResult = .success([mockPokemonSet])
        viewModelUnderTesting.fetchViewData()
        let expectedResult = mockPokemonSet.id
        let actualResult = viewModelUnderTesting.keys.first!
        XCTAssertEqual(expectedResult, actualResult)
    }

}
