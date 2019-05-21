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

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Watson Tone Analyzer
        watson_tone_analyzer.serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"

//MARK: Initially updating time_specific arrays at launch
    //update_time()
//    func update_arrays_onload (days_range: [Int]) -> [Event]{
//    var return_list = [Event]()
//    for event in events{
//        if days_range.contains(event.EventDate_Compute[5] as! Int){
//            return_list.append(event)
//        }}
//        return return_list
//        }
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    memories_authenticate = true
    }

    override func viewWillAppear(_ animated: Bool) {
    // write function in data.swift to insert new events not already in the time specific arrays
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
