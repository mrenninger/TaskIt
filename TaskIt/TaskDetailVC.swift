//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Michael Renninger on 12/9/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

@objc protocol TaskDetailVCDelegate {
    optional func taskDetailEdited()
    
}

class TaskDetailVC: UIViewController {

    var detailTaskModel:TaskModel!
    var delegate:TaskDetailVCDelegate?
    
    @IBOutlet weak var taskTF: UITextField!
    @IBOutlet weak var subtaskTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named:"Background")!)
        
        taskTF.text = detailTaskModel.task
        subtaskTF.text = detailTaskModel.subtask
        datePicker.date = detailTaskModel.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        detailTaskModel.task = taskTF.text
        detailTaskModel.subtask = subtaskTF.text
        detailTaskModel.date = datePicker.date
        detailTaskModel.isComplete = detailTaskModel.isComplete
        
        ModelManager.instance.saveContext()
        
        self.navigationController?.popViewControllerAnimated(true)
        
        delegate?.taskDetailEdited!()
    }

}
