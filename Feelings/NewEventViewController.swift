//
//  NewEventViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-28.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log
import CoreData
import RestKit
import ToneAnalyzerV3

class NewEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var NewEventNameLabel: UILabel!
    @IBOutlet weak var NewEventNameField: UITextField!
    @IBOutlet weak var NewEventImage: UIImageView!
    @IBOutlet weak var NewEventDescription: UITextView!
    
    @IBOutlet weak var New_Happy_Sad_Emoji: UILabel!
    @IBOutlet weak var New_Anger_Fear_Emoji: UILabel!
    @IBOutlet weak var New_Interest_Bordem_Emoji: UILabel!
    @IBOutlet weak var New_Love_Hate_Emoji: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var New_Happy_Sad_Value: UILabel!
    @IBOutlet weak var New_Anger_Fear_Value: UILabel!
    @IBOutlet weak var New_Interest_Bordem_Value: UILabel!
    @IBOutlet weak var New_Love_Hate_Value: UILabel!
	
	@IBOutlet weak var Happy_Sad_Stepper: UIStepper!
	@IBOutlet weak var Anger_Fear_Stepper: UIStepper!
	@IBOutlet weak var Interest_Bordem_Stepper: UIStepper!
	@IBOutlet weak var Love_Hate_Stepper: UIStepper!
	
	@IBOutlet weak var Call_API_Tone_Analyzer_Button: UIButton!
	@IBOutlet weak var Auto_Manual_Button: UIButton!
	
    var did_select_photo = false

    // MARK: Corrsponding Steppers
    
    @IBAction func New_Happy_Sad_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
        
        New_Happy_Sad_Value.text = String(Int(sender.value))
        
        switch Int(sender.value) {
        case 0:
        New_Happy_Sad_Emoji.text = "😶"
        case 3:
        New_Happy_Sad_Emoji.text = "😁"
        case 2:
        New_Happy_Sad_Emoji.text = "😊"
        case 1:
        New_Happy_Sad_Emoji.text = "🙂"
        case -1:
        New_Happy_Sad_Emoji.text = "😕"
        case -2:
        New_Happy_Sad_Emoji.text = "☹️"
        case -3:
        New_Happy_Sad_Emoji.text = "😭"
        default:
        New_Happy_Sad_Emoji.text = "YES"
        }
    }
    
    @IBAction func New_Anger_Fear_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
    
        New_Anger_Fear_Value.text = String(Int(sender.value))
    
    switch Int(sender.value){
       case 0:
       New_Anger_Fear_Emoji.text = "😶"
       case 3:
       New_Anger_Fear_Emoji.text = "😡"
       case 2:
       New_Anger_Fear_Emoji.text = "😤"
       case 1:
       New_Anger_Fear_Emoji.text = "😠"
       case -1:
       New_Anger_Fear_Emoji.text = "😨"
       case -2:
       New_Anger_Fear_Emoji.text = "😰"
       case -3:
       New_Anger_Fear_Emoji.text = "😱"
       default:
       New_Anger_Fear_Emoji.text = "YES"
        }
    }
    
    @IBAction func New_Interest_Bordem_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
    
        New_Interest_Bordem_Value.text = String(Int(sender.value))
        
        switch Int(sender.value){
        case 0:
        New_Interest_Bordem_Emoji.text = "😶"
        case 3:
        New_Interest_Bordem_Emoji.text = "😳"
        case 2:
        New_Interest_Bordem_Emoji.text = "🤔"
        case 1:
        New_Interest_Bordem_Emoji.text = "😯"
        case -1:
        New_Interest_Bordem_Emoji.text = "😐"
        case -2:
        New_Interest_Bordem_Emoji.text = "😑"
        case -3:
        New_Interest_Bordem_Emoji.text = "😪"
        default:
        New_Interest_Bordem_Emoji.text = "YES"
        }
    }
    
    @IBAction func New_Love_Hate_Value_Stepper(_ sender: UIStepper) {
    
    sender.maximumValue = 3.0
    sender.minimumValue = -3.0
    
        New_Love_Hate_Value.text = String(Int(sender.value))
        
        switch Int(sender.value){
        case 0:
        New_Love_Hate_Emoji.text = "😶"
        case 3:
        New_Love_Hate_Emoji.text = "😍"
        case 2:
        New_Love_Hate_Emoji.text = "🥰"
        case 1:
        New_Love_Hate_Emoji.text = "😘"
        case -1:
        New_Love_Hate_Emoji.text = "😏"
        case -2:
        New_Love_Hate_Emoji.text = "😖"
        case -3:
        New_Love_Hate_Emoji.text = "😈"
        default:
        New_Love_Hate_Emoji.text = "YES"
        }
    }
	
    //MARK: API call and manual values
	
	@IBAction func Call_Tone_Analyzer(_ sender: UIButton) {
		let text_to_API = NewEventDescription.text
	
	}
	
	@IBAction func Manual_Auto_Values(_ sender: UIButton) {
		if Happy_Sad_Stepper.isHidden == false && Anger_Fear_Stepper.isHidden == false && Interest_Bordem_Stepper.isHidden == false && Love_Hate_Stepper.isHidden == false {
			Happy_Sad_Stepper.isHidden = true
			Anger_Fear_Stepper.isHidden = true
			Interest_Bordem_Stepper.isHidden = true
			Love_Hate_Stepper.isHidden = true
			sender.setTitle("Auto Adjust", for: .normal)
			Call_API_Tone_Analyzer_Button.isUserInteractionEnabled = false
			Call_API_Tone_Analyzer_Button.setTitle("Analyzer Disabled", for: .disabled)
		
		} else if Happy_Sad_Stepper.isHidden == true && Anger_Fear_Stepper.isHidden == true && Interest_Bordem_Stepper.isHidden == true && Love_Hate_Stepper.isHidden == true {
			Happy_Sad_Stepper.isHidden = false
			Anger_Fear_Stepper.isHidden = false
			Interest_Bordem_Stepper.isHidden = false
			Love_Hate_Stepper.isHidden = false
			sender.setTitle("Manual Adjust", for: .normal)
			Call_API_Tone_Analyzer_Button.isUserInteractionEnabled = true
		}
	}
	
    // Return 0 if the steppers are not touched, the corresponding value is it was touched
    func get_emotion_values (Raw: String) -> Int{
    if Raw == "Sadness" || Raw == "Fear" || Raw == "Bordem" || Raw == "Hate" {
    return 1
        } else {
        return Int(Raw)!
        }
    }
	
    // Get the time and date from the device, function called when new event is created
    func get_Event_Time () -> [Any]{
//    let time = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.none, timeStyle: .short)
    let hour_24 = Calendar.current.component(.hour, from: Date())
    let min = Calendar.current.component(.minute, from: Date())
    let sec = Calendar.current.component(.second, from: Date())
    var hour_12 = 0
    var APM = ""
    if hour_24 > 12{
        hour_12 = hour_24 - 12
        APM = "PM"
        } else {
        hour_12 = hour_24
        APM = "AM"
        }
    let day = Calendar.current.component(.day, from: Date())
    let month = Calendar.current.component(.month, from: Date())
    let year = Calendar.current.component(.year, from: Date())
    
    let display_time = String(hour_12) + ":" + String(min) + ":" + String(sec) + APM + "   " + String(month) + "/" + String(day) + "/" + String(year)
    return [display_time, hour_12, APM, hour_24, min, sec, day, month, year]
    }
	
	// MARK: event_data_segue variable
	var event_data_segue: [Any]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
	// Do any additional setup after loading the view.
        NewEventNameField.returnKeyType = .done
        NewEventNameField.delegate = self
        NewEventDescription.returnKeyType = .done
        NewEventDescription.delegate = self
        updateSaveButtonState()
		
		Call_API_Tone_Analyzer_Button.setTitle("Analyze Text - Ready", for: .normal)
		
	// Watson Tone Analyzer
        watson_tone_analyzer.serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"
    
    // MARK: Detecting Keyboard Activities
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

    guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    
 if (notification.name == UIResponder.keyboardWillShowNotification && NewEventDescription.isFirstResponder) || (notification.name == UIResponder.keyboardWillChangeFrameNotification && NewEventDescription.isFirstResponder){
    view.frame.origin.y = -keyboardRect.height
    } else {
    view.frame.origin.y = 0
    }}
    
