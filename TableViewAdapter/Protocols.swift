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


public protocol CollectionItemType: ValueContainerType, SelectionHandlerType {
    var id: String { get }
    var mapper: AbstractMapper? { get set }
}


public protocol CollectionSectionType: class, SelectionHandlerType {
    var header: CollectionItemType? { get set }
    var footer: CollectionItemType? { get set }
    var items: [CollectionItemType]? { get set }
    var mappers: [AbstractMapper] { get set }
    var index: String? { get set }
}
