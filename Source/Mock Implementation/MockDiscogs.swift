//  Copyright © 2017 nrith. All rights reserved.

import JSONClient
import PromiseKit
import UIKit

/// A `Discogs` implementation that generates canned values from the sample
/// JSON code documented at api.discogs.com.
public class MockDiscogs: MockClient, Discogs {
    
    public init(errorMode: Bool = false) {
        let bundle = Bundle(for: MockDiscogs.self)

        if errorMode {
            super.init(errorDomain: "net.immediate.MockDiscogs", bundle: bundle)
        } else {
            super.init(bundle: bundle)
        }
    }

    public func authorize() -> Promise<DiscogsUserIdentity> {
        return Promise<DiscogsUserIdentity> { (fulfill, reject) in
            if errorMode {
                reject(NSError())
            } else {
                let userIdentity: DiscogsUserIdentity? = try JSONUtils.jsonObject(forFileNamed: "get-user-identity-200", ofType: "json", inBundle: bundle)
                fulfill(userIdentity!)
            }
        }
    }
    
    // MARK: - Database
    
    public func artist(id: Int) -> Promise<DiscogsArtist> {
        return apply(toJsonObjectIn: "get-artist-200",
                     error: DiscogsError.artistNotFoundById(id))
    }

    public func releases(forArtist artistId: Int) -> Promise<DiscogsReleaseSummaries> {
        return apply(toJsonObjectIn: "get-artist-releases-200",
                     error: DiscogsError.artistNotFoundById(artistId))
    }

    public func label(id: Int) -> Promise<DiscogsLabel> {
        return apply(toJsonObjectIn: "get-label-200",
                     error: DiscogsError.labelNotFoundById(id))
    }
    
    public func releases(forLabel labelId: Int) -> Promise<DiscogsReleaseSummaries> {
        return apply(toJsonObjectIn: "get-label-releases-200",
                     error: DiscogsError.labelNotFoundById(labelId))
    }
    
    public func masterRelease(id: Int) -> Promise<DiscogsMasterRelease> {
        return apply(toJsonObjectIn: "get-master-200",
                     error: DiscogsError.masterReleaseNotFoundById(id))
    }

    public func releasesForMasterRelease(_ id: Int,
                                         pageNumber: Int = 0,
                                         resultsPerPage: Int = 50) -> Promise<DiscogsMasterReleaseVersions> {
        return apply(toJsonObjectIn: "get-master-release-versions-200",
                     error: DiscogsError.masterReleaseNotFoundById(id))
    }

    public func release(id: Int) -> Promise<DiscogsRelease> {
        return apply(toJsonObjectIn: "get-release-200",
                     error: DiscogsError.masterReleaseNotFoundById(id))
    }

    // MARK: - Collections
    
    public func customCollectionFields(for userName: String) -> Promise<DiscogsCollectionCustomFields> {
        return apply(toJsonObjectIn: "get-custom-fields-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionValue(for userName: String) -> Promise<DiscogsCollectionValue> {
        return apply(toJsonObjectIn: "get-collection-value-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionFolders(for userName: String) -> Promise<DiscogsCollectionFolders> {
        return apply(toJsonObjectIn: "get-folders-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionFolderInfo(forFolderId folderId: Int,
                                     userName: String) -> Promise<DiscogsCollectionFolder> {
        return apply(toJsonObjectIn: "get-folder-metadata-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func createFolder(named folderName: String,
                             userName: String) -> Promise<DiscogsCollectionFolder> {
        return apply(toJsonObjectIn: "post-create-folder-201",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func edit(_ folder: DiscogsCollectionFolder,
                     userName: String) -> Promise<DiscogsCollectionFolder> {
        return apply(toJsonObjectIn: "post-edit-folder-metadata-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func collectionItems(forFolderId folderId: Int,
                                userName: String,
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) -> Promise<DiscogsCollectionFolderItems> {
        return apply(toJsonObjectIn: "get-items-in-folder-200",
                     error: DiscogsError.unknownUser(username: userName))
    }
    
    public func addItem(_ itemId: Int,
                        toFolderId folderId: Int,
                        userName: String) -> Promise<DiscogsCollectionItemInfo> {
        return apply(toJsonObjectIn: "add-item-to-collection-folder-200",
                     error: DiscogsError.unknownUser(username: userName))
    }

    // MARK: - Search

    public func search(for queryString: String, type: String = "title") -> Promise<DiscogsSearchResults> {
        return apply(toJsonObjectIn: "search-200",
                     error: DiscogsError.unknown(nil))
    }

}
