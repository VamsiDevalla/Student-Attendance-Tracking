//
//  DealsViewController.swift
//  SwapNShop
//
//  Created by Mallidi,Anudeep Reddy on 4/16/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to display all deals
class DealsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var dealsTableView: UITableView!
    // To refresh the page
    @IBAction func refresh(_ sender: Any) {
        self.viewDidLoad()
    }
    
    var gameTitles:[String] = []
    var gameDescriptions:[String] = []
    var gameCost:[Int] = []
    var gameimages:[UIImage] = []
    var dealTypes: [String] = []
    var dealStatuses: [String] = []
    var objectID: [String] = []
    var postedBY: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTitles = []
        gameDescriptions = []
        gameCost = []
        gameimages = []
        dealTypes = []
        dealStatuses = []
        objectID = []
        postedBY = []
        // Querying the deals table
        let query = PFQuery(className:"Deals")
        query.whereKey("userId", notEqualTo: PFUser.current()?.objectId as Any)
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                // Looping through the objects to get the names of the workers in each object
                for object in objects! {
                    let postedBy = object["userId"]
                    self.postedBY.append(postedBy as! String)
                    let obj = object.objectId
                    self.objectID.append( obj! )
                    let gameTitle = object["gameTitle"]
                    self.gameTitles.append(gameTitle as! String)
                    let gameDes = object["gameDescription"]
                    self.gameDescriptions.append(gameDes as! String)
                    let gameCost = object["dealCost"]
                    self.gameCost.append(gameCost as! Int)
                    let dealType = object["dealType"]
                    self.dealTypes.append(dealType as! String)
                    let dealStatus = object["dealStatus"]
                    self.dealStatuses.append(dealStatus as! String)
                    let gameImageFile = object["gameImage"] as! PFFile
                    do {
                        let data = try gameImageFile.getData()
                        let image = UIImage(data: data)
                        self.gameimages.append(image!)
                    }
                    catch{
                        print("image not retrived");
                    }
                }
                self.dealsTableView.reloadData()
            }
        }
        self.dealsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dealsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if gameTitles.count > 0 {
            return gameTitles.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DealsTableViewCell", owner:self, options: nil)?.first as! DealsTableViewCell
        if gameTitles.count == gameimages.count{
            cell.gameImageIMGV?.image = gameimages[indexPath.row]
        }
        cell.dealTypeCostLBL?.text = "\(dealTypes[indexPath.row]) for $\(String(gameCost[indexPath.row]))"
        cell.gameTitleLBL?.text = gameTitles[indexPath.row]
        cell.gameDescriptionTXTV?.text = gameDescriptions[indexPath.row]
        return cell
    }
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPost", sender: Any?.self)
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToPins = UITableViewRowAction(style: .normal, title : "Add To Pins") { (rowAction, indexPath) in
            //TODO: edit the row at indexPath here
            var error: NSError?
            let query = PFQuery(className:"Cart")
            query.whereKey("dealID", equalTo: self.objectID[indexPath.row])
            query.whereKey("userID", equalTo: PFUser.current()?.objectId as Any)
            let c = query.countObjects(&error)
            if c == 0 {
                let object = PFObject(className: "Cart")
                object["dealID"] = self.objectID[indexPath.row]
                object["userID"] = PFUser.current()?.objectId
                object.saveInBackground{
                    (success, error) -> Void in
                    if let error = error as NSError? {
                        let errorString = error.userInfo["error"] as? NSString
                        self.alert(message: errorString!, title: "Error")
                    }
                    else {
                        object.saveInBackground(block: { (d, NSError) in
                            if d {
                                self.alert( message: "This is added to your Pinned List",title: "Success")
                            }
                            else {
                                self.alert(message: "Some Thing went wrong on our side, Try Later", title: "Sorry!")
                            }
                        })
                    }
                }
            }
            else {
                self.alert(message: "This post is already in your pins", title: "oops!")
            }
        }
        return [addToPins]
    }
}


