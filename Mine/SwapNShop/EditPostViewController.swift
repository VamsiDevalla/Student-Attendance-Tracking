//
//  EditPostViewController.swift
//  SwapNShop
//
//  Created by toshiba on 4/15/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse

// Class to handel post editing
class EditPostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var navTitile: UINavigationItem!
    
    //to dismiss the keyboard when a enter button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTitleTXT.resignFirstResponder()
        postDescriptionTXTV.resignFirstResponder()
        postCostTXT.resignFirstResponder()
        postTypeTXT.resignFirstResponder()
        return true
    }
    
    let dealTypeList = ["Choose your choice","Swap","Sale","Rent","Swap or Sale","Swap or Rent","Sale or Rent","Negotiable"]
    let picker = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dealTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        postTypeTXT.text = dealTypeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dealTypeList[row]
    }
    
    var dealImage:UIImage = #imageLiteral(resourceName: "IMG_3137")
    var dealTitle = ""
    var dealDescription = ""
    var dealCost = ""
    var dealType = ""
    var objectID = ""
    
    override func viewDidLoad() {
        self.navTitile.title = dealTitle
        postTitleTXT.delegate = self
        postDescriptionTXTV.delegate = self
        postCostTXT.delegate = self
        postTypeTXT.delegate = self
        super.viewDidLoad()
        self.navigationItem.title = dealTitle
        postImageIMGV.image = dealImage
        postTitleTXT.text = dealTitle
        postDescriptionTXTV.text = dealDescription
        postCostTXT.text = dealCost
        postTypeTXT.text = dealType
        picker.delegate = self
        picker.dataSource = self
        postTypeTXT.inputView = picker
        // Adding a tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // To dismiss keyboard on tap gesture
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //keyboard shows
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView: postDescriptionTXTV, moveDistance: -120, up: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == postCostTXT || textField == postTypeTXT  ){
            moveTextField(textField: postTypeTXT, moveDistance: -180, up: true)
        }
    }
    
    // keyboard hiddens
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == postCostTXT || textField == postTypeTXT ){
            moveTextField(textField: postTypeTXT, moveDistance: -180, up: false)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView: postDescriptionTXTV, moveDistance: -120, up: false)
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
    
    func moveTextView(textView: UITextView, moveDistance: Int, up:Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var postImageIMGV: UIImageView!
    @IBAction func changeImageBTN(_ sender: UIButton) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // To navigate to gallery
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        postImageIMGV.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var postTitleTXT: UITextField!
    @IBOutlet weak var postDescriptionTXTV: UITextView!
    @IBOutlet weak var postCostTXT: UITextField!
    @IBOutlet weak var postTypeTXT: UITextField!
    @IBAction func saveChanges(_ sender: UIButton) {
        let query = PFQuery(className:"Deals")
        query.getObjectInBackground(withId: self.objectID) { (updatedObject, error) in
            if error != nil {
                self.alert(message: "Fill All the Feilds", title: "Sorry!")
            }
            else if let updatedObject = updatedObject {
                let gameTitle = self.postTitleTXT.text
                let gameDescription = self.postDescriptionTXTV.text
                let cost = self.postCostTXT.text
                let dealType = self.postTypeTXT.text
                if(gameTitle != "" && gameDescription != "" && cost != "" && dealType != ""){
                    //create an image data
                    let imageData = UIImagePNGRepresentation(self.postImageIMGV.image!)
                    //create a parse file to store in cloud
                    let parseImageFile = PFFile(name: "gameImage.png", data: imageData!)
                    updatedObject["gameImage"] = parseImageFile
                    updatedObject["gameTitle"] = gameTitle
                    updatedObject["gameDescription"] = gameDescription
                    updatedObject["dealCost"] = Int(cost!)
                    updatedObject["dealType"] = dealType
                    updatedObject["dealStatus"] = "In Deals List"
                    updatedObject.saveInBackground{
                        (success, error) -> Void in
                        if let error = error as NSError? {
                            let errorString = error.userInfo["error"] as? NSString
                            self.alert(message: errorString!, title: "Error")
                        }
                        else {
                            updatedObject.saveInBackground(block: { (d, NSError) in
                                if d {
                                    let alert:UIAlertController = UIAlertController(title: "Success", message: "Changes are Saved", preferredStyle: .alert)
                                    let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .cancel, handler: {action in  self.dismiss(animated: true, completion: nil)})
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
                    self.alert(message: "Fill All the Feilds", title: "Sorry!")
                }
            }
        }
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
