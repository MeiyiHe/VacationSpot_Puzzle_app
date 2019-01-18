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
    
    var puzzleViewController: PuzzleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Select Picture"

        // adding imageview
        placeImg = UIImageView(frame: CGRect(x: 50, y: 235, width: 300.0, height: 300.0))
        placeImg.image = UIImage(named:"defaultPhoto")
        placeImg.isUserInteractionEnabled = true
        placeImg.center.x = self.view.center.x
        self.view.addSubview(placeImg)
        
        
        // add tapRecognizer to imageView
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPhotoLibrary))
        placeImg.addGestureRecognizer(tapGestureRecognizer)
        
        var slicedImg = slice(image: placeImg.image!, into: 3)
        print(slicedImg)
        
    }
    
    // do something when image tapped
    @objc func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer){
        
        // Ensures that if the user taps the image view while typing in the text field, the keyboard is dismissed properly.
        //inputTextField.resignFirstResponder()
        
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
    
    
    // handle picture cutting here:
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    

}
