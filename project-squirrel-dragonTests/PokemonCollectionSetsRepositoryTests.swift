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
        mockPokemonTcgAllSetsApiClient.apiCallResult = .success(load("PokemonCollectionSetsMockData.json"))
        repositoryUnderTest.fetch()
        XCTAssert(!repositoryUnderTest.pokemonCollectionSets.isEmpty)
    }

    func testSuccessfulApiCallUpdatesRepositoryStateToSuccess() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .success(load("PokemonCollectionSetsMockData.json"))
        repositoryUnderTest.fetch()
        let expectedStateResult: RepositoryState = .success
        let actualStateResult = repositoryUnderTest.state
        XCTAssertEqual(expectedStateResult, actualStateResult)
    }

    func testFailedApiCallDoesNotUpdatesPokemonCollectionSetsRepositoryArray() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        repositoryUnderTest.fetch()
        XCTAssert(repositoryUnderTest.pokemonCollectionSets.isEmpty)
    }

    func testWhileWaitingForApiCallResponseRepositoryStateIsLoading() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        let expectedStateResult: RepositoryState = .loading
        let actualStateResult = repositoryUnderTest.state
        XCTAssertEqual(expectedStateResult, actualStateResult)
    }

    func testFailedApiCallUpdatesRepositoryStateToError() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        repositoryUnderTest.fetch()
        let expectedStateResult: RepositoryState = .error
        let actualStateResult = repositoryUnderTest.state
        XCTAssertEqual(expectedStateResult, actualStateResult)
    }

    func testFailedApiCallUpdatesRepositoryErrorMessage() throws {
        mockPokemonTcgAllSetsApiClient.apiCallResult = .failure(URLError(.badServerResponse))
        repositoryUnderTest.fetch()
        let expectedErrorMessage = "The operation couldn’t be completed. (NSURLErrorDomain error -1011.)"
        let actualErrorMessage = repositoryUnderTest.errorMessage
        XCTAssertEqual(expectedErrorMessage, actualErrorMessage)
    }

}
