//
//  Place.swift
//  VacationSpot
//
//  Created by Lexi He on 1/8/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit
import os.log

class Place: NSObject, NSCoding {
    
    // Following 2 functions are required by NSCoding protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    /*
     The return value of decodeObjectForKey(_:) is an Any? optional. The guard statement both unwraps the optional and downcasts the enclosed type to a String, before assigning it to the name constant. If either of these operations fail, the entire initializer fails.
     
     The decodeIntegerForKey(_:) method unarchives an integer. Because the return value of decodeIntegerForKey is Int, there’s no need to downcast the decoded value and there is no optional to unwrap.
     */
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Place object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
    
    
    //MARK: Properties:
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Archiving Paths
    // Outside of the Place class, can access the path using the syntax Place.ArchiveURL.path.
    // DocumentsDirectory constant uses the file manager’s urls(for:in:) method to look up the URL for your app’s documents directory. This is a directory where your app can save data for the user. This method returns an array of URLs, and the first parameter returns an optional containing the first URL in the array. However, as long as the enumerations are correct, the returned array should always contain exactly one match. Therefore, it’s safe to force unwrap the optional.
    // After determining the URL for the documents directory, you use this URL to create the URL for your apps data. Here, you create the file URL by appending places to the end of the documents URL.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("places")
    
    
    // (var) instead of constants (let) because they’ll need to change throughout the object’s lifetime.
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
