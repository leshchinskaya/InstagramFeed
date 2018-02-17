//
//  Explore+CoreDataClass.swift
//  
//
//  Created by Marie on 17.02.18.
//
//

import Foundation
import CoreData

@objc(Explore)
public class Explore: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Explore"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
