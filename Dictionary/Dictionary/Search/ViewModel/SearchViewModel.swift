//
//  SearchViewModel.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import Foundation
import DictionaryAPI


//protocol SearchViewModelProtocol {
//    var delegate: SearchViewModelDelegate? { get set }
//}
//
//protocol SearchViewModelDelegate: AnyObject {
//
//}
//
//
//
//final class SearchViewModel {
//    private var dictionaries: [DictionaryElement] = []
//    let service: DictionaryServiceProtocol
//    weak var delegate: SearchViewModelDelegate?
//
//    init(service: DictionaryServiceProtocol, delegate: SearchViewModelDelegate? = nil) {
//        self.service = service
//        self.delegate = delegate
//    }
//
//    fileprivate func fetchData() {
//        let word = "kit" // İstediğiniz kelimeyi burada belirleyin
//
//        service.fetchDictionaryEntries(word: word) { result in
//            switch result {
//            case .success(let entries):
//                // Sözlük girişlerini entries olarak alabilirsiniz
//                // İstediğiniz şekilde görüntüleyebilirsiniz
//
//                // Örnek olarak, ilk girişin kelimesini ve anlamını bastıralım:
//                if let firstEntry = entries.first {
//                    if let word = firstEntry.word,
//                       let meanings = firstEntry.meanings {
//                        print("Kelime: \(word)")
//
//                        for meaning in meanings {
//                            if let partOfSpeech = meaning.partOfSpeech,
//                               let definitions = meaning.definitions {
//                                print("Anlam (\(partOfSpeech)):")
//
//                                for definition in definitions {
//                                    if let definitionText = definition.definition {
//                                        print("- \(definitionText)")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print("Veri çekme hatası: \(error)")
//            }
//        }
//
//        service.fetchSynonyms(word: word) { result in
//            switch result {
//            case .success(let synonyms):
//                // Eş anlamlıları synonyms olarak alabilirsiniz
//                // İstediğiniz şekilde görüntüleyebilirsiniz
//
//                // Örnek olarak, eş anlamlıları bastıralım:
//                print("Eş Anlamlılar:")
//                for synonym in synonyms {
//                    print("- \(synonym)")
//                }
//
//            case .failure(let error):
//                print("Eş anlamlıları çekme hatası: \(error)")
//            }
//        }
//    }
//}
//
//
//extension SearchViewModel: SearchViewModelProtocol {
//
//}

//protocol SearchViewModelProtocol {
//    var delegate: SearchViewModelDelegate? { get set }
//    
//    func fetchData()
//}
//
//protocol SearchViewModelDelegate: AnyObject {
//    func didFetchEntries(_ entries: [DictionaryElement])
//    func didFailFetchingEntries(with error: Error)
//    func didFetchSynonyms(_ synonyms: [String])
//    func didFailFetchingSynonyms(with error: Error)
//}
//
//final class SearchViewModel: SearchViewModelProtocol {
//    private var dictionaries: [DictionaryElement] = []
//    let service: DictionaryServiceProtocol
//    weak var delegate: SearchViewModelDelegate?
//    
//    init(service: DictionaryServiceProtocol, delegate: SearchViewModelDelegate? = nil) {
//        self.service = service
//        self.delegate = delegate
//    }
//    
//    func fetchData() {
//        let word = "kit" // İstediğiniz kelimeyi burada belirleyin
//        
//        service.fetchDictionaryEntries(word: word) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let entries):
//                self.dictionaries = entries
//                self.delegate?.didFetchEntries(entries)
//                
//            case .failure(let error):
//                self.delegate?.didFailFetchingEntries(with: error)
//            }
//        }
//        
//        service.fetchSynonyms(word: word) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let synonyms):
//                self.delegate?.didFetchSynonyms(synonyms)
//                
//            case .failure(let error):
//                self.delegate?.didFailFetchingSynonyms(with: error)
//            }
//        }
//    }
//}
//
//

