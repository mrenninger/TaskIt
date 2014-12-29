//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Michael Renninger on 12/9/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskVCDelgate {
    func addTask(message: String)
    func addTaskCancelled(message: String)
}

class AddTaskVC: UIViewController {
    
    
    @IBOutlet weak var taskTF: UITextField!
    @IBOutlet weak var subtaskTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate:AddTaskVCDelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named:"Background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTask("Task was not added!")
    }
    
    @IBAction func addTaskBtnTapped(sender: UIButton) {
        
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let managedObjectContext = ModelManager.instance.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        task.task = NSUserDefaults.standardUserDefaults().boolForKey(SHOULD_CAPITALIZE_TASK) == true ? taskTF.text.capitalizedString : taskTF.text
        task.subtask = subtaskTF.text
        task.date = datePicker.date        
        task.isComplete = NSUserDefaults.standardUserDefaults().boolForKey(SHOULD_COMPLETE_NEW_TODO) == true ? true : false
        
        ModelManager.instance.saveContext()
        
        var req = NSFetchRequest(entityName: "TaskModel")
        var err:NSError? = nil
        var results:NSArray = managedObjectContext!.executeFetchRequest(req, error: &err)!
        
        for res in results {
            println(res)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTask("Task added!")
    }
}
