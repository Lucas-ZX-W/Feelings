//
//  MenuViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-20.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log
import CoreData

class MenuViewController: UIViewController {

	@IBOutlet weak var main_happiness_sadness_emoji: UILabel!
	@IBOutlet weak var main_anger_fear_emoji: UILabel!
	@IBOutlet weak var main_confidence_inhibition_emoji: UILabel!
	@IBOutlet weak var main_analytical_emotional_emoji: UILabel!
	
	@IBOutlet weak var main_happiness_sadness_string: UILabel!
	@IBOutlet weak var main_anger_fear_string: UILabel!
	@IBOutlet weak var main_confidence_inhibition_string: UILabel!
	@IBOutlet weak var main_analytical_emotional_string: UILabel!
	
	@IBOutlet weak var total_events_string: UILabel!
	
	var curr_selected_time_period: String = "7 days"
	@IBOutlet weak var main_segment_bar_outlet: UISegmentedControl!
	@IBAction func main_segment_bar(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
			case 0: curr_selected_time_period = "7 days"
			case 1: curr_selected_time_period = "14 days"
			case 2: curr_selected_time_period = "30 days"
			case 3: curr_selected_time_period = "all time"
			default: ()
		}
		update_values_on_main_avg(time_period: curr_selected_time_period) // first function needs to be completed before the second, might need queues to regulate
		update_values_on_main_UI(time_period: curr_selected_time_period)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // MARK: Core Data Fetch (initial on launch) for main events array:
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memory")
		// Request the NSManagedObjects to be fetched in decending date order
		let dateSort = NSSortDescriptor(key: "eventdate", ascending: false)
		fetchRequest.sortDescriptors = [dateSort]
		
