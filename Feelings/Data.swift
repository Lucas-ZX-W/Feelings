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

//MARK: Watson API

	let watson_tone_analyzer = ToneAnalyzer(version: "2.0.1", apiKey: "Nf_WkaaDfCwJH0yI3Wd4jb8MJpOTDYR5B_DOP88kQj7a")

	

//MARK: Functions

func get_happy_value () -> Int{
    var a = 0
    for e in events{
		a += (e.value(forKeyPath: "happy_sad_value") as? Int)!
    }
    return a
    }

func get_anger_value () -> Int{
    var a = 0
    for e in events{
    a += (e.value(forKeyPath: "anger_fear_value") as? Int)!
    }
    return a
    }

func get_interest_value () -> Int{
    var a = 0
    for e in events{
    a += (e.value(forKeyPath: "interest_bordem_value") as? Int)!
    }
    return a
    }

func get_love_value () -> Int{
    var a = 0
    for e in events{
    a += (e.value(forKeyPath: "love_hate_value") as? Int)!
    }
    return a
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
