//
//  PuzzleGameCollectionViewCell.swift
//  VacationSpotAndPuzzle
//
//  Created by Lexi He on 1/17/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit

class PuzzleGameCollectionViewCell: UICollectionViewCell {
    
    
    // each cell contains a puzzle piece
    let imgView: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "Layer 3")
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    // the border highlight when select a cell
    let border: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth  = 3
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    // this variable handle the hide and show of the border based on selected or not
    override var isSelected: Bool {
        didSet {
            if isSelected {
                border.isHidden = false
            } else {
                border.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // set up constraints
    func setUpViews() {
        self.addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        imgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        
        self.addSubview(border)
        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive=true
        border.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive=true
        border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive=true
        border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive=true
        border.isHidden=true
    }
}
