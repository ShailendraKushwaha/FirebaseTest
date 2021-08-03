//
//  ViewController.swift
//  FirebaseTest
//
//  Created by SHAILENDRA KUSHWAHA on 24/06/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    let logoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test App"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 52)
        label.textColor = .white
        return label
    }()
    
    let loginContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var phoneTextField : UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.layer.cornerRadius = 25
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "Phone Number"
        let blackplaceholderText = NSAttributedString(string: "         enter phone number",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.attributedPlaceholder = blackplaceholderText
        textField.delegate = self
        return textField
    }()
    
    let instrictionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please Enter The OTP sent on your mobile to successfully login"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    lazy var signInButton : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(self.didTapOnSignInButton(sender:)), for: .touchUpInside)
        button.setTitle("Get OTP", for: .normal)
        return button
    }()
    
    var centerYAnchor : NSLayoutConstraint?
    var updatedCenterYAnchor: NSLayoutConstraint?
    var loginHeightContainer:NSLayoutConstraint?
    var updatedLoginHeightContainer:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(logoLabel)
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor = logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYAnchor?.isActive = true
        updatedCenterYAnchor = logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -150)
        updatedCenterYAnchor?.isActive = false
        
        logoLabel.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.8).isActive = true
        logoLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        self.view.addSubview(loginContainer)
        loginContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        loginHeightContainer = loginContainer.heightAnchor.constraint(equalToConstant:130)
        loginHeightContainer?.isActive = true
        updatedLoginHeightContainer = loginContainer.heightAnchor.constraint(equalToConstant:150)
        updatedLoginHeightContainer?.isActive = false
        
        loginContainer.addSubview(phoneTextField)
        loginContainer.addSubview(instrictionLabel)
        loginContainer.addSubview(signInButton)
        
        phoneTextField.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant:50).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: loginContainer.topAnchor,constant: 10).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: loginContainer.leftAnchor).isActive = true
        
        instrictionLabel.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        instrictionLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor,constant: 5).isActive = true

        instrictionLabel.bottomAnchor.constraint(equalTo: signInButton.topAnchor,constant: -5).isActive = true
        instrictionLabel.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor).isActive = true
        instrictionLabel.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor).isActive = true
        
        signInButton.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor,constant: -10).isActive = true
        signInButton.leftAnchor.constraint(equalTo: loginContainer.leftAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginContainer.isHidden = true
        
        if let id = AppData.shared.getUserId(), id != ""{
            self.launchFeedScreen()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, animations: {
            
            self.centerYAnchor?.isActive = false
            self.updatedCenterYAnchor?.isActive = true
            
            self.view.layoutIfNeeded()
        }, completion: { done in
            self.loginContainer.isHidden = false
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc private func didTapOnSignInButton(sender:Any){
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+91" + phoneTextField.text!, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            self.showAlert(title: "Something went wrong please try again later", message: error.localizedDescription)
            return
          }
            DispatchQueue.main.async{
                AppData.shared.saveVerificationId(id: verificationID!)
                self.instrictionLabel.isHidden = false
                self.loginHeightContainer?.isActive = false
                self.updatedLoginHeightContainer?.isActive = true
                self.signInButton.setTitle("Verify", for: .normal)
                self.signInButton.removeTarget(self, action: #selector(self.didTapOnSignInButton(sender:)), for: .touchUpInside)
                self.signInButton.addTarget(self, action: #selector(self.didTapOnVerifyButton(sender:)), for: .touchUpInside)
                self.phoneTextField.text = ""
                self.view.setNeedsLayout()
            }

        }
    }
    
    @objc private func didTapOnVerifyButton(sender:Any){
        
        guard let verificationID = AppData.shared.getVerificationId() else {
            self.showAlert(title: "Something went wrong please try again later", message: "")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: phoneTextField.text!)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
          if let error = error {
            self.showAlert(title: "Something went wrong please try again later", message: error.localizedDescription)
            return
          }
//            Login Successfull
//
            DispatchQueue.main.async{
                AppData.shared.saveUserId(id: authResult?.user.uid ?? "")
                self.launchFeedScreen()
            }
        }
    }
    
    private func launchFeedScreen(){
        self.navigationController?.pushViewController(FeedVC(), animated: true)
    }
    
    private func showAlert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController : UITextFieldDelegate {
    
}

