//
//  SignupViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/22/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

     //MARK: UI Objects
      
      lazy var headerLabel: UILabel = {
          let label = UILabel()
          label.numberOfLines = 0
          label.text = "Create An Account"
          label.font = UIFont(name: "Verdana-Bold", size: 28)
          label.textColor = #colorLiteral(red: 0.2338379025, green: 0.2365351021, blue: 0.8315110803, alpha: 1)
          label.backgroundColor = .clear
          label.textAlignment = .center
          return label
      }()
      
      lazy var emailTextField: UITextField = {
          let textField = UITextField()
          textField.placeholder = "Enter Email"
          textField.font = UIFont(name: "Verdana", size: 14)
          textField.backgroundColor = .white
          textField.borderStyle = .bezel
          textField.autocorrectionType = .no
          textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
          return textField
      }()
      
      lazy var passwordTextField: UITextField = {
          let textField = UITextField()
          textField.placeholder = "Enter Password"
          textField.font = UIFont(name: "Verdana", size: 14)
          textField.backgroundColor = .white
          textField.borderStyle = .bezel
          textField.autocorrectionType = .no
          textField.isSecureTextEntry = true
          textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
          return textField
      }()
      
      lazy var createButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Continue", for: .normal)
          button.setTitleColor(.white, for: .normal)
          button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
          button.backgroundColor = #colorLiteral(red: 0.2334540784, green: 0.2368975878, blue: 0.8274126649, alpha: 1)
          button.layer.cornerRadius = 5
          button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
          button.isEnabled = false
          return button
      }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                                        attributes: [
                                                            NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!,
                                                            NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Login",
                                                  attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!,
                                                               NSAttributedString.Key.foregroundColor:  UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(dismissFromView), for: .touchUpInside)
        return button
    }()
      
      //MARK: Lifecycle
      
      override func viewDidLoad() {
          super.viewDidLoad()
          view.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
          setupHeaderLabel()
          setupCreateStackView()
      }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
      //MARK: Obj C methods
    
    @objc func dismissFromView(){
        self.dismiss(animated: true, completion: nil)
    }
    
      @objc func validateFields() {
             guard emailTextField.hasText, passwordTextField.hasText else {
                 createButton.backgroundColor = #colorLiteral(red: 0.3629951477, green: 0.4371426404, blue: 0.9123402238, alpha: 1)
                 createButton.isEnabled = false
                 return
             }
             createButton.isEnabled = true
             createButton.backgroundColor = #colorLiteral(red: 0.2334540784, green: 0.2368975878, blue: 0.8274126649, alpha: 1)
         }
      
      @objc func trySignUp() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                 showAlert(with: "Error", and: "Please fill out all fields.")
                 return
             }
             
             guard email.isValidEmail else {
                 showAlert(with: "Error", and: "Please enter a valid email")
                 return
             }
             
             guard password.isValidPassword else {
                 showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
                 return
             }
         let profileVC = ProfileViewController()
        profileVC.createUserModel.email = email
        profileVC.createUserModel.password = password
        profileVC.buttonSelection = .createButtonEnabled
             present(profileVC, animated: true, completion: nil)
    }
      
      //MARK: Private Methods
      private func showAlert(with title: String, and message: String) {
             let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
             alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
             present(alertVC, animated: true, completion: nil)
         }

      
      //MARK: UI Setup
         
         private func setupHeaderLabel() {
             view.addSubview(headerLabel)
             
             headerLabel.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
                 headerLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                 headerLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                 headerLabel.heightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08)])
         }
         
         private func setupCreateStackView() {
             let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,createButton, dismissButton])
             stackView.axis = .vertical
             stackView.spacing = 15
             stackView.distribution = .fillEqually
             self.view.addSubview(stackView)
             
             stackView.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 100),
                 stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                 stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
         }


}

