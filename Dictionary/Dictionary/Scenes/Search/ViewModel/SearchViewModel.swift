//
//  SearchViewModel.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import Foundation
import DictionaryAPI
import CoreData
import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func reloadData()
    func push(vc: UIViewController)
    func showAlert(error: String)
}

final class SearchViewModel {
    
    // MARK: - PROPERTIES
    
    var keyboardHeight: CGFloat = 0.0
    var searchEntries: [SearchEntry] = []
    weak var delegate: SearchViewModelDelegate?
    
    // MARK: - INTERNAL FUNCTIONS
    
    func loadSearchEntries() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SearchEntry> = SearchEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            let fetchedEntries = try context.fetch(fetchRequest)
            var uniqueEntries: [SearchEntry] = []
            var searchTextSet: Set<String> = Set()
            var count = 0
            for entry in fetchedEntries {
                if !searchTextSet.contains(entry.searchText ?? "") {
                    uniqueEntries.append(entry)
                    searchTextSet.insert(entry.searchText ?? "")
                    count += 1
                }
                
                if count >= 5 {
                    break
                }
            }
            searchEntries = uniqueEntries
            delegate?.reloadData()
        } catch {
            print("Arama girişleri yüklenirken hata oluştu: \(error)")
        }
    }
    
    func performSearch(with keyword: String?) {
        guard let keyword = keyword else { return }
        let dictionaryService = DictionaryService()
        dictionaryService.fetchDictionaryEntries(word: keyword) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entries):
                DispatchQueue.main.async {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let searchEntry = SearchEntry(context: context)
                    searchEntry.searchText = keyword
                    searchEntry.timestamp = Date()
                    do {
                        try context.save()
                    } catch {
                        print("Arama girişi kaydedilirken hata oluştu: \(error)")
                    }
                    self.loadSearchEntries()
                    let detailViewController = DetailViewController()
                    let detailVM = DetailViewModel()
                    detailVM.entries = entries
                    detailViewController.viewModel = detailVM
                    self.delegate?.push(vc: detailViewController)
                }
            case .failure(let error):
                self.delegate?.showAlert(error: error.localizedDescription)
            }
        }
    }
}
