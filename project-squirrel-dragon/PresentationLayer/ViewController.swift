//
//  ViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/04.
//

import UIKit

class ViewController: UIViewController {

    var child = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        child = CustomSearchBarViewController()
//        child = CustomSearchBarViewController();
//        child = PokemonCollectionSetsModuleBuilder.build()
        addChild( child)
        view.addSubview(child.view)
//        child.didMove(toParent: self)
        // Do any additional setup after loading the view.
//        PokemonCollectionSetsRepository(pokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClient()).fetch()
    }

}
