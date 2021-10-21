//
//  SetDetailsViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/20.
//

import Foundation

protocol SetsDetailViewModelDelegate: AnyObject {
    func isLoadingSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel)
    func didLoadSetDetailsViewModel(_ setDetailsViewModel: SetDetailsViewModel)
    func didFailWithError(message: String)
}

class SetDetailsViewModel {

    // MARK: - Properties
    private weak var delegate: SetsDetailViewModelDelegate?
    private (set) var setDetails: SetDetails!

    // TODO: - repo to firebase to get userdetails

    // MARK: - Initialization
    init(setDetails: SetDetails, delegate: SetsDetailViewModelDelegate?) {
        self.delegate = delegate
        self.setDetails = setDetails
    }

    func updateView() {
        self.delegate?.isLoadingSetDetailsViewModel(self)

    }
}