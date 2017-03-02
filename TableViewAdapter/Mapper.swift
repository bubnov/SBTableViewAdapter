//
//  Mapper.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import Foundation


protocol AbstractMapper {
    var id: String? { get }
    var targetClass: AnyClass { get }
    @discardableResult func apply<V, T>(_ value: V?, to target: T) -> T
}


class Mapper<Value, Target: AnyObject>: AbstractMapper {
    
    typealias Closure = (_ value: Value?, _ target: Target) -> Void
    
    var id: String?
    var targetClass: AnyClass = Target.self
    private var _closure: Closure?
    
    init(id: String? = nil, closure: @escaping Closure) {
        self.id = id ?? "\(Value.self)"
        _closure = closure
    }
    
    func apply<V, T>(_ value: V?, to target: T) -> T {
        if let closure = _closure {
            closure(value as? Value, target as! Target)
        }
        return target
    }
}
