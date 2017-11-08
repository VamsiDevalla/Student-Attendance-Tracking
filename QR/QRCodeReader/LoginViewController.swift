//  LoginViewController.swift
//  QRCodeReader
//  Created by Vanamali,Sirisha on 11/1/17.


import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        // Veryfing login
        PFUser.logInWithUsername(inBackground: userName.text!, password: password.text!,
                                 block: {(user, error) -> Void in
                                    if let error = error as NSError?{
                                        let errorString = error.userInfo["error"] as? NSString
                                        // In case something went wrong...
                                        self.alert(message: errorString!, title: "Error")
                                    }
                                    else {
                                        let alert:UIAlertController = UIAlertController(title: "Success", message: "Login Successful", preferredStyle: .alert)
                                        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in self.performSegue(withIdentifier: "toHome", sender: nil)})
                                        alert.addAction(defaultAction)
                                        self.present(alert, animated: true, completion: nil)
                                    }
        })
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
//
//  LoginViewController.swift
//  QRCodeReader
//
//  Created by Vanamali,Sirisha on 11/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//


