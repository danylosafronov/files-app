//
//  AppAppearance.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation
import UIKit

struct AppAppearance {
    static func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
