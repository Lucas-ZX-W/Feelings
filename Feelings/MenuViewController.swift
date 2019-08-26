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
	
	@IBOutlet weak var main_segment_bar_outlet: UISegmentedControl!
	@IBAction func main_segment_bar(_ sender: UISegmentedControl) {
	
	
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Watson Tone Analyzer
        watson_tone_analyzer.serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"

		//MARK: Initially creating time_specific arrays at launch & filling in the total emotional values at launch
		initial_most_recent_to_past(until: 7)
		initial_most_recent_to_past(until: 14)
		initial_most_recent_to_past(until: 30)
		
		raw_total_happy_sad_val = get_happy_sad_value(array_name: "all time")
		raw_total_anger_fear_val = get_anger_fear_value(array_name: "all time")
		raw_total_confidence_inhibition_val = get_confidence_inhibition_value(array_name: "all time")
		raw_total_analytical_emotional_val = get_analytical_emotional_value(array_name: "all time")
		all_time_array_length = events.count
		
		// initially loading the values
    }
    
    override func viewDidAppear(_ animated: Bool) {
		
		
    }

    override func viewWillAppear(_ animated: Bool) {
    // write function in data.swift to insert new events not already in the time specific arrays; may not need this
        memories_authenticate = true
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    func update_values_on_main(time_period: Int){
		
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
