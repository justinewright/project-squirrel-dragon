//
//  SetDetailsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

protocol SetsDetailViewModelDelegate: AnyObject {
    func didLoadSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel)
    func didFailWithError(message: String)
}

class SetDetailsViewModel {

    // MARK: - Properties
    private weak var delegate: SetsDetailViewModelDelegate?
    private (set) var setDetails: SetDetails!

    // MARK: - Initialization
    init(delegate: SetsDetailViewModelDelegate?) {
        self.delegate = delegate
    }

    func updateSetDetailsData(withPokemonSet set: PokemonCollectionSet) {
        // using dummy data as a placeholder until firebase database is working
        var temporaryUserSet = DummyData.userSet
        temporaryUserSet.id = set.id
        self.setDetails = SetDetails(id: set.id, userSet: temporaryUserSet, pokemonCollectionSet: set)
    }
    // TODO: - repo to firebase to get userdetails

    var collectedFraction: String {
        "\(setDetails.userSet.cardsCollected)/\(setDetails.pokemonCollectionSet.total)"
    }

    var collectedPercentage: String {
        "\((setDetails.userSet.cardsCollected)/(setDetails.pokemonCollectionSet.total)*100)%"
    }

    var formatedReleaseDate: String {
        "RELEASE DATE: " + setDetails.pokemonCollectionSet.releaseDate
    }

    var logoURL: URL? {
        URL(string: setDetails.pokemonCollectionSet.imageLogo)
    }
}
