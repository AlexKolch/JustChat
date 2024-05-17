//
//  SignUpVC.swift
//  JustChat
//
//  Created by Алексей Колыченков on 13.05.2024.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    
    let checkField = CheckField.shared //проверка валидности полей
    let service = AuthService.shared
    var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMainViewGesture))
        mainView.addGestureRecognizer(tapGesture!)
    }
    
    func setAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
@objc
    func tapMainViewGesture() {
        self.mainView.endEditing(true)
    }
    
    // MARK: - Navigation
    @IBAction func closeBtnTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func signUpTapped() {
        if checkField.validField(nil, EmailTF), checkField.validField(nil, passwordTF) {
            //проверка на валидность пройдена
            if passwordTF.text == rePasswordTF.text {
                print("password fields correct") //пароли совпадают
                service.createUser(email: EmailTF.text!, password: passwordTF.text!) { [weak self] result in
                    if result {
                        print("Успешно Зарегистрирован")
                        self?.service.confirmEmail()
                        self?.setAlert(title: "Auth success", message: "Check your email for verification")
                    } else {
                        print("Ошибка регистрации")
                        self?.setAlert(title: "Auth error", message: "Try again")
                    }
                }
            } else {
                print("field not similar!")
            }
        }
    }
    
}
