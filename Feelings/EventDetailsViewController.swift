//
//  EventDetailsViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-30.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log
import CoreData

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var DetailEventName: UILabel!
    @IBOutlet weak var DetailEventImage: UIImageView!
    @IBOutlet weak var DetailEventDescription: UITextView!
    @IBOutlet weak var DetailEventTime: UILabel!
    
    
    @IBOutlet weak var Detail_Happy_Sad_Value: UILabel!
    @IBOutlet weak var Emoji_Happy_Sad: UILabel!
    @IBOutlet weak var Detail_Anger_Fear_Value: UILabel!
    @IBOutlet weak var Emoji_Anger_Fear: UILabel!
    @IBOutlet weak var Detail_Confidence_Inhibition_Value: UILabel!
    @IBOutlet weak var Emoji_Confidence_Inhibition: UILabel!
    @IBOutlet weak var Detail_Analytical_Emotional_Value: UILabel!
    @IBOutlet weak var Emoji_Analytical_Emotional: UILabel!
    
    
    var event: NSManagedObject?
    
    func adjustUITextViewHeight(arg : UITextView){
    arg.translatesAutoresizingMaskIntoConstraints = true
    arg.sizeToFit()
    arg.isScrollEnabled = false
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
		
        if let event = event {
        
        //This sets the scene up to display the correct content inside the array.
        DetailEventName.text = event.value(forKeyPath: "eventname") as? String
        if event.value(forKeyPath: "does_have_photo") as? Bool == true{
        DetailEventImage.image = UIImage(data:((event.value(forKeyPath: "eventphoto") as? Data)!),scale:1.0)
        } else {
        DetailEventImage.isHidden = true}
        DetailEventDescription.text = event.value(forKeyPath: "eventdescription") as? String
        DetailEventTime.text = event.value(forKeyPath: "eventtime_display") as? String

        Detail_Happy_Sad_Value.text = String((event.value(forKeyPath: "happy_sad_value") as? Int)!)
        Detail_Anger_Fear_Value.text = String((event.value(forKeyPath: "anger_fear_value") as? Int)!)
        Detail_Confidence_Inhibition_Value.text = String((event.value(forKeyPath: "confidence_inhibition_value") as? Int)!)
        Detail_Analytical_Emotional_Value.text = String((event.value(forKeyPath: "analytical_emotional_value") as? Int)!)
        }
        
        // MARK: Controlling Emojis
        //Happy / Sad
		switch event?.value(forKeyPath: "happy_sad_value") as! Int {
			case 0: Emoji_Happy_Sad.text = "😶"
			case 3: Emoji_Happy_Sad.text = "😁"
			case 2: Emoji_Happy_Sad.text = "😊"
			case 1: Emoji_Happy_Sad.text = "🙂"
			case -1: Emoji_Happy_Sad.text = "😕"
			case -2: Emoji_Happy_Sad.text = "☹️"
			case -3: Emoji_Happy_Sad.text = "😭"
			default: Emoji_Happy_Sad.text = "nil"
		}
       
		//Anger / Fear
		switch event?.value(forKeyPath: "anger_fear_value") as! Int{
			case 0: Emoji_Happy_Sad.text = "😶"
			case 3: Emoji_Anger_Fear.text = "😡"
			case 2: Emoji_Anger_Fear.text = "😤"
			case 1: Emoji_Anger_Fear.text = "😠"
			case -1: Emoji_Anger_Fear.text = "😨"
			case -2: Emoji_Anger_Fear.text = "😰"
			case -3: Emoji_Anger_Fear.text = "😱"
			default: Emoji_Anger_Fear.text = "nil"
		}
    
		// Interest / Bordem
		switch event?.value(forKeyPath: "confidence_inhibition_value") as! Int{
			case 0: Emoji_Confidence_Inhibition.text = "😶"
			case 3: Emoji_Confidence_Inhibition.text = "😎"
			case 2: Emoji_Confidence_Inhibition.text = "😉"
			case 1: Emoji_Confidence_Inhibition.text = "😏"
			case -1: Emoji_Confidence_Inhibition.text = "😐"
			case -2: Emoji_Confidence_Inhibition.text = "😒"
			case -3: Emoji_Confidence_Inhibition.text = "😓"
			default: Emoji_Confidence_Inhibition.text = "nil"
		}
    
		// Love / Hate
		switch event?.value(forKeyPath: "analytical_emotional_value") as! Int{
			case 0: Emoji_Analytical_Emotional.text = "😶"
			case 3: Emoji_Analytical_Emotional.text = "🤓"
			case 2: Emoji_Analytical_Emotional.text = "🧐"
			case 1: Emoji_Analytical_Emotional.text = "🤨"
			case -1: Emoji_Analytical_Emotional.text = "😛"
			case -2: Emoji_Analytical_Emotional.text = "😝"
			case -3: Emoji_Analytical_Emotional.text = "🤪"
			default: Emoji_Analytical_Emotional.text = "nil"
			}
    }

    override func viewDidAppear(_ animated: Bool) {
    memories_authenticate = false
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
