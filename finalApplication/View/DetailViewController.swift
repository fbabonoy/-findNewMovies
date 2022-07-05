//
//  DetailViewController.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/6/22.


import UIKit
import CloudKit

class DetailViewController: UIViewController {

    private var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        return image
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Title"
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 20)
        return title
    }()
    
    private var overviewLable: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "For background, as you probably know, we recently announced that we are shutting down our Jobs and Developer Story features. While some found job-related products useful, we learned that most job seekers don’t actually turn to job boards as a primary resource. We determined that discontinuing job-related products would help us better serve developers and the broader community long-term. One consequence of this is that we will need to make changes to the dedicated ad unit for Jobs. We've always carried this ad placement, presented in the lower of the two right-hand sidebar ads on Stack Overflow, and used it to promote a list of relevant job opportunities."
        title.numberOfLines = 0
        title.textColor = .black
        return title
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: screenSize.width, height: view.frame.height / 5)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
    }()
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        setUp()
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         self.navigationController?.navigationBar.isHidden = false
     }
    
    func setUp() {
        view.addSubview(image)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(overviewLable)
        let layout = view.safeAreaLayoutGuide

        image.topAnchor.constraint(equalTo: layout.topAnchor, constant: 10).isActive = true
        image.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: view.frame.width/4).isActive = true
        image.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -(view.frame.width/4)).isActive = true
        image.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        
        overviewLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
//        overview.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        overviewLable.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: 15).isActive = true
        overviewLable.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -15).isActive = true
        overviewLable.heightAnchor.constraint(equalToConstant: layout.layoutFrame.height / 3.8).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: overviewLable.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
    }


}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

    func configureDetailView(title: String?, imageData: Data?, overview: String?) {
        titleLabel.text = title
        overviewLable.text = overview
        image.image = nil
        if let imageData = imageData {
            image.image = UIImage(data: imageData)
        }
    }
    
    
}

extension DetailViewController: UICollectionViewDelegate {

}
