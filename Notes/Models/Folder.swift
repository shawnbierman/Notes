//
//  Folder.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import Foundation

struct Folder: Codable {
    let name: String
    let notes: [Note]?

    init(name: String, notes: [Note]?) {
        self.name = name
        self.notes = notes
    }
}
