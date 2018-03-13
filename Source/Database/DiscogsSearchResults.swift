//  Copyright © 2017 nrith. All rights reserved.

import Foundation

public struct DiscogsSearchResults: Codable {

    public var results: [Result]?

    public struct Result: Codable, Unique {

        public var catalogNumber: String?
        public var community: Community?
        public var country: String?
        public var format: [String]?
        public var genre: [String]?
        public var id: Int
        public var label: [String]?
        public var resourceUrl: String
        public var style: [String]?
        public var thumb: String?
        public var title: String
        public var type: String
        public var uri: String
        public var year: String?

        private enum CodingKeys: String, CodingKey {
            case catalogNumber = "catno"
            case community
            case country
            case format
            case genre
            case id
            case label
            case resourceUrl = "resource_url"
            case style
            case thumb
            case title
            case type
            case uri
            case year
        }

    }

    public struct Community: Codable {
        public var have: Int
        public var want: Int
    }

}
