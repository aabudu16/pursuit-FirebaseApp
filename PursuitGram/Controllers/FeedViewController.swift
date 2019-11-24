//
//  FeedViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/22/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    // enum
    enum collectionIdentifiers:String{
        case collectionCell
    }
    
    var feeds = [Post](){
        didSet{
            collectionView.reloadData()
        }
    }
    //MARK: UI Objects
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(FeedsCollectionViewCell.self, forCellWithReuseIdentifier: collectionIdentifiers.collectionCell.rawValue)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    lazy var feedLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Zapf Dingbats", size: 30)
        label.text = "Feed"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureFeedLabelConstraints()
        configureCollectionViewConstraints()
    }
    
    //MARK: Private Constraints function
    private func configureFeedLabelConstraints(){
        self.view.addSubview(feedLabel)
        feedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([feedLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), feedLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), feedLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), feedLabel.heightAnchor.constraint(equalToConstant: 100)])
    }
    
    private func configureCollectionViewConstraints(){
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5), collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),collectionView.topAnchor.constraint(equalTo: self.feedLabel.bottomAnchor)])
    }
    
}
extension FeedViewController: UICollectionViewDelegate{}
extension FeedViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifiers.collectionCell.rawValue, for: indexPath) as? FeedsCollectionViewCell else {return UICollectionViewCell()}
        
        cell.displayNameLabel.text = "Display label"
        cell.feedImage.image = UIImage(systemName: "photo")
        CustomLayer.shared.createCustomlayer(layer: cell.layer)
        
        return cell
    }
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let virticalCellCGSize = CGSize(width: 170, height: 170)
        return virticalCellCGSize
    }
}
