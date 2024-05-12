//
//  ViewController.swift
//  JustChat
//
//  Created by Алексей Колыченков on 09.05.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var sliderCollectionV: UICollectionView = setCollectionView()
    
    private var slides = [Slide(image: "img1", text: "efdsvsdvsdvsdv"), Slide(image: "img2", text: "ddvv"), Slide(image: "img3", text: "efdsvsdvsdvsdv")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sliderCollectionV)
    }

    private func setCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.backgroundColor = .gray
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: SlideCollectionViewCell.reuseId, bundle: nil), forCellWithReuseIdentifier: SlideCollectionViewCell.reuseId)
        return collection
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.view.frame.size
    }
}

extension LoginViewController: UICollectionViewDelegate {
    
}

extension LoginViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideCollectionViewCell.reuseId, for: indexPath) as? SlideCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(slide: slides[indexPath.item])
        if indexPath.item == 2 {
            cell.SignInButton.isHidden = false
            cell.SignUpButton.isHidden = false
            cell.titleApp.textColor = .black
            cell.descrText.textColor = .black
        }
        return cell
    }
    
}

