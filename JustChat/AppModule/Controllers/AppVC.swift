//
//  AppVC.swift
//  JustChat
//
//  Created by Алексей Колыченков on 13.05.2024.
//

import UIKit

class AppVC: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    let service = AuthService.shared
    var users = [String]() //Имена пользователей
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AppVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseId, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let dataCell = users[indexPath.row]
        cell.configCell(dataCell)
        return cell
    }
    
}

extension AppVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
