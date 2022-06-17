//
//  String+Extensions.swift
//  Files
//
//  Created by Danylo Safronov on 13.06.2022.
//

import Foundation
import UIKit

extension String {
    func height(forWidth width: CGFloat, withFont font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }
}
