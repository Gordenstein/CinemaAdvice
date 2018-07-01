//
//  LoginViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 16.05.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  var fitstTime = true
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUpButton.layer.borderWidth = 1
    signUpButton.layer.borderColor = UIColor.white.cgColor
    
    Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        if (user?.isEmailVerified ?? false) {
          self.performSegue(withIdentifier: self.loginToList, sender: nil)
          self.textFieldLoginEmail.text = nil
          self.textFieldLoginPassword.text = nil
        } else {
          if !self.fitstTime {
            let alert = UIAlertController(title: "На данный момент вход невозможен",
                                          message: "Ваш email был зарегистрирован, но для входа необходимо его подтвердить. Пожалуйста, перейдите по ссылке в письме.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Хорошо!", style: .default))
            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func loginDidTouch(_ sender: Any) {
    fitstTime = false
    guard
      let email = textFieldLoginEmail.text,
      let password = textFieldLoginPassword.text,
      email.count > 0,
      password.count > 0
      else {
        return
    }
    Auth.auth().signIn(withEmail: email, password: password) { user, error in
      if let error = error, user == nil {
        let alert = UIAlertController(title: "Ошибка авторизации",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true, completion: nil)
      }
      if user != nil {
        if (user?.isEmailVerified ?? false) {
          self.performSegue(withIdentifier: self.loginToList, sender: nil)
          self.textFieldLoginEmail.text = nil
          self.textFieldLoginPassword.text = nil
        } else {
          let alert = UIAlertController(title: "На данный момент вход невозможен",
                                        message: "Ваш email был зарегистрирован, но для входа необходимо его подтвердить. Пожалуйста, перейдите по ссылке в письме.",
                                        preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title: "Хорошо!", style: .default))
          self.present(alert, animated: true, completion: nil)
          
        }
      }
    }
    
  }
  
  @IBAction func signUpDidTouch(_ sender: Any) {
    let alert = UIAlertController(title: "Регистрация",
                                  message: "Пожалуйста, введите Ваш настоящий email и пароль (более 6 символов).",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Сохранить",
                                   style: .default) { action in
                                    let emailField = alert.textFields![0]
                                    let passwordField = alert.textFields![1]
                                    self.fitstTime = false
                                    Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                                      if error != nil {
                                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                          switch errorCode {
                                          case .weakPassword:
                                            print("Please provide a strong password")
                                          default:
                                            print("There is an error")
                                          }
                                        }
                                      }
                                      if user != nil {
                                        user?.sendEmailVerification(completion: { (error) in
                                          print(error?.localizedDescription ?? "No verification")
                                        })
//                                        if (user?.isEmailVerified ?? false) {
//                                          Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
//                                                             password: self.textFieldLoginPassword.text!)
//                                        }
                                      }
                                    })
    }
    let cancelAction = UIAlertAction(title: "Отмена",style: .default)
    alert.addTextField { textEmail in
      textEmail.placeholder = "Введите Ваш email"
    }
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Введите Ваш пароль"
    }
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  @IBAction func choosePasswordTextField(_ sender: Any) {
    textFieldLoginPassword.becomeFirstResponder()
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
}
