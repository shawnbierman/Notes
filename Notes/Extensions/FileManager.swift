//
//  FileManager.swift
//  Notes
//
//  Created by Shawn Bierman on 6/23/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import Foundation

public extension FileManager {

    enum FileError: Error {
        case createDirectoryFailed
    }

    static var documentDirectoryUrl: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func saveFolder(as folderName: String) throws {
        let url = documentDirectoryUrl.appendingPathComponent(folderName)

        do {
            try `default`.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw FileError.createDirectoryFailed
        }
    }
}
