//
//  PokemonCollectionSetsRepositoryTests.swift
//  project-squirrel-dragonTests
//
//  Created by Justine Wright on 2021/10/06.
//

import XCTest

class PokemonCollectionSetsRepositoryTests: XCTestCase {

    var repositoryUnderTest: PokemonCollectionSetsRepository!
    var mockPokemonTcgAllSetsApiClient: MockPokemonTcgAllSetsApiClient!

    override func setUp() {
        mockPokemonTcgAllSetsApiClient = MockPokemonTcgAllSetsApiClient()
        repositoryUnderTest = PokemonCollectionSetsRepository(pokemonTcgAllSetsApiClient: mockPokemonTcgAllSetsApiClient)
    }

    func testSuccessfulApiCallUpdatesPokemonCollectionSetsRepositoryArray() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .success(mockPokemonCollectionSetsData)
        repositoryUnderTest.fetch { _ in }
        XCTAssert(!repositoryUnderTest.pokemonCollectionSets.isEmpty)
    }

    func testFailedApiCallDoesNotUpdatesPokemonCollectionSetsRepositoryArray() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        repositoryUnderTest.fetch { _ in }
        XCTAssert(repositoryUnderTest.pokemonCollectionSets.isEmpty)
    }

    func testFailedApiCallUpdatesRepositoryErrorMessage() throws {
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
