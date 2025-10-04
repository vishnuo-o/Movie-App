//
//  FavoriteMovie+CoreDataProperties.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation
import CoreData

extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var addedDate: Date?

}
