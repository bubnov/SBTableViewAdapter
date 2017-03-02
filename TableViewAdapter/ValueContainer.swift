//
//  ValueContainer.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import Foundation


public protocol ValueContainerType: class {
    var value: Any? { get }
    var isDynamic: Bool { get }
}


public class ValueContainer: ValueContainerType {
 
    public typealias DynamicValueClosure = () -> Any
    
    private var _value: Any?
    private var _dynamicValue: DynamicValueClosure?
    
    public var value: Any? {
        if _value != nil { return _value }
        if _dynamicValue != nil { return _dynamicValue!() }
        return nil
    }
    
    public var isDynamic: Bool {
        return _dynamicValue != nil
    }
    
    init(value: Any?) {
        _value = value
    }
    
    init(closure: @escaping DynamicValueClosure) {
        _dynamicValue = closure
    }
}
