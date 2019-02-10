//
//  EventTableViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-21.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log

var events = [Event]()

class EventTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Adding the edit button to the top navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
   
    
        // Don't forget to call the fucking Function you dumbass!
      //loadSampleEvent()
    
    }
   
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "EventTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell else {fatalError("The cell is not an instance of the ViewCell class")}
        
      let event = events[indexPath.row]
        
        // Configure the cell...

        cell.EventNameLabel.text = event.EventName
        if event.does_have_photo == true {
        cell.DefaultEventPhoto.image = event.EventPhoto}
        cell.Cell_EventTime.text = event.EventTime
        // Functions to control the cell view emojis:
        
        if event.Happy_Sad_Value == 0 {
        cell.Cell_Happy_Sad_Emoji.isHidden = true
        //cell.Cell_Happy_Sad_Emoji.text = "😶"
        }
        else if event.Happy_Sad_Value == 3{
        cell.Cell_Happy_Sad_Emoji.text = "😁"
        }
        else if event.Happy_Sad_Value == 2{
        cell.Cell_Happy_Sad_Emoji.text = "😊"
        }
        else if event.Happy_Sad_Value == 1 {
        cell.Cell_Happy_Sad_Emoji.text = "🙂"
        }
        else if event.Happy_Sad_Value == -1{
        cell.Cell_Happy_Sad_Emoji.text = "😕"
        }
        else if event.Happy_Sad_Value == -2{
        cell.Cell_Happy_Sad_Emoji.text = "☹️"
        }
        else if event.Happy_Sad_Value == -3{
        cell.Cell_Happy_Sad_Emoji.text = "😭"
        }
    
        //Hide the default photo if the photo is not changed
        
//        if event.does_have_photo == false{
//        cell.DefaultEventPhoto.isHidden = true
//        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
       
        switch(segue.identifier ?? "") {
        
        case "AddNewItem":
            os_log("Adding a new Event.", log: OSLog.default, type: .debug)

        case "ShowEventDetail":
            guard let eventDetailsViewController = segue.destination as?
                EventDetailsViewController else {
                    fatalError("Unexpeceted Destination: \(segue.destination)")
            }
            
            guard let selectedeventcell = sender as? EventTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
                //fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedeventcell) else {fatalError("The Selected Cell is not being displayed by the table")
            }
            let selectedevent = events[indexPath.row]
            eventDetailsViewController.event = selectedevent
            
            //case "EditEvent":
           // guard let editEventsViewController = segue.destination as?
          //      NewEventViewController else {
          //          fatalError("Unexpeceted Destination: \(segue.destination)")
          //  }
            
            // Needs to change sender to the button
            
          //  guard let selectedeventcell = sender as? EventTableViewCell else {
          //      fatalError("Unexpected sender: \(sender)")
                
          //  }
          
           // guard let indexPath = tableView.indexPath(for: selectedeventcell) else /{fatalError("The Selected Cell is not being displayed by the table")
         //   }
         //   let selectedevent = events[indexPath.row]
        //    editEventsViewController.event = selectedevent
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            //fatalError("Unexpected Segue Identifier; \(segue.identifier)")

        }
        }
    // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
 @IBAction func unwindToEventList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as?
            NewEventViewController, let event = sourceViewController.event{
    
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
            events[selectedIndexPath.row] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }  else  {
           //Adding a new event instead of editing it.
                let newIndexPath = IndexPath(row: events.count, section: 0)
            
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            }
            //let newIndexPath = IndexPath(row: events.count, section: 0)

        //events.append(event)
            //tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        }
    
    
    
    
    
//    private func loadSampleEvent() {
//
//        let EventPhoto1 = UIImage(named: "event1")
//        //let EventPhoto2 = UIImage(named: "event2")
//        //let EventPhoto3 = UIImage(named: "event3")
//
//        guard let event1 = Event(Detail_EventName: "Sad", Detail_EventPhoto: EventPhoto1, Detail_does_have_photo: true, Detail_EventDescription: "I just hate life u know what I'm saying" ,Detail_Happy_Sad_Value: 0, Detail_Anger_fear_Value: 0, Detail_Interest_bordem_Value: 0, Detail_Love_hate_Value: 0)
//            else {
//                fatalError("Unable to Load Event")
//
//        }

//        guard let event2 = Event(EventName: "Depressing", EventPhoto: EventPhoto2, Detail_Happy_Sad_Value: 0)
//            else {
//                fatalError("Unable to Load Event")
//
//        }
//
//        guard let event3 = Event(EventName: "NOOO", EventPhoto: EventPhoto3, Detail_Happy_Sad_Value: 0)
//            else {
//                fatalError("Unable to Load Event")
//
//        }

        //events += [event1]

}
