//
//  Data.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-20.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log
import CoreData
import RestKit
import ToneAnalyzerV3

//MARK: Data Arrays and variables
var events: [NSManagedObject] = [] // Main memories array (All Time)
var events_7_days: [NSManagedObject] = []
var events_14_days: [NSManagedObject] = []
var events_30_days: [NSManagedObject] = []

var raw_total_happy_sad_val: Int = 0
var raw_total_anger_fear_val: Int = 0
var raw_total_confidence_inhibition_val: Int = 0
var raw_total_analytical_emotional_val: Int = 0
var all_time_array_length: Int = 0

//var avg_happy_sad_val: Double = 0
//var avg_anger_fear_val: Double = 0
//var avg_confidence_inhibition_val: Double = 0
//var avg_analytical_emotional_val: Double = 0
//var total_happy_val: Int = 0
//var total_sad_val: Int = 0
//var total_anger_val: Int = 0
//var total_fear_val: Int = 0
//var total_confidence_val: Int = 0
//var total_inhibition_val: Int = 0
//var total_analytical_val: Int = 0
//var total_emotional_val: Int = 0
//var all_time_array_length: Int = 0

//MARK: Corss app variables for operation
var memories_authenticate = true
var saved_memory_success = false

//MARK: Watson API
let watson_tone_analyzer = ToneAnalyzer(version: "2019-08-26", apiKey: "Nf_WkaaDfCwJH0yI3Wd4jb8MJpOTDYR5B_DOP88kQj7a") // For argument "version", use today's date for the most recent; Carthage version can be checked via the Swift SDK Github page

