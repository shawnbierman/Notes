//
//  Folder.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import Foundation

struct Folder: Codable {
    let id: String
    let name: String
    let notes: [Note]?

    init(id: String, name: String, notes: [Note]?) {
        self.id = id
        self.name = name
        self.notes = notes
    }
}

struct Note: Codable {
    let id: String
    let name: String
    let body: String
    let folder: Folder

    init(id: String, name: String, body: String, folder: Folder) {
        self.id = id
        self.name = name
        self.body = body
        self.folder = folder
    }
}
