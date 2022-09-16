//
//  File.swift
//  
//
//  Created by Gyeongtae Nam on 2022/09/16.
//

import Foundation
import CoreData
public class CoreDataManager: NSPersistentContainer {
    public static let shared = CoreDataManager()
    public init() {
        guard let objectModelURL = Bundle.main.url(forResource: "CoreDataConfig", withExtension: "xcdatamodeld"),
              let objectModel = NSManagedObjectModel(contentsOf: objectModelURL) else {
            fatalError("Failed to retrivew the object model")
        }
        super.init(name: "CoreDataConfig", managedObjectModel: objectModel)
        self.initialize()
    }
    
    private func initialize() {
        self.loadPersistentStores { (_, error) in
            fatalError("Unresolved error (\(error?.localizedDescription ?? "ERROR!!")")
        }
        self.viewContext.automaticallyMergesChangesFromParent = true
    }
}
