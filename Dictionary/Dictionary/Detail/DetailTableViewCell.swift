//
//  DetailTableViewCell.swift
//  Dictionary
//
//  Created by STARK on 28.05.2023.
//

import UIKit
import DictionaryAPI

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partOfSpeechLbl: UILabel!
    @IBOutlet weak var definitionLbl: UILabel!
    @IBOutlet weak var exampleTitleLbl: UILabel!
    @IBOutlet weak var exampleLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    
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
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func set(model: MeaningList) {
//
//        partOfSpeechLbl.text = model.partOfSpeech
//        definitionLbl.text = model.definition
//        if model.example.isEmpty {
//            exampleLbl.isHidden = true
//            exampleTitleLbl.isHidden = true
//        }else{
//            exampleLbl.text = model.example
//        }
//        numberLbl.text = "\(model.id) -"
//      }
//}


