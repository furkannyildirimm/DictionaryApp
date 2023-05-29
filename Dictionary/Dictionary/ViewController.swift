//
//  ViewController.swift
//  Dictionary
//
//  Created by STARK on 26.05.2023.
//


import UIKit
import DictionaryAPI

class ViewController: UIViewController {
    let dictionaryService = DictionaryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    func fetchData() {
        let word = "kit" // İstediğiniz kelimeyi burada belirleyin
        
        dictionaryService.fetchDictionaryEntries(word: word) { result in
            switch result {
            case .success(let entries):
                // Sözlük girişlerini entries olarak alabilirsiniz
                // İstediğiniz şekilde görüntüleyebilirsiniz
                
                // Örnek olarak, ilk girişin kelimesini ve anlamını bastıralım:
                if let firstEntry = entries.first {
                    if let word = firstEntry.word,
                       let meanings = firstEntry.meanings {
                        print("Kelime: \(word)")
                        
                        for meaning in meanings {
                            if let partOfSpeech = meaning.partOfSpeech,
                               let definitions = meaning.definitions {
                                print("Anlam (\(partOfSpeech)):")
                                
                                for definition in definitions {
                                    if let definitionText = definition.definition {
                                        print("- \(definitionText)")
                                    }
                                }
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print("Veri çekme hatası: \(error)")
            }
        }
        
        dictionaryService.fetchSynonyms(word: word) { result in
            switch result {
            case .success(let synonyms):
                // Eş anlamlıları synonyms olarak alabilirsiniz
                // İstediğiniz şekilde görüntüleyebilirsiniz
                
                // Örnek olarak, eş anlamlıları bastıralım:
                print("Eş Anlamlılar:")
                for synonym in synonyms {
                    print("- \(synonym)")
                }
                
            case .failure(let error):
                print("Eş anlamlıları çekme hatası: \(error)")
            }
        }
    }
}
