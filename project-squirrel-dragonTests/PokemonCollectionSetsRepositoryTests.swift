//
//  PokemonCollectionSetsRepositoryTests.swift
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

class PokemonCollectionSetsRepositoryTests: XCTestCase {

    var mockPokemonCollectionSetsData: PokemonSetsData!

    class MockPokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol {

        var apiCallResult: Result<PokemonSetsData, URLError> = .failure(URLError(.badServerResponse))

        func fetch(then handler: @escaping PokemonTcgAllSetsApiClientResultBlock) {
            handler(apiCallResult)
        }

    }

    var repositoryUnderTest: PokemonCollectionSetsRepository!
    var mockPokemonTcgAllSetsApiClient: MockPokemonTcgAllSetsApiClient!

    override func setUp() {
        mockPokemonTcgAllSetsApiClient = MockPokemonTcgAllSetsApiClient()
        repositoryUnderTest = PokemonCollectionSetsRepository(pokemonTcgAllSetsApiClient: mockPokemonTcgAllSetsApiClient)
        mockPokemonCollectionSetsData = PokemonSetsData(data: mockData)
    }

    func testSuccessfulApiCallUpdatesPokemonCollectionSetsRepositoryArray() {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .success(mockPokemonCollectionSetsData)
        repositoryUnderTest.fetch { _ in }
        let expectation = self.expectation(description: "Test")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(!repositoryUnderTest.pokemonCollectionSets.isEmpty)
    }

    func testFailedApiCallDoesNotUpdatesPokemonCollectionSetsRepositoryArray() {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        repositoryUnderTest.fetch { _ in }
        XCTAssert(repositoryUnderTest.pokemonCollectionSets.isEmpty)
    }

    func testFailedApiCallUpdatesRepositoryErrorMessage() {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        repositoryUnderTest.fetch { result in
            switch result {
            case .success(_):
                XCTFail("Received results instead of error")
            case .failure(let error):
                let expectedErrorMessage = "The operation couldn’t be completed. (NSURLErrorDomain error -1011.)"
                let actualErrorMessage = error.localizedDescription
                XCTAssertEqual(expectedErrorMessage, actualErrorMessage)
            }
        }
    }

}
