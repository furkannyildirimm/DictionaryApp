//
//  File.swift
//  
//
//  Created by STARK on 26.05.2023.
//

import Foundation
import Alamofire

public protocol DictionaryServiceProtocol: AnyObject {
    func fetchDictionaryEntries(word: String, completion: @escaping (Result<[DictionaryElement], Error>) -> Void)
    func fetchSynonyms(word: String, completion: @escaping (Result<[String], Error>) -> Void)
}

public class DictionaryService: DictionaryServiceProtocol {
    
    public init() {}
    
    public func fetchDictionaryEntries(word: String, completion: @escaping (Result<[DictionaryElement], Error>) -> Void) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let entries = try decoder.decode([DictionaryElement].self, from: data)
                    completion(.success(entries))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchSynonyms(word: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "https://api.datamuse.com/words?rel_syn=\(word)"
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let jsonArray = json as? [[String: Any]] {
                    let sortedArray = jsonArray.sorted { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
                    let top5Array = Array(sortedArray.prefix(5))
                    let synonyms = top5Array.compactMap { $0["word"] as? String }
                    completion(.success(synonyms))
                } else {
                    completion(.failure(ServiceError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum ServiceError: Error {
    case invalidResponse
}




//public protocol DictionaryServiceProtocol: AnyObject {
//    func fetchDictionaryEntries(word: String, completion: @escaping (Result<[Dictionary], Error>) -> Void)
//}
//
//public class DictionaryService: DictionaryServiceProtocol {
//
//    public init() {}
//
//    public func fetchDictionaryEntries(word: String, completion: @escaping (Result<[Dictionary], Error>) -> Void) {
//
//        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
//        AF.request(urlString).responseData { response in
//            switch response.result {
//
//            case .success(let data):
//                let decoder = Decoders.dateDecoder
//
//                do {
//                    let response = try decoder.decode(DictionaryResponse.self, from: data)
//                    completion(.success(response.results))
//                } catch {
//                    print("********** JSON DECODE ERROR *******")
//                }
//            case .failure(let error):
//                print("**** GEÇİCİ BİR HATA OLUŞTU: \(error.localizedDescription) ******")
//            }
//        }
//    }
//}
//


//public protocol DictionaryServiceProtocol: AnyObject {
//    func fetchDictionaryEntries(word: String, completion: @escaping (Result<[Dictionary], Error>) -> Void)
//    func fetchSynonyms(word: String, completion: @escaping (Result<[String], Error>) -> Void)
//}
//
//public class DictionaryService: DictionaryServiceProtocol {
//    public init() {}
//
//    public func fetchDictionaryEntries(word: String, completion: @escaping (Result<[Dictionary], Error>) -> Void) {
//        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
//        AF.request(urlString).responseData { response in
//            switch response.result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//
//                do {
//                    let entries = try decoder.decode([Dictionary].self, from: data)
//                    completion(.success(entries))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    public func fetchSynonyms(word: String, completion: @escaping (Result<[String], Error>) -> Void) {
//        let urlString = "https://api.datamuse.com/words?rel_syn=\(word)"
//        AF.request(urlString).responseJSON { response in
//            switch response.result {
//            case .success(let json):
//                if let jsonArray = json as? [[String: Any]] {
//                    let sortedArray = jsonArray.sorted { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
//                    let top5Array = Array(sortedArray.prefix(5))
//                    let synonyms = top5Array.compactMap { $0["word"] as? String }
//                    completion(.success(synonyms))
//                } else {
//                    completion(.failure(ServiceError.invalidResponse))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
//
//// Özel bir hata türü oluşturabilirsiniz.
//enum ServiceError: Error {
//    case invalidResponse
//}
//





