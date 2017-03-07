//
//  TableViewAdapterProtocols.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public protocol SelectionHandlerType {
    var selectionHandler: ((CollectionItemType) -> Void)? { get set }
}


public protocol CollectionViewAdapterType: class, SelectionHandlerType {
    func assign(to view: UIView)
    var mappers: [AbstractMapper] { get set }
    var sections: [CollectionSectionType] { get set }
}


public protocol CollectionItemType: ValueContainerType, SelectionHandlerType, CollectionReloadableType {
    var id: String { get }
    var mapper: AbstractMapper? { get set }
}


public protocol CollectionSectionType: class, SelectionHandlerType, CollectionReloadableType {
    var header: CollectionItemType? { get set }
    var footer: CollectionItemType? { get set }
    var items: [CollectionItemType]? { get set }
    var mappers: [AbstractMapper] { get set }
    var index: String? { get set }
}


public protocol CollectionReloadableType: class {
    func reload(with animation: UITableViewRowAnimation?)
}


public extension CollectionReloadableType {
    
    func reload() {
        reload(with: nil)
    }
}


internal protocol InternalCollectionItemType: class {
    var _index: Int? { get set }
    weak var _section: ReloadableSectionType? { get set }
}


internal protocol InternalCollectionSectionType: class {
    var _index: Int? { get set }
    weak var _adapter: ReloadableAdapterType? { get set }
}


internal protocol ReloadableAdapterType: class {
    func reloadItem(at index: Int, section: Int, animation: UITableViewRowAnimation?)
    func reloadSection(at index: Int, animation: UITableViewRowAnimation?)
}


internal protocol ReloadableSectionType: class {
    func reloadItem(at index: Int, animation: UITableViewRowAnimation?)
}


// open func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
// open func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
// open func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
// open func moveSection(_ section: Int, toSection newSection: Int)
//
// open func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
// open func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
// open func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
// open func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
