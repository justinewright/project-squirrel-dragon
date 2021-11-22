//
//  CardsCollectionViewModelTests.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/11/12.
//

import XCTest

class CardsCollectionViewModelTests: XCTestCase {
    class MockDelegate: CardsCollectionViewModelDelegate {
        var didLoadCardsCalled = false
        var didFailWithErrorCalled = false

        func didLoadCardsCollectionViewModel(_ cardsCollectionViewModel: CardsCollectionViewModel) {
            didLoadCardsCalled = true
        }

        func didFailWithError(message: String) {
            didFailWithErrorCalled = true
        }
    }

    class MockUserCardsRepository: RepositoryProtocol {
        var fetchCalled = false
        var postCalled = false
        var deleteCalled = false
        var repoResult: Result<Any, URLError> = .failure(URLError(.badServerResponse))
        
        func fetch(itemWithID itemID: String, then handler: @escaping AnyResultBlock) {
            fetchCalled = true
            handler(repoResult)
        }

        func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock) {
            postCalled = true
            handler(repoResult)
        }

        func delete(_ item: Any, then handler: @escaping AnyResultBlock) {
            deleteCalled = true
            handler(repoResult)
        }

    }

    class MockTCGCardsRepository: TCGCardsRepositoryProtocol {
        var fetchCalled = false
        var repoResult: Result<Any, URLError> = .failure(URLError(.badServerResponse))

        func fetch(itemWithID itemID: String, then handler: @escaping AnyResultBlock) {
            fetchCalled = true
            handler(repoResult)
        }
    }

    var mockPrices = Prices(averageSellPrice: 2,
                            lowPrice: 1,
                            trendPrice: 3,
                            germanProLow: 0,
                            suggestedPrice: 2,
                            reverseHoloSell: 2,
                            reverseHoloLow: 2,
                            reverseHoloTrend: 2,
                            lowPriceExPlus: 2,
                            avg1: 2,
                            avg7: 2,
                            avg30: 2,
                            reverseHoloAvg1: 2,
                            reverseHoloAvg7: 2,
                            reverseHoloAvg30: 2)

    var mockCardData: [CardData] = []
    var mockUserCardData: [UserCardData] = []

    var viewModelUnderTesting: CardsCollectionViewModel!
    var mockDelegate: MockDelegate = MockDelegate()
    var mockUserCardsRepository: MockUserCardsRepository = MockUserCardsRepository()
    var mockTCGCardsRepository: MockTCGCardsRepository = MockTCGCardsRepository()

    override func setUp() {
        mockCardData = [CardData(id: "",
                                 name: "",
                                 supertype: nil,
                                 subtypes: nil,
                                 level: nil,
                                 hp: nil,
                                 types: nil,
                                 evolvesFrom: nil,
                                 abilities: nil,
                                 attacks: nil,
                                 weaknesses: nil,
                                 retreatCost: nil,
                                 convertedRetreatCost: nil,
                                 set: SetsData(id: "base1",
                                               name: "Base",
                                               series: "Base",
                                               printedTotal: 102,
                                               total: 102,
                                               releaseDate: "1999/01/09",
                                               updatedAt: "2020/08/14 09:35:00",
                                               images: Images(symbol: "https://images.pokemontcg.io/base1/symbol.png", logo: "https://images.pokemontcg.io/base1/logo.png")),
                                 number: "1",
                                 artist: "",
                                 rarity: nil,
                                 flavorText: nil,
                                 nationalPokedexNumbers: [0],
                                 images: CardImages(small: "", large: ""),
                                 cardmarket: CardMarket(url: "", updatedAt: "", prices: mockPrices))]

        viewModelUnderTesting = CardsCollectionViewModel(delegate: mockDelegate,
                                                         pokemonCardsRepository: mockTCGCardsRepository,
                                                         userCardsRepository: mockUserCardsRepository)
    }
    // MARK: - Repository tests
    func testFetchViewDataDoesNotCallTCGSetsRepositoryFetchWhenSetIdNotSet() {
        viewModelUnderTesting.fetchViewData()
        let expectedResult = false
        let actualResult = mockTCGCardsRepository.fetchCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testFetchViewDataCallsTCGSetsRepositoryFetchWhenSetIdNotSet() {
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockTCGCardsRepository.fetchCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testFetchViewDataDoesNotCallUserSetsRepositoryFetcWhenSetIdNotSet() {
        viewModelUnderTesting.fetchViewData()
        let expectedResult = false
        let actualResult = mockUserCardsRepository.fetchCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testFetchViewDataCallsUserSetsRepositoryFetchWhenSetIdSet() {
        mockTCGCardsRepository.repoResult = .success(PokemonCardsData(data: mockCardData))
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockUserCardsRepository.fetchCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testPostCardCollectedNumberOfZeroCallsRemoveCard() {
        viewModelUnderTesting.postCard(cardId: "", withCollectedNumber: 0)
        let expectedResult = true
        let actualResult = mockUserCardsRepository.deleteCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testPostCardCallsUserCardsRepositoryPost() {
        viewModelUnderTesting.postCard(cardId: "", withCollectedNumber: 2)
        let expectedResult = true
        let actualResult = mockUserCardsRepository.postCalled
        XCTAssertEqual(expectedResult, actualResult)

    }

    func testRemoveCardCallsUserCardsRepositoryDelete() {
        viewModelUnderTesting.removeCard(cardId: "")
        let expectedResult = true
        let actualResult = mockUserCardsRepository.deleteCalled
        XCTAssertEqual(expectedResult, actualResult)
    }

    // MARK: - Delegate tests
    func testWhenDataSuccessfullyFetchedThenDelegateViewDidLoadCalled() {
        mockTCGCardsRepository.repoResult = .success(PokemonCardsData(data: mockCardData))
        mockUserCardsRepository.repoResult = .success(FirebaseData(id: "",
                                                                   data: mockUserCardData))
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockDelegate.didLoadCardsCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenDataFailedFetchedThenDelegateViewDidLoadCalledNotCalled() {
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = false
        let actualResult = mockDelegate.didLoadCardsCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenDataNotSuccessfullyFetchedThenDelegateDidFailWithErrorCalled() {
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockDelegate.didFailWithErrorCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenDataUnsuccessfullyFetchedThenDelegateDidFailWithErrorCalled() {
        mockTCGCardsRepository.repoResult = .success(PokemonCardsData(data: mockCardData))
        mockUserCardsRepository.repoResult = .success( FirebaseData(id: "", data: mockUserCardData))
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = false
        let actualResult = mockDelegate.didFailWithErrorCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenWrongDataTypeFetchedFromUserCardsRepoThenDelegateDidFailWithErrorCalled() {
        mockTCGCardsRepository.repoResult = .success(PokemonCardsData(data: mockCardData))
        mockUserCardsRepository.repoResult = .success("")
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockDelegate.didFailWithErrorCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenWrongDataTypeFetchedFromPokemonCardsRepoThenDelegateDidFailWithErrorCalled() {
        mockTCGCardsRepository.repoResult = .success("")
        mockUserCardsRepository.repoResult = .success("")
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = true
        let actualResult = mockDelegate.didFailWithErrorCalled

        XCTAssertEqual(expectedResult, actualResult)
    }

    func testWhenDataSuccessfullyLoadedThenCollectableCardsIsPopulated() {
        mockTCGCardsRepository.repoResult = .success(PokemonCardsData(data: mockCardData))
        mockUserCardsRepository.repoResult = .success( FirebaseData(id: "", data: mockUserCardData))
        viewModelUnderTesting.configure(forSetID: "")
        viewModelUnderTesting.fetchViewData()
        let expectedResult = false
        let actualResult = viewModelUnderTesting.collectableCards.isEmpty

        XCTAssertEqual(expectedResult, actualResult)
    }
}
