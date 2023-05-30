//
//  DetailViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import DictionaryAPI
import AVFoundation

struct MeaningList {
    let id: Int
    let partOfSpeech: String
    let definition: String
    let example: String
    
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    
    var entries: [DictionaryElement]
    var meaningList: [MeaningList] = []
    var synonyms: [String] = []
    var collectionView: UICollectionView!
    var audioPlayer: AVPlayer?
    
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
        setupCollectionView()
        fetchSynonyms()
        voiceButton()
        addCustomBackButton()
    }
    
    func addCustomBackButton() {
        let backButton = CustomBackButton()
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func registerNewsTableViewCell() {
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
    }
    
    func voiceButton(){
        var audioSet: Set<String> = []
        for phonetics in entries {
            for phonetic in phonetics.phonetics ?? [] {
                if phonetic.audio != ""{
                    audioSet.insert(phonetic.audio ?? "")
                }
            }
        }
        if let audioURLString = audioSet.first {
            voiceBtn.isHidden = false
            voiceBtn.isEnabled = true
            setupAudioPlayer(audioURLString)
        } else {
            voiceBtn.isHidden = true
            voiceBtn.isEnabled = false
        }
    }
    
    @IBAction func voiceBtnTapped(_ sender: UIButton) {
        if audioPlayer?.timeControlStatus == .playing {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
    }
    
    func setupAudioPlayer(_ audioURLString: String) {
        guard let audioURL = URL(string: audioURLString) else { return }
        let playerItem = AVPlayerItem(url: audioURL)
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func audioPlayerDidFinishPlaying(_ notification: Notification) {
        
        audioPlayer?.seek(to: CMTime.zero)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 50, left: 10, bottom: 10, right: 25)
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: detailTableView.frame.width, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SynonymCell")
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: collectionView.frame.width, height: 30))
        headerLabel.text = "Synonym"
        headerLabel.textAlignment = .left
        headerLabel.textColor = .black
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        collectionView.addSubview(headerLabel)
        
        
        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: detailTableView.frame.width, height: 0))
        viewFooter.addSubview(collectionView)
        detailTableView.tableFooterView = viewFooter
    }
    
    func fetchSynonyms() {
        guard let keyword = entries.first?.word else { return }
        
        let dictionaryService = DictionaryService()
        dictionaryService.fetchSynonyms(word: keyword) { [weak self] result in
            switch result {
            case .success(let synonyms):
                self?.synonyms = synonyms
                self?.collectionView.reloadData()
                
                
                let height = self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0
                self?.collectionView.frame.size.height = height
                self?.detailTableView.tableFooterView?.frame.size.height = height
                self?.detailTableView.tableFooterView = self?.detailTableView.tableFooterView
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

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synonyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SynonymCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        let label = UILabel(frame: cell.bounds)
        label.text = synonyms[indexPath.item]
        label.textColor = .black
        label.textAlignment = .center
        cell.contentView.addSubview(label)
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let synonym = synonyms[indexPath.item]
        print("Selected Synonym: \(synonym)")
    }
}
