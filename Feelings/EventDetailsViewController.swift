//
//  EventDetailsViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-30.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var DetailEventName: UILabel!
    @IBOutlet weak var DetailEventImage: UIImageView!
    @IBOutlet weak var DetailEventDescription: UITextView!
    @IBOutlet weak var DetailEventTime: UILabel!
    
    
    @IBOutlet weak var Detail_Happy_Sad_Value: UILabel!
    @IBOutlet weak var Emoji_Happy_Sad: UILabel!
    
    
    var event: Event?
    
    func adjustUITextViewHeight(arg : UITextView){
    arg.translatesAutoresizingMaskIntoConstraints = true
    arg.sizeToFit()
    arg.isScrollEnabled = false
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let event = event {
        
        //This sets the scene up to display the correct content inside the array.
        DetailEventName.text = event.EventName
        if event.does_have_photo == true{
        DetailEventImage.image = event.EventPhoto
        } else {
        DetailEventImage.isHidden = true}
        DetailEventDescription.text = event.EventDescription
        Detail_Happy_Sad_Value.text = String(event.Happy_Sad_Value)
        DetailEventTime.text = event.EventTime
        }
        
        // Controlling Emojis
        //Happy / Sad
       
        if Detail_Happy_Sad_Value.text == "0" {
        Emoji_Happy_Sad.text = "😶"
        }
        else if Detail_Happy_Sad_Value.text == "3"{
        Emoji_Happy_Sad.text = "😁"
        }
        else if Detail_Happy_Sad_Value.text == "2"{
        Emoji_Happy_Sad.text = "😊"
        }
        else if Detail_Happy_Sad_Value.text == "1" {
        Emoji_Happy_Sad.text = "🙂"
        }
        else if Detail_Happy_Sad_Value.text == "-1"{
        Emoji_Happy_Sad.text = "😕"
        }
        else if Detail_Happy_Sad_Value.text == "-2"{
        Emoji_Happy_Sad.text = "☹️"
        }
        else if Detail_Happy_Sad_Value.text == "-3"{
        Emoji_Happy_Sad.text = "😭"
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Check this fucntion, the scenes are transiting but they are not loading the content from the Table View Cells
     //override func prepare(for segue: UIStoryboardSegue, sender: Any?){
// super.prepare(for: segue, sender: sender)
        
        //let EventName = DetailEventName.text ?? ""
        //let EventPhoto = DetailEventImage.image
  
       // event = Event(EventName: EventName, EventPhoto: EventPhoto)
   // }
    
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
