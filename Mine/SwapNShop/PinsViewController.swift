//
//  PinsViewController.swift
//  SwapNShop
//
//  Created by toshiba on 4/17/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to display all pinned posts
class PinsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var pinsTableView: UITableView!
    
    @IBAction func toDealsAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    // To refresh the page
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.viewDidLoad()
    }
    
    var gameTitles:[String] = []
    var gameDescriptions:[String] = []
    var gameCost:[Int] = []
    var gameimages:[UIImage] = []
    var dealTypes: [String] = []
    var dealStatuses: [String] = []
    var objectID: [String] = []
    var objID: [String] = []
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
        objID = []
        postedBY = []
        let query1 = PFQuery(className:"Cart")
        query1.whereKey("userID", equalTo: PFUser.current()?.objectId as Any)
        query1.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    let obj = object.objectId
                    self.objID.append(obj! as String)
                    let objectID = object["dealID"] as! String
                    let query = PFQuery(className:"Deals")
                    print(self.objectID)
                    query.whereKey("objectId", equalTo: objectID)
                    query.findObjectsInBackground {
                        (objects, error) -> Void in
                        if error == nil {
                            // Looping through the objects to get the names of the workers in each object
                            for object in objects! {
                                let postedBy = object["userId"]
                                self.postedBY.append(postedBy as! String)
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
                            self.pinsTableView.reloadData()
                        }
                    }
                    self.pinsTableView.reloadData()
                }
            }
            self.pinsTableView.reloadData()
        }
        
        self.pinsTableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            let alert:UIAlertController = UIAlertController(title: "Alert", message: "Your post has been deleted", preferredStyle: .alert)
            let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in  let query = PFQuery(className:"Cart")
                query.whereKey("objectId", equalTo: self.objID[indexPath.row] )
                query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                    for object in objects!
                    {
                        object.deleteInBackground()
                        object.saveInBackground()
                    }
                }
            })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            self.viewDidLoad()
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPinnedpost", sender: Any?.self)
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? PinsPostViewController {
            destination.dealImage = gameimages[self.pinsTableView.indexPathForSelectedRow!.row]
            destination.dealTitle = gameTitles[self.pinsTableView.indexPathForSelectedRow!.row]
            destination.dealDescription = gameDescriptions[self.pinsTableView.indexPathForSelectedRow!.row]
            destination.dealCost = String(gameCost[self.pinsTableView.indexPathForSelectedRow!.row])
            destination.dealType = dealTypes[self.pinsTableView.indexPathForSelectedRow!.row]
            destination.objId = objID[self.pinsTableView.indexPathForSelectedRow!.row]
            destination.postedBy = postedBY[self.pinsTableView.indexPathForSelectedRow!.row]
        }
    }
}
