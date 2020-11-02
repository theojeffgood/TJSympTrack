//
//  Symptom.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 7/17/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation
import RealmSwift

class Symptom: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var isChecked: Bool = false
}
