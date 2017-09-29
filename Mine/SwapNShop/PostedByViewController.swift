//
//  PostedByViewController.swift
//  SwapNShop
//
//  Created by toshiba on 4/19/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle the display of posted by view
class PostedByViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var postedbyTableView: UITableView!
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var flag = 0
    var obj = ""
    var values:[String] = ["","Username","Firstname:","Lastname:","E-mail:","Phone :","City","Street","State","Country","Zipcode"]
    var des:[String] = [""]
    var img:[UIImage] = [#imageLiteral(resourceName: "IMG_3143")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        des = [""]
        let p = PFUser.query()
        p?.whereKey("objectId", equalTo: self.obj)
        p?.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                let author = objects?[0]
                self.des.append(author?["username"] as! String)
                self.des.append(author?["FirstName"] as! String)
                self.des.append( author?["LastName"] as! String)
                self.des.append(author?["email"] as! String)
                self.des.append( String(describing: (author?["ContactNumber"])!))
                self.des.append(author?["City"] as! String)
                self.des.append(author?["Street"] as! String)
                self.des.append(author?["State"] as! String)
                self.des.append(author?["Country"] as! String)
                self.des.append(author?["ZipCode"] as! String)
                //ProfileImage
                let userImageFile = author?["ProfileImage"] as! PFFile
                userImageFile.getDataInBackground { (Success, Error) in
                    if (Success != nil){
                        let image = UIImage(data: Success!)
                        self.img[0] = image!
                        self.postedbyTableView.reloadData()
                    }
                }
            }
            self.postedbyTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return des.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.row == 0{
            let cell = Bundle.main.loadNibNamed("ProfileImageTableViewCell", owner:self, options: nil)?.first as! ProfileImageTableViewCell
            cell.profilepic.image = img[0]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profilecell", for: indexPath)
            cell.detailTextLabel?.text = des[indexPath.row]
            cell.textLabel?.text = values[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 250
        }
        else {
            return 60
        }
    }
    
}
