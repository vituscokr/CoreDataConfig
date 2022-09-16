//
//  File.swift
//  
//
//  Created by vitus on 2022/09/16.
//
import Foundation
import CoreData
import Combine

@available(macOS 10.15, *)
public class ConfigStorage: NSObject, ObservableObject {
    public var items = CurrentValueSubject<[Config], Never>([])
    public static let shared: ConfigStorage = ConfigStorage()
    private let fetchController: NSFetchedResultsController<Config>
    private var viewContext: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    private override init() {
        let fetchRequest: NSFetchRequest<Config> = Config.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "key", ascending: true)]
        fetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            items.value = fetchController.fetchedObjects ?? []
        } catch {
        }
    }
    func read(key: ConfigKey ) -> String {
        let objects = fetchController.fetchedObjects?.filter {
            $0.key == key.rawValue
        }
        guard let object  = objects?.first else {
            return ""
        }
        return object.wrappedValue
    }
    func add(key: ConfigKey, value: String ) {
        let viewContext = fetchController.managedObjectContext
        let config = Config(context: viewContext)
        config.key = key.rawValue
        config.value = value
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func upate(key: ConfigKey, value: String) {
        let viewContext = fetchController.managedObjectContext
        let objects = fetchController.fetchedObjects?.filter {
            $0.key == key.rawValue
        }
        guard let object  = objects?.first else {
            self.add(key: key, value: value)
            return
        }
        object.value = value
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func delete(key: ConfigKey ) {
        let viewContext = fetchController.managedObjectContext
        let objects = fetchController.fetchedObjects?.filter {
            $0.key == key.rawValue
        }
        guard let array  = objects else {
            return
        }
        for obj in array {
            viewContext.delete(obj)
        }
        do {
            try viewContext.save()
        } catch {
        }
    }
}
@available(macOS 10.15, *)
extension ConfigStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let items = controller.fetchedObjects as? [Config] else {
            return
        }
        self.items.value = items
    }
}

