//
//  HomePageBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import Foundation

class HomePageBuilder {
    static func build() -> UITabBarController {
        let subModules: Submodules = (
                sets: PokemonCollectionSetsModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build),
                money: WatchStatsModuleBuilder.build(usingNavigationFactory: NavigationBuilder.build)
            )

        let landingPage = TabBarBuilder.build(usingSubmodules: subModules)

        return landingPage
    }
}
