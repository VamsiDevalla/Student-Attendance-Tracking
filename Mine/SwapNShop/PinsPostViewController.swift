//
//  PinsPostViewController.swift
//  SwapNShop
//
//  Created by toshiba on 4/17/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle the display of the particular deal
class PinsPostViewController: UIViewController {
    
    @IBOutlet weak var navTitile: UINavigationItem!
    var dealImage:UIImage = #imageLiteral(resourceName: "IMG_3143")
    var dealTitle = ""
    var dealDescription = ""
    var dealCost = ""
    var dealType = ""
    var objId = ""
    var postedBy = ""
    
    override func viewDidLoad() {
        self.navTitile.title = dealTitle
        super.viewDidLoad()
        self.navigationItem.title = dealTitle
        dealImageIMGV.image = dealImage
        dealTitleLBL.text = dealTitle
        dealDescriptionTXTV.text = dealDescription
        dealCostLBL.text = dealCost
        dealTypeLBL.text = dealType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func removeFromPinAction(_ sender: UIButton) {
        let alert:UIAlertController = UIAlertController(title: "Alert", message: "Select post is removed from your pinned list", preferredStyle: .alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in  let query = PFQuery(className:"Cart")
            query.whereKey("objectId", equalTo: self.objId )
            query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                for object in objects!
                {
                    object.deleteInBackground()
                    object.saveInBackground()
                }
            }
            self.viewDidLoad()
        })
        alert.addAction(defaultAction)
        self.dismiss(animated: true, completion: nil)
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
