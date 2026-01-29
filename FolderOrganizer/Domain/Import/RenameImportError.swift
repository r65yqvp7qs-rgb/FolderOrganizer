// FolderOrganizer/Domain/Import/RenameImportError.swift
//

import Foundation

enum RenameImportError: Error {
    case decodeFailed(Error)
    case unsupportedVersion
    case missingRootFolder
}
