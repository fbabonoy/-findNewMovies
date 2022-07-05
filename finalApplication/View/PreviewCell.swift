//
//  previewCell.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/6/22.
//

import UIKit


protocol ModeDetails {
    func modeDetailsButtonAction(row: Int)
}

class PreviewCell: UITableViewCell {

    static let identifier = "previewCell"
    var delegate: ModeDetails?
    private var favoriteDef = 0
    private var rowCell = 0
//    private var movieTitle: String?
//    private var movieOverview: String?
//    private var moviewImage: Data?
    private var favoritesArray: [Any?] = []


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
        return title
    }()
    
    private var overviewLable: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "overview"
        title.textColor = .black
        title.numberOfLines = 0
        return title
    }()
    
    private lazy var favorite: UIButton = {
        let title = UIButton()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setImage(UIImage(systemName: "checkmark"), for: .normal)
        return title
    }()
    
    private lazy var details = UIAction(title: "Refresh") { [weak self] (action) in
        
        self?.delegate!.modeDetailsButtonAction(row: self!.rowCell)

    }
    
    private lazy var showDetails: UIButton = {
        let button = UIButton(frame: .zero, primaryAction: details)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("show details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        return button
        
    }()
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
//        favorite.tintColor = favoriteDef
        setUp()
        
        // Configure the view for the selected state
    }

    func setUp(){
        contentView.addSubview(image)
        contentView.addSubview(titleCell)
        contentView.addSubview(overviewLable)
        contentView.addSubview(showDetails)
        contentView.addSubview(favorite)
        
        let layout = contentView.safeAreaLayoutGuide
                
        image.topAnchor.constraint(equalTo: layout.topAnchor, constant: 10).isActive = true
        image.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: 10).isActive = true
        image.rightAnchor.constraint(equalTo: layout.leftAnchor, constant: 90).isActive = true
        image.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -10).isActive = true
        
        titleCell.topAnchor.constraint(equalTo: layout.topAnchor, constant: 10).isActive = true
        titleCell.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        titleCell.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -30).isActive = true
        
        overviewLable.topAnchor.constraint(equalTo: titleCell.bottomAnchor).isActive = true
        overviewLable.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        overviewLable.rightAnchor.constraint(equalTo: showDetails.leftAnchor).isActive = true
        overviewLable.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -10).isActive = true
        
        showDetails.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -10).isActive = true
        showDetails.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -10).isActive = true
        showDetails.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        favorite.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -10).isActive = true
        favorite.bottomAnchor.constraint(equalTo: showDetails.topAnchor, constant: -10).isActive = true
        
    }
    
    func configureCell(title: String?, imageData: Data?, overview: String?, row: Int, favColor: UIColor?) {
        favoritesArray = []
        
        titleCell.text = title
        favoritesArray.append(title)
        overviewLable.text = overview
        favoritesArray.append(overview)
        image.image = nil
        favorite.tintColor = favColor ?? UIColor.black
        
//        print(favoritesArray)
        rowCell = row
        if let _ = favColor {
            favoriteDef = 1
        }
        if let imageData = imageData {
            image.image = UIImage(data: imageData)
            favoritesArray.append(imageData)

        }
    }
}
