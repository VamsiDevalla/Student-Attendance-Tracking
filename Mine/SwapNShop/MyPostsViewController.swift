//
//  MyPostsViewController.swift
//  SwapNShop
//
//  Created by Mallidi,Anudeep Reddy on 4/16/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to display user posts
class MyPostsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var n = 0
    var gameTitles:[String] = []
    var gameDescriptions:[String] = []
    var gameCost:[Int] = []
    var gameimages:[UIImage] = []
    var dealTypes: [String] = []
    var dealStatuses: [String] = []
    var objectID: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameTitles = []
        self.gameDescriptions = []
        self.gameCost = []
        self.gameimages = []
        self.dealTypes = []
        self.dealStatuses = []
        self.objectID = []
        // Querying Deals table to retrive user posts
        let query = PFQuery(className:"Deals")
        query.whereKey("userId", equalTo: PFUser.current()?.objectId as Any)
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                // Looping through the objects to get the names of the workers in each object
                for object in objects! {
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
                self.myPostTableView.reloadData()
            }
        }
        self.myPostTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // To refresh the page
    @IBAction func refreshBTN(_ sender: UIBarButtonItem) {
        self.viewDidLoad()
    }
    
    @IBOutlet weak var myPostTableView: UITableView!
    
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
        // Configure the cell...
        let cell = Bundle.main.loadNibNamed("DealsTableViewCell", owner:self, options: nil)?.first as! DealsTableViewCell
        if gameimages.count == gameimages.count{
            cell.gameImageIMGV?.image = gameimages[indexPath.row]
        }
        cell.dealTypeCostLBL?.text = "\(dealTypes[indexPath.row]) for $\(String(gameCost[indexPath.row]))"
        cell.gameTitleLBL?.text = gameTitles[indexPath.row]
        cell.gameDescriptionTXTV?.text = gameDescriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title : "Edit") { (rowAction, indexPath) in
            //TODO: edit the row at indexPath here
            self.n = indexPath.row
            self.performSegue(withIdentifier: "toEditPost", sender: Any?.self)
        }
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            let alert:UIAlertController = UIAlertController(title: "Alert", message: "You Posted a game", preferredStyle: .alert)
            let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in   let query = PFQuery(className:"Deals")
                query.whereKey("objectId", equalTo: self.objectID[indexPath.row] )
                query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                    for object in objects!
                    {
                        object.deleteInBackground()
                        object.saveInBackground()
                    }
                }
                let query2 = PFQuery(className:"Cart")
                query2.whereKey("dealID", equalTo: self.objectID[indexPath.row])
                query2.findObjectsInBackground {
                    (objects, error) -> Void in
                    if error == nil {
                        for object in objects! {
                            object.deleteInBackground()
                            object.saveInBackground()
                        }
                    }
                }
                self.viewDidLoad()
            })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            self.viewDidLoad()
        }
        deleteAction.backgroundColor = .red
        return [editAction,deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "postDetail", sender: Any?.self)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? PostViewController {
            destination.dealImage = gameimages[self.myPostTableView.indexPathForSelectedRow!.row]
            destination.dealTitle = gameTitles[self.myPostTableView.indexPathForSelectedRow!.row]
            destination.dealDescription = gameDescriptions[self.myPostTableView.indexPathForSelectedRow!.row]
            destination.dealCost = String(gameCost[self.myPostTableView.indexPathForSelectedRow!.row])
            destination.dealType = dealTypes[self.myPostTableView.indexPathForSelectedRow!.row]
            destination.objectID = objectID[self.myPostTableView.indexPathForSelectedRow!.row]
        }
        else if let destination = segue.destination as? EditPostViewController {
            destination.dealImage = gameimages[n]
            destination.dealTitle = gameTitles[n]
            destination.dealDescription = gameDescriptions[n]
            destination.dealCost = String(gameCost[n])
            destination.dealType = dealTypes[n]
            destination.objectID = objectID[n]
        }
    }
}
