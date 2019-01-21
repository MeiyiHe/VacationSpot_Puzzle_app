//
//  PlaceTableViewController.swift
//  VacationSpotAndPuzzle
//
//  Created by Lexi He on 1/16/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit
import os.log

class PlaceTableViewController: UITableViewController {
    
    //MARK: Properties, initializes it with a default value (an empty array of Place objects)
    var places = [Place]()
    var currRow:Int!
    // reload data for adding new place in array
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData();
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Vacation Spot"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "PlaceTableViewCell")
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PlaceTableViewController.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        
        // if loadPlaces() returns an array of Place objs, this condition is True, enter if statement
        // if loadPlaces() return nil then no places to load, do not enter the if statement
        if let savedPlaces = loadPlaces() {
            places += savedPlaces
        }else{
            // Load the sample data.
            loadSamplePlaces()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = PlaceViewController()
        detailView.placeTableViewController = self
        
        currRow = indexPath.row
        
        detailView.place = Place(name: places[currRow].name, photo: places[currRow].photo, rating: places[currRow].rating)
        detailView.inputTextField?.text = places[currRow].name
        detailView.placeImg?.image = places[currRow].photo
        detailView.stackView.rating = places[currRow].rating
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    // The following 2 function handle the tap on edit button on the navigation bar
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            places.remove(at: indexPath.row)
            
            // store information
            savePlaces()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // when tap on add button on the navigation bar
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!){
        let newViewController = PlaceViewController()
        newViewController.placeTableViewController = self
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    // ------ this two funciton to set up table view controller ------
    // this function create and return tableview cell in tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PlaceTableViewCell"
        
        // The as? PlaceTableViewCell expression attempts to downcast the returned object from the UITableViewCell class to your PlaceTableViewCell class. This returns an optional.
        // The guard let expression safely unwraps the optional.
        // cellIdentifier in storyboard should match here.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaceTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        
        // Fetches the appropriate place for the data source layout.
        let place = places[indexPath.row]
        
        // Configure the cell here:
        // This code sets each of the views in the table view cell to display the corresponding data from place object.
        cell.nameLabel.text = place.name
        cell.photoImageView.image = place.photo
        cell.ratingControl.rating = place.rating
        return cell
    }
    
    // this function handle how many cell will be shown on TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    // ------ this two funciton to set up table view controller ------
    
    
    
    // setting the cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = 90
        return cellHeight
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Private Methods
    private func loadSamplePlaces() {
        
        let photo1 = UIImage(named: "cat")
        let photo2 = UIImage(named: "cat")
        let photo3 = UIImage(named: "cat")
        
        guard let place1 = Place(name: "Place A", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let place2 = Place(name: "Place B", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let place3 = Place(name: "Place C", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        places += [place1, place2, place3]
    }
    
    /*
     This method attempts to archive the meals array to a specific location, and returns true if it’s successful. It uses the constant Place.ArchiveURL that you defined in the Place class to identify where to save the information.
     */
    private func savePlaces() {
        
        
        print("PlaceTableView: savePlaces(): \(places.count)")
        // testing store information
        //UserDefaults.standard.set(places, forKey: "SavedPlaces")
        // PropertyListEncoder().encode(player)
        
        let successSave = try? NSKeyedArchiver.archivedData(withRootObject: places, requiringSecureCoding: true)
        // NSKeyedArchiver.archivedData(withRootObject: hero)
        
        //UserDefaults.standard.set(placeTableViewController.places, forKey: "SavedPlaces")
        UserDefaults.standard.set( successSave, forKey: "SavedPlaces" )
    }
    
    /*
     Return type of an optional array of Place objects, it might return an array of Place objects or might return nil
     */
    private func loadPlaces() -> [Place]? {
        print("loadPlaces(): \(places.count)")
    
//        if let savedData = UserDefaults.standard.value(forKey: "SavedPlaces") as? NSData {
//            places += NSKeyedUnarchiver.unarchiveObject(with: savedData as Data) as! [Place]
//        }
        let data = NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self], from: UserDefaults.standard.object(forKey: "SavedPlaces") as! Place)
        
        //return NSKeyedUnarchiver.unarchivedObject(ofClasses: <#T##[AnyClass]#>, from: <#T##Data#>)
        return UserDefaults.standard.object(forKey: "SavedPlaces") as? [Place]
        
        //return places
    }

}
