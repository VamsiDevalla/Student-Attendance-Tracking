//
//  logInViewController.swift
//  SwapNShop
//
//  Created by Sangaraju,Sunil Kumar on 4/2/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle login
class logInViewController: UIViewController, UITextFieldDelegate {
    
    // To dismiss the keyboard when a enter button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        userNameTxt.delegate = self
        passwordTxt.delegate = self
        super.viewDidLoad()
        // Adding a tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // To dismiss keyboard on tap gesture
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        // Veryfing login
        PFUser.logInWithUsername(inBackground: userNameTxt.text!, password: passwordTxt.text!,
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
