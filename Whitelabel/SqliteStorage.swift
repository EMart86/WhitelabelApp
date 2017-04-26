//
//  SqliteStorage.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation
import CoreData

open class ManagedObjectStore: Store {
    private var observableModels: Observable<[NSManagedObject]>?
    
    func models<T>() -> Observable<[T]>? {
        if observableModels == nil {
            observableModels = storage.provider.observable(where: ManagedObjectQuery(entity: entity, predicate: predicate, sortDescriptors: sortDescriptors))
        }
        return observableModels as? Observable<[T]>
    }
    
    struct ManagedObjectQuery: Query {
        let entity: NSManagedObject.Type
        let predicate: NSPredicate?
        let sortDescriptors: [NSSortDescriptor]
    }
    
    private(set) var storage: Storage
    private let entity: NSManagedObject.Type
    private let predicate: NSPredicate?
    private let sortDescriptors: [NSSortDescriptor]
    
    
    init(storage: Storage, entity: NSManagedObject.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) {
        self.storage = storage
        self.entity = entity
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        
        if sortDescriptors.isEmpty {
            assertionFailure("Fetchrequest requires at least one sort-descriptor")
        }
    }
    
    func newInstance<T: NSManagedObject>() -> T? {
        guard let storage = self.storage as? SqliteStorage,
            let context = storage.managedObjectContext as? NSManagedObjectContext else {
                return nil
        }
        return T(context: context)
    }
}

final class ManagedObjectObservable: Observable<[NSManagedObject]> {
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    init(_ fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchedResultsController = fetchedResultsController
        super.init()
        value = fetchedResultsController.fetchedObjects as? [NSManagedObject]
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension ManagedObjectObservable: NSFetchedResultsControllerDelegate  {
    @nonobjc public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        value = fetchedResultsController.fetchedObjects as! [NSManagedObject]?
    }
}

final class ManagedObjectProvider: ObjectProvider {
    let managedObjectContext: NSManagedObjectContext
    init(_ managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    override func observable<T: NSManagedObject>(where query: Query) -> Observable<[T]>? {
        guard let query = query as? ManagedObjectStore.ManagedObjectQuery else {
                assertionFailure("Expecting ManagedObjectStore.ManagedObjectQuery as closure parameter")
                return nil
        }
        let entityName = NSStringFromClass(query.entity.self)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName) as! NSFetchRequest<T>
        request.fetchBatchSize = 20
        request.predicate = query.predicate
        request.sortDescriptors = query.sortDescriptors
        
        let controller = NSFetchedResultsController<T>(fetchRequest: request,
                                                       managedObjectContext: managedObjectContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        return ManagedObjectObservable(controller as! NSFetchedResultsController<NSFetchRequestResult>) as? Observable<[T]>
    }
}

final class SqliteStorage<T: NSManagedObject>: Storage {
    private(set) var provider: ObjectProvider = ObjectProvider()
    
    private let momdName: String
    private let sqlFileUrl: URL?
    
    init(_ momdName: String? = nil,
         sqlFileUrl: URL? = nil) {
        self.momdName = momdName ?? Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        self.sqlFileUrl = sqlFileUrl
    }
    
    func createProvider() -> SqliteStorage<T> {
        let managedObjectContext = self.managedObjectContext
        provider = ManagedObjectProvider(managedObjectContext)
        return self
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
