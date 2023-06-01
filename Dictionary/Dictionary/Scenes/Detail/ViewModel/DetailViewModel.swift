//
//  HomeViewModel.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//


import DictionaryAPI
import AVFoundation

protocol DetailViewModelDelegate: AnyObject {
    func fetchedData()
}

struct MeaningList {
    let id: Int
    let partOfSpeech: String
    let definition: String
    let example: String
}

final class DetailViewModel {
    
    // MARK: - PROPERTIES
    
    var entries: [DictionaryElement] = []
    var meaningList: [MeaningList] = []
    var synonyms: [String] = []
    var audioPlayer: AVPlayer?
    weak var delegate: DetailViewModelDelegate?
    
    // MARK: - INTERNAL FUNCTIONS
    
    func getAudioSet() -> Set<String> {
        var audioSet: Set<String> = []
        for phonetics in entries {
            for phonetic in phonetics.phonetics ?? [] {
                if phonetic.audio != "" {
                    audioSet.insert(phonetic.audio ?? "")
                }
            }
        }
        return audioSet
    }
    
    func setupAudioPlayer(_ audioURLString: String) {
        guard let audioURL = URL(string: audioURLString) else { return }
        let playerItem = AVPlayerItem(url: audioURL)
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func fetchSynonyms() {
        guard let keyword = entries.first?.word else { return }
        let dictionaryService = DictionaryService()
        dictionaryService.fetchSynonyms(word: keyword) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let synonyms):
                self.synonyms = synonyms
                self.delegate?.fetchedData()
                
            case .failure(let error):
                print("Hata oluştu: \(error)")
            }
        }
    }
    
    func createMeaningList() -> [MeaningList] {
        var meaningList: [MeaningList] = []
        
        for meanings in entries {
            for meaning in meanings.meanings ?? [] {
                guard let partOfSpeech = meaning.partOfSpeech?.capitalized else {
                    continue
                }
                guard let definitions = meaning.definitions else {
                    continue
                }
                for (index, definition) in definitions.enumerated() {
                    let meaningItem = MeaningList(id: index + 1, partOfSpeech: partOfSpeech, definition: definition.definition ?? "", example: definition.example ?? "")
                    meaningList.append(meaningItem)
                }
            }
        }
        return meaningList
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    @objc private func audioPlayerDidFinishPlaying(_ notification: Notification) {
        audioPlayer?.seek(to: CMTime.zero)
    }
}
