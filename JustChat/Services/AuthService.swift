//
//  AuthService.swift
//  JustChat
//
//  Created by Алексей Колыченков on 14.05.2024.
//

import UIKit
import FirebaseAuth

class AuthService {
    static let shared = AuthService(); private init() {}
    
    func createUser(email: String, password: String, completion: @escaping (_ verified: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(false)
                print(error.localizedDescription)
            } else {
                completion(true)
            }
        }
    }
    
    func confirmEmail() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { err in
            if let err {
                print(err.localizedDescription)
            }
        })
    }
}
