//
//  ExportDocument.swift
//  Anki
//
//  Created by 陳奕利 on 2022/3/1.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ExportDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.commaSeparatedText]
    }

    var documentData: String

	init(documentData: String) {
		self.documentData = documentData
	}
	
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        documentData = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: documentData.data(using: .utf8)!)
    }
}
