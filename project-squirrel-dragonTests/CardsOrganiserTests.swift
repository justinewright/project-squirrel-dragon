//
//  CardsOrganiserTests.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/11/25.
//

import XCTest

class CardsOrganiserTests: XCTestCase {

    static func createMockCollectableCard(withId cardId: String,
                                          andRarity rarity: String,
                                          andCollectedNumber collectedNumber: Int) -> CollectableCard {
        let mockRareCardData = CardData(id: cardId,
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
                                        rarity: rarity,
                                        flavorText: nil,
                                        nationalPokedexNumbers: [0],
                                        images: CardImages(small: "", large: ""),
                                        cardmarket: CardMarket(url: "", updatedAt: "", prices: mockPrices))
        return CollectableCard(id: "a",
                               pokemonCard: mockRareCardData,
                               userCard: collectedNumber > 0 ? UserCardData(id: cardId, collectedNumber: collectedNumber): nil )
    }

    static var uncollectedRareCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "a", andRarity: "Rare", andCollectedNumber: 0)
    }

    static var collectedRareCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "b", andRarity: "Rare", andCollectedNumber: 1)
    }

    static var uncollectedCommonCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "c", andRarity: "Common", andCollectedNumber: 0)
    }

    static var collectedCommonCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "d", andRarity: "Common", andCollectedNumber: 1)
    }

    static var uncollectedUncommonCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "e", andRarity: "Uncommon", andCollectedNumber: 0)
    }

    static var collectedUncommonCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "f", andRarity: "Uncommon", andCollectedNumber: 1)
    }

    static var uncollectedPromoCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "g", andRarity: "Promo", andCollectedNumber: 0)
    }

    static var collectedPromoCard: CollectableCard {
        CardsOrganiserTests.createMockCollectableCard(withId: "h", andRarity: "Promo", andCollectedNumber: 1)
    }

    var cardsOrganiser: CardsOrganiser!

    var emptyDeck: [CollectableCard] = []
    var deckWithNoCollectedCards: [CollectableCard] = [uncollectedRareCard, uncollectedCommonCard, uncollectedUncommonCard, uncollectedPromoCard]
    var deckWithSomeCollectedCards: [CollectableCard] = [uncollectedRareCard, uncollectedCommonCard, uncollectedUncommonCard, uncollectedPromoCard,
                                                         collectedRareCard, collectedPromoCard, collectedUncommonCard, collectedCommonCard]
    var deckWithAllCollectedCards: [CollectableCard] = [collectedRareCard, collectedPromoCard, collectedUncommonCard, collectedCommonCard]

    override class func setUp() {}

    // MARK: - Test Totals
    func testTotalNumberOfCardsIsZeroForEmptyInput() {
        cardsOrganiser = CardsOrganiser(collectableCards: emptyDeck)
        let expectedResult = 0
        let actualResult = cardsOrganiser.totalCards
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testTotalNumberOfCollectedCardsIsZeroForEmptyInput() {
        cardsOrganiser = CardsOrganiser(collectableCards: emptyDeck)
        let expectedResult = 0
        let actualResult = cardsOrganiser.numberOfCollectedCards
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testTotalNumberOfCardsIsEightForInputSizeOfEight() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 8
        let actualResult = cardsOrganiser.totalCards
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedCardsIsZeroForWhenUserHasNoCards() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithNoCollectedCards)
        let expectedResult = 0
        let actualResult = cardsOrganiser.numberOfCollectedCards
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedCardsIsFourForWhenUserHasFourCards() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithAllCollectedCards)
        let expectedResult = 4
        let actualResult = cardsOrganiser.totalCards
        XCTAssertEqual(expectedResult, actualResult)
    }

    // MARK: - Test Rare

    func testTotalNumberOfRareCardsIsTwoWhenTwoRareCardsInDeck() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 2
        let actualResult = cardsOrganiser.dividedTotalCardsByRarityCount[.rare]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedRareCardsIsOneWhenUserHasOneRareCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 1
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.rare]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedRareCardsIsZeroWhenUserHasNoRareCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithNoCollectedCards)
        let expectedResult = 0
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.rare]
        XCTAssertEqual(expectedResult, actualResult)
    }

    // MARK: - Test Common
    func testTotalNumberOfCommonCardsIsTwoWhenTwoCommonCardsInDeck() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 2
        let actualResult = cardsOrganiser.dividedTotalCardsByRarityCount[.common]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedCommonCardsIsOneWhenUserHasOneCommonCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 1
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.common]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedCommonCardsIsZeroWhenUserHasNoCommonCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithNoCollectedCards)
        let expectedResult = 0
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.common]
        XCTAssertEqual(expectedResult, actualResult)
    }
    // MARK: - Test Uncommon
    func testTotalNumberOfUncommonCardsIsTwoWhenTwoUncommonCardsInDeck() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 2
        let actualResult = cardsOrganiser.dividedTotalCardsByRarityCount[.uncommon]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedUncommonCardsIsOneWhenUserHasOneUncommonCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 1
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.uncommon]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedUncommonCardsIsZeroWhenUserHasNoUncommonCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithNoCollectedCards)
        let expectedResult = 0
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.uncommon]
        XCTAssertEqual(expectedResult, actualResult)
    }
    // MARK: - Test Promo
    func testTotalNumberOfPromoCardsIsTwoWhenTwoPromoCardsInDeck() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 2
        let actualResult = cardsOrganiser.dividedTotalCardsByRarityCount[.promo]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedPromoCardsIsOneWhenUserHasOnePromoCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithSomeCollectedCards)
        let expectedResult = 1
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.promo]
        XCTAssertEqual(expectedResult, actualResult)
    }

    func testNumberOfCollectedPromoCardsIsZeroWhenUserHasNoPromoCard() {
        cardsOrganiser = CardsOrganiser(collectableCards: deckWithNoCollectedCards)
        let expectedResult = 0
        let actualResult = cardsOrganiser.dividedCollectedCardsByRarityCount[.promo]
        XCTAssertEqual(expectedResult, actualResult)
    }
}
