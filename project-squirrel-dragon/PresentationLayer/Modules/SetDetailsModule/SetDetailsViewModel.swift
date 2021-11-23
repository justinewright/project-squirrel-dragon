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
    typealias FirebaseUserCard = UserSetData
    // MARK: - Properties
    private weak var delegate: SetsDetailViewModelDelegate?
    private (set) var setDetails: SetDetails!
    private var userSetRepository: RepositoryProtocol

    // MARK: - Initialization
    init(delegate: SetsDetailViewModelDelegate?, userSetRepository: RepositoryProtocol) {
        self.delegate = delegate
        self.userSetRepository = userSetRepository
    }

    func updateSetDetailsData(withPokemonSet set: PokemonCollectionSet) {
        self.setDetails = SetDetails(id: set.id, userSet: nil, pokemonCollectionSet: set)
    }

    func fetchUserDetails() {

        userSetRepository.fetch { result in
            switch result {
            case .success(let set):
                guard let userSets = set as? FirebaseData<UserSetData> else { return }
                let matchingUserSet = userSets.data.filter { $0.id == self.setDetails.id }
                self.setDetails.userSet = matchingUserSet.first
                self.delegate?.didLoadSetDetailsViewModel(self)
            case .failure(let error):
                self.delegate?.didFailWithError(message: error.localizedDescription)

            }
        }
    }

    var collectedFraction: String {
        "\(setDetails.userSet?.collectedCards ?? 0)/\(setDetails.pokemonCollectionSet.total)"
    }

    var collectedPercentage: String {
        "\(Int((Double(setDetails.userSet?.collectedCards ?? 0))/(Double(setDetails.pokemonCollectionSet.total))*100))%"
    }

    var formatedReleaseDate: String {
        "RELEASE DATE: " + setDetails.pokemonCollectionSet.releaseDate
    }

    var logoURL: URL? {
        URL(string: setDetails.pokemonCollectionSet.imageLogo)
    }
}
