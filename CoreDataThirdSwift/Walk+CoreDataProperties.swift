//
//  Walk+CoreDataProperties.swift
//  CoreDataThirdSwift
//
//  Created by songbiwen on 2017/2/20.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk");
    }

    @NSManaged public var time: NSDate?
    @NSManaged public var dog: Dog?

}
