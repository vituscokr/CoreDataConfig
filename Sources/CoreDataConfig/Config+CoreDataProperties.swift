//
//  File.swift
//  
//
//  Created by vitus on 2022/09/16.
//

import Foundation
import Foundation
import CoreData
extension Config {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Config> {
        return NSFetchRequest<Config>(entityName: "Config")
    }
    @NSManaged public var key: String?
    @NSManaged public var value: String?
    public var wrappedKey: String {
        key ?? ""
    }
    public var wrappedValue: String {
        value ?? ""
    }
}
extension Config: Identifiable {

}
