//
//  PuzzleViewController.swift
//  VacationSpotAndPuzzle
//
//  Created by Lexi He on 1/16/19.
//  Copyright © 2019 Meiyi He. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // puzzle image array
    var questionImageArray = [#imageLiteral(resourceName: "Layer 1"), #imageLiteral(resourceName: "Layer 3"), #imageLiteral(resourceName: "Layer 6"), #imageLiteral(resourceName: "Layer 4"), #imageLiteral(resourceName: "Layer 5"), #imageLiteral(resourceName: "Layer 7"), #imageLiteral(resourceName: "Layer 8"), #imageLiteral(resourceName: "Layer 9"), #imageLiteral(resourceName: "Layer 10")]
    
    var correctAns = [0,3,1,4,2,5,6,7,8]
    
    // initial display
    var wrongAns = Array(0..<9)
    var wrongImgArray = [UIImage]()
    var undoArray = [(first: IndexPath, second: IndexPath)]()
    var numMoves = 0
    
    var firstIdxPath:IndexPath?
    var secondIdxPath:IndexPath?
    
    // collection view for the puzzle game
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.allowsMultipleSelection = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // initialize swap button
    let swapBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Swap", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // initialize undo button
    let undoBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Undo", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.red, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // initalize count move label
    let moveCntLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Puzzle Game"
        
        wrongImgArray = questionImageArray
        setUpViews()
    }
    
    
    // MARK: collection view set up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionImageArray.count
    }
    
    // populate cells in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PuzzleGameCollectionViewCell
        cell.imgView.image = wrongImgArray[indexPath.item]
        return cell
    }
    
    // handle selection in puzzle game
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if firstIdxPath == nil {
            firstIdxPath = indexPath
            collectionView.selectItem(at: firstIdxPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
            
        } else if secondIdxPath == nil {
            secondIdxPath = indexPath
            collectionView.selectItem(at: secondIdxPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }else {
            collectionView.deselectItem(at: secondIdxPath!, animated: true)
            secondIdxPath = indexPath
            collectionView.selectItem(at: secondIdxPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
    
    // store index path when selecting cell
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == firstIdxPath {
            firstIdxPath = nil
        } else if indexPath == secondIdxPath {
            secondIdxPath = nil
        }
    }
    
    // set up the width of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3, height: width/3)
    }
    
    
    
    func setUpViews() {
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(PuzzleGameCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(myCollectionView)
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 170).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive=true
        myCollectionView.heightAnchor.constraint(equalTo: myCollectionView.widthAnchor).isActive=true
        
        
        self.view.addSubview(swapBtn)
        swapBtn.widthAnchor.constraint(equalToConstant: 200).isActive=true
        swapBtn.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20).isActive=true
        swapBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        swapBtn.heightAnchor.constraint(equalToConstant: 50).isActive=true
        swapBtn.addTarget(self, action: #selector(swapBtnAction), for: .touchUpInside)
        
        self.view.addSubview(undoBtn)
        undoBtn.widthAnchor.constraint(equalToConstant: 200).isActive=true
        undoBtn.topAnchor.constraint(equalTo: swapBtn.bottomAnchor, constant: 15).isActive=true
        undoBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        undoBtn.heightAnchor.constraint(equalToConstant: 50).isActive=true
        undoBtn.addTarget(self, action: #selector(undoBtnAction), for: .touchUpInside)
        
        self.view.addSubview(moveCntLabel)
        moveCntLabel.widthAnchor.constraint(equalToConstant: 200).isActive=true
        moveCntLabel.topAnchor.constraint(equalTo: undoBtn.bottomAnchor, constant: 15).isActive=true
        moveCntLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        moveCntLabel.heightAnchor.constraint(equalToConstant: 50).isActive=true
        moveCntLabel.text = "Moves: \(numMoves)"
    }
    
    // when user click on swap button
    @objc func swapBtnAction() {
        // check nil
        guard let start = firstIdxPath, let end = secondIdxPath else {return}
        
        // perform swap action
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        })
        { (finished) in
            // update array and the view after swap the cells
            self.myCollectionView.deselectItem(at: start, animated: true)
            self.myCollectionView.deselectItem(at: end, animated: true)
            self.firstIdxPath = nil
            self.secondIdxPath = nil
            self.wrongImgArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoArray.append((first: start, second: end))
            self.numMoves += 1
            self.moveCntLabel.text = "Moves: \(self.numMoves)"
            
            if self.wrongAns == self.correctAns {
                let alert = UIAlertController(title: "You Won!", message: "Congratulations 🤣", preferredStyle: UIAlertController.Style.alert)
                let okay = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                let restart = UIAlertAction(title: "Restart", style: UIAlertAction.Style.default, handler: {(action) in self.restartGame()})
                
                alert.addAction(okay)
                alert.addAction(restart)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // this function reset the game
    func restartGame() {
        self.undoArray.removeAll()
        // each time will have a different puzzle game
        self.wrongAns = Array(0..<9)
        self.wrongImgArray = questionImageArray
        self.firstIdxPath = nil
        self.secondIdxPath = nil
        self.numMoves = 0
        self.moveCntLabel.text = "Moves: \(self.numMoves)"
        self.myCollectionView.reloadData()
    }
    
    
    // when user click on undo button
    @objc func undoBtnAction() {
        if undoArray.count == 0 {
            return
        }
        let start = undoArray.last!.first
        let end = undoArray.last!.second
        
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        })
        { (finished) in
            // updata datasource
            self.wrongImgArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoArray.removeLast()
            self.numMoves += 1
            self.moveCntLabel.text = "Moves: \(self.numMoves)"
        }
    }

}
