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
    
    let checkField = CheckField.shared
    let service = AuthService.shared
    var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMainViewGesture))
        mainView.addGestureRecognizer(tapGesture!)
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
                print("field correct") //пароли совпадают
                service.createUser(email: EmailTF.text!, password: passwordTF.text!) { [weak self] result in
                    if result {
                        print("Успешно Зарегистрирован")
                        self?.service.confirmEmail()
                    } else {
                        print("Ошибка регистрации")
                    }
                }
            } else {
                print("field not similar!")
            }
        }
    }
    
}
