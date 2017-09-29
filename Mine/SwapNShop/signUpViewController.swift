//
//  signUpViewController.swift
//  SwapNShop
//
//  Created by Devalla,Vamsi on 4/10/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle Sign Up process
class signUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    //to dismiss the keyboard when a enter button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTxt.resignFirstResponder()
        firstNameTxt.resignFirstResponder()
        lastNameTxt.resignFirstResponder()
        mailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        reTypeTxt.resignFirstResponder()
        contactTxt.resignFirstResponder()
        streetTxt.resignFirstResponder()
        cityTxt.resignFirstResponder()
        stateTxt.resignFirstResponder()
        zipcodeTxt.resignFirstResponder()
        CountryTXT.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxt.delegate = self
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        mailTxt.delegate = self
        passwordTxt.delegate = self
        reTypeTxt.delegate = self
        contactTxt.delegate = self
        streetTxt.delegate = self
        cityTxt.delegate = self
        stateTxt.delegate = self
        zipcodeTxt.delegate = self
        CountryTXT.delegate = self
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
    }
    
    @IBOutlet weak var profilepic: UIImageView!
    @IBAction func photopic(_ sender: UIButton) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // To navigate to gallery
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        profilepic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var mailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var reTypeTxt: UITextField!
    @IBOutlet weak var contactTxt: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var zipcodeTxt: UITextField!
    @IBOutlet weak var CountryTXT: UITextField!
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //keyboard shows
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == CountryTXT || textField == zipcodeTxt || textField == stateTxt || textField == cityTxt || textField == contactTxt || textField == streetTxt ){
            moveTextField(textField: CountryTXT, moveDistance: -220, up: true)
        }
    }
    
    // keyboard hiddens
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == CountryTXT || textField == zipcodeTxt || textField == stateTxt || textField == cityTxt || textField == contactTxt || textField == streetTxt ){
            moveTextField(textField: CountryTXT, moveDistance: -220, up: false)
        }
    }
    
    // userdefined method to show animation for keyboard
    func moveTextField(textField: UITextField, moveDistance: Int, up:Bool)
    {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        // Retrieving the info from the text fields
        let username = userNameTxt.text
        let password = passwordTxt.text
        if passwordTxt.text != reTypeTxt.text{
            self.alert(message: "Password did not match", title: "Error")
        }
        else{
            if ( firstNameTxt.text! != "" && lastNameTxt.text! != "" && mailTxt.text! != "" && contactTxt.text! != "" && streetTxt.text! != "" && cityTxt.text! != "" && stateTxt.text! != "" && zipcodeTxt.text! != "" ){
                // Defining the user object
                //create an image data
                let imageData = UIImagePNGRepresentation(self.profilepic.image!)
                //create a parse file to store in cloud
                let parseImageFile = PFFile(name: "ProfileImage.png", data: imageData!)
                let user = PFUser()
                user.username = username
                user.password = password
                user["pass"] = password
                user["FirstName"] = firstNameTxt.text
                user["LastName"] = lastNameTxt.text
                user["email"] = mailTxt.text
                user["ContactNumber"] = Int(contactTxt.text!)
                user["Street"] = streetTxt.text
                user["State"] = stateTxt.text
                user["ZipCode"] = zipcodeTxt.text
                user["City"] = cityTxt.text
                user["Country"] = CountryTXT.text
                user["ProfileImage"] = parseImageFile
                // Signing up using the Parse API
                user.signUpInBackground {
                    (success, error) -> Void in
                    if let error = error as NSError? {
                        let errorString = error.userInfo["error"] as? NSString
                        self.alert(message: errorString!, title: "Error")
                    }
                    else {
                        user.saveInBackground(block: { (d, NSError) in
                            if d {
                                let alert:UIAlertController = UIAlertController(title: "Success", message: "Registration Successful", preferredStyle: .alert)
                                let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in self.performSegue(withIdentifier: "toLogIn", sender: nil)})
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
                self.alert(message: "Please fill all the columns and click sign up button", title: "Alert")
            }
        }
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