func parse_return_json_data(input: ToneAnalysis) -> [Int] {
	var emotions_list: [(String, Double)] = []
	// Return values
	var happy_sad_value: Int = 0
	var anger_fear_value: Int = 0
	var confidence_inhibition_value: Int = 0
	var analytical_emotional_value: Int = 0

	// Compute value directly from API
	var api_Anger: Double = 0
	var api_Fear: Double = 0
	var api_Joy: Double = 0
	var api_Sadness: Double = 0
	var api_Analytical: Double = 0
	var api_Confident: Double = 0
	var api_Tentative: Double = 0

//	do {
//		if let json = try JSONSerialization.jsonObject(with: input, options: []) as? [String: Any] {
//
//			if let document_tone: Dictionary<String, Array<Dictionary<String, Any>>> = json["document_tone"] as! Dictionary<String, Array<Dictionary<String, Any>>> {
//
//				if let document_tones_list = document_tone["tones"]{
//					for emotion in document_tones_list{
//						let tuple = (emotion["tone_name"], emotion["score"])
//						emotions_list.append(tuple as! (String?, Double?))
//					}
//				}
//			}
//		}
//	} catch let err {
//		print(err.localizedDescription)
//	}

	let document_tone = input.documentTone
	let document_tones_list = document_tone.tones
	for emotion in document_tones_list!{
		let tuple = (emotion.toneID, emotion.score)
		emotions_list.append(tuple)
	}

	// Parse through emotions_list for Int values of api_direct values
	for set in emotions_list{
		switch set.0 {
			case "anger": api_Anger = set.1
			case "fear": api_Fear = set.1
			case "joy": api_Joy = set.1
			case "sadness": api_Sadness = set.1
			case "analytical": api_Analytical = set.1
			case "confident": api_Confident = set.1
			case "tentative": api_Tentative = set.1
			default: ()
		}
	}
	// Compute api_direct values to final return values
	switch api_Anger{
		case 0.9...1.0: anger_fear_value = 3
		case 0.73..<0.9: anger_fear_value = 2
		case 0.5..<0.73: anger_fear_value = 1
		default: ()
	}
	switch api_Fear{
		case 0.9...1.0: anger_fear_value = -3
		case 0.73..<0.9: anger_fear_value = -2
		case 0.5..<0.73: anger_fear_value = -1
		default: ()
	}
	switch api_Joy{
		case 0.9...1.0: happy_sad_value = 3
		case 0.73..<0.9: happy_sad_value = 2
		case 0.5..<0.73: happy_sad_value = 1
		default: ()
	}
	switch api_Sadness{
		case 0.9...1.0: happy_sad_value = -3
		case 0.73..<0.9: happy_sad_value = -2
		case 0.5..<0.73: happy_sad_value = -1
		default: ()
	}
	switch api_Confident{
		case 0.9...1.0: confidence_inhibition_value = 3
		case 0.73..<0.9: confidence_inhibition_value = 2
		case 0.5..<0.73: confidence_inhibition_value = 1
		default: ()
	}
	switch api_Tentative{
		case 0.9...1.0: confidence_inhibition_value = -3
		case 0.73..<0.9: confidence_inhibition_value = -2
		case 0.5..<0.73: confidence_inhibition_value = -1
		default: ()
	}
	switch api_Analytical{
		case 0.9...1.0: analytical_emotional_value = 3
		case 0.73..<0.9: analytical_emotional_value = 2
		case 0.5..<0.73: analytical_emotional_value = 1
		default: ()
	}
	if api_Analytical < 0.5 && analytical_emotional_value == 0{
		if (abs(happy_sad_value) == 3 && abs(anger_fear_value) == 3) || (abs(happy_sad_value) == 3 && abs(confidence_inhibition_value) == 3) || (abs(anger_fear_value) == 3 && abs(confidence_inhibition_value) == 3){analytical_emotional_value = -3}
		else if (abs(happy_sad_value) == 3 || abs(confidence_inhibition_value) == 3 || abs(anger_fear_value) == 3) || (abs(happy_sad_value) == 2 && abs(anger_fear_value) == 2) || (abs(happy_sad_value) == 2 && abs(confidence_inhibition_value) == 2) || (abs(anger_fear_value) == 2 && abs(confidence_inhibition_value) == 2){analytical_emotional_value = -2}
		else if (abs(happy_sad_value) == 2 || abs(confidence_inhibition_value) == 2 || abs(anger_fear_value) == 2) || (abs(happy_sad_value) == 1 && abs(anger_fear_value) == 1) || (abs(happy_sad_value) == 1 && abs(confidence_inhibition_value) == 1) || (abs(anger_fear_value) == 1 && abs(confidence_inhibition_value) == 1){analytical_emotional_value = -1}
	}
	// Final return
	return [happy_sad_value, anger_fear_value, confidence_inhibition_value, analytical_emotional_value]
}

//MARK: Functions
//FIXME: consider condensing these 4 functions into one; add another one / two for computing the values of just the individual emotions
func get_happy_sad_value (array_name: String) -> Int{
	var array: [NSManagedObject]? = nil
	switch array_name{
		case "all time": array = events
		case "7 days": array = events_7_days
		case "14 days": array = events_14_days
		case "30 days": array = events_30_days
		default: ()
	}
    var a = 0
    for e in array!{
		a += (e.value(forKeyPath: "happy_sad_value") as? Int)!
    }
    return a
    }

func get_anger_fear_value (array_name: String) -> Int{
	var array: [NSManagedObject]? = nil
	switch array_name{
		case "all time": array = events
		case "7 days": array = events_7_days
		case "14 days": array = events_14_days
		case "30 days": array = events_30_days
		default: ()
	}
    var a = 0
    for e in array!{
    a += (e.value(forKeyPath: "anger_fear_value") as? Int)!
    }
    return a
    }

func get_confidence_inhibition_value (array_name: String) -> Int{
	var array: [NSManagedObject]? = nil
	switch array_name{
		case "all time": array = events
		case "7 days": array = events_7_days
		case "14 days": array = events_14_days
		case "30 days": array = events_30_days
		default: ()
	}
    var a = 0
    for e in array!{
    a += (e.value(forKeyPath: "confidence_inhibition_value") as? Int)!
    }
    return a
    }

