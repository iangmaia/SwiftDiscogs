//  Copyright © 2017 Poikile Creations. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit

/// Swift implementation of the Discogs (https://www.discogs.com) API. Most
/// calls return a `Promise`, which the API call will populate with either
/// a populated object of the expected type, or an error.
open class DiscogsClient: OAuth1JSONClient, Discogs {

    // MARK: - Private properties
    
    fileprivate var headers: OAuthSwift.Headers = [:]
    
    public private(set) var userAgent: String
    
    // MARK: - Initializers
    
    /// Initialize the Discogs client. This doesn't make any calls to the
    /// Discogs API; that happens in `authorize()`.
    public init(consumerKey: String,
                consumerSecret: String,
                userAgent: String) {
        self.userAgent = userAgent
        super.init(consumerKey: consumerKey,
                   consumerSecret: consumerSecret,
                   requestTokenUrl: "https://api.discogs.com/oauth/request_token",
                   authorizeUrl: "https://www.discogs.com/oauth/authorize",
                   accessTokenUrl: "https://api.discogs.com/oauth/access_token",
                   baseUrl: URL(string: "https://api.discogs.com")!)
        headers["User-Agent"] = self.userAgent
        /// Discogs requires all API calls to include a custom `User-Agent`
        /// header.
    }

    override open func authorize(presentingViewController: UIViewController,
                                 callbackUrlString: String) -> Promise<OAuthSwiftCredential> {
        let promise: Promise<OAuthSwiftCredential> = super.authorize(presentingViewController: presentingViewController,
                                                                     callbackUrlString: callbackUrlString)
        
        return promise
    }
    
    // MARK: - Authorization & User Identity
    
    public func userIdentity() -> Promise<DiscogsUserIdentity> {
        return authorizedGet(path: "/oauth/identity", headers: headers)
    }
    
    public func userProfile(userName: String) -> Promise<DiscogsUserProfile> {
        return authorizedGet(path: "/users/\(userName)", headers: headers)
    }
    
    // MARK: - Database
    
    public func artist(identifier: Int) -> Promise<DiscogsArtist> {
        return get(path: "/artists/\(identifier)", headers: headers)
    }
    
    public func label(identifier: Int) -> Promise<DiscogsLabel> {
        return get(path: "/labels/\(identifier)", headers: headers)
    }
    
    public func masterRelease(identifier: Int) -> Promise<DiscogsMasterRelease> {
        return get(path: "/masters/\(identifier)", headers: headers)
    }
    
    public func release(identifier: Int) -> Promise<DiscogsRelease> {
        return get(path: "/releases/\(identifier)", headers: headers)
    }
    
    public func releases(forArtist artistId: Int) -> Promise<DiscogsReleaseSummaries> {
        return get(path: "/artists/\(artistId)/releases", headers: headers)
    }
    
    public func releases(forLabel labelId: Int) -> Promise<DiscogsReleaseSummaries> {
        return get(path: "/labels/\(labelId)/releases", headers: headers)
    }
    
    public func releasesForMasterRelease(_ identifier: Int,
                                         pageNumber: Int = 1,
                                         resultsPerPage: Int = 50) -> Promise<DiscogsMasterReleaseVersions> {
        // turn the pageNumber and resultsPerPage into query parameters
        return get(path: "/masters/\(identifier)/versions", headers: headers)
    }
    
    // MARK: - Collections
    
    public func customCollectionFields(for userName: String) -> Promise<DiscogsCollectionCustomFields> {
        return authorizedGet(path: "/users/\(userName)/collection/fields", headers: headers)
    }
    
    public func collectionValue(for userName: String) -> Promise<DiscogsCollectionValue> {
        return authorizedGet(path: "/users/\(userName)/collection/value", headers: headers)
    }
    
    public func collectionFolders(for userName: String) -> Promise<DiscogsCollectionFolders> {
        return authorizedGet(path: "/users/\(userName)/collection/folders", headers: headers)
    }
    
    public func collectionFolderInfo(forFolderId folderId: Int,
                                     userName: String) -> Promise<DiscogsCollectionFolder> {
        return authorizedGet(path: "/users/\(userName)/collection/folders/\(folderId)", headers: headers)
    }
    
    public func createFolder(named folderName: String,
                             userName: String) -> Promise<DiscogsCollectionFolder> {
        return authorizedPost(path: "/users/\(userName)/collection/folders/\(folderName)", headers: headers)
    }
    
    public func edit(_ folder: DiscogsCollectionFolder,
                     userName: String) -> Promise<DiscogsCollectionFolder> {
        return Promise<DiscogsCollectionFolder> { (seal) in
        }
    }
    
    public func collectionItems(forFolderId folderId: Int,
                                userName: String,
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) -> Promise<DiscogsCollectionFolderItems> {
        // turn the pageNumber and resultsPerPage into query parameters
        return authorizedGet(path: "/users/\(userName)/collection/folders/\(folderId)/releases",
            headers: headers)
    }
    
    public func addItem(_ itemId: Int,
                        toFolderId folderId: Int,
                        userName: String) -> Promise<DiscogsCollectionItemInfo> {
        return authorizedPost(path: "/users/\(userName)/collection/folders/\(folderId)/releases/{itemId}", headers: headers)
    }
    
    // MARK: - Search
    
    public func search(for queryString: String,
                       type: String) -> Promise<DiscogsSearchResults> {
        let params = ["q": queryString]
        
        return authorizedGet(path: "/database/search", headers: headers, parameters: params)
    }
    
}
