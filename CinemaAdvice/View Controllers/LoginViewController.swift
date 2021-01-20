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

  let loginToList = "LoginToList"
  var checkEmailVerification = false

  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    signUpButton.layer.borderWidth = 1
    signUpButton.layer.borderColor = UIColor.label.cgColor
    self.textFieldLoginEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "palceholder_color") ?? .yellow])
    self.textFieldLoginPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "palceholder_color") ?? .yellow])

    Auth.auth().addStateDidChangeListener { _, user in
      if user != nil {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
        self.textFieldLoginEmail.text = nil
        self.textFieldLoginPassword.text = nil
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func loginDidTouch(_ sender: Any) {
    guard let email = textFieldLoginEmail.text,
          let password = textFieldLoginPassword.text,
          email.count > 0,
          password.count > 0 else {
      return
    }
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let authResult = authResult {
        if !self.checkEmailVerification || authResult.user.isEmailVerified {
          self.performSegue(withIdentifier: self.loginToList, sender: nil)
          self.textFieldLoginEmail.text = nil
          self.textFieldLoginPassword.text = nil
        } else {
          let alert = UIAlertController(title: NSLocalizedString("Login is not available", comment: "Localized kind: На данный момент вход невозможен"),
                                        message: NSLocalizedString("A verification link has been send to your email account. Please click on the link that has been sent to your email.", comment: "Localized kind: Ваш email был зарегистрирован, но для входа необходимо его подтвердить. Пожалуйста, перейдите по ссылке в письме."),
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("Got it!", comment: "Localized kind: Хорошо!"), style: .default))
          self.present(alert, animated: true, completion: nil)
        }
      } else {
        var errorMessage = "Please try again later"
        if let error = error {
          errorMessage = error.localizedDescription
        }
        let alert = UIAlertController(title: NSLocalizedString("Authorisation Error", comment: "Localized kind: Ошибка авторизации"),
                                      message: errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Localized kind: ОК"), style: .default))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }

  @IBAction func signUpDidTouch(_ sender: Any) {
    let alert = UIAlertController(title: NSLocalizedString("Sign Up", comment: "Localized kind: Регистрация"),
                                  message: NSLocalizedString("Please enter your email and password (more than 6 simbols).", comment: "Localized kind: Пожалуйста, введите Ваш настоящий email и пароль (более 6 символов)."),
                                  preferredStyle: .alert)

    let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: "Localized kind: Сохранить"),
                                   style: .default) { _ in
      guard let textFields = alert.textFields,
            textFields.count > 1,
            let email = textFields[0].text,
            let password = textFields[1].text else {
        // Error
        return
      }
      Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
        if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
          switch errorCode {
          case .weakPassword:
            print("User set weak password")
          default:
            print("Sing Up error: \(errorCode)")
          }
        }
        if let user = authResult?.user {
          user.sendEmailVerification { (error) in
            print(error?.localizedDescription ?? "No verification")
          }
        } else {
          // Error
        }
      }
    }
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Localized kind: Отмена"), style: .default)
    alert.addTextField { textEmail in
      textEmail.placeholder = NSLocalizedString("Enter your email", comment: "Localized kind: Введите Ваш email")
    }
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = NSLocalizedString("Enter your password", comment: "Localized kind: Введите Ваш пароль")
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
