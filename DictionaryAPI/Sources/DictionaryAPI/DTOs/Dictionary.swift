//
//  Dictionary.swift
//  
//
//  Created by STARK on 26.05.2023.
//

import Foundation

// MARK: - DictionaryElement
public struct DictionaryElement: Decodable {
    public let word, phonetic: String?
    public let phonetics: [Phonetic]?
    public let meanings: [Meaning]?
    public let license: License?
    public let sourceUrls: [String]?
    
    init(word: String?, phonetic: String?, phonetics: [Phonetic]?, meanings: [Meaning]?, license: License?, sourceUrls: [String]?) {
        self.word = word
        self.phonetic = phonetic
        self.phonetics = phonetics
        self.meanings = meanings
        self.license = license
        self.sourceUrls = sourceUrls
    }
}

// MARK: - License
public struct License: Decodable {
    public let name: String?
    public let url: String?
}

// MARK: - Meaning
public struct Meaning: Decodable {
    public let partOfSpeech: String?
    public let definitions: [Definition]?
    public let synonyms, antonyms: [String]?
}

// MARK: - Definition
public struct Definition: Decodable {
   public let definition: String?
   public let antonyms: [String]?
   public let example: String?
}

// MARK: - Phonetic
public struct Phonetic: Decodable {
    public let text: String?
    public let audio: String?
    public let sourceURL: String?
    public let license: License?

    enum CodingKeys: String, CodingKey {
        case text, audio
        case sourceURL = "sourceUrl"
        case license
    }
}


