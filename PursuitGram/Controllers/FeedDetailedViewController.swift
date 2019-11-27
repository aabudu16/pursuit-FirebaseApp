//
//  FeedDetsiledViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/24/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit

class FeedDetailedViewController: UIViewController {
    
    var feed:Post!{
        didSet{
            
            ImageHelper.shared.getImage(urlStr: feed.feedImage) { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let image):
                    DispatchQueue.main.async {
                         self.feedDetailImage.image = image
                    }
                }
            }
            
            displayNameLabel.text = "Submitted by \(feed.userName)"
            dateLabel.text = "Created at: \(String(describing: feed.dateCreated))"
            
        }
    }
    
    //MARK: private UIObjects
    lazy var feedDetailImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "imagePlaceholder")
        return image
    }()
    
    lazy var imageDetailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Image Detail"
        label.font = UIFont(name: "Verdana-Bold", size: 35)
        label.textColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Submitted by DisplayName"
        label.font = UIFont(name: "Verdana-Bold", size: 20)
        label.textColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Created at: Date"
        label.font = UIFont(name: "Verdana-Bold", size: 15)
        label.textColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: private functions
    private func setupView(){
        view.backgroundColor = .white
        configureTitleLabelConstraints()
        configureUploadImageConstraints()
        configureDisplayNameLabelConstraints()
        configureDateLabelConstraints()
    }
    //MARK: private constraints
    
    private func configureTitleLabelConstraints(){
        view.addSubview(imageDetailLabel)
        imageDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageDetailLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), imageDetailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), imageDetailLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), imageDetailLabel.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    private func configureUploadImageConstraints(){
        view.addSubview(feedDetailImage)
        feedDetailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([feedDetailImage.topAnchor.constraint(equalTo: self.imageDetailLabel.bottomAnchor), feedDetailImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30), feedDetailImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30), feedDetailImage.heightAnchor.constraint(equalToConstant: 300)])
    }
    
    private func configureDisplayNameLabelConstraints(){
        view.addSubview(displayNameLabel)
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([displayNameLabel.topAnchor.constraint(equalTo: self.feedDetailImage.bottomAnchor, constant: 10), displayNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10) ,displayNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor) ,displayNameLabel.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    private func configureDateLabelConstraints(){
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([dateLabel.topAnchor.constraint(equalTo: self.displayNameLabel.bottomAnchor, constant: 10), dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10) ,dateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor) ,dateLabel.heightAnchor.constraint(equalToConstant: 30)])
    }
    
}