		do {
			events = try managedContext.fetch(fetchRequest)
	  	} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
	  	}
		
        // Watson Tone Analyzer
        watson_tone_analyzer.serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"

		//MARK: Initially creating time_specific arrays at launch & filling in the total emotional values at launch
		initial_most_recent_to_past(until: 7)
		initial_most_recent_to_past(until: 14)
		initial_most_recent_to_past(until: 30)
		
		raw_total_happy_sad_val = get_raw_emotions_value(array_name: "all time", KeyPath: "happy_sad_value")
		raw_total_anger_fear_val = get_raw_emotions_value(array_name: "all time", KeyPath: "anger_fear_value")
		raw_total_confidence_inhibition_val = get_raw_emotions_value(array_name: "all time", KeyPath: "confidence_inhibition_value")
		raw_total_analytical_emotional_val = get_raw_emotions_value(array_name: "all time", KeyPath: "analytical_emotional_value")
		all_time_array_length = events.count
		
		// initially loading the values
		update_values_on_main_avg(time_period: curr_selected_time_period)
		update_values_on_main_UI(time_period: curr_selected_time_period)
    }
    
    override func viewDidAppear(_ animated: Bool) {
		
    }

    override func viewWillAppear(_ animated: Bool) {
    // write function in data.swift to insert new events not already in the time specific arrays; may not need this
        memories_authenticate = true
        update_values_on_main_avg(time_period: curr_selected_time_period)
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	// updates the UI and the values (total, not avg) of the main menu
    func update_values_on_main_UI(time_period: String){
		// divide raw total value by the number of events to determine the value used by the emoji in menu, have to half the value ranges for emotions on menu; 0-0.5 = 1, 0.5-1 = 2, 1-1.5 = 3 same for negative values
		var value_happy_sad: Int = 0
		var value_anger_fear: Int = 0
		var value_confidence_inhibition: Int = 0
		var value_analytical_emotional: Int = 0
		var array_length: Int = 0
		if time_period == "all time"{
			value_happy_sad = raw_total_happy_sad_val
			value_anger_fear = raw_total_anger_fear_val
			value_confidence_inhibition = raw_total_confidence_inhibition_val
			value_analytical_emotional = raw_total_analytical_emotional_val
			array_length = all_time_array_length
		} else {
			value_happy_sad = get_raw_emotions_value(array_name: time_period, KeyPath: "happy_sad_value")
			value_anger_fear = get_raw_emotions_value(array_name: time_period, KeyPath: "anger_fear_value")
			value_confidence_inhibition = get_raw_emotions_value(array_name: time_period, KeyPath: "confidence_inhibition_value")
			value_analytical_emotional = get_raw_emotions_value(array_name: time_period, KeyPath: "analytical_emotional_value")
			switch time_period{
				case "7 days": array_length = events_7_days.count
				case "14 days": array_length = events_14_days.count
				case "30 days": array_length = events_30_days.count
				default: ()
			}
		}
		// then apply the values to the UI elements
		if array_length == 0{
			total_events_string.text = "No Memories saved for \(time_period)" // wording could be better?
			main_happiness_sadness_string.text = "N/A"
			main_happiness_sadness_string.text = "N/A"
			main_confidence_inhibition_string.text = "N/A"
			main_analytical_emotional_string.text = "N/A"
			main_happiness_sadness_emoji.text = "X"
			main_anger_fear_emoji.text = "X"
			main_confidence_inhibition_emoji.text = "X"
			main_analytical_emotional_string.text = "X"
		} else {
			total_events_string.text = "\(array_length) Memories in the past \(time_period)"
			let happy_sad_involved: Int = get_num_of_involved_events(array_name: time_period, KeyPath: "happy_sad_value")
			let anger_fear_involved: Int = get_num_of_involved_events(array_name: time_period, KeyPath: "anger_fear_value")
			let confidence_inhibition_involved: Int = get_num_of_involved_events(array_name: time_period, KeyPath: "confidence_inhibition_value")
			let analytical_emotional_involved: Int = get_num_of_involved_events(array_name: time_period, KeyPath: "analytical_emotional_value")
			if happy_sad_involved == 0{
				main_happiness_sadness_string.text = "0 Memories"
				main_happiness_sadness_emoji.text = "X"
			} else { // older version : "\(raw_total_happy_sad_val) for \(happy_sad_involved) Memories"
				main_happiness_sadness_string.text = "From \(happy_sad_involved) Memories"
			}
			if anger_fear_involved == 0{
				main_anger_fear_string.text = "0 Memories"
				main_anger_fear_emoji.text = "X"
			} else {
				main_anger_fear_string.text = "From \(anger_fear_involved) Memories"
			}
			if confidence_inhibition_involved == 0{
				main_confidence_inhibition_string.text = "0 Memories"
				main_confidence_inhibition_emoji.text = "X"
			} else {
				main_confidence_inhibition_string.text = "From \(confidence_inhibition_involved) Memories"
			}
			if analytical_emotional_involved == 0{
				main_analytical_emotional_string.text = "0 Memories"
				main_analytical_emotional_emoji.text = "X"
			} else {
				main_analytical_emotional_string.text = "From \(analytical_emotional_involved) Memories"
			}
		}
	}
	// updates the values of avg used by the main emojis (No UI modification)
	func update_values_on_main_avg(time_period: String){
		var time_array: [NSManagedObject] = events_7_days
		switch time_period{
			case "7 days": time_array = events_7_days
			case " 14 days": time_array = events_14_days
			case "30 days": time_array = events_30_days
			case "all time": time_array = events
			default: ()
		}
		if time_array.count != 0{
			avg_happy_sad_val = Double(raw_total_happy_sad_val / time_array.count)
			avg_anger_fear_val = Double(raw_total_anger_fear_val / time_array.count)
			avg_confidence_inhibition_val = Double(raw_total_confidence_inhibition_val / time_array.count)
			avg_analytical_emotional_val = Double(raw_total_analytical_emotional_val / time_array.count)
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

//update_time()
//    func update_arrays_onload (days_range: [Int]) -> [Event]{
//    var return_list = [Event]()
//    for event in events{
//        if days_range.contains(event.EventDate_Compute[5] as! Int){
//            return_list.append(event)
//        }}
//        return return_list
//        }
