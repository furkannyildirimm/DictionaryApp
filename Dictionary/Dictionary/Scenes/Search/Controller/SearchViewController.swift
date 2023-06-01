//
//  SearchViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import CoreData

final class SearchViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - PROPERTIES
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    // MARK: - OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        searchBar.delegate = self
        tableView.register(cellClass: SearchCell.self)
        searchBar.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewModel.loadSearchEntries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            viewModel.keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.button.transform = CGAffineTransform(translationX: 0, y: -self.viewModel.keyboardHeight)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.button.transform = .identity
        }
    }
    
    @IBAction private func searchButtonTapped(_ sender: Any) {
        guard let keyword = searchBar.text else {
            return
        }
        viewModel.performSearch(with: keyword)
    }
}

// MARK: - UISEARCHBARDELEGATE

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.button.transform = CGAffineTransform(translationX: 0, y: -self.viewModel.keyboardHeight)
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

//MARK: - UITABLEVIEWDATASOURCE&DELEGATE

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        let searchEntry = viewModel.searchEntries[indexPath.row]
        cell.titleLabel.text = searchEntry.searchText
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchEntry = viewModel.searchEntries[indexPath.row]
        let keyword = searchEntry.searchText
        viewModel.performSearch(with: keyword)
    }
}

//MARK: - SEARCHVIEWMODELDELEGATE

extension SearchViewController: SearchViewModelDelegate {
    func showAlert(error: String) {
        DispatchQueue.main.async { [weak self] in
            if let viewController = self {
                Alert.showAlert(alertTitle: "Error", alertMessage: "Word not found.", defaultTitle: "OK", viewController: viewController)
            }
            print("Hata oluştu: \(error)")
        }
    }
    
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadData() {
        tableView.reloadData()
        searchBar.text = ""
    }
}

