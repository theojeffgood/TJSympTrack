//
//  FoodData.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation

struct FoodData: Decodable {
    let common: [Common]
}

struct Common: Decodable {
    let tag_name: String
    let tag_id: String
    let photo: Photo
}

struct Photo: Decodable {
    let thumb: String
}
