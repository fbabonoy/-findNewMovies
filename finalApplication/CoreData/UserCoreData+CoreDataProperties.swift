//
//  UserCoreData+CoreDataProperties.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/18/22.
//
//

import Foundation
import CoreData


extension UserCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCoreData> {
        return NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
    }

    @NSManaged public var id: Int64

}

extension UserCoreData : Identifiable {

}
