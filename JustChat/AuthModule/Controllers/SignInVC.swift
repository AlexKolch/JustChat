//
//  SignInVC.swift
//  JustChat
//
//  Created by Алексей Колыченков on 13.05.2024.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    let service = AuthService.shared
    let checkField = CheckField.shared //проверка валидности полей
    var userDefaults = UserDefaults.standard
    var tapGesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMainViewGesture))
        self.mainView.addGestureRecognizer(tapGesture!)
    }
    
    @objc
        func tapMainViewGesture() {
            self.mainView.endEditing(true)
        }
   
    func setAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    // MARK: - Navigation
    @IBAction func closeBtnTapped() {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func signInBtnTapped() {
        if checkField.validField(nil, emailTF),
           checkField.validField(nil, passwordTF) {
            service.authInApp(with: emailTF.text!, password: passwordTF.text!) { [weak self] result in
                switch result {
                case .success(let user):
                    print("User - \(user.uid) auth")
                    self?.userDefaults.set(true, forKey: "isAuth") //устанавливаем флаг авторизации пользователя
                    
                    self?.performSegue(withIdentifier: "goToAppVC", sender: self)
                case .failure(let error):
                    print("authInApp was failure \(error.localizedDescription)!")
                    self?.setAlert(title: "Authoriaztion was failed", message: "Check your login and passsword or link for verification sent to you email.")
                }
            }
        } else {
            setAlert(title: "Error", message: "Check the entered data")
        }
    }
    
    
    @IBAction func forgotPasswordTapped() {
    }
    
    
    @IBAction func haventAccBtnTapped() {
    }
    
}
