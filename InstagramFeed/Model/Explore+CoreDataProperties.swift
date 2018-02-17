//
//  Explore+CoreDataProperties.swift
//  
//
//  Created by Marie on 17.02.18.
//
//

import Foundation
import CoreData


extension Explore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Explore> {
        return NSFetchRequest<Explore>(entityName: "Explore")
    }

    @NSManaged public var image: NSData?

}
