//
//  WatchStatsViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/01.
//

import UIKit
import WatchConnectivity

class WatchStatsViewController: UIViewController {

    @IBOutlet weak var watchLabel: UILabel!

    enum WatchMode: String {
        case cardCollectionStats = "cardCollectionStats"
        case valueStats = "valueStats"
    }

    private var watchMode = WatchMode.cardCollectionStats
    private lazy var viewModel = WatchStatsViewModel(
        delegate: self,
        pokemonCardsRepository: TCGPokemonRepository(apiClient: PokemonTcgApiClient(endPoint: Endpoint(path: "cards"), forDataType: TCGReturnDataTypes.TcgCards)),

        userCardsRepository: UserPokemonDataRepository(firebaseApiClient: FirebaseApiClient(endPoint: Endpoint(path: "cards"), forDataType: UserReturnDataTypes.UserCards)),
        userSetRepository: UserPokemonDataRepository(firebaseApiClient: FirebaseApiClient(endPoint: Endpoint(path: "sets"), forDataType: UserReturnDataTypes.UserSets)))

    private var session: WCSession?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWatchSession()
    }

    func setupWatchSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
}

// MARK: - Watch Delegate Methods
extension WatchStatsViewController: WCSessionDelegate {
    func loading() {
        DispatchQueue.main.async {
            self.watchLabel.text = "Loading..."
        }
    }
    func doneLoading() {
        DispatchQueue.main.async {
            self.watchLabel.text = "Watch..."
        }
    }

    func loadCollectedStats() {
        if let validSession = session, validSession.isReachable {
            let dataToWatch: [String: Any] = ["collectedStats": viewModel.collectedCardsStats]
            validSession.sendMessage(dataToWatch, replyHandler: nil, errorHandler: nil)
            doneLoading()
        }
    }

    func loadValueStats() {
    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        loading()
        if let valueFromWatch = message["watchMode"] as? String {
            if valueFromWatch == "cardCollectionStats" {
                watchMode = .cardCollectionStats
                viewModel.fetchViewData()

            }
        }
    }
}

// MARK: - Watch Stats View Model Delegate Methods
extension WatchStatsViewController: WatchStatsViewModelDelegate{
    func didLoadWatchStatsViewModel(_ watchStatsViewModel: WatchStatsViewModel) {
        switch watchMode {
        case .cardCollectionStats:
            loadCollectedStats()
        case .valueStats:
            loadValueStats()
        }
    }

    func didFailWithError(message: String) {
        print("failed to load watch information")
    }

}
