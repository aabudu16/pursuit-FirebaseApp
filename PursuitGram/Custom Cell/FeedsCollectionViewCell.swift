//
//  FeedsCollectionViewCell.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/24/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit

class FeedsCollectionViewCell: UICollectionViewCell {
    
    lazy var feedImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "imagePlaceholder")
        return image
    }()
    
    lazy var displayNameLabel:UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.textColor = .white
           label.font = UIFont(name: "Zapf Dingbats", size: 15)
          // label.text = "display name"
           return label
       }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        configureImageViewConstraints()
        configureVenueLabelConstraints()
       }
    
    private func configureImageViewConstraints(){
        addSubview(feedImage)
        feedImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([feedImage.topAnchor.constraint(equalTo: self.topAnchor), feedImage.leadingAnchor.constraint(equalTo: self.leadingAnchor), feedImage.trailingAnchor.constraint(equalTo: self.trailingAnchor), feedImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    private func configureVenueLabelConstraints(){
           addSubview(displayNameLabel)
           displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([displayNameLabel.leadingAnchor.constraint(equalTo: self.feedImage.leadingAnchor), displayNameLabel.trailingAnchor.constraint(equalTo: self.feedImage.trailingAnchor), displayNameLabel.bottomAnchor.constraint(equalTo: self.feedImage.bottomAnchor,constant: 5), displayNameLabel.heightAnchor.constraint(equalToConstant: 20)])
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
