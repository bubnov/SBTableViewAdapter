//
//  TableViewAdapterProtocols.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public protocol ActionHandlerType: class {
    var selectionHandler: ((CollectionItemType) -> Void)? { get set }
    var accessoryButtonHandler: ((CollectionItemType) -> Void)? { get set }
}

public protocol EditableItemType {
    var editable: Bool { get set }
    var editingStyle: UITableViewCellEditingStyle { get set }
    var titleForDeleteConfirmationButton: String? { get set }
    var editActions: [UITableViewRowAction]? { get set }
    var commitEditingStyle: ((UITableViewCellEditingStyle, CollectionItemType) -> Void)? { get set }
}

public protocol CollectionViewAdapterType: class, ActionHandlerType {
    func assign(to view: UIView)
    var mappers: [AbstractMapper] { get set }
    var sections: [CollectionSectionType] { get set }
}

public protocol CollectionItemType: ValueContainerType, ActionHandlerType, CollectionReloadableType, EditableItemType {
    var id: String { get }
    var mapper: AbstractMapper? { get set }
}

public protocol CollectionSectionType: class, ActionHandlerType, CollectionReloadableType {
    var header: CollectionItemType? { get set }
    var footer: CollectionItemType? { get set }
    var items: [CollectionItemType]? { get set }
    var mappers: [AbstractMapper] { get set }
    var index: String? { get set }
    var isHidden: Bool { get set }
    var dynamicItemMapper: AbstractMapper? { get set }
    var dynamicItemCount: Int? { get set }
}

public protocol CollectionReloadableType: class {
    func reload(with animation: UITableViewRowAnimation?)
}

public extension CollectionReloadableType {
    
    func reload() {
        reload(with: nil)
    }
}

public protocol TableViewHeaderFooterViewType {
    var isFooter: Bool { get set }
    var isFirst: Bool { get set }
    var tableViewStyle: UITableViewStyle { get set }
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
