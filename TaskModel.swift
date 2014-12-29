//
//  TaskModel.swift
//  TaskIt
//
//  Created by Michael Renninger on 12/10/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var isComplete: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
