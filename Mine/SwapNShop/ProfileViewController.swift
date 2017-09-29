//
//  ProfileViewController.swift
//  SwapNShop
//
//  Created by Mallidi,Anudeep Reddy on 4/16/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to display profile page
class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var profileTable: UITableView!
    
    var values:[String] = ["Username","Firstname:","Lastname:","E-mail:","Phone :","City","Street","State","Country","Zipcode"]
    var des:[String] = []
    var img:[UIImage] = [#imageLiteral(resourceName: "IMG_3137")]
    var pass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        des = []
        pass = ""
        let user = PFUser.current()
        des.append(user?["username"] as! String)
        des.append(user?["FirstName"] as! String)
        des.append( user?["LastName"] as! String)
        des.append(user?["email"] as! String)
        des.append( String(describing: (user?["ContactNumber"])!))
        des.append(user?["City"] as! String)
        des.append(user?["Street"] as! String)
        des.append(user?["State"] as! String)
        des.append(user?["Country"] as! String)
        des.append(user?["ZipCode"] as! String)
        pass = user?["pass"] as! String
        //ProfileImage
        let userImageFile = user?["ProfileImage"] as! PFFile
        userImageFile.getDataInBackground { (Success, Error) in
            if (Success != nil){
                let image = UIImage(data: Success!)
                self.img[0] = image!
                self.profileTable.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        self.profileTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return values.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.row == 0{
            let cell = Bundle.main.loadNibNamed("ProfileImageTableViewCell", owner:self, options: nil)?.first as! ProfileImageTableViewCell
            cell.profilepic.image = img[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profilecell", for: indexPath)
            cell.detailTextLabel?.text = des[indexPath.row-1]
            cell.textLabel?.text = values[indexPath.row-1
            ]
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
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        let currentUser = PFUser.current()
        if currentUser == nil {
            
            self.performSegue(withIdentifier: "toLogIn", sender: nil)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? profileEditViewController {
            destination.img = img[0]
            destination.userName = des[0]
            destination.firstName = des[1]
            destination.lastName = des[2]
            destination.email = des[3]
            destination.contactNumber = des[4]
            destination.city = des[5]
            destination.street = des[6]
            destination.state = des[7]
            destination.country = des[8]
            destination.zipcode = des[9]
            destination.password = pass
            destination.reTypePassword = pass
        }
    }
}
