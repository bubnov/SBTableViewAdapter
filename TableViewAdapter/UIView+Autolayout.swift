//
//  UIView+Autolayout.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public extension UIView {
    
    @discardableResult func addConstraints(
        _ formats: [String],
        views: [String: UIView],
        options: NSLayoutFormatOptions? = NSLayoutFormatOptions(rawValue: 0),
        metrics: [String: Any]? = nil)
        -> [NSLayoutConstraint]?
    {
        if formats.count == 0 || views.count == 0 {
            return nil
        }
        
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var allConstraints: [NSLayoutConstraint] = []
        
        for format in formats {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options!, metrics: metrics, views: views)
            allConstraints.append(contentsOf: constraints)
        }
        
        addConstraints(allConstraints)
        
        return allConstraints;
    }
    
    @discardableResult func addConstraint(
        item view1: Any,
        attribute attr1: NSLayoutAttribute,
        relatedBy relation: NSLayoutRelation,
        toItem view2: Any?,
        attribute attr2: NSLayoutAttribute,
        multiplier: CGFloat,
        constant c: CGFloat)
        -> NSLayoutConstraint
    {
        if let view = view1 as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(
            item: view1,
            attribute: attr1,
            relatedBy: relation,
            toItem: view2,
            attribute: attr2,
            multiplier: multiplier,
            constant: c
        )
        
        addConstraint(constraint)
        
        return constraint
    }
}

