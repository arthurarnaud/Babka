//
//  Fonts.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import SwiftUI

// MARK: Babka Fonts

// Montserrat
private let regularSecondaryFontName = "Montserrat-Regular"
private let semiBoldSecondaryFontName = "Montserrat-SemiBold"
private let boldSecondaryFontName = "Montserrat-Bold"

// MARK: - General use

public extension Font {
    static let homeTitle = Font.system(size: 42, weight: .semibold) // My Recipes
    static let sectionTitle = Font.custom(semiBoldSecondaryFontName, size: 18) // LAST ADDED
    static let titleFont = Font.system(size: 30, weight: .semibold) // Tomato Soup
    static let subtitleFont = Font.custom(semiBoldSecondaryFontName, size: 13) // MAIN COURSE
    static let infoFont = Font.system(size: 20, weight: .semibold) // (35)min
    static let subInfoFont = Font.system(size: 16, weight: .semibold) // 35(min)
    static let searchText = Font.custom(semiBoldSecondaryFontName, size: 26) // Soup
    static let longTextFont = Font.custom(regularSecondaryFontName, size: 13)
    static let timePickerFont = Font.system(size: 36, weight: .regular) // h / min
}
