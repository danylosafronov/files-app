//
//  Collection+Extensions.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import Foundation

extension Collection {
    func getOrNil(index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
