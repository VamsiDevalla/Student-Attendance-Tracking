//
//  AttendanceViewController.swift
//  QRCodeReader
//
//  Created by Vanamali,Sirisha on 11/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse
class AttendanceViewController: UIViewController {
var scaned = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         var error: NSError?
        
        let query = PFQuery(className:"QRCode")
        query.whereKey("QR", equalTo: scaned as Any)
        let c = query.countObjects(&error)
        if c == 1 {
            let user = PFUser.current()
            let sid =  user?["ID"]
            let crn = scaned.split(separator: "-")[1]
            let attendance = PFQuery(className:"Attendance")
            attendance.whereKey("SID", equalTo: sid as Any)
            attendance.whereKey("CRN", equalTo: crn as Any!)
            attendance.findObjectsInBackground {
                (objects, error) -> Void in
                if error == nil {
                    for object in objects! {
                        //if
                        object["Status"] = true
                        object.saveInBackground{
                            (success, error) -> Void in
                            if let error = error as NSError? {
                                let errorString = error.userInfo["error"] as? NSString
                                self.alert(message: errorString!, title: "Error")
                            }
                            else {
                                
                                let reg = PFQuery(className:"regestries")
                                reg.whereKey("studentId", equalTo: sid as Any)
                                reg.whereKey("CRN", equalTo: crn as Any)
                                reg.findObjectsInBackground {
                                    (objects, error) -> Void in
                                    if error == nil {
                                        for object in objects! {
                                            let status = object["lacturesAttended"]
                                            let count = status as! Int
                                            object["lacturesAttended"] = count+1
                                            object.saveInBackground{
                                                (success, error) -> Void in
                                                if let error = error as NSError? {
                                                    let errorString = error.userInfo["error"] as? NSString
                                                    self.alert(message: errorString!, title: "Error")
                                                }
                                                else {
                                                    object.saveInBackground(block: { (d, NSError) in
                                                        if d {
                                                            let alert:UIAlertController = UIAlertController(title: "Success", message: "Attendance Marked", preferredStyle: .alert)
                                                            
                                                            let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in self.performSegue(withIdentifier: "toPercentage", sender: nil)})
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
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
