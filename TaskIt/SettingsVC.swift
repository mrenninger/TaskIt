//
//  SettingsVC.swift
//  TaskIt
//
//  Created by Michael Renninger on 12/17/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    // Constants
    let VERSION_NUM = "1.0"
        
    // @IBOutlets
    @IBOutlet weak var capitalizeTV: UITableView!
    @IBOutlet weak var newToDoTV: UITableView!
    @IBOutlet weak var versionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named:"Background")!)

        capitalizeTV.delegate = self
        capitalizeTV.dataSource = self
        capitalizeTV.scrollEnabled = false
        
        newToDoTV.delegate = self
        newToDoTV.dataSource = self
        newToDoTV.scrollEnabled = false
        
        title = "Settings"
        
        versionLbl.text = VERSION_NUM
        
        var doneBtn = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("doneBarBtnItemPressed:"))
        navigationItem.leftBarButtonItem = doneBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneBarBtnItemPressed(btn: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

}

extension SettingsVC: UITableViewDelegate {
    
}

extension SettingsVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return tableView == capitalizeTV ? "Capitalize new task?" : "Complete new task?"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var bool:Bool = indexPath.row == 0 ? false : true
        var key:String = tableView == capitalizeTV ? SHOULD_CAPITALIZE_TASK : SHOULD_COMPLETE_NEW_TODO
        
        NSUserDefaults.standardUserDefaults().setBool(bool, forKey: key)
        
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:UITableViewCell
        
        if tableView == capitalizeTV {
            cell = tableView.dequeueReusableCellWithIdentifier("capitalizeCell") as UITableViewCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "No do not capitalize"
                if NSUserDefaults.standardUserDefaults().boolForKey(SHOULD_CAPITALIZE_TASK) == false {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
            else {
                cell.textLabel?.text = "Yes, Capitalize!"
                if NSUserDefaults.standardUserDefaults().boolForKey(SHOULD_CAPITALIZE_TASK) == true {
                    cell.accessoryType = .Checkmark
                }
                else {
                    cell.accessoryType = .None
                }
            }
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("completeNewToDoCell") as UITableViewCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "No do not complete task"
                if NSUserDefaults.standardUserDefaults().boolForKey(SHOULD_COMPLETE_NEW_TODO) == false {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
            else {
                cell.textLabel?.text = "Yes, complete task!"
                if NSUserDefaults.standardUserDefaults().boolForKey(SHOULD_COMPLETE_NEW_TODO) == true {
                    cell.accessoryType = .Checkmark
                }
                else {
                    cell.accessoryType = .None
                }
            }
        }
        
        return cell
    }
}