func get_analytical_emotional_value (array_name: String) -> Int{
	var array: [NSManagedObject]? = nil
	switch array_name{
		case "all time": array = events
		case "7 days": array = events_7_days
		case "14 days": array = events_14_days
		case "30 days": array = events_30_days
		default: ()
	}
    var a = 0
    for e in array!{
    a += (e.value(forKeyPath: "analytical_emotional_value") as? Int)!
    }
    return a
    }

/** initial function to construct the time-specific arrays at launch of app */
func initial_most_recent_to_past(until: Int) {
	var return_array: [NSManagedObject]? = nil
	switch until{
		case 7: return_array = events_7_days
		case 14: return_array = events_14_days
		case 30: return_array = events_30_days
		default: ()
	}
	
	let now = Date()
	let bottom_time = (Calendar.current.date(byAdding: DateComponents(day:-until), to: Date()))!
	let range = bottom_time...now

	for event in events{
		if range.contains(event.value(forKeyPath: "eventdate") as! Date){
			return_array!.append(event)
		} else { break }
	}
	return_array!.sort(by: {($0.value(forKeyPath: "eventdate") as! Date) > ($1.value(forKeyPath: "eventdate") as! Date)})
	//return_array.sort(by:>)
}

/** post initial function to add new events to the existing time-specific arrays; NOTE this may not need to be called since the saved event can simply be inserted after it is saved */
func modify_most_recent_to_past(until: Int) {
	var return_array: [NSManagedObject]? = nil
	switch until{
		case 7: return_array = events_7_days
		case 14: return_array = events_14_days
		case 30: return_array = events_30_days
		default: ()
	}
	
	let now = Date()
	let bottom_time = (Calendar.current.date(byAdding: DateComponents(day:-until), to: Date()))!
	let range = bottom_time...now

	for event in events{
		if range.contains(event.value(forKeyPath: "eventdate") as! Date){
			if return_array!.contains(event) == false{
			return_array!.insert(event, at: 0)
			}
		} else { break }
	}
	//return_array!.sort(by: {($0.value(forKeyPath: "eventdate") as! Date) > ($1.value(forKeyPath: "eventdate") as! Date)})
	//return_array.sort(by:>)
}

func remove_from_time_specific(event: NSManagedObject, time_specific_array_days: Int){
	var return_array: [NSManagedObject]? = nil
	switch time_specific_array_days{
		case 7: return_array = events_7_days
		case 14: return_array = events_14_days
		case 30: return_array = events_30_days
		default: ()
	}
	return_array! = return_array!.filter {$0 != event}
}

//class Event  {
//
//    var EventName: String
//    var EventPhoto: UIImage?
//    var does_have_photo: Bool
//    var EventDescription: String
//    var EventTime_Display: String
//    var EventDate_Compute: [Any]
//
//    var Happy_Sad_Value: Int
//    var Anger_fear_Value: Int
//    var Interest_bordem_Value: Int
//    var Love_hate_Value: Int
//
//    init?(Detail_EventName: String, Detail_EventPhoto: UIImage?, Detail_does_have_photo: Bool, Detail_EventDescription: String, Detail_EventTime_Display: String, Detail_EventDate_Compute: [Any],Detail_Happy_Sad_Value: Int, Detail_Anger_fear_Value: Int, Detail_Interest_bordem_Value: Int, Detail_Love_hate_Value: Int) {
//
//
//
//    // Initilization of the values
//        self.EventName = Detail_EventName
//        self.EventPhoto = Detail_EventPhoto
//        self.does_have_photo = Detail_does_have_photo
//        self.EventDescription = Detail_EventDescription
//        self.EventTime_Display = Detail_EventTime_Display
//        self.Happy_Sad_Value = Detail_Happy_Sad_Value
//        self.Anger_fear_Value = Detail_Anger_fear_Value
//        self.Interest_bordem_Value = Detail_Interest_bordem_Value
//        self.Love_hate_Value = Detail_Love_hate_Value
//        self.EventDate_Compute = Detail_EventDate_Compute
//
//        // If some of the values are left blank, this will return nil to signal the problem
//
//    guard !EventName.isEmpty else {
//            return nil
//        }
//    }
//    }
