//
//  SqliteStorage.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation
import CoreData

struct ManagedObjectStore: Store {
    struct ManagedObjectQuery: Query {
        let entityName: String
        let predicate: NSPredicate?
        let sortDescriptors: [NSSortDescriptor]?
    }
    
    private(set) var storage: Storage
    private(set) var models: Observable<[Any]>? = nil
    
    init(storage: Storage, entityName: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.storage = storage
        models = storage.provoder.observable(where: ManagedObjectQuery(entityName: entityName, predicate: predicate, sortDescriptors: sortDescriptors))
    }
    
}

final class ManagedObjectObservable: Observable<[NSManagedObject]> {
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    init(_ fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchedResultsController = fetchedResultsController
        super.init()
        value = fetchedResultsController.fetchedObjects as? [NSManagedObject]
        fetchedResultsController.delegate = self
    }
}

extension ManagedObjectObservable: NSFetchedResultsControllerDelegate  {
    @nonobjc public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        value = fetchedResultsController.fetchedObjects as! [NSManagedObject]?
    }
}

final class ManagedObjectProvider: ObjectProvider {
    private let managedObjectContext: NSManagedObjectContext
    init(_ managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    override func observable<NSManagedObject>(where query: Query) -> Observable<[NSManagedObject]>? {
        guard let query = query as? ManagedObjectStore.ManagedObjectQuery else {
            assertionFailure("Expecting ManagedObjectStore.ManagedObjectQuery as closure parameter")
            return nil
        }
        return ManagedObjectObservable(
            NSFetchedResultsController(fetchRequest: NSFetchRequest(entityName: query.entityName),
                                       managedObjectContext: managedObjectContext,
                                       sectionNameKeyPath: nil,
                                       cacheName: nil)) as? Observable<[NSManagedObject]>
    }
}

final class SqliteStorage<T: NSManagedObject>: Storage {
    internal var provoder: ObjectProvider = ObjectProvider()

    private let momdName: String
    private let sqlFileUrl: URL?
    
    init(momdName: String = Bundle.main.bundleIdentifier!, sqlFileUrl: URL? = nil) {
        self.momdName = momdName
        self.sqlFileUrl = sqlFileUrl
        provoder = ManagedObjectProvider(managedObjectContext)
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            return self.persistentContainer.viewContext
        } else {
            var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = self.persistentStoreCoordinator
            return context
        }
    }()
    
    func insert(model: Any) {
        guard let model = model as? NSManagedObject else {
            return
        }
        managedObjectContext.insert(model)
    }
    
    func remove(model: Any) {
        guard let model = model as? NSManagedObject else {
            return
        }
        managedObjectContext.delete(model)
    }
    
    func commit() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func rollback() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.rollback()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Helper
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.momdName)
        if let pathUrl = self.sqlFileUrl {
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: pathUrl)]
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOf: self.sqlFileUrl!)!)
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.sqlFileUrl, options: nil)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
}
