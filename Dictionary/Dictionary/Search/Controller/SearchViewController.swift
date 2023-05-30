//
//  SearchViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import DictionaryAPI
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var button: UIButton!
    var keyboardHeight: CGFloat = 0.0
    var searchEntries: [SearchEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadSearchEntries()
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3) {
                self.button.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.button.transform = .identity
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let keyword = searchBar.text else {
            return
        }
        performSearch(with: keyword)
    }
    
//    func loadSearchEntries() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let fetchRequest: NSFetchRequest<SearchEntry> = SearchEntry.fetchRequest()
//        fetchRequest.fetchLimit = 6
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
//
//        do {
//            let fetchedEntries = try context.fetch(fetchRequest)
//            let uniqueEntries = fetchedEntries.reduce([]) { result, entry in
//                result.contains(where: { $0.searchText == entry.searchText }) ? result : result + [entry]
//            }
//            searchEntries = uniqueEntries
//            tableView.reloadData()
//        } catch {
//            print("Arama girişleri yüklenirken hata oluştu: \(error)")
//        }
//    }
    
    func loadSearchEntries() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SearchEntry> = SearchEntry.fetchRequest()
        fetchRequest.fetchLimit = 5 // Son 5 arama girişini almak için sınırlama yapılıyor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)] // Tarih sırasına göre sıralama yapılıyor
        
        do {
            searchEntries = try context.fetch(fetchRequest)
            tableView.reloadData() // TableView'i güncelle
        } catch {
            print("Arama girişleri yüklenirken hata oluştu: \(error)")
        }
    }
    
    
    func performSearch(with keyword: String?) {
        guard let keyword = keyword else {
            return
        }
        let dictionaryService = DictionaryService()
        dictionaryService.fetchDictionaryEntries(word: keyword) { [weak self] result in
            guard let self = self else { return }
            
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
                    
                    let detailViewController = DetailViewController(entries: entries)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    if let viewController = self {
                        Alert.showAlert(alertTitle: "Error", alertMessage: "Word not found.", defaultTitle: "OK", viewController: viewController)
                    }
                    print("Hata oluştu: \(error)")
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.button.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.button.transform = .identity
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let searchEntry = searchEntries[indexPath.row]
        cell.titleLabel.text = searchEntry.searchText
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchEntry = searchEntries[indexPath.row]
        let keyword = searchEntry.searchText
        performSearch(with: keyword)
    }
}

