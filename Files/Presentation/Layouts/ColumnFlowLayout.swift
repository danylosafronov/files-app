//
//  ColumnFlowLayout.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import Foundation
import UIKit

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Overrides
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let spacing = 8.0
        let maxWidth = collectionView.bounds.width - 2 * spacing
        let itemWidth = maxWidth
        
        itemSize = CGSize(width: itemWidth, height: 41)
        sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        minimumInteritemSpacing = spacing
        minimumLineSpacing = spacing
    }
}
