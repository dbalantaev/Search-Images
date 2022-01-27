//
//  Photo.swift
//  Search Images
//
//  Created by Дмитрий Балантаев on 27.01.2022.
//

import SwiftUI

struct Photo: Identifiable, Decodable, Hashable {
    var id: String
    var urls: [String: String]
    
}
