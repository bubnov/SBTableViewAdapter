//
//  Section.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import Foundation


public class Section: CollectionSectionType, ReloadableSectionType, InternalCollectionSectionType {
    
    internal var _index: Int?
    internal weak var _adapter: ReloadableAdapterType?
    
    public var isHidden: Bool = false
    public var index: String?
    public var mappers: [AbstractMapper] = []
    public var selectionHandler: ((CollectionItemType) -> Void)?
    public var accessoryButtonHandler: ((CollectionItemType) -> Void)?
    public var header: CollectionItemType?
    public var footer: CollectionItemType?
    public var items: [CollectionItemType]? {
        willSet {
            for item in items ?? [] {
                guard let item = item as? InternalCollectionItemType else { continue }
                item._index = nil
                item._section = nil
            }
        }
        didSet {
            for (i, item) in (items ?? []).enumerated() {
                guard let item = item as? InternalCollectionItemType else { continue }
                item._index = i
                item._section = self
            }
        }
    }
    
    public init(header: Any? = nil, footer: Any? = nil, index: String? = nil, items: [Any], mappers: [AbstractMapper]? = nil) {
        self.header = _convertObjectToItem(header, id: "header")
        self.footer = _convertObjectToItem(footer, id: "footer")
        self.index = index
        for item in items {
            if self.items == nil {
                self.items = []
            }
            if let i = _convertObjectToItem(item) {
                self.items?.append(i)
            }
        }
        if mappers != nil {
            self.mappers.append(contentsOf: mappers!)
        }
    }
    
    public convenience init(_ items: Any...) {
        self.init(items: items)
    }
    
    public func reload(with animation: UITableViewRowAnimation? = nil) {
        guard let index = _index else { return }
        _adapter?.reloadSection(at: index, animation: animation)
    }
    
    private func _convertObjectToItem(_ object: Any?, id: String? = nil) -> CollectionItemType? {
        guard object != nil else { return nil }
        if object is CollectionItemType {
            let item = object as? CollectionItemType
            return item
        }
        let itemId = id ?? "\(Mirror(reflecting: object!).subjectType)"
        return Item(id: "\(itemId)", value: object!)
    }
    
    internal func reloadItem(at index: Int, animation: UITableViewRowAnimation? = nil) {
        guard let section = _index else { return }
        _adapter?.reloadItem(at: index, section: section, animation: animation)
    }
}
