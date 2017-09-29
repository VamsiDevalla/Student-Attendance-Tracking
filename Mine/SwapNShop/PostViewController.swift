//
//  PostViewController.swift
//  SwapNShop
//
//  Created by toshiba on 4/15/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle the display of the particular post
class PostViewController: UIViewController {
    
    var dealImage:UIImage = #imageLiteral(resourceName: "IMG_3143")
    var dealTitle = ""
    var dealDescription = ""
    var dealCost = ""
    var dealType = ""
    var objectID = ""
    
    @IBOutlet weak var navTitile: UINavigationItem!
    
    override func viewDidLoad() {
        self.navTitile.title = dealTitle
        super.viewDidLoad()
        self.navTitile.title = dealTitle
        postImageIMGV.image = dealImage
        postTitleLBL.text = dealTitle
        postDescriptionTXTV.text = dealDescription
        postCostLBL.text = dealCost
        postTypeLBL.text = dealType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var postImageIMGV: UIImageView!
    @IBOutlet weak var postTitleLBL: UILabel!
    @IBOutlet weak var postDescriptionTXTV: UITextView!
    @IBOutlet weak var postCostLBL: UILabel!
    @IBOutlet weak var postTypeLBL: UILabel!
    @IBAction func editPostAction(_ sender: UIButton) {
    }
    @IBAction func DeletePost(_ sender: UIButton) {
        let alert:UIAlertController = UIAlertController(title: "Alert", message: "Your post has been deleted", preferredStyle: .alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in
            let query = PFQuery(className:"Deals")
            query.whereKey("objectId", equalTo: self.objectID)
            query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                for object in objects!
                {
                    object.deleteInBackground()
                    object.saveInBackground()
                }
            }
            let query2 = PFQuery(className:"Cart")
            query2.whereKey("dealID", equalTo: self.objectID)
            query2.findObjectsInBackground {
                (objects, error) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground()
                        object.saveInBackground()
                    }
                }
            }
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // To navigate to previous page
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // To navigate to edit post page
    @IBAction func editPostBTN(_ sender: UIButton) {
        performSegue(withIdentifier: "toEditPost", sender: Any?.self)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? EditPostViewController {
            destination.dealImage = dealImage
            destination.dealTitle = dealTitle
            destination.dealDescription = dealDescription
            destination.dealCost = dealCost
            destination.dealType = dealType
            destination.objectID = objectID
        }
    }
}
