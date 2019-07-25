//
//  EventTableViewController.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-21.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log
import LocalAuthentication
import CoreData
import AVFoundation // Old style vibration

//MARK: Data Arrays
var events: [NSManagedObject] = [] // Main memories array (All Time)
//FIXME: Configure all other arrays and their sorting functions for NSmanagedObject
var events_7_days: [NSManagedObject] = []
var events_14_days: [NSManagedObject] = []
var events_30_days: [NSManagedObject] = []

//MARK: Corss app variables
var memories_authenticate = true
var saved_memory_success = false

class EventTableViewController: UITableViewController{
    
    @IBOutlet var Memories_Table_View: UITableView!
    @IBOutlet weak var Add_Memory_Button: UIBarButtonItem!
    
    let haptic_notification = UINotificationFeedbackGenerator()
    var alert = UIAlertController()
	
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
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = Memories_Table_View.bounds
        visualEffectView.tag = 1
        Memories_Table_View.addSubview(visualEffectView)
    }
    
    // MARK: Local authentication
    func authentication(){
        let context = LAContext()
        var error: NSError?
        
        // check if ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            let reason = "Authenticate to Access Memories"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in

        if success {
        // Move to the main thread because a state update triggers UI changes.
        DispatchQueue.main.async { [unowned self] in
            self.Memories_Table_View.isUserInteractionEnabled = true
            self.Add_Memory_Button.isEnabled = true
            self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = true})
            //self.state = .loggedin
            //self.showAlertController("Biometrics Authentication Succeeded")
            }
        } else {
        //print(error?.localizedDescription ?? "Failed to authenticate")
        //self.showAlertController("Authentication Failed")
//        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
//            self.navigationController?.pushViewController(homeView, animated: true)

		let reason = "Authenticate to Access Memories using password"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

        if success {
        // Move to the main thread because a state update triggers UI changes.
        DispatchQueue.main.async { [unowned self] in
            self.Memories_Table_View.isUserInteractionEnabled = true
            self.Add_Memory_Button.isEnabled = true
            self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = true})
            //self.state = .loggedin
            //self.showAlertController("Biometrics Authentication Succeeded")
            }
        } else {
        //print(error?.localizedDescription ?? "Failed to authenticate")
        self.showAlertController("Authentication Failed")
        //_ = self.navigationController?.popViewController(animated: true)
	//        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
	//            self.navigationController?.pushViewController(homeView, animated: true)
        }}
        }}
    } else {
    //showAlertController("Biometrics not available, using password")
        let reason = "Authenticate to Access Memories using password"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

        if success {
        // Move to the main thread because a state update triggers UI changes.
        DispatchQueue.main.async { [unowned self] in
            self.Memories_Table_View.isUserInteractionEnabled = true
            self.Add_Memory_Button.isEnabled = true
            self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = true})
            //self.state = .loggedin
            //self.showAlertController("Biometrics Authentication Succeeded")
            }
        } else {
        //print(error?.localizedDescription ?? "Failed to authenticate")
        self.showAlertController("Authentication Failed")
		//_ = self.navigationController?.popViewController(animated: true)
//        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
//            self.navigationController?.pushViewController(homeView, animated: true)
        }}
    }}
	
