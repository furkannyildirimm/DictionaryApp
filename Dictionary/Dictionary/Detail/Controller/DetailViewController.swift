//
//  DetailViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import DictionaryAPI

struct MeaningList {
    let partOfSpeech: String
    let definition: String
    let example: String
    
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    var entries: [DictionaryElement]
    var meaningList: [MeaningList] = []
    
    init(entries: [DictionaryElement]) {
        self.entries = entries
        super.init(nibName: nil, bundle: nil)
        meaningList = createMeaningList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNewsTableViewCell()
    }
    
    private func registerNewsTableViewCell(){
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
    }
    
    func createMeaningList() -> [MeaningList] {
        var meaningList: [MeaningList] = []
        guard let meanings = entries.first?.meanings else { return [] }
        for meaning in meanings {
            guard let partOfSpeech = meaning.partOfSpeech ,
                  let definitions = meaning.definitions
            else {
                continue
            }
            for definition in definitions {
                let meaningItem = MeaningList(partOfSpeech: partOfSpeech, definition: definition.definition ?? "", example: definition.example ?? "")
                meaningList.append(meaningItem)
            }
        }
        return meaningList
    }
}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meaningList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let entry = meaningList[indexPath.row]
        cell.set(model: entry)
        return cell
    }
}
