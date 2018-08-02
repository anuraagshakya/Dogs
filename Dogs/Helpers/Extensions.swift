//
//  Extensions.swift
//  Dogs
//
//  Created by Anuraag Shakya on 02.08.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
