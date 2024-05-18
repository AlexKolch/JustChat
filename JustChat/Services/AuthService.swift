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

//MARK: - Request in Firebase
extension AuthService {
    
    func getAllUsers(handler: @escaping ([String]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snap, error in
            if let err = error {
                print("Не получилось получить данные: \(err.localizedDescription)")
            }
            guard let docs = snap?.documents else { return }
            var emailList = [String]()
            //Получаем данные из массива документов файрбейса
            for doc in docs {
                let data = doc.data()
                let userEmail = data["email"] as! String //достаем по ключу
                emailList.append(userEmail)
            }
            handler(emailList)
        }
    }
}
//MARK: - Messanger
extension AuthService {
    ///отправить данные чата на сервер
    func sendMessage(chatId: String?, otherUserId: String, message: Message, text: String, handler: @escaping (Bool) -> Void) {
        if chatId == nil {
            //создаем новый чат
           
        } else {
            let message: [String: Any] = [
                "date": message.sentDate,
                "senderID": message.sender.senderId,
                "text": text
            ]
            Firestore.firestore().collection("chats").document(chatId!).collection("messages").addDocument(data: message) { err in
                if let err {
                    handler(false)
                } else {
                    handler(true)
                }
            }
        }
    }
    
    func updateChat() {
        
    }
    
    func getChatID() {
        
    }
    
    func getAllMessages() {
        
    }
    
    func getOneMessage() {
        
    }
}
