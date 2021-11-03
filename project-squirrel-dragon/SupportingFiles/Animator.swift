//
//  Animator.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/03.
//

import Foundation
typealias Animation = (UICollectionViewCell, IndexPath, UICollectionView) -> Void

final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, collectionView)
        hasAnimatedAllCells = indexPath.row ==  collectionView.numberOfItems(inSection: 0)
    }
}

enum AnimationFactory {

    static func makeFadeAnimation(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, _ in
            cell.alpha = 0

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
    }
}
