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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(model: DictionaryElement) {
        if let partOfSpeech = model.meanings?.first?.partOfSpeech {
              partOfSpeechLbl.text = partOfSpeech
          }
          
          if let definition = model.meanings?.first?.definitions?.first?.definition {
              definitionLbl.text = definition
          }
      }
}
