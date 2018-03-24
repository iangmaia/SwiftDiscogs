//  Copyright © 2017 nrith. All rights reserved.

import Foundation

/// A collection of the custom fields that a user has defined.
public struct DiscogsCollectionCustomFields: Codable {

    /// The custom fields that the user has defined, if any.
    public var fields: [DiscogsCollectionCustomField]?

}

/// A user-defined column in the collection database.
public struct DiscogsCollectionCustomField: Codable {

    /// Determines what type of editing/display component to use when
    /// entering data on Discogs.com.
    public enum FieldType: String {
        case dropdown
        case textarea
    }

    /// The field's unique ID within the set of fields.
    public var id: Int

    /// `true` if this field should be visible when other users view the
    /// collection.
    public var isPublic: Bool

    /// If this is a text-area field, this is the number of lines that
    /// should be displayed.
    public var lines: Int?

    /// The name of the field.
    public var name: String

    /// For dropdown fields, these are the option strings to display. They
    /// will appear in the order they're specified.
    public var options: [String]?

    /// The index of this field among all fields.
    public var position: Int

    /// The field's type. Currently, the only valid values are `dropdown`
    /// for lists, and `textarea` for free-text entry.
    public var type: String

    /// Customize the mapping of properties to JSON keys. Even though only
    /// one field ("public", which can't be used as a property name because
    /// it conflicts with the `public` keyword), ALL of the fields have
    /// to be included in this `enum`.
    private enum CodingKeys: String, CodingKey {
        case id
        case isPublic = "public"
        case lines
        case name
        case options
        case position
        case type
    }

}
