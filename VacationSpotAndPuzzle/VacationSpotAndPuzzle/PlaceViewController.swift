//
//  PlaceViewController.swift
//  VacationSpotAndPuzzle
//
//  Created by Lexi He on 1/16/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit
import os.log


class PlaceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var inputTextField: UITextField!
    var placeNamelabel: UILabel!
    
    var addBtn: UIButton!
    var placeImg: UIImageView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var pickedImage: UIImage!
    
    var placeTableViewController: PlaceTableViewController!
    
    /*
     This value is either passed by 'PlaceTableViewController' in 'prepare(for:sender:)'
     or constructed as part of adding a new meal
     */
    var place: Place!
    // customize stack view
    var stackView = RatingControl()
    
    func setUpStackView(){
        self.view.addSubview(stackView)
        
        // allow to create customize constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.center.x = self.view.center.x
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 125),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70),
            ])
    }
    
    // when tap on cancel button on the navigation bar
    @objc func myLeftSideBarButtonItemTapped(_ sender: UIBarButtonItem!){
        _ = navigationController?.popViewController(animated: true)
    }
    
    // when tap on save button on the navigation bar
    @objc func myRightSideBarButtonItemTapped(_ sender: UIBarButtonItem!){
        
        // If we're editing existed cell
        if place != nil {
            if let index = placeTableViewController.places.index(where: {$0.name == place?.name}) {
                
                stackView.updateButtonSelectionStates()
                placeTableViewController.places[index].rating = stackView.rating
                placeTableViewController.places[index].photo = placeImg.image
                
                if inputTextField.text != "" {
                    placeTableViewController.places[index].name = inputTextField.text!
                }else{
                    let alert = UIAlertController(title: "Error", message: "Name cannot be empty!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style:.default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else{
            // If creating new place
            
            if inputTextField.text == "" {
                print("empty name, handle here")
                let alert = UIAlertController(title: "Error", message: "Name cannot be empty!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style:.default))
                
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                // first check if exist in places array
                var checkExist = false
                for elem in placeTableViewController.places {
                    if elem.name == inputTextField.text!{
                        checkExist = true
                    }
                }
                
                if checkExist {
                    // if already exist, show alert
                    let alert = UIAlertController(title: "Error", message: "This place already exist!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style:.default))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    // if not exist, add to places array
                    guard let newPlace = Place(name: inputTextField.text!, photo: placeImg.image, rating: stackView.rating) else{
                        fatalError("Unable to instantiate place")
                    }
                    placeTableViewController.places += [newPlace]
                }
                
            }
        }
        
        // store information
        savePlaces()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Add Place"
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(myLeftSideBarButtonItemTapped(_:)))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        
        placeNamelabel = UILabel(frame: CGRect(x: 50, y: 130, width: 300.0, height: 22))
        placeNamelabel.text = "Enter name, photo and rating:"
        placeNamelabel.lineBreakMode = .byWordWrapping
        placeNamelabel.textAlignment = .center
        placeNamelabel.center.x = self.view.center.x
        self.view.addSubview(placeNamelabel)
        
        
        inputTextField = UITextField(frame: CGRect(x: 50, y: 160, width: 300.0, height: 30.00))
        inputTextField.placeholder = "Enter place name"
        inputTextField.borderStyle = UITextField.BorderStyle.line
        inputTextField.backgroundColor = UIColor.white
        inputTextField.textColor = UIColor.blue
        inputTextField.returnKeyType = UIReturnKeyType.done
        inputTextField.enablesReturnKeyAutomatically = true
        // Handle the text field’s user input through delegate callbacks.
        inputTextField.delegate = self
        inputTextField.center.x = self.view.center.x
        self.view.addSubview(inputTextField)
        
        
        // adding imageview
        placeImg = UIImageView(frame: CGRect(x: 50, y: 200, width: 300.0, height: 300.0))
        placeImg.image = UIImage(named:"defaultPhoto")
        placeImg.isUserInteractionEnabled = true
        placeImg.center.x = self.view.center.x
        self.view.addSubview(placeImg)
        
        // add tapRecognizer to imageView
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPhotoLibrary))
        placeImg.addGestureRecognizer(tapGestureRecognizer)
        
        
        // initialize stack view for the ratings
        setUpStackView()
        
        // if place existed already
        if let place = place {
            navigationItem.title = place.name
            placeImg.image = place.photo
            inputTextField.text = place.name
            stackView.rating = place.rating
        }
    }
    
    // do something when image tapped
    @objc func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer){
        
        // Ensures that if the user taps the image view while typing in the text field, the keyboard is dismissed properly.
        inputTextField.resignFirstResponder()
        
        // add imagePicker to imageView
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // gets called when a user taps the image picker’s Cancel button
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    // gets called when a user selects a photo
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        
        placeImg.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addBtnClicked(sender : UIButton){
        
        let alert = UIAlertController(title: "", message: "Place added successfully", preferredStyle: .alert)
        present(alert, animated: true) {
            sleep(2)
            alert.dismiss(animated: true)
        }
        
        // clear the text field
        inputTextField.text = ""
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        //placeNamelabel.text = inputTextField.text
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     This method attempts to archive the meals array to a specific location, and returns true if it’s successful. It uses the constant Place.ArchiveURL that you defined in the Place class to identify where to save the information.
     */
    private func savePlaces() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(placeTableViewController.places, toFile: Place.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Places successfully saved.", log: OSLog.default, type: .debug)
        }else{
            os_log("Failed to save places", log: OSLog.default, type: .error)
        }
    }
    
    /*
     Return type of an optional array of Place objects, it might return an array of Place objects or might return nil
     */
    private func loadPlaces() -> [Place]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: "Place.ArchiveURL.path") as? [Place]
    }

}
