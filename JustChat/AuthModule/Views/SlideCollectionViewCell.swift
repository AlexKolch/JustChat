//
//  SlideCollectionViewCell.swift
//  JustChat
//
//  Created by Алексей Колыченков on 12.05.2024.
//

import UIKit

class SlideCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "SlideCollectionViewCell"
    
    @IBOutlet weak var titleApp: UILabel!
    @IBOutlet weak var descrText: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(slide: Slide) {
        descrText.text = slide.text
        image.image = UIImage(named: slide.image)
    }
    
    @IBAction func SignInTapped(_ sender: UIButton) {
        delegate?.openSignInVC()
    }
    
    @IBAction func SignUpTapped(_ sender: UIButton) {
        delegate?.openSignUpVC()
    }
}
