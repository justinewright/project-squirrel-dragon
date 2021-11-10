//
//  PokemonCollectionSetsViewModel.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/22.
//

import XCTest

let mockData = [SetsData(id: "base1",
                         name: "Base",
                         series: "Base",
                         printedTotal: 102,
                         total: 102,
                         releaseDate: "1999/01/09",
                         updatedAt: "2020/08/14 09:35:00",
                         images: Images(symbol: "https://images.pokemontcg.io/base1/symbol.png", logo: "https://images.pokemontcg.io/base1/logo.png"))]

class PokemonCollectionSetsViewModelTest: XCTestCase {
    let mockUserSet = UserSetData(id: mockData.first!.id, collectedCards: 0, cardData: [])
    let mockPokemonSet = PokemonCollectionSet(pokemonSetsData: mockData.first!)
    let mockPokemonSetData = PokemonSetsData(data: mockData)
    var mockFirebaseSet: FirebaseData<UserSetData>!

    class MockRepository: RepositoryProtocol {
        var fetchCalled = false
        var repoResult: Result<Any, URLError> = .failure(URLError(.badServerResponse))

        func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock) {

        }

        func delete(_ item: Any, then handler: @escaping AnyResultBlock) {

        }

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
    var mocktcgSetRepo: MockRepository!
    var mockUserSetRepo: MockRepository!

    override func setUp() {
        mockFirebaseSet = FirebaseData(id: "", data: [mockUserSet])
        mocktcgSetRepo = MockRepository()
        mockUserSetRepo = MockRepository()
        mockDelegate = MockDelegate()
        viewModelUnderTesting = PokemonCollectionSetsViewModel(pokemonCollectionViewModelDelegate: mockDelegate,
                                                               pokemonSetsRepository: mocktcgSetRepo,
                                                               userSetsRepository: mockUserSetRepo)
    }

    func testUpdateViewCallsRepositoryFetch() {
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mocktcgSetRepo.fetchCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testOnSuccessfulRepositoryFetchesResultUpdatesPopulatesPokemonCollectionSet() {

        mocktcgSetRepo.repoResult = .success(mockPokemonSetData)
        mockUserSetRepo.repoResult = .success(mockFirebaseSet)
        viewModelUnderTesting.fetchViewData()
        let expectedResult = 1
        let actualResult = viewModelUnderTesting.sets.count
        XCTAssertEqual(expectedResult, actualResult)

    }

    func testOnSuccessfulRepositoryFetchResultDelegateDidLoadIsCalled() {
        mocktcgSetRepo.repoResult = .success(mockPokemonSetData)
        mockUserSetRepo.repoResult = .success(mockFirebaseSet)
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
        mocktcgSetRepo.repoResult = .success(mockPokemonSetData)
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
        mocktcgSetRepo.repoResult = .success(mockPokemonSetData)
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
        mocktcgSetRepo.repoResult = .success(mockPokemonSetData)
        mockUserSetRepo.repoResult = .success(mockFirebaseSet)
        viewModelUnderTesting.filteredList = []
        viewModelUnderTesting.fetchViewData()
        let expectedResult = 1
        let actualResult = viewModelUnderTesting.sets.count
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testViewModelReturnsArrayOfCurrentSetsKeys() {
        mocktcgSetRepo.repoResult = .success(mockPokemonSetData)
        mockUserSetRepo.repoResult = .success(mockFirebaseSet)
        viewModelUnderTesting.fetchViewData()
        let expectedResult = mockPokemonSet.id
        let actualResult = viewModelUnderTesting.keys.first!
        XCTAssertEqual(expectedResult, actualResult)
    }

}
