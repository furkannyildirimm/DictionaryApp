//
//  SearchViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import DictionaryAPI

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var button: UIButton!
    var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    func performSearch(with keyword: String) {
        let dictionaryService = DictionaryService()
        dictionaryService.fetchDictionaryEntries(word: keyword) { [weak self] result in
            switch result {
            case .success(let entries):
                DispatchQueue.main.async {
                    let detailViewController = DetailViewController(entries: entries)
                    self?.navigationController?.pushViewController(detailViewController, animated: true)
                }
            case .failure(let error):
                print("Hata oluştu: \(error)")
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
