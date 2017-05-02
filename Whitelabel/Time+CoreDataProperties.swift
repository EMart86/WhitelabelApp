//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Martin Eberl on 02.05.17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time");
    }

    @NSManaged public var value: NSDate?

}
