//
//  CardDetailModuleBuilder.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/15.
//

import Foundation

class CardDetailModuleBuilder {

    static func build(usingNavigationFactory factory: NavigationFactory, and collectableCard: CollectableCard) -> UINavigationController {
        let storyboard = UIStoryboard.init(name: "CardDetail", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "CardDetail")
        view.navigationItem.largeTitleDisplayMode = .never
        view.navigationController?.isNavigationBarHidden = true
        if let view = view as? CardDetailViewController {
            view.configure(withCard: collectableCard)
        }
        return factory(view)
    }

}
