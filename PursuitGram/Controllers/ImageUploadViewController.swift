//
//  ImageUploadViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/23/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController {

    lazy var uploadImage:UIImageView = {
           let image = UIImageView()
           image.image = #imageLiteral(resourceName: "imagePlaceholder")
           return image
       }()
    
    lazy var uploadButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Login", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
           button.backgroundColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
           button.layer.cornerRadius = 5
           button.addTarget(self, action: #selector(handleUploadButton), for: .touchUpInside)
           return button
       }()
    
    lazy var titleLabel: UILabel = {
          let label = UILabel()
          label.numberOfLines = 0
          label.text = "Upload An Image"
          label.font = UIFont(name: "Verdana-Bold", size: 35)
          label.textColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
          label.backgroundColor = .clear
          label.textAlignment = .center
          return label
      }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTitleLabelConstraints()
        configureUploadImageConstraints()
        configureUploadButtonConstraints()

    }
//MARK:-- @objc function
    @objc func handleUploadButton(){
        print("upload button pressed")
    }

    
  //MARK: private constraints
    
    private func configureTitleLabelConstraints(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor), titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), titleLabel.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    private func configureUploadImageConstraints(){
        view.addSubview(uploadImage)
        uploadImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([uploadImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor), uploadImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30), uploadImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30), uploadImage.heightAnchor.constraint(equalToConstant: 300)])
    }
    
    private func configureUploadButtonConstraints(){
        view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([uploadButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20), uploadButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50), uploadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -50), uploadButton.heightAnchor.constraint(equalToConstant: 40)])
    }
}
