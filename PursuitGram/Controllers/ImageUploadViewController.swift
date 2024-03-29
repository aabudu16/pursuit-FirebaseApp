//
//  ImageUploadViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/23/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit
import Photos
import FirebaseAuth

class ImageUploadViewController: UIViewController {
    
    var imageURL: URL? = nil
    var image = UIImage() {
        didSet {
            self.uploadImage.image = image
        }
    }
    
    //MARK:-- UIObjects
    lazy var uploadImage:UIImageView = {
        let image = UIImageView()
        CustomLayer.shared.createCustomlayer(layer: image.layer)
        let guesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDoubleTapped(sender:)))
        guesture.numberOfTapsRequired = 2
        image.image = #imageLiteral(resourceName: "imagePlaceholder")
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(guesture)
        return image
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
        button.layer.cornerRadius = 5
        CustomLayer.shared.createCustomlayer(layer: button.layer)
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.hidesWhenStopped = true
        activityView.color = .white
        activityView.stopAnimating()
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK:-- @objc function
    @objc func handleUploadButton(){
        guard uploadImage.image != nil, uploadImage.image != UIImage(named: "imagePlaceholder") else {
            showAlert(with: "Error", and: "Please enter a valid image")
            return
        }
        

        guard let user = FirebaseAuthService.manager.currentUser else {
            showAlert(with: "Error", and: "You must be logged in to create a post")
            return
        }
        
        guard let imageURLString = imageURL?.absoluteString else {
            return
        }

        guard let userDisplayName = user.displayName else {
            return
        }
        let newPost = Post(creatorID: user.uid, image: imageURLString, userName: userDisplayName)
        FirestoreService.manager.createPost(post: newPost) { (result) in
            self.handlePostResponse(withResult: result)
        }
      //  print(FirebaseAuthService.manager.currentUser?.displayName)
    }
    
    //MARK: Private methods
    
    private func handlePostResponse(withResult result: Result<Void, Error>) {
        switch result {
        case .success:
            showAlert(with: nil, and: "A new post has been added")
        case let .failure(error):
            print("An error occurred creating the post: \(error)")
        }
    }
    
    
    private func showAlert(with title: String?, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
    @objc private func imageViewDoubleTapped(sender:UITapGestureRecognizer) {
        print("pressed")
        //MARK: TODO - action sheet with multiple media options
        activityIndicator.startAnimating()
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    print("Denied photo library permissions")
                default:
                    print("No usable status")
                }
            })
        default:
            presentPhotoPickerController()
        }
    }
    
    //MARK: private functions
    
    private func setupView(){
        view.backgroundColor = .white
        configureTitleLabelConstraints()
        configureUploadImageConstraints()
        configureUploadButtonConstraints()
        configureActivityIndicatorConstraints()
        showAlert(with: "Message", and: "Double tab to set your image")
    }
    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
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
    
    private func configureActivityIndicatorConstraints(){
        self.uploadImage.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicator.topAnchor.constraint(equalTo: self.uploadImage.topAnchor) , activityIndicator.leadingAnchor.constraint(equalTo: self.uploadImage.leadingAnchor) ,activityIndicator.trailingAnchor.constraint(equalTo: self.uploadImage.trailingAnchor) ,activityIndicator.bottomAnchor.constraint(equalTo: self.uploadImage.bottomAnchor)])
    }
}

extension ImageUploadViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        self.image = selectedImage
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        FirebaseStorageService.manager.storeUserInputImage(image: imageData, completion: { [weak self] (result) in
                   switch result{
                   case .success(let url):
                    print("working")
                    print(result)
                       self?.imageURL = url
                    
                   case .failure(let error):
                    print("Notworking")
                       print(error)
                   }
               })
        self.activityIndicator.stopAnimating()
        picker.dismiss(animated: true, completion: nil)
    }
}
