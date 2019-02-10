//
//  NewEventViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-28.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log

class NewEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var NewEventNameLabel: UILabel!
    @IBOutlet weak var NewEventNameField: UITextField!
    @IBOutlet weak var NewEventImage: UIImageView!
    @IBOutlet weak var NewEventDescription: UITextView!
    
    
    @IBOutlet weak var New_Happy_Sad_Emoji: UILabel!
    
   
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var New_Happy_Sad_Value: UILabel!
    @IBOutlet weak var New_Anger_Fear_Value: UILabel!
    @IBOutlet weak var New_Interest_Bordem_Value: UILabel!
    @IBOutlet weak var New_Love_Hate_Value: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!    
  
    var did_select_photo = false

    //Corrsponding Steppers
    
    @IBAction func New_Happy_Sad_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
        
        New_Happy_Sad_Value.text = String(Int(sender.value))
        
        if Int(sender.value) == 0 {
        New_Happy_Sad_Emoji.text = "😶"
        }
        else if Int(sender.value) == 3{
        New_Happy_Sad_Emoji.text = "😁"
        }
        else if Int(sender.value) == 2{
        New_Happy_Sad_Emoji.text = "😊"
        }
        else if Int(sender.value) == 1 {
        New_Happy_Sad_Emoji.text = "🙂"
        }
        else if Int(sender.value) == -1{
        New_Happy_Sad_Emoji.text = "😕"
        }
        else if Int(sender.value) == -2{
        New_Happy_Sad_Emoji.text = "☹️"
        }
        else if Int(sender.value) == -3{
        New_Happy_Sad_Emoji.text = "😭"
        }
    
    }
    
    @IBAction func New_Anger_Fear_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
    
        New_Anger_Fear_Value.text = String(Int(sender.value))
    }
    
    @IBAction func New_Interest_Bordem_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
    
        New_Interest_Bordem_Value.text = String(Int(sender.value))
    }
    
    @IBAction func New_Love_Hate_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
    
        New_Love_Hate_Value.text = String(Int(sender.value))
    
    }
    // Return 0 if the steppers are not touched, the corresponding value is it was touched
    func get_emotion_values (Raw: String) -> Int{
    if Raw == "Sad" || Raw == "Fear" || Raw == "Bordem" || Raw == "Hate" {
    return 1
        } else {
        return Int(Raw)!
        }
    }
    // Get the time and date from the device, function called when new event is created
    func get_Event_Time () -> String{
    let time = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.none, timeStyle: .short)
    let day = Calendar.current.component(.day, from: Date())
    let month = Calendar.current.component(.month, from: Date())
    let year = Calendar.current.component(.year, from: Date())
    
    let result = time + "   " + String(month) + "/" + String(day) + "/" + String(year)
    return result
    }
    
  var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NewEventNameField.delegate = self
        
        updateSaveButtonState()
    
    // Clear the textview of the default text when selected - Does not work; only runs once
    //if NewEventDescription.isFirstResponder == true && NewEventDescription.text == "Tap to Enter Text"{
    //NewEventDescription.text = ""
    //} else if NewEventDescription.isFirstResponder == true && NewEventDescription.text == "" {
    //NewEventDescription.text = "Tap to Enter Text"
        //}
    
    // Detecting Keyboard Activities
       NotificationCenter.default.addObserver(self, selector: #selector(keyboard_comingup(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboard_comingup(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboard_comingup(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

deinit {
       NotificationCenter.default.addObserver(self, selector: #selector(keyboard_comingup(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboard_comingup(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboard_comingup(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    }
@objc func keyboard_comingup (notification: Notification){

    guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
return
    }
    //let inset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardRect.height, right: 0)
    
 if (notification.name == UIResponder.keyboardWillShowNotification && NewEventDescription.isFirstResponder) || (notification.name == UIResponder.keyboardWillChangeFrameNotification && NewEventDescription.isFirstResponder){
    view.frame.origin.y = -keyboardRect.height
    } else {
    view.frame.origin.y = 0
    }}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        NewEventImage.image = selectedImage
        did_select_photo = true
        // Dismiss the picker.
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Cancelling Action, The Save Button Was not Pressed", log: OSLog.default,type: .debug)
        return
        }
    
    let EventName = NewEventNameField.text ?? ""
    let EventPhoto = NewEventImage.image
    let EventDescription = NewEventDescription.text ?? ""
    let EventTime = get_Event_Time()
        
    var DOES_HAVE_PHOTO = true
    if did_select_photo == true{
        DOES_HAVE_PHOTO = true
        } else {
        DOES_HAVE_PHOTO = false
        }
        
        
        let HAPPY_SAD_VALUE = get_emotion_values(Raw: New_Happy_Sad_Value.text!)
        let ANGER_FEAR_VALUE = get_emotion_values(Raw: New_Anger_Fear_Value.text!)
        let INTEREST_BORDEM_VALUE = get_emotion_values(Raw: New_Interest_Bordem_Value.text!)
        let LOVE_HATE_VALUE = get_emotion_values(Raw: New_Love_Hate_Value.text!)
        
        
        event = Event(Detail_EventName: EventName, Detail_EventPhoto: EventPhoto, Detail_does_have_photo: DOES_HAVE_PHOTO, Detail_EventDescription: EventDescription, Detail_EventTime: EventTime, Detail_Happy_Sad_Value: Int(HAPPY_SAD_VALUE), Detail_Anger_fear_Value: Int(ANGER_FEAR_VALUE), Detail_Interest_bordem_Value: Int(INTEREST_BORDEM_VALUE), Detail_Love_hate_Value: Int(LOVE_HATE_VALUE))
    
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
   
    }

    // MARK: Actions
    
    @IBAction func selectimagefromdevicelibrary(_ sender: UITapGestureRecognizer) {
    
    // Hide the keyboard.
    NewEventNameField.resignFirstResponder()
    
    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
    let imagePickerController = UIImagePickerController()
    
    // Only allow photos to be picked, not taken.
    imagePickerController.sourceType = .photoLibrary
    
    // Make sure ViewController is notified when the user picks an image.
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = NewEventNameField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }




}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
