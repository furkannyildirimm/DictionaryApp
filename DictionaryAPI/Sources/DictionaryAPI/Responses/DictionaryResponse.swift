//
//  DictionaryResponse.swift
//  
//
//  Created by STARK on 27.05.2023.
//

import Foundation

import Foundation

public struct DictionaryResponse: Decodable {
    public let results: [DictionaryElement]
    
    private enum RootCodingKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.results = try container.decode([DictionaryElement].self, forKey: .results)
    }
}
