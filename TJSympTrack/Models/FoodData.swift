//
//  FoodData.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation

struct FoodData: Codable {
    let common: [Common]
}

struct Common: Codable {
    let tag_name: String
    let tag_id: String
    let photo: Photo
}

struct Photo: Codable {
    let thumb: String
}
