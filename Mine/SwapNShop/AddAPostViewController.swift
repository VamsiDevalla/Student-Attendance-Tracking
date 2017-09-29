//
//  AddAPostViewController.swift
//  SwapNShop
//
//  Created by Sangaraju,Sunil Kumar on 4/11/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit
import Parse
import Bolts

// Class to add a post
class AddAPostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var navTitile: UINavigationItem!
    
    //to dismiss the keyboard when a enter button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gameTitleTXT.resignFirstResponder()
        gameDescriptionTXTV.resignFirstResponder()
        GameCostTXT.resignFirstResponder()
        dealTypePicker.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let dealTypeList = ["Choose your choice","Swap","Sale","Rent","Swap or Sale","Swap or Rent","Sale or Rent","Negotiable"]
    let picker = UIPickerView()
    
    override func viewDidLoad() {
        gameTitleTXT.delegate = self
        gameDescriptionTXTV.delegate = self
        GameCostTXT.delegate = self
        dealTypePicker.delegate = self
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        dealTypePicker.inputView = picker
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
    
    //keyboard shows
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView: gameDescriptionTXTV, moveDistance: -120, up: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == GameCostTXT || textField == dealTypePicker){
            moveTextField(textField: GameCostTXT, moveDistance: -180, up: true)
        }
    }
    
    // keyboard hiddens
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == GameCostTXT || textField == dealTypePicker){
            moveTextField(textField: GameCostTXT, moveDistance: -180, up: false)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView: gameDescriptionTXTV, moveDistance: -120, up: false)
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
    
    // to move text fields upwards
    func moveTextView(textView: UITextView, moveDistance: Int, up:Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dealTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dealTypePicker.text = dealTypeList[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dealTypeList[row]
    }
    
    // To display altert messages
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var dealTypePicker: UITextField!
    @IBOutlet weak var GameImageIMGV: UIImageView!
    @IBOutlet weak var GameCostTXT: UITextField!
    @IBOutlet weak var gameDescriptionTXTV: UITextView!
    @IBOutlet weak var gameTitleTXT: UITextField!
    @IBAction func addImageBTN(_ sender: UIButton) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // To navigate to gallery
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        GameImageIMGV.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        let object = PFObject(className: "Deals")
        let gameTitle = gameTitleTXT.text
        let gameDescription = gameDescriptionTXTV.text
        let cost = GameCostTXT.text
        let dealType = dealTypePicker.text
        if(gameTitle != "" && gameDescription != "" && cost != "" && dealType != ""){
            //create an image data
            let imageData = UIImagePNGRepresentation(self.GameImageIMGV.image!)
            //create a parse file to store in cloud
            let parseImageFile = PFFile(name: "gameImage.png", data: imageData!)
            object["userId"]=PFUser.current()?.objectId
            object["gameImage"] = parseImageFile
            object["gameTitle"]=gameTitleTXT.text
            object["gameDescription"] = gameDescription
            object["dealCost"] = Int(cost!)
            object["dealType"] = dealType
            object["dealStatus"] = "In Deals List"
            object.saveInBackground{
                (success, error) -> Void in
                if let error = error as NSError? {
                    let errorString = error.userInfo["error"] as? NSString
                    self.alert(message: errorString!, title: "Error")
                } else {
                    object.saveInBackground(block: { (d, NSError) in
                        if d {
                            let alert:UIAlertController = UIAlertController(title: "Success", message: "You Posted a game", preferredStyle: .alert)
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
            self.alert(message: "Fill All the Feilds", title: "Sorry!")
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
