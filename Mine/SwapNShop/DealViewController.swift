//
//  DealViewController.swift
//  SwapNShop
//
//  Created by toshiba on 4/15/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle the display of the particular deal
class DealViewController: UIViewController {
    
    @IBOutlet weak var navTitile: UINavigationItem!
    
    var dealImage:UIImage = #imageLiteral(resourceName: "IMG_3137")
    var dealTitle = ""
    var dealDescription = ""
    var dealCost = ""
    var dealType = ""
    var objectID = ""
    var postedBy = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitile.title = dealTitle
        dealImageIMGV.image = dealImage
        dealTitleLBL.text = dealTitle
        dealDescriptionTXTV.text = dealDescription
        dealCostLBL.text = dealCost
        dealTypeLBL.text = dealType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // To navigate to the previous page
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var dealImageIMGV: UIImageView!
    @IBOutlet weak var dealTitleLBL: UILabel!
    @IBOutlet weak var dealDescriptionTXTV: UITextView!
    @IBOutlet weak var dealCostLBL: UILabel!
    @IBOutlet weak var dealTypeLBL: UILabel!
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addToPinAction(_ sender: UIButton) {
        var error: NSError?
        // Adding a row to the cart table
        let query = PFQuery(className:"Cart")
        query.whereKey("dealID", equalTo: objectID)
        query.whereKey("userID", equalTo: PFUser.current()?.objectId as Any)
        let c = query.countObjects(&error)
        if c == 0 {
            let object = PFObject(className: "Cart")
            object["dealID"] = objectID
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
                            let alert:UIAlertController = UIAlertController(title: "Success", message: "This is added to your Pinned List", preferredStyle: .alert)
                            let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in self.dismiss(animated: true, completion: nil)})
                            alert.addAction(defaultAction)
                            self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func postedByAction(_ sender: UIButton) {
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? PostedByViewController {
            dest.flag = 1
            dest.obj = postedBy
        }
    }
}
