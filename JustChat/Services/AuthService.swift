//
//  AuthService.swift
//  JustChat
//
//  Created by Алексей Колыченков on 14.05.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct Constants {
    static let collectionUsers = "users"
    static let collectionChats = "chats"
}

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
    
    func getAllUsers(handler: @escaping ([CurrentUser]) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        var users = [CurrentUser]() //Складываем юзеров из Firebase сюда
        
        Firestore.firestore().collection("users")
            .whereField("email", isNotEqualTo: email) //условие, доставать email-ы из базы, кроме текущего пользователя
            .getDocuments { snap, error in
            if let err = error {
                print("Не получилось получить данные: \(err.localizedDescription)")
            }
            guard let docs = snap?.documents else { return }
//            var emailList = [String]() //складывали email-ы сюда
                
            //Получаем данные из массива документов файрбейса
            for doc in docs {
                let data = doc.data()
                let userId = doc.documentID //ID документа т.е. ID юзера
                let userEmail = data["email"] as! String //достаем по ключу email
                
//                emailList.append(userEmail)
                users.append(CurrentUser(id: userId, email: userEmail))
            }
            handler(users)
        }
    }
}
//MARK: - Messanger
extension AuthService {
    ///отправить данные чата на сервер
    func sendMessage(chatId: String?, otherUserId: String, text: String, handler: @escaping (String) -> Void) {
        guard
            let uid = Auth.auth().currentUser?.uid else { //достаем ID currentUser
            print("Не сущ uid")
            return }
        
        if chatId == nil {
            //создаем новый чат
            let chatId = UUID().uuidString //создаем id для чата
            
            //устанавливаем данные для полей документа Чат (chatId)
            let selfChatData: [String: Any] = [
                "date": Date(),
                "otherId": otherUserId
            ]
            
            let otherUserChatData: [String: Any] = [
                "date": Date(),
                "otherId": uid
            ]
            
            //Сохраняем чат к себе (в свой userID)
            Firestore.firestore().collection("users")
                .document(uid)
                .collection("chats")
                .document(chatId)
                .setData(selfChatData) //устанавливаем документу поля с данными
            
            //Сохраняем чат юзеру с которым переписываемся (в его userID)
            Firestore.firestore().collection("users")
                .document(otherUserId) //идем к документу собеседника
                .collection("chats")
                .document(chatId) //Создаем тот же самый чат по одному chatId
                .setData(otherUserChatData)
            
            //Создаем чат в коллекции "chats" firebase
            let message: [String: Any] = ["date": Date(), "senderID": uid, "text": text]
            let chatInfo: [String: Any] = ["date": Date(), "selfSender": uid, "otherSender": otherUserId]
            
            Firestore.firestore().collection("chats")
                .document(chatId) //создаем документ чата ОБЯЗАТЕЛЬНО с тем же chatId
                .setData(chatInfo) { err in
                    if let err {
                        print("Данные чата не создались по причине: - \(err.localizedDescription)")
                        return
                    }
                   //Если получилось создать чат, Создаем в чате коллекцию сообщений
                    Firestore.firestore().collection("chats")
                        .document(chatId) //идем в наш чат
                        .collection("messages") //создаем коллекцию сообщений
                        .addDocument(data: message) { err in
                            if let err {
                                print("Не получилось создать документ сообщения - \(err.localizedDescription)")
                            } else {
                                //добавялем новое сообщение в коллекцию сообщений
                                handler(chatId)
                            }
                        }
                }
        } else {
            //Чат сущ, добавляем в него документ с новым сообщением
            let message: [String: Any] = ["date": Date(), "senderID": uid, "text": text]
            
            Firestore.firestore().collection("chats").document(chatId!).collection("messages").addDocument(data: message) { err in
                if let err {
                    print("Не получилось создать документ сообщения - \(err.localizedDescription)")
                } else {
                    handler(chatId!)
                }
            }
        }
    }
    
    
    func updateChat() {
        
    }
    
    ///получение id чата
    func getChatID(otherId: String, completion: @escaping (String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(Constants.collectionUsers)
            .document(uid)
            .collection(Constants.collectionChats)
            .whereField("otherId", isEqualTo: otherId)
            .getDocuments { snap, err in
                if let err {
                    print("Ошибка поиска ID чата getChatID - \(err.localizedDescription)")
                    return
                }
                if let snap, !snap.documents.isEmpty {
                    let doc = snap.documents.first
                    if let chatId = doc?.documentID {
                        completion(chatId) //возвращаем id чата
                    }
                }
            }
    }
    
    func getAllMessages() {
        
    }
    
    func getOneMessage() {
        
    }
}
