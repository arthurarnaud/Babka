//
//  Fonts.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import SwiftUI

// MARK: MapIt Fonts

// EB Garamond
private let regularPrimaryFontName = "EBGaramond-Regular"
private let mediumPrimaryFontName = "EBGaramond-Medium"
private let semiBoldPrimaryFontName = "EBGaramond-SemiBold"
private let boldPrimaryFontName = "EBGaramond-Bold"

// Montserrat
private let regularSecondaryFontName = "Montserrat-Regular"
private let semiBoldSecondaryFontName = "Montserrat-SemiBold"

// MARK: - General use
public extension Font {
    static let titleFont = Font.custom(semiBoldPrimaryFontName, size: 32) // Tomato Soup
    static let subtitleFont = Font.custom(semiBoldSecondaryFontName, size: 13) // MAIN COURSE
    static let infoFont = Font.custom(boldPrimaryFontName, size: 20) // (35)min
    static let subInfoFont = Font.custom(boldPrimaryFontName, size: 18) // 35(min)
    
    static let longTextFont = Font.custom(regularSecondaryFontName, size: 13)
}
