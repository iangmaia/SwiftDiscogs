//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// The user interface for the `DiscogsArtistViewController`. It has outlets
/// for a table view and a collection view, even though only one will be
/// active at a time, depending on the device's orientation.
open class DiscogsArtistView: UIView {

    /// The artist model.
    open var model: DiscogsArtistModel? {
        didSet {
            reload()
        }
    }

    // MARK: - Outlets

    /// The table view. This should be non-`nil` when the device is in
    /// compact-width mode.
    @IBOutlet weak var tableView: UITableView? {
        didSet {
            reload()
        }
    }

    /// The collection view. This should be non-`nil` when the device is in
    /// regular-width mode.
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            reload()
        }
    }

    // MARK: - Other Functions

    /// Reload the table or collection view, as appropriate.
    open func reload() {
        if let tableView = tableView {
            model?.tableView = tableView
            tableView.reloadData()
        }

        if let collectionView = collectionView {
            model?.collectionView = collectionView
            collectionView.reloadData()
        }
    }

}

public protocol DiscogsArtistBioCell {

    var bioLabel: UILabel? { get }
    var bioText: String? { get set }

}

open class DiscogsArtistBioTableCell: UITableViewCell, DiscogsArtistBioCell {

    @IBOutlet open weak var bioLabel: UILabel?

    open var bioText: String? {
        set {
            bioLabel?.text = bioText
        }

        get {
            return bioLabel?.text
        }
    }

}
