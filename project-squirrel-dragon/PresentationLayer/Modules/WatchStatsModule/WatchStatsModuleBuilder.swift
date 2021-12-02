//
//  WatchStatsModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/01.
//

import Foundation

class WatchStatsModuleBuilder {

    static func build(usingNavigationFactory factory: NavigationFactory) -> UINavigationController {
        let storyboard = UIStoryboard.init(name: "WatchStats", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "WatchStats")
        view.navigationItem.largeTitleDisplayMode = .never
        view.navigationController?.isNavigationBarHidden = true
        return factory(view)
    }

}
