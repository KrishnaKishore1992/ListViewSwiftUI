//
//  Extensions.swift
//  OrderMaking
//
//  Created by Kittu Lalli on 29/04/20.
//  Copyright © 2020 Kittu Lalli. All rights reserved.
//

import Foundation

enum CodableError: Error {
    case notFound(String)
}

extension String {
    
    func parse<T: Codable>() throws -> T {
        if let fileUrl = Bundle.main.url(forResource: self, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            let parsedElements = try PropertyListDecoder().decode(T.self, from: data)
            return parsedElements
        }
        throw CodableError.notFound("File Not Found")
    }
}
