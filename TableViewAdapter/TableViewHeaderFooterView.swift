//
//  TableViewHeaderFooterView.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public class TableViewHeaderFooterView: UITableViewHeaderFooterView {

    lazy var label = UILabel()
    var isFooter = false
    var isFirst = false
    weak var tableView: UITableView?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        
        setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let tableView = superview as? UITableView {
            switch tableView.style {
            case .plain:
                contentView.backgroundColor = UIColor(white: 0.97, alpha: 1)
            case .grouped:
                contentView.backgroundColor = UIColor.clear
            }
            
            label.textColor = textLabel?.textColor
        }
    }
    
    override public func updateConstraints() {
        if label.superview != contentView {
            contentView.addSubview(label)
            
            var metrics: [String: Any]?
            switch tableView?.style ?? .plain {
            case .grouped:
                metrics = [
                    "topInset": isFooter ? 13 : (isFirst ? 32 : 16),
                    "bottomInset": isFooter ? 13 : 8
                ]
            case .plain:
                metrics = [
                    "topInset": 4,
                    "bottomInset": 3
                ]
            }
            
            contentView.addConstraints(
                ["|-[label]-|", "V:|-(topInset@250)-[label]-(bottomInset@250)-|"],
                views: ["label": label],
                metrics: metrics
            )
        }
        
        super.updateConstraints()
    }
    
    override public func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize
    {
        guard label.text?.characters.count ?? 0 > 0 else { return CGSize(width: 0, height: 0.01) }
        return super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
    }
}
