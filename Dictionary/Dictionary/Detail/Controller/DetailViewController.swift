//
//  DetailViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import DictionaryAPI

class DetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var kelimetableview: UITableView!
    
    
    
    var entries: [DictionaryElement]
        
        init(entries: [DictionaryElement]) {
            self.entries = entries
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNewsTableViewCell()

    }
    private func registerNewsTableViewCell(){
        kelimetableview.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
    }

}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let entry = entries[indexPath.row]
        cell.set(model: entry)
        return cell
    }
    
    
}










//import UIKit
//
//class DetailViewController: UIViewController {
//
//    @IBOutlet weak var wordLabel: UILabel!
//    @IBOutlet weak var meaningLabel: UILabel!
//    @IBOutlet weak var synonymsLabel: UILabel!
//
//    var word: String = ""
//    var viewModel: DictionaryServiceProtocol!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fetchData()
//    }
//
//    func fetchData() {
//        viewModel.fetchDictionaryEntries(word: word) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let entries):
//                if let firstEntry = entries.first {
//                    DispatchQueue.main.async {
//                        self.wordLabel.text = firstEntry.word
//                        self.meaningLabel.text = self.formatMeanings(meanings: firstEntry.meanings)
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.showErrorMessage(error)
//                }
//            }
//        }
//
//        viewModel.fetchSynonyms(word: word) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let synonyms):
//                DispatchQueue.main.async {
//                    self.synonymsLabel.text = synonyms.joined(separator: ", ")
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.showErrorMessage(error)
//                }
//            }
//        }
//    }
//
//    func formatMeanings(meanings: [Meaning]?) -> String {
//        guard let meanings = meanings else { return "" }
//
//        var formattedMeanings = ""
//
//        for meaning in meanings {
//            if let partOfSpeech = meaning.partOfSpeech, let definitions = meaning.definitions {
//                let formattedDefinitions = definitions.compactMap { "- \($0.definition ?? "")" }.joined(separator: "\n")
//                formattedMeanings += "\(partOfSpeech):\n\(formattedDefinitions)\n\n"
//            }
//        }
//
//        return formattedMeanings
//    }
//
//    func showErrorMessage(_ error: Error) {
//        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
//    }
//}
