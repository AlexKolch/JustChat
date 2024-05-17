//
//  UserTableViewCell.swift
//  JustChat
//
//  Created by Алексей Колыченков on 17.05.2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseId = "UserTableViewCell"

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.layer.cornerRadius = 10
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ name: String) {
        nameLabel.text = name
    }
    
}
