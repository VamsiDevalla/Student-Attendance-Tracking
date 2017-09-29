//
//  profileEditViewController.swift
//  SwapNShop
//
//  Created by Sangaraju,Sunil Kumar on 4/10/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handle profile editing
class profileEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    //to dismiss the keyboard when a enter button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTXT.resignFirstResponder()
        firstNameTXT.resignFirstResponder()
        lastnameTXT.resignFirstResponder()
        emailTXT.resignFirstResponder()
        passwordTXT.resignFirstResponder()
        reTypePasswordTXT.resignFirstResponder()
        contactNumberTXT.resignFirstResponder()
        streetTXT.resignFirstResponder()
        cityTXT.resignFirstResponder()
        stateTXT.resignFirstResponder()
        zipCodeTXT.resignFirstResponder()
        countryTXT.resignFirstResponder()
        return true
    }
    
    var img:UIImage = #imageLiteral(resourceName: "IMG_3137")
    var firstName = ""
    var lastName = ""
    var password = ""
    var reTypePassword = ""
    var userName = ""
    var email = ""
    var contactNumber = ""
    var street = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTXT.delegate = self
        firstNameTXT.delegate = self
        lastnameTXT.delegate = self
        emailTXT.delegate = self
        passwordTXT.delegate = self
        reTypePasswordTXT.delegate = self
        contactNumberTXT.delegate = self
        streetTXT.delegate = self
        cityTXT.delegate = self
        stateTXT.delegate = self
        zipCodeTXT.delegate = self
        countryTXT.delegate = self
        profileImageIMGV.image = img
        firstNameTXT.text = firstName
        lastnameTXT.text = lastName
        passwordTXT.text = password
        reTypePasswordTXT.text = reTypePassword
        userNameTXT.text = userName
        emailTXT.text = email
        contactNumberTXT.text = contactNumber
        streetTXT.text = street
        cityTXT.text = city
        stateTXT.text = state
        zipCodeTXT.text = zipcode
        countryTXT.text = country
        // Adding a tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // To dismiss keyboard on tap gesture
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //keyboard shows
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == countryTXT || textField == zipCodeTXT || textField == stateTXT || textField == cityTXT || textField == streetTXT ){
            moveTextField(textField: countryTXT, moveDistance: -150, up: true)
        }
        
    }
    
    // keyboard hiddens
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == countryTXT || textField == zipCodeTXT || textField == stateTXT || textField == cityTXT || textField == streetTXT ){
            moveTextField(textField: countryTXT, moveDistance: -150, up: false)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var profileImageIMGV: UIImageView!
    
    @IBAction func changeImageAction(_ sender: UIButton) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // To navigate to gallery
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        profileImageIMGV.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var firstNameTXT: UITextField!
    @IBOutlet weak var lastnameTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    @IBOutlet weak var reTypePasswordTXT: UITextField!
    @IBOutlet weak var userNameTXT: UITextField!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var contactNumberTXT: UITextField!
    @IBOutlet weak var streetTXT: UITextField!
    @IBOutlet weak var cityTXT: UITextField!
    @IBOutlet weak var stateTXT: UITextField!
    @IBOutlet weak var zipCodeTXT: UITextField!
    @IBOutlet weak var countryTXT: UITextField!
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let username = userNameTXT.text
        let password = passwordTXT.text
        if passwordTXT.text != reTypePasswordTXT.text{
            self.alert(message: "Password did not match", title: "Error")
        }
        else{
            if ( firstNameTXT.text! != "" && lastnameTXT.text! != "" && emailTXT.text! != "" && contactNumberTXT.text! != "" && streetTXT.text! != "" && cityTXT.text! != "" && stateTXT.text! != "" && zipCodeTXT.text! != "" ){
                // Defining the user object
                //create an image data
                let imageData = UIImagePNGRepresentation(self.profileImageIMGV.image!)
                //create a parse file to store in cloud
                let parseImageFile = PFFile(name: "ProfileImage.png", data: imageData!)
                let user = PFUser.current()
                user?.username = username
                user?.password = password
                user?["FirstName"] = firstNameTXT.text
                user?["LastName"] = lastnameTXT.text
                user?["email"] = emailTXT.text
                user?["ContactNumber"] = Int(contactNumberTXT.text!)
                user?["Street"] = streetTXT.text
                user?["State"] = stateTXT.text
                user?["ZipCode"] = zipCodeTXT.text
                user?["City"] = cityTXT.text
                user?["Country"] = countryTXT.text
                user?["ProfileImage"] = parseImageFile
                user?.saveInBackground(block: { (d, NSError) in
                    if d {
                        let alert:UIAlertController = UIAlertController(title: "Success", message: "Changes are Saved", preferredStyle: .alert)
                        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in self.dismiss(animated: true, completion: nil)})
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        self.alert(message: "Some Thing went wrong on our side, Try Later", title: "Sorry!")
                    }
                })
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
