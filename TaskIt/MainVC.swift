//
//  ViewController.swift
//  TaskIt
//
//  Created by Michael Renninger on 12/9/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    // Constants
    
    
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Properties
    var resultsC:NSFetchedResultsController = NSFetchedResultsController()
    
    
    
    // Overrides
    override func viewDidLoad() {
        println("viewDidLoad")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor(patternImage: UIImage(named:"Background")!)
        
        resultsC = getFetchedResultsController()
        resultsC.delegate = self
        resultsC.performFetch(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("iCloudUpdated"), name: "coreDataUpdated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear: \(animated)")
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue: \(segue.identifier)")
        
        if segue.identifier == "showTaskDetail" {
            println("SHOW TASK DETAIL!!!")
            let detailVC:TaskDetailVC = segue.destinationViewController as TaskDetailVC
            
            let indexPath = self.tableView.indexPathForSelectedRow() // returns an optional

            let tTask = resultsC.objectAtIndexPath(indexPath!) as TaskModel
            
            detailVC.detailTaskModel = tTask
            detailVC.delegate = self
        }
        
        else if segue.identifier == "showAddTask" {
            println("SHOW ADD TASK!!!")
            let addTaskVC:AddTaskVC = segue.destinationViewController as AddTaskVC
            addTaskVC.delegate = self

        }
    }
    
    
    
    // IBActions
    @IBAction func addTaskButtonTapped(sender: UIBarButtonItem) {
        println("addTaskButtonTapped")

        self.performSegueWithIdentifier("showAddTask", sender: self)
    }
    
    
    
    // Helpers
    func taskFetchRequest() -> NSFetchRequest {
        let req = NSFetchRequest(entityName: "TaskModel")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        
        req.sortDescriptors = [completedDescriptor, sortDescriptor]
        
        return req
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        resultsC = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: ModelManager.instance.managedObjectContext!, sectionNameKeyPath: "isComplete", cacheName: nil)
        return resultsC
    }
    
    
    
    // iCloud Notification
    func iCloudUpdated() {
        tableView.reloadData()
    }
    

}



extension MainVC: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultsC.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsC.sections![section].numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tTask = resultsC.objectAtIndexPath(indexPath) as TaskModel
        
        var cell:TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        cell.taskLabel.text = tTask.task
        cell.descriptionLabel.text = tTask.subtask
        cell.dateLabel.text = Date.toString(date: tTask.date)
        
        return cell
    }
}



extension MainVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}



extension MainVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultsC.sections?.count == 1 {
            let fetchedObjects = resultsC.fetchedObjects!
            let testTask:TaskModel = fetchedObjects[0] as TaskModel
            return testTask.isComplete == false ? "To do" : "Completed"
        } else {
            return section == 0 ? "To do" : "Completed"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let tTask = resultsC.objectAtIndexPath(indexPath) as TaskModel
        tTask.isComplete = tTask.isComplete == true ? false : true
        ModelManager.instance.saveContext()
    }

}



extension MainVC: TaskDetailVCDelegate {
    func taskDetailEdited() {
        showAlert()
    }
    
    func showAlert(message:String = "Congratulations") {
        var alert = UIAlertController(title: "Change Made!", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: .Default, handler:nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}



extension MainVC:AddTaskVCDelgate {
    func addTask(message: String) {
        showAlert(message: message)
    }
    
    func addTaskCancelled(message: String) {
        showAlert(message: message)
    }
}
