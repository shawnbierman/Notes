//
//  Note.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import Foundation

struct Note: Codable {
    let id: UUID
    let title: String
    let content: String
    let folder: Folder
    let createDate: Date
    let lastUpdateDate: Date

    init(title: String, content: String, folder: Folder) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.folder = folder
        self.createDate = Date()
        self.lastUpdateDate = Date()
    }
}
