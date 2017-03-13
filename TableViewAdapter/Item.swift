//
//  Item.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import Foundation


public class Item: ValueContainer, CollectionItemType, InternalCollectionItemType {
    
    internal var _index: Int?
    internal weak var _section: ReloadableSectionType?
    
    private var _id: String?
    public var id: String {
        if _id == nil {
            if let value = value {
                var id = "\(Mirror(reflecting: value).subjectType)"
                if mapper != nil {
                    id += "_\(mapper!.targetClass)"
                }
                if isDynamic {
                    return id
                }
                _id = id
            }
        }
        return _id!
    }
    public var mapper: AbstractMapper?
    public var selectionHandler: ((CollectionItemType) -> Void)?
    public var accessoryButtonHandler: ((CollectionItemType) -> Void)?
    public var editable: Bool = true
    public var editingStyle: UITableViewCellEditingStyle = .none
    public var titleForDeleteConfirmationButton: String?
    public var editActions: [UITableViewRowAction]?
    public var commitEditingStyle: ((UITableViewCellEditingStyle, CollectionItemType) -> Void)?
    
    public init(id: String? = nil, value: Any, mapper: AbstractMapper? = nil) {
        super.init(value: value)
        _id = id
        self.mapper = mapper
    }
    
    public init(id: String? = nil, mapper: AbstractMapper? = nil, dynamicValue: @escaping DynamicValueClosure) {
        super.init(closure: dynamicValue)
        _id = id
        self.mapper = mapper
    }
    
    public init(id: String, mapper: AbstractMapper? = nil) {
        super.init(value: nil)
        _id = id
        self.mapper = mapper
    }
    
    public func reload(with animation: UITableViewRowAnimation? = nil) {
        guard let index = _index else { return }
        _section?.reloadItem(at: index, animation: animation)
    }
}
