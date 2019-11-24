//
//  ProfileViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/22/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit
import Photos
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var currentUser: Result<User, Error>!
    var createUserModel:(email:String, password: String) = ("","")
    var settingFromLogin = false
    
    //MARK: TODO - set up views using autolayout, not frames
    //MARK: TODO - edit other fields in this VC
    var image = UIImage() {
        didSet {
           // self.imageView.image = image
        }
    }
    
    var imageURL: URL? = nil
    
    
    
    lazy var imageView: UIImageView = {
        let guesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDoubleTapped(sender:)))
        guesture.numberOfTapsRequired = 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width / 2, height: self.view.bounds.width / 2))
        imageView.backgroundColor = .black
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(guesture)
        return imageView
    }()
    
    lazy var displayName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(25)
        label.text = "Display Name"
        return label
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(30)
        label.text = "Profile"
        return label
    }()
    lazy var createButton:UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 16)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var updateProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    lazy var editDisplayName: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "edit_property"), for: .normal)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
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
        self.view.backgroundColor = #colorLiteral(red: 0.2601475716, green: 0.2609100342, blue: 0.9169666171, alpha: 1)
        showAlert(with: "Required", and: "Double tap on the image to set your profile image, and set a valid display name")
        setupViews()
        //MARK: TODO - load in user image and fields when coming from profile page
    }
    
    //MARK: @objc fucntions
    @objc private func createButtonPressed(){
        print("create button pressed")
        // guarding against not having a valid email or password
        guard createUserModel.email != "", createUserModel.password != "" else {
            return
        }
        // guarding against not having a display name and image
        guard let userName = displayName.text, let imageURL = imageURL else {
            showAlert(with: "Error", and: "Please use a valid image and user name")
            return
        }
        // srart activity indicator
        activityIndicator.startAnimating()
        // handles creating a new user account
               FirebaseAuthService.manager.createNewUser(email: createUserModel.email.lowercased(), password: createUserModel.password) { [weak self] (result) in
                   self?.currentUser = result
               }
        
        // handles creating and updaring current user profile
        FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL) { (result) in
            switch result {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (nextResult) in
                    switch nextResult {
                    case .success():
                        self?.imageView.layer.borderColor = UIColor.green.cgColor
                    case .failure(let error):
                        self?.imageView.layer.borderColor = UIColor.red.cgColor
                        self?.showAlert(with: "Error", and: "It seem your image was not save. Please check your image format and try again")
                        self?.activityIndicator.stopAnimating()
                        print(error)
                        return
                    }
                }
            case .failure(let error):
                //MARK: TODO - handle
                print(error)
            }
        }
        
        self.handleCreateAccountResponse(with: currentUser)
        // stop activity indicator
        activityIndicator.stopAnimating()
    }
    
    @objc private func updateButtonPressed(){
        // guarding against not having a display name and image
        guard let userName = displayName.text, let imageURL = imageURL else {
            showAlert(with: "Error", and: "Please a valid image and user name")
            return
        }
        self.activityIndicator.startAnimating()
        FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL) { (result) in
            switch result {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (nextResult) in
                    switch nextResult {
                    case .success():
                        self?.activityIndicator.stopAnimating()
                        self?.showAlertWithSucessMessage()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", and: "It seem your image was not save. Please check your image format and try again")
                self.activityIndicator.stopAnimating()
                print(error)
            }
        }
    }
    
    
    @objc private func imageViewDoubleTapped(sender:UITapGestureRecognizer) {
        print("pressed")
        //MARK: TODO - action sheet with multiple media options
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("Denied photo library permissions")
                default:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("No usable status")
                }
            })
        default:
            presentPhotoPickerController()
        }
    }
    
    @objc func editButtonPressed(){
        print(createUserModel)
        showAlertWithTextField(with: "Edit your display name")
    }
    
    private func setupViews() {
        setupImageView()
        profileLabelConstraints()
        configureDisplayNameConstraints()
        setupUpdateButton()
        configureEditDisplayNameConstraints()
        configureCreateButtonConstraints()
        configureActivityIndicatorConstraints()
    }
    //MARK: private function
    
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case.success(let user):
                print(user)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else { return }
                
                if FirebaseAuthService.manager.currentUser != nil {
                    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                        window.rootViewController = FeedViewController()
                    }, completion: nil)
                    
                } else {
                    print("No current user")
                }
                
                
            case .failure(let error):
                self?.showAlert(with: "Error Creating User", and: error.localizedDescription)
            }
            
        }
    }
    
    private func showAlertWithSucessMessage(){
        let alert = UIAlertController(title: "Sussess", message: "You have updated your profile", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (dismiss) in
            self.handleNavigationAwayFromVCAfterUpdating()
        }
         alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showAlertWithTextField(with message: String) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let text = alertVC.textFields?[0].text else {return}
            self.displayName.text = text
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertVC.addAction(save)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
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
    
    private func handleNavigationAwayFromVCAfterUpdating() {
        if settingFromLogin {
//            //MARK: TODO - refactor this logic into scene delegate
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
//                else {
//                    //MARK: TODO - handle could not swap root view controller
//                    return
//            }
//
//            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
//                window.rootViewController = FeedViewController()
//            }, completion: nil)
//        } else {
//            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
       }
    }
    
    
    //MARK: private constraints function
    private func configureDisplayNameConstraints(){
        view.addSubview(displayName)
        displayName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([displayName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), displayName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), displayName.heightAnchor.constraint(equalToConstant: 50), displayName.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20)])
    }
    
    private func configureEditDisplayNameConstraints(){
        self.view.addSubview(editDisplayName)
        editDisplayName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([editDisplayName.bottomAnchor.constraint(equalTo: self.displayName.topAnchor, constant: 25), editDisplayName.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant:  80), editDisplayName.heightAnchor.constraint(equalToConstant: 20), editDisplayName.widthAnchor.constraint(equalToConstant: 20)])
    }
    
    private func configureCreateButtonConstraints(){
        self.view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([createButton.topAnchor.constraint(equalTo: self.displayName.bottomAnchor, constant:  20),createButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:  100),createButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:  -100), createButton.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    private func profileLabelConstraints(){
        view.addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([profileLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant:  -20), profileLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), profileLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), profileLabel.heightAnchor.constraint(equalToConstant: 100)])
    }
    private func setupImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width / 2),
            imageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2)
        ])
    }
    
    
    private func setupUpdateButton() {
        view.addSubview(updateProfileButton)
        
        updateProfileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            updateProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            updateProfileButton.heightAnchor.constraint(equalToConstant: 30),
            updateProfileButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3)
        ])
    }
    
    private func configureActivityIndicatorConstraints(){
        imageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicator.topAnchor.constraint(equalTo: self.imageView.topAnchor), activityIndicator.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor) ,activityIndicator.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor) ,activityIndicator.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor)])
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            //MARK: TODO - handle couldn't get image :(
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            //MARK: TODO - gracefully fail out without interrupting UX
            return
        }
        
        FirebaseStorageService.manager.storeUserInputImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                //Note - defer UI response, update user image url in auth and in firestore when save is pressed
                self?.imageURL = url
            case .failure(let error):
                //MARK: TODO - defer image not save alert, try again later. maybe make VC "dirty" to allow user to move on in nav stack
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}
