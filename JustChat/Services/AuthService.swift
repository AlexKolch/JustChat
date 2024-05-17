//
//  AuthService.swift
//  JustChat
//
//  Created by Алексей Колыченков on 14.05.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService(); private init() {}
    
    enum ErrorResponse: Error {
        case notVerified, failureAuth
    }
    
    ///Регистрация в приложении
    func createUser(email: String, password: String, completion: @escaping (_ verified: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(false); print(error.localizedDescription)
            } else {
                //Успешная запись email юзера в базу данных
                let userId = result?.user.uid //берем userId, чтобы по нему создавать document в таблице firestore
                let data: [String: Any] = ["email": email]
                Firestore.firestore().collection("users").document(userId!).setData(data) //данные сохранились
                completion(true)
            }
        }
    }
    
    ///Верификация email
    func confirmEmail() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { err in
            if let err {
                print(err.localizedDescription)
            }
        })
    }
    
    ///Авторизация в приложении
    func authInApp(with email: String, password: String, completion: @escaping (Result<User, ErrorResponse>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard
                error == nil else {   //Неуспешная авторизация
                completion(.failure(.failureAuth)) ; print(error!.localizedDescription)
                return }
            if let result { //Успешная авторизация
                //проверка на верификацию юзера
                if result.user.isEmailVerified {
                    completion(.success(result.user))
                } else {
                    self.confirmEmail()
                    completion(.failure(.notVerified))
                }
            }
        }
    }
}
