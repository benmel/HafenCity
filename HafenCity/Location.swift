//
//  HafenCity.swift
//  HafenCity
//
//  Created by Ben Meline on 2/18/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var coordX: NSNumber
    @NSManaged var coordY: NSNumber
    @NSManaged var directory: String
    @NSManaged var name: String
    @NSManaged var text: String

}
