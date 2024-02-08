//
//  FetchedResultList.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//  Found at https://augmentedcode.io/2023/04/03/nsfetchedresultscontroller-wrapper-for-swiftui-view-models/
//

import CoreData
import Foundation

@MainActor final class FetchedResultList<Result: NSManagedObject> {
    private let fetchedResultsController: NSFetchedResultsController<Result>
    private let observer: FetchedResultsObserver<Result>

    init(context: NSManagedObjectContext, filter: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]) {
        let request = NSFetchRequest<Result>(entityName: String(describing: Result.self))
        request.predicate = filter
        request.sortDescriptors = sortDescriptors.isEmpty ? nil : sortDescriptors
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        observer = FetchedResultsObserver(controller: fetchedResultsController)

        observer.willChange = { [unowned self] in willChange?()
        }
        observer.didChange = { [unowned self] in didChange?()
        }
        refresh()
    }

    func refresh() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("failed to load results")
        }
    }

    var items: [Result] {
        fetchedResultsController.fetchedObjects ?? []
    }

    var predicate: NSPredicate? {
        get {
            fetchedResultsController.fetchRequest.predicate
        }
        set {
            fetchedResultsController.fetchRequest.predicate = newValue
            refresh()
        }
    }

    var sortDescriptors: [NSSortDescriptor] {
        get {
            fetchedResultsController.fetchRequest.sortDescriptors ?? []
        }
        set {
            fetchedResultsController.fetchRequest.sortDescriptors = newValue.isEmpty ? nil : newValue
            refresh()
        }
    }

    var willChange: (() -> Void)?
    var didChange: (() -> Void)?
}

private final class FetchedResultsObserver<Result: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    var willChange: () -> Void = {}
    var didChange: () -> Void = {}

    init(controller: NSFetchedResultsController<Result>) {
        super.init()
        controller.delegate = self
    }

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        willChange()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        didChange()
    }
}
