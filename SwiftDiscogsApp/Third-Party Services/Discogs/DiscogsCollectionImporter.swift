//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import PromiseKit
import Stylobate
import SwiftDiscogs

public class DiscogsCollectionImporter: NSManagedObjectContext {

    typealias CoreDataFieldsByID = [Int16: CustomField]

    typealias CoreDataFoldersByID = [Int64: Folder]

    // MARK: - Properties

    /// The mapping of the fetched or created `CollectionItem`s, keyed by their
    /// `CollectionItem.releaseVersionID`s.
    private var coreDataItems: [Int64: CollectionItem] = [:]

    private var discogsFolders: [Int: SwiftDiscogs.CollectionFolder] = [:]

    /// The mapping of the Discogs `CollectionFolderItem`s, keyed by their
    /// IDs.
    private var discogsItems: [Int: SwiftDiscogs.CollectionFolderItem] = [:]

    private var userName: String = ""

    // MARK: - Import Functions

    public func importDiscogsCollection() {
        importDiscogsCustomFields().then { (coreDataFields) -> Promise<CoreDataFoldersByID> in
            self.importDiscogsFolders()
        }.done { (coreDataFolders) in
            self.importDiscogsItems()
        }.cauterize()
    }

    /// Import the custom fields that the user has defined. The
    /// `CustomCollectionField.fetchOrCreateEntity()` is a bit different from
    /// the other managed objects' `fetchOrCreate()`s because there are two
    /// custom field types (dropdown and textarea), and the appropriate one has
    /// to be created.
    func importDiscogsCustomFields() -> Promise<CoreDataFieldsByID> {
        return DiscogsManager.discogs.customCollectionFields(forUserName: userName).then { (discogsFieldsResponse) -> Promise<CoreDataFieldsByID> in
            return Promise<CoreDataFieldsByID> { (seal) in
                var coreDataCustomFields = CoreDataFieldsByID()

                try discogsFieldsResponse.fields?.forEach { [weak self] (discogsField) in
                    guard let self = self else {
                        seal.fulfill(CoreDataFieldsByID())
                        return
                    }

                    if let coreDataField = try CustomField.fetchOrCreateEntity(fromDiscogsField: discogsField, inContext: self) {
                        coreDataCustomFields[coreDataField.id] = coreDataField
                    }
                }

                seal.fulfill(coreDataCustomFields)
            }
        }
    }

    func importDiscogsFolders() -> Promise<CoreDataFoldersByID> {
        return DiscogsManager.discogs.collectionFolders(forUserName: userName).then { (discogsFoldersResponse) -> Promise<CoreDataFoldersByID> in
            return Promise<CoreDataFoldersByID> { (seal) in
                seal.fulfill(CoreDataFoldersByID())
            }
//            guard let self = self else { return }

//            try discogsFoldersResponse.folders.forEach { (discogsFolder) in
//                let request: NSFetchRequest<Folder> = Folder.fetchRequest(sortDescriptors: [(\Folder.folderID).sortDescriptor()])
//                let coreDataFolder: Folder = try self.fetchOrCreate(withRequest: request) { (folder) in
//                    folder.update(withDiscogsFolder: discogsFolder)
//                }
//
//                self.coreDataFolders[coreDataFolder.folderID] = coreDataFolder
//            }
        }
    }

    func buildListOfDiscogsItems(inMasterFolder masterFolder: Folder,
                                 fromDiscogsFolder discogsFolder: SwiftDiscogs.CollectionFolder) {
        let count = discogsFolder.count
        let pageSize = 100
        let pageCount = (count / pageSize) + 1

        (1..<pageCount).forEach { (pageNumber) in
            DiscogsManager.discogs.collectionItems(inFolderID: discogsFolder.id,
                                                   userName: userName,
                                                   pageNumber: pageNumber,
                                                   resultsPerPage: pageSize).done { (itemsResult) in
            }.cauterize()
        }
    }

    func importDiscogsItems() {

    }

}

public extension SwiftDiscogsApp.CollectionItem {

    func update(withDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem,
                inContext context: NSManagedObjectContext) throws {
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)

//        try discogsItem.notes?.forEach { (discogsNote) in
//            let predicate = CollectionItemField.uniquePredicate(forReleaseVersionID: discogsItem.id,
//                                                                fieldID: discogsNote.fieldId)
//            let request: NSFetchRequest<CollectionItemField> = CollectionItemField.fetchRequest(sortDescriptors: [],
//                                                                                                predicate: predicate)
//            _ = try context.fetchOrCreate(withRequest: request) { (note) in
//
//            }
//        }
    }

}

public extension SwiftDiscogsApp.CollectionItemField {

    static func uniquePredicate(forReleaseVersionID releaseVersionID: Int,
                                fieldID: Int) -> NSPredicate {
        return NSPredicate(format: "collectionItem.releaseVersionID == \(releaseVersionID)")
            + NSPredicate(format: "customField.id == \(Int64(fieldID))")
    }

    func update(withDiscogsNote discogsNote: SwiftDiscogs.CollectionFolderItem.Note,
                customField: SwiftDiscogsApp.CustomField,
                collectionItem: SwiftDiscogsApp.CollectionItem) {
        self.value = discogsNote.value
        self.customField = customField
        self.collectionItem = collectionItem
    }

}

public extension SwiftDiscogsApp.Folder {

    func update(withDiscogsFolder discogsFolder: SwiftDiscogs.CollectionFolder) {
        self.folderID = Int64(discogsFolder.id)
        self.name = discogsFolder.name
    }

}

