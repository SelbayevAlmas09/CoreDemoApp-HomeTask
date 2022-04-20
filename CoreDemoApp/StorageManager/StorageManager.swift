//
//  StorageManager.swift
//  CoreDemoApp
//
//  Created by Almas Selbayev on 19.04.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }

        return taskList
    }
    
    func save(taskName: String, completion: @escaping (Task) -> Void) {
        let task = Task(context: persistentContainer.viewContext)
        task.title = taskName
        
        StorageManager.shared.hasChanges()
        completion(task)
    }
    
    func delete(_ task: Task) {
        persistentContainer.viewContext.delete(task)
        hasChanges()
    }
    
    func hasChanges() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}



