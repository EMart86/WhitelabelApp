//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Martin Eberl on 24.04.17.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time");
    }


}
