//
//  PlaceTableViewCell.swift
//  VacationSpot
//
//  Created by Lexi He on 1/8/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    var photoImageView: UIImageView = {
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var ratingControl = RatingControl()
    
    var nameLabel: UILabel = {
        var nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        return nl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.photoImageView.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        self.nameLabel.frame = CGRect(x: 100, y: 0, width: self.frame.width, height: 50)
        self.ratingControl.frame = CGRect(x: 100, y: 50, width: self.frame.width, height: 40)
        
        self.contentView.addSubview(photoImageView)
        self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.photoImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5).isActive = true
        self.photoImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.photoImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        self.contentView.addSubview(nameLabel)
        self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 110).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 45).isActive = true
        
        
        self.contentView.addSubview(ratingControl)
        self.ratingControl.translatesAutoresizingMaskIntoConstraints = false
        self.ratingControl.axis = .horizontal
        self.ratingControl.distribution = .equalCentering
        self.ratingControl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 42).isActive = true
        self.ratingControl.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 105).isActive = true
        self.ratingControl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
