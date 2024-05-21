//
//  AppVC.swift
//  JustChat
//
//  Created by Алексей Колыченков on 13.05.2024.
//

import UIKit

class UsersVC: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    let service = AuthService.shared
    var users = [CurrentUser]() //Юзеры из Firebase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        getUsers()
    }
    
    fileprivate func setTableView() {
        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseId)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.separatorStyle = .none
    }

    ///Получаем данные из Firebase
    private func getUsers() {
        service.getAllUsers { users in
            self.users = users
            self.usersTableView.reloadData()
        }
    }
}

extension UsersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseId, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let dataCell = users[indexPath.row]
        cell.configCell(dataCell.email)
        return cell
    }
    
}

extension UsersVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = users[indexPath.row].id
        let vc = ChatVC()
        vc.otherId = userId
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
