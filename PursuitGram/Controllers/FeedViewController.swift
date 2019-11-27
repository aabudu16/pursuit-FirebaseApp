//
//  FeedViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/22/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    
    //MARK: UI LifeCylce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    //MARK: objc function
    @objc func handleLogoutButton(){
        try?  Auth.auth().signOut()
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func handlePresentingProfileVC(){
        let profileVC = ProfileViewController()
        profileVC.buttonSelection = .updateProfileButtonEnabled
        self.present(profileVC, animated: true, completion: nil)
    }
    
    //MARK: private func
    private func getPosts() {
        FirestoreService.manager.getAllPosts(sortingCriteria: .fromNewestToOldest) { (result) in
            switch result {
            case .success(let posts):
                self.feeds = posts
            case .failure(let error):
                print("error getting posts \(error)")
            }
        }
    }
    
    
    private func setupLogoutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogoutButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(handlePresentingProfileVC))
    }
    private func setupView(){
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
extension FeedViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedDetailedVc = FeedDetailedViewController()
        feedDetailedVc.feed = feeds[indexPath.item]
        navigationController?.pushViewController(feedDetailedVc, animated: true)
    }
}
extension FeedViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifiers.collectionCell.rawValue, for: indexPath) as? FeedsCollectionViewCell else {return UICollectionViewCell()}
        let feed = feeds[indexPath.row]
        
        cell.displayNameLabel.text = feed.userName
        ImageHelper.shared.getImage(urlStr: feed.feedImage) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let image):
                DispatchQueue.main.async {
                    cell.feedImage.image = image
                }
            }
        }
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