// Alert controller template
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        // Deselects the selected cell when returning
        if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: true)}
		
        // MARK: Core Data Fetch:
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
		
        if memories_authenticate == true{
        Memories_Table_View.isUserInteractionEnabled = false
        self.Add_Memory_Button.isEnabled = false
        self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = false})
        authentication()}
    }
    // End of authentication
    
    //MARK:  Confirmation message and taptic for saving new event
    override func viewDidAppear(_ animated: Bool) {
        if saved_memory_success == true{
        //self.showAlertController("Memory Saved")
        self.alert = UIAlertController(title: nil, message: "Memory Saved", preferredStyle: .alert)
        self.present(self.alert, animated: true, completion: nil)
        haptic_notification.notificationOccurred(.success)
        saved_memory_success = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
        self.dismiss(animated: true, completion: nil)}
        }
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
        
        // MARK: Configure the cell...

        cell.EventNameLabel.text = event.value(forKeyPath: "eventname") as? String
        if event.value(forKeyPath: "does_have_photo") as? Bool == true {
			cell.DefaultEventPhoto.image = UIImage(data:((event.value(forKeyPath: "eventphoto") as? Data)!),scale:1.0)
		}
        cell.Cell_EventTime.text = event.value(forKeyPath: "eventtime_display") as? String
        
        // Functions to control the cell view emojis:
        // Happy / Sad
        switch event.value(forKeyPath: "happy_sad_value") as? Int {
        case 0:
        //cell.Cell_Happy_Sad_Emoji.isHidden = true
        cell.Cell_Happy_Sad_Emoji.text = "😶"
        case 3:
        cell.Cell_Happy_Sad_Emoji.text = "😁"
        case 2:
        cell.Cell_Happy_Sad_Emoji.text = "😊"
        case 1:
        cell.Cell_Happy_Sad_Emoji.text = "🙂"
        case -1:
        cell.Cell_Happy_Sad_Emoji.text = "😕"
        case -2:
        cell.Cell_Happy_Sad_Emoji.text = "☹️"
        case -3:
        cell.Cell_Happy_Sad_Emoji.text = "😭"
        default:
        cell.Cell_Happy_Sad_Emoji.text = "nil"
        }
    
        //Anger / Fear
       switch event.value(forKeyPath: "anger_fear_value") as? Int{
       case 0:
       cell.Cell_Anger_Fear_Emoji.text = "😶"
       case 3:
       cell.Cell_Anger_Fear_Emoji.text = "😡"
       case 2:
       cell.Cell_Anger_Fear_Emoji.text = "😤"
       case 1:
       cell.Cell_Anger_Fear_Emoji.text = "😠"
       case -1:
       cell.Cell_Anger_Fear_Emoji.text = "😨"
       case -2:
       cell.Cell_Anger_Fear_Emoji.text = "😰"
       case -3:
       cell.Cell_Anger_Fear_Emoji.text = "😱"
       default:
       cell.Cell_Anger_Fear_Emoji.text = "nil"
        }
        
        switch event.value(forKeyPath: "confidence_inhibition_value") as? Int{
        case 0:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😶"
        case 3:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😎"
        case 2:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😉"
        case 1:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😏"
        case -1:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😐"
        case -2:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😒"
        case -3:
        cell.Cell_Confidence_Inhibition_Emoji.text = "😓"
        default:
        cell.Cell_Confidence_Inhibition_Emoji.text = "nil"
        }
        
        switch event.value(forKeyPath: "analytical_emotional_value") as? Int{
        case 0:
        cell.Cell_Analytical_Emotional_Emoji.text = "😶"
        case 3:
        cell.Cell_Analytical_Emotional_Emoji.text = "🤓"
        case 2:
        cell.Cell_Analytical_Emotional_Emoji.text = "🧐"
        case 1:
        cell.Cell_Analytical_Emotional_Emoji.text = "🤨"
        case -1:
        cell.Cell_Analytical_Emotional_Emoji.text = "😛"
        case -2:
        cell.Cell_Analytical_Emotional_Emoji.text = "😝"
        case -3:
        cell.Cell_Analytical_Emotional_Emoji.text = "🤪"
        default:
        cell.Cell_Analytical_Emotional_Emoji.text = "nil"
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
            let event_managed_object = events[indexPath.row]
            let event_date = event_managed_object.value(forKeyPath: "eventdate")
            events.remove(at: indexPath.row)
            //events.remove(at: abs(indexPath.row - events.count) - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Remove the NSManagedObject from the CoreData stack
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
			let managedContext = appDelegate.persistentContainer.viewContext
			let entity = NSEntityDescription.entity(forEntityName: "Memory", in: managedContext)!
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memory")
			request.predicate = NSPredicate(format:"eventdate = %@", event_date as! CVarArg/**"Remove"*/)
			request.entity = entity
			//let pred = NSPredicate(format: "name = %@", event_name as! CVarArg)
			//request.predicate = pred
			do {
				if let result: [NSManagedObject]? = try managedContext.fetch(request) as! [NSManagedObject]{
					for object in result!{
						if object == event_managed_object{
							managedContext.delete(object)
						}
					}
					try managedContext.save()
				}
				remove_from_time_specific(event: event_managed_object, time_specific_array_days: 7)
				remove_from_time_specific(event: event_managed_object, time_specific_array_days: 14)
				remove_from_time_specific(event: event_managed_object, time_specific_array_days: 30)
			} catch {}
        }
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
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
            return //os_log("Adding a new Event.", log: OSLog.default, type: .debug)

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
            //let selectedevent = events[abs(indexPath.row - events.count) - 1]
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
	// CoreData setup:
	guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
	
	let managedContext = appDelegate.persistentContainer.viewContext
	
	let entity = NSEntityDescription.entity(forEntityName: "Memory", in: managedContext)!
	
  	let memory = NSManagedObject(entity: entity, insertInto: managedContext)
	// End of Core Data Setup
	
        if let sourceViewController = sender.source as?
            NewEventViewController, let event_from_segue = sourceViewController.event_data_segue{
			
            // Segue data is in the following format: [ANALYTICAL_EMOTIONAL_VALUE, ANGER_FEAR_VALUE, CONFIDENCE_INHIBITION_VALUE,DOES_HAVE_PHOTO, Event_Date, EventDescription, EventName, EventPhoto, EventTime_Display, HAPPY_SAD_VALUE]
			
            // List follows the list in the data model under reverse alphebatical order
			memory.setValue(event_from_segue[0], forKeyPath: "analytical_emotional_value")
			memory.setValue(event_from_segue[1], forKeyPath: "anger_fear_value")
			memory.setValue(event_from_segue[2], forKeyPath: "confidence_inhibition_value")
			memory.setValue(event_from_segue[3], forKeyPath: "does_have_photo")
			memory.setValue(event_from_segue[4], forKeyPath: "eventdate")
			memory.setValue(event_from_segue[5], forKeyPath: "eventdescription")
			memory.setValue(event_from_segue[6], forKeyPath: "eventname")
			memory.setValue(event_from_segue[7], forKeyPath: "eventphoto")
			memory.setValue(event_from_segue[8], forKeyPath: "eventtime_display")
			memory.setValue(event_from_segue[9], forKeyPath: "happy_sad_value")
    
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
            	events[selectedIndexPath.row] = memory
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
           //Adding a new event instead of editing it.
				let newIndexPath = IndexPath(row: 0, section: 0)
				do {
					try managedContext.save()
					events.insert(memory, at: 0)
					//events.append(memory)
				} catch let error as NSError {
					print("Could not save. \(error), \(error.userInfo)")
				}
				tableView.insertRows(at: [newIndexPath], with: .automatic)

// Below for appending the memory to the end of the list (oldest -> newest)
//                let newIndexPath = IndexPath(row: events.count, section: 0)
//                do {
//					try managedContext.save()
//                	events.append(memory)
//				} catch let error as NSError {
//					print("Could not save. \(error), \(error.userInfo)")
//				}
//                tableView.insertRows(at: [newIndexPath], with: .automatic)

			// inserting the new event to the front of the time-specific arrays
			events_7_days.insert(memory, at: 0)
			events_14_days.insert(memory, at: 0)
			events_30_days.insert(memory, at: 0)
            }
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
