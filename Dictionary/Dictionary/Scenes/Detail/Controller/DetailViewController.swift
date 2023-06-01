//
//  DetailViewController.swift
//  Dictionary
//
//  Created by STARK on 27.05.2023.
//

import UIKit
import AVFoundation

final class DetailViewController: UIViewController, LoadingShowable {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var voiceBtn: UIButton!
    @IBOutlet private weak var detailTableView: UITableView!
    
    // MARK: - PROPERTIES
    
    private var collectionView: UICollectionView!
    var viewModel: DetailViewModel = DetailViewModel() {
        didSet {
            viewModel.delegate = self
            viewModel.meaningList = viewModel.createMeaningList()
        }
    }
    
    // MARK: - OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        detailTableView.register(cellClass: DetailTableViewCell.self)
        setupCollectionView()
        viewModel.fetchSynonyms()
        voiceButton()
        addCustomBackButton()
        displayTitleAndSubtitle()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func voiceButton() {
        if let audioURLString = viewModel.getAudioSet().first {
            voiceBtn.isHidden = false
            voiceBtn.isEnabled = true
            viewModel.setupAudioPlayer(audioURLString)
        } else {
            voiceBtn.isHidden = true
            voiceBtn.isEnabled = false
        }
    }
    
    private func displayTitleAndSubtitle() {
        if let entry = viewModel.entries.first {
            if let word = entry.word?.capitalized {
                titleLabel.isHidden = false
                titleLabel.text = word
            } else {
                titleLabel.isHidden = true
            }
            
            if let phonetic = entry.phonetics?.first?.text {
                subtitleLabel.isHidden = false
                subtitleLabel.text = phonetic
            } else {
                subtitleLabel.isHidden = true
            }
        } else {
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
        }
    }
    
    
    private func addCustomBackButton() {
        let backButton = CustomBackButton()
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @IBAction func voiceBtnTapped(_ sender: UIButton) {
        viewModel.audioPlayer?.timeControlStatus == .playing ? viewModel.audioPlayer?.pause() : viewModel.audioPlayer?.play()
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
        
        let footerTitleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: collectionView.frame.width, height: 30))
        footerTitleLabel.text = "Synonym"
        footerTitleLabel.textAlignment = .left
        footerTitleLabel.textColor = .black
        footerTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        collectionView.addSubview(footerTitleLabel)
        
        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: detailTableView.frame.width, height: 0))
        viewFooter.addSubview(collectionView)
        detailTableView.tableFooterView = viewFooter
    }
}

//MARK: - UITABLEVIEWDATASOURCE

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meaningList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
        let entry = viewModel.meaningList[indexPath.row]
        cell.set(model: entry)
        return cell
    }
}

//MARK: - UICOLLECTIONVIEWDATASOURCE

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.synonyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SynonymCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        let label = UILabel(frame: cell.bounds)
        label.text = viewModel.synonyms[indexPath.item]
        label.textColor = .black
        label.textAlignment = .center
        cell.contentView.addSubview(label)
        
        return cell
    }
}

//MARK: - UICOLLECTIONVIEWDELEGATEFLOWLAYOUT

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let synonym = viewModel.synonyms[indexPath.item]
        let label = UILabel()
        label.text = synonym
        label.font = UIFont.systemFont(ofSize: 17)
        let labelSize = label.sizeThatFits(CGSize(width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        if labelSize.width > 100 || labelSize.height > 40 {
            return CGSize(width: labelSize.width + 20, height: 40)
        } else {
            return CGSize(width: 100, height: 40)
        }
    }
}

//MARK: - UICOLLECTIONVIEWDELEGATE

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let synonym = viewModel.synonyms[indexPath.item]
        print("Selected Synonym: \(synonym)")
    }
}

//MARK: - DETAILVIEWMODELDELEGATE

extension DetailViewController: DetailViewModelDelegate {
    func fetchedData() {
        self.hideLoading()
        collectionView.reloadData()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.frame.size.height = height
        detailTableView.tableFooterView?.frame.size.height = height
        detailTableView.tableFooterView = detailTableView.tableFooterView
    }
}
