//
//  RatingControl.swift
//  VacationSpot
//
//  Created by Lexi He on 1/7/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    
    var place: Place!
    var canSet: Bool = false
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }
    var starSize: CGSize = CGSize(width: 44.0, height:44.0){
        didSet{
            setupButtons()
        }
    }
    var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //Button Action
    private func setupButtons() {
        
        // clear out existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        
        // load button images
        let bundle = Bundle(for: type(of:self))
        let filledStar = UIImage(named: "filledStar", in:bundle, compatibleWith:self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in:bundle, compatibleWith:self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in:bundle, compatibleWith:self.traitCollection)
        
        
        for index in 0 ..< starCount {
            // create the button
            let button = UIButton()
            
            // set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // set the accessibility label
            button.accessibilityLabel = "Set \(index+1) star rating"
            
            // set up the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to the stack
            addArrangedSubview(button)
            
            // add the new button to the button array
            ratingButtons.append(button)
        }
        
        // update the status of the ratings
        updateButtonSelectionStates()
    }
    
    
    // action for tapping the button
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // only can set the ratings in detail view
        if canSet{
            
            // calculate the rating of the selected button
            let selectedRating = index + 1
            
            if selectedRating == rating {
                // if the selected star represents the current rating, reset the rating to 0.
                rating = 0
            }else{
                // otherwise set the rating to the selected star
                rating = selectedRating
            }
            
        }else{
            for i in ratingButtons{
                i.isUserInteractionEnabled = false
            }
        }
        
    }
    
    @objc func updateButtonSelectionStates() {
        
        // enumerate the button and set isSelected field appropriately
        for (index, button) in ratingButtons.enumerated() {
            
            // if the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
            
            // set the hint string for the current selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            }else{
                hintString = nil
            }
            
            // calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // assign the hintString and valueString
            button.accessibilityLabel = hintString
            button.accessibilityValue = valueString
        }
    }
    
}
