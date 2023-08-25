//
//  NumberFormat+extension.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 18/07/23.
//

import Foundation

extension Int {
    func getFormattedNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        return formattedNumber
    }
}

