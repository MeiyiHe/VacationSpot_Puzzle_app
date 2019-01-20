//
//  ChangePuzzleViewController.swift
//  VacationSpotAndPuzzle
//
//  Created by Lexi He on 1/18/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit

class ChangePuzzleViewController: UIViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    var placeImg: UIImageView!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    var pickedImage: UIImage!
    
    var puzzleVC: PuzzleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Select Picture"
        
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveBarButton

        // adding imageview
        placeImg = UIImageView(frame: CGRect(x: 50, y: 235, width: 300.0, height: 300.0))
        placeImg.image = UIImage(named:"defaultPhoto")
        placeImg.isUserInteractionEnabled = true
        placeImg.center.x = self.view.center.x
        self.view.addSubview(placeImg)
        
        if placeImg != nil {
            print("in changePuzzleVC not nil     !!!!")
        }
        
        // add tapRecognizer to imageView
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPhotoLibrary))
        placeImg.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    // when tap on save button on the navigation bar
    @objc func myRightSideBarButtonItemTapped(_ sender: UIBarButtonItem!){
        puzzleVC.changePic = true
        puzzleVC.currImage = placeImg.image;
        puzzleVC.questionImageArray = puzzleVC.slice(image: placeImg.image ?? UIImage(named: "cat")!, into: 3)
        
        let curr = Dictionary(uniqueKeysWithValues: zip(puzzleVC.wrongAns, puzzleVC.questionImageArray))
        let newArray = curr.shuffled()
        puzzleVC.wrongAns = newArray.map({$0.key})
        puzzleVC.wrongImgArray = newArray.map({$0.value})
        
        
        if self.placeImg.image == nil {
            print("no picture upload")
        }else{
            print("there exist picture")
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // do something when image tapped
    @objc func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer){
        
        // Ensures that if the user taps the image view while typing in the text field, the keyboard is dismissed properly.
        //inputTextField.resignFirstResponder()
        
        // add imagePicker to imageView
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = true
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        //var image : UIImage!
//
//        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
//            placeImg.image = img
//        }
//        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            placeImg.image = img
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    
    // gets called when a user taps the image picker’s Cancel button
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    // gets called when a user selects a photo
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage!
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            placeImg.image = selectedImage
        }
        else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            placeImg.image = selectedImage
        }
        
        //placeImg.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
}
