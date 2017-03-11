//
//  TableViewHeaderFooterView.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public class TableViewHeaderFooterView: UITableViewHeaderFooterView, TableViewHeaderFooterViewType {

    lazy var label = UILabel()
    public var isFooter = false
    public var isFirst = false
    public var tableViewStyle: UITableViewStyle = .plain
    private var contentViewConstraints: [NSLayoutConstraint]?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        
        contentView.addSubview(label)
        
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
                label.textColor = UIColor(white: 0.13, alpha: 1)
            case .grouped:
                contentView.backgroundColor = UIColor.clear
                label.textColor = UIColor(white: 0.43, alpha: 1)
            }
        }
    }
    
    override public func updateConstraints() {
        if let oldConstraints = contentViewConstraints {
            contentView.removeConstraints(oldConstraints)
        }
        
        var metrics: [String: Any]?
        switch tableViewStyle {
        case .grouped:
            metrics = [
                "topInset": isFooter ? 8 : (isFirst ? 32 : 16),
                "bottomInset": isFooter ? 13 : 8
            ]
        case .plain:
            metrics = [
                "topInset": 4,
                "bottomInset": 3
            ]
        }
        
        contentViewConstraints = contentView.addConstraints(
            ["|-[label]-(8@999)-|", "V:|-(topInset@250)-[label]-(bottomInset@250)-|"],
            views: ["label": label],
            metrics: metrics
        )
        
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
