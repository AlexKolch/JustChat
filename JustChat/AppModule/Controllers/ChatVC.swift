//
//  ChatVC.swift
//  JustChat
//
//  Created by Алексей Колыченков on 18.05.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

class ChatVC: MessagesViewController {
    let service = AuthService.shared
    
    var chatId: String?
    var otherId: String!
    
    private let selfSender = Sender(senderId: "1", displayName: "Me")
    private var otherSender = Sender(senderId: "2", displayName: "Sam")
    
    private var messagesList = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesList.append(Message(sender: selfSender, messageId: "1", sentDate: Date().addingTimeInterval(-11200), kind: .text("Привет!")))
        messagesList.append(Message(sender: otherSender, messageId: "2", sentDate: Date().addingTimeInterval(-10200), kind: .text("Привет! Как дела?")))
        messagesList.append(Message(sender: selfSender, messageId: "3", sentDate: Date().addingTimeInterval(-9000), kind: .text("Все ок!")))
        messagesCollectionView.reloadData()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        showMessageTimestampOnSwipeLeft = true
    }
    

}

extension ChatVC: MessagesDataSource {
  
    var currentSender: MessageKit.SenderType {
        return self.selfSender //определяет главного пользователя
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
       return messagesList[indexPath.section] //требует вывести сообщения по индексу секции
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
       return messagesList.count
    }
    
}

extension ChatVC: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
}

extension ChatVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(sender: selfSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messagesList.append(message)
        
        service.sendMessage(chatId: chatId, otherUserId: otherId, message: message, text: text) { [weak self] result in
            if result {
                DispatchQueue.main.async {
                    inputBar.inputTextView.text = nil
                    self?.messagesCollectionView.reloadDataAndKeepOffset() //перезагрузить коллекцию и проскролить к новым item
                }
            } else {
                
            }
        }
       
    }
}
