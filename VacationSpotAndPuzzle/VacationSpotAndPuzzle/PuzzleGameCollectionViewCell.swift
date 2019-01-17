//
//  PuzzleGameCollectionViewCell.swift
//  VacationSpotAndPuzzle
//
//  Created by Lexi He on 1/17/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit

class PuzzleGameCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.image = #imageLiteral(resourceName: "Layer 3")
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
}
