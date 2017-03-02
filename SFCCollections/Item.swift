//
//  Item.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import Foundation


class Item: ValueContainer, CollectionItemType {
    
    private var _id: String?
    var id: String {
        if _id == nil {
            if let value = value {
                let id = "\(Mirror(reflecting: value).subjectType)"
                if isDynamic {
                    return id
                }
                _id = id
            }
        }
        return _id!
    }
    var mapper: AbstractMapper?
    var selectionHandler: ((CollectionItemType) -> Void)?
    
    init(id: String? = nil, value: Any, mapper: AbstractMapper? = nil) {
        super.init(value: value)
        _id = id
        self.mapper = mapper
    }
    
    init(id: String? = nil, mapper: AbstractMapper? = nil, dynamicValue: @escaping DynamicValueClosure) {
        super.init(closure: dynamicValue)
        _id = id
        self.mapper = mapper
    }
    
    init(id: String, mapper: AbstractMapper? = nil) {
        super.init(value: nil)
        _id = id
        self.mapper = mapper
    }
}
