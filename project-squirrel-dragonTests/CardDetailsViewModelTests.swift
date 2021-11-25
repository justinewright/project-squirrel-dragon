//
//  CardDetailsViewModelTests.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/11/22.
//

import XCTest

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

class CardDetailsViewModelTests: XCTestCase {
    
    var viewModelUnderTesting: CardDetailViewModel!
    
    let mockCardDataWithTestableNils = CardData(id: "",
                                                name: "Pikachuu",
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
                                                cardmarket: CardMarket(url: "", updatedAt: "", prices: mockPrices))
    
    let mockCardDataWithoutTestableNils = CardData(id: "",
                                                   name: "Pikachuu",
                                                   supertype: nil,
                                                   subtypes: nil,
                                                   level: nil,
                                                   hp: nil,
                                                   types: ["a"],
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
                                                   rarity: "rare",
                                                   flavorText: nil,
                                                   nationalPokedexNumbers: [0],
                                                   images: CardImages(small: "", large: ""),
                                                   cardmarket: CardMarket(url: "", updatedAt: "", prices: mockPrices))
    
    let userCardData = UserCardData(id: "", collectedNumber: 0)
    
    override func setUp() {
        let mockCollectableCard = CollectableCard(id: "", pokemonCard: mockCardDataWithTestableNils, userCard: userCardData)
        
        viewModelUnderTesting = CardDetailViewModel()
        viewModelUnderTesting.configure(withCard: mockCollectableCard)
        
    }
    
    func testAddOneCardIncreasesTotalCollectedCardsByOne() {
        let expectedResult = 1
        viewModelUnderTesting.addOneCard()
        let actualResult = viewModelUnderTesting.totalCardsCollected
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testRemoveOneCardDecreasesTotalCollectedCardsByOne() {
        let expectedResult = 1
        viewModelUnderTesting.addOneCard()
        viewModelUnderTesting.addOneCard()
        viewModelUnderTesting.removeOneCard()
        let actualResult = viewModelUnderTesting.totalCardsCollected
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testRemoveOneCardReturnsZeroWhenAlreadyZero() {
        let expectedResult = 0
        viewModelUnderTesting.removeOneCard()
        let actualResult = viewModelUnderTesting.totalCardsCollected
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testFinalCardsCollectedReturnsNilWhenCollectedNumberIsSame() {
        XCTAssertNil(viewModelUnderTesting.finalCardsCollected)
    }
    
    func testFinalCardsCollectedReturnsNewWhenCollectedNumberIsDifferent() {
        let expectedResult = 1
        viewModelUnderTesting.addOneCard()
        let actualResult = viewModelUnderTesting.finalCardsCollected!
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testNumberStringFormattedCorrectly() {
        let expectedResult =  "number: 1"
        let actualResult = viewModelUnderTesting.number!
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testPokemonNameStringFormattedCorrectly() {
        let expectedResult =  "name: Pikachuu"
        let actualResult = viewModelUnderTesting.pokemonName!
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testRarityStringReturnsDashWhenNil() {
        let expectedResult =  "rarity: -"
        let actualResult = viewModelUnderTesting.rarity!
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testRarityStringReturnsRarityWhenNotNil() {
        let mockCollectableCard = CollectableCard(id: "", pokemonCard: mockCardDataWithoutTestableNils, userCard: userCardData)
        viewModelUnderTesting.configure(withCard: mockCollectableCard)
        let expectedResult =  "rarity: rare"
        let actualResult = viewModelUnderTesting.rarity!
        XCTAssertEqual(expectedResult, actualResult)
        
    }
    
    func testTypeStringFormattedCorrectlyWithNil() {
        let expectedResult =  "type: -"
        let actualResult = viewModelUnderTesting.type!
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testTypeStringFormattedCorrectlyWhenNotNil() {
        let mockCollectableCard = CollectableCard(id: "", pokemonCard: mockCardDataWithoutTestableNils, userCard: userCardData)
        viewModelUnderTesting.configure(withCard: mockCollectableCard)
        let expectedResult = "type: a"
        let actualResult = viewModelUnderTesting.type!
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testPricesReturnsTwoColumns() {
        let expectedResult = 2
        let actualResult = Mirror(reflecting: viewModelUnderTesting.prices).children.count
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testPricesFirstColumnTitleIsCorrect() {
        let expectedResult = "Prices"
        let column = viewModelUnderTesting.prices.0?.split(separator: "\n")
        let actualResult = String(column?.first ?? "")
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testPricesSecondColumnTitleIsCorrect() {
        let expectedResult = "(€)"
        let column = viewModelUnderTesting.prices.1?.split(separator: "\n")
        let actualResult = String(column?.first ?? "")
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testPriceNumberStringHasTwoDecimalPlaces() {
        let expectedResult =  2
        let column = viewModelUnderTesting.prices.1?.split(separator: "\n")
        let price = String(column?[2] ?? "")
        let priceDecimalPlaces = price.split(separator: ".")
        let decimalPlaces = priceDecimalPlaces.last
        let actualResult = decimalPlaces!.count
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testNationalPokedexNumberHasThreeNumberPlaces() {
        let expectedResult = 3
        let actualResult = viewModelUnderTesting.nationalPokedexNumberLabel?.count
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testWhenSettingTotalCardsIfInputIsValidUpdateCardsCollectedToNewValue() {
        let expectedResult = 2
        viewModelUnderTesting.totalCardsCollected = expectedResult
        let actualResult = viewModelUnderTesting.totalCardsCollected
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testWhenSettingTotalCardsIfInputIsInvalidUpdateCardsCollectedToZero() {
        let expectedResult = 0
        viewModelUnderTesting.totalCardsCollected = -8
        let actualResult = viewModelUnderTesting.totalCardsCollected
        XCTAssertEqual(expectedResult, actualResult)
    }
}