// MARK: Clear the textview of the default text when selected
// Disable analyze button when editing
func textViewDidBeginEditing(_ textView: UITextView){
    if textView.text == "How are you feeling?"{
    	textView.text = ""
	}
	Auto_Manual_Button.isUserInteractionEnabled = false
    Call_API_Tone_Analyzer_Button.isUserInteractionEnabled = false
	Call_API_Tone_Analyzer_Button.setTitle("Cannot Analyze While Editing", for: .disabled)
    }
    
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if(text == "\n") {
        textView.resignFirstResponder()
        return false
    }
    return true
}

func textViewDidEndEditing(_ textView: UITextView) {
	if textView.text == ""{
    	textView.text = "How are you feeling?"
    }
    Auto_Manual_Button.isUserInteractionEnabled = true
	Call_API_Tone_Analyzer_Button.isUserInteractionEnabled = true
}

    override func viewDidAppear(_ animated: Bool) {
    memories_authenticate = false
    //saved_memory_success = true
    }

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
    
    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Cancelling Action, The Save Button Was not Pressed", log: OSLog.default,type: .debug)
        return
        }
        saved_memory_success = true
    
    let EventName = NewEventNameField.text ?? ""
    let EventPhoto = NewEventImage.image?.pngData()
    let EventDescription = NewEventDescription.text ?? ""
    let time_array = get_Event_Time()
    let EventTime_Display = time_array[0] // Array follows the structure: [display_time, hour_12, A/PM, Hour_24, Min, Sec, Day, Month, Year]
    let hour_12 = time_array[1]
    let A_PM = time_array[2]
    let hour_24 = time_array[3]
    let Minutes = time_array[4]
    let Seconds = time_array[5]
    let Day = time_array[6]
    let Month = time_array[7]
    let Year = time_array[8]
        
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
		
	// Segue data is in the following format:
		event_data_segue = [Year, Seconds, Month, Minutes, LOVE_HATE_VALUE, INTEREST_BORDEM_VALUE, hour_24, hour_12, HAPPY_SAD_VALUE, EventTime_Display, EventPhoto!, EventName, EventDescription, DOES_HAVE_PHOTO, Day, ANGER_FEAR_VALUE, A_PM]
		
//        event = Event(Detail_EventName: EventName, Detail_EventPhoto: EventPhoto, Detail_does_have_photo: DOES_HAVE_PHOTO, Detail_EventDescription: EventDescription, Detail_EventTime_Display: EventTime_Display as! String, Detail_EventDate_Compute: [EventDate_Compute], Detail_Happy_Sad_Value: Int(HAPPY_SAD_VALUE), Detail_Anger_fear_Value: Int(ANGER_FEAR_VALUE), Detail_Interest_bordem_Value: Int(INTEREST_BORDEM_VALUE), Detail_Love_hate_Value: Int(LOVE_HATE_VALUE))
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    saved_memory_success = false
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
