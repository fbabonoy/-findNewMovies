//
//  CollectionViewCell.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/6/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "collectionCell"
    
    private var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        return image
    }()
    
    private var titleCell: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Title"
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        return title
    }()
    
//
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp(){
        contentView.addSubview(image)
        contentView.addSubview(titleCell)

        
        let layout = contentView.safeAreaLayoutGuide
        
        image.topAnchor.constraint(equalTo: layout.topAnchor, constant: 10).isActive = true
        image.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20).isActive = true
        image.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -30).isActive = true
        
        titleCell.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
        titleCell.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        titleCell.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true

        
    }
}
