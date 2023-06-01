//
//  DetailTableViewCell.swift
//  Dictionary
//
//  Created by STARK on 28.05.2023.
//

import UIKit


final class DetailTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: DetailTableViewCell.self)
    
    // MARK: - IBOUTLETS
    
    @IBOutlet private weak var partOfSpeechLbl: UILabel!
    @IBOutlet private weak var definitionLbl: UILabel!
    @IBOutlet private weak var exampleTitleLbl: UILabel!
    @IBOutlet private weak var exampleLbl: UILabel!
    @IBOutlet private weak var numberLbl: UILabel!
    
    // MARK: - OVERRIDE FUNCTIONS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exampleLbl.isHidden = true
        exampleTitleLbl.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        exampleLbl.isHidden = true
        exampleTitleLbl.isHidden = true
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    func set(model: MeaningList) {
        partOfSpeechLbl.text = model.partOfSpeech
        definitionLbl.text = model.definition
        
        if !model.example.isEmpty {
            exampleLbl.isHidden = false
            exampleTitleLbl.isHidden = false
            exampleLbl.text = model.example
        } else {
            exampleLbl.isHidden = true
            exampleTitleLbl.isHidden = true
            exampleLbl.text = nil
        }
        numberLbl.text = "\(model.id) -"
    }
}


