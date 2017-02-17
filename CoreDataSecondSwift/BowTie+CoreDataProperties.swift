//
//  BowTie+CoreDataProperties.swift
//  CoreDataSecondSwift
//
//  Created by songbiwen on 2017/2/17.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

import Foundation
import CoreData


extension BowTie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BowTie> {
        return NSFetchRequest<BowTie>(entityName: "BowTie");
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastWorn: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var photoData: NSData?
    @NSManaged public var rating: Int16
    @NSManaged public var searchKey: String?
    @NSManaged public var timesWorn: Int32
    @NSManaged public var tintcolor: NSObject?

}
