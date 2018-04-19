//
//  TableViewPositionManager.swift
//  Collections
//
//  Created by Bubnov Slavik on 18/06/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public protocol TableViewPositionManagerType: LoggableType {
    init(tableView: UITableView, idResolver: @escaping (IndexPath) -> String?, indexPathResolver: @escaping (String) -> IndexPath?)
    func storePosition()
    @discardableResult func restorePosition(animated: Bool) -> Bool
    func reset()
    func keepPosition(animated: Bool, block: () -> Void)
}

extension TableViewPositionManagerType {
    
    @discardableResult public func restorePosition() -> Bool {
        return restorePosition(animated: false)
    }
    
    public func keepPosition(block: () -> Void) {
        keepPosition(animated: false, block: block)
    }
}

public class TableViewPositionManager: TableViewPositionManagerType {
    
    private struct CellInfo: CustomStringConvertible {
        var cellMinY: CGFloat
        var id: String
        var description: String {
            return "<CellInfo id: \(id), cellMinY: \(cellMinY)>"
        }
    }
    
    public var logger: ((String) -> Void)?
    private weak var _tableView: UITableView?
    private let _indexPathResolver: (String) -> IndexPath?
    private let _idResolver: (IndexPath) -> String?
    private var _storedCellPositions: [CellInfo] = []
    
    required public init(tableView: UITableView, idResolver: @escaping (IndexPath) -> String?, indexPathResolver: @escaping (String) -> IndexPath?) {
        _tableView = tableView
        _idResolver = idResolver
        _indexPathResolver = indexPathResolver
        reset()
    }
    
    public func reset() {
        _storedCellPositions = []
    }
    
    public func storePosition() {
        reset()
        
        guard let tableView = _tableView, tableView.contentOffset.y > 0 else { return }
        
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            guard let id = _idResolver(indexPath), let cell = tableView.cellForRow(at: indexPath) else { continue }
            _storedCellPositions.append(
                CellInfo(
                    cellMinY: cell.frame.minY - tableView.contentOffset.y,
                    id: id
                )
            )
        }
        
        logger?("Stored positions: \(_storedCellPositions)")
    }
    
    @discardableResult public func restorePosition(animated: Bool = false) -> Bool {
        guard let tableView = _tableView else { return false }
        
        var restored = false
        
        for info in _storedCellPositions {
            guard let indexPath = _indexPathResolver(info.id) else { continue }
            guard indexPath.row < tableView.numberOfRows(inSection: indexPath.section) else { continue }
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            guard let cell = tableView.cellForRow(at: indexPath) else { continue }
            
            let diff = cell.frame.minY - tableView.contentOffset.y - info.cellMinY
            let offset = CGPoint(x: 0, y: tableView.contentOffset.y + diff)
            if diff != 0 {
                tableView.setContentOffset(offset, animated: animated)
            }
            
            if let tableView = tableView as? TableViewWithKeepableOffset {
                tableView.offsetToKeep = offset
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    tableView.offsetToKeep = nil
                })
            }
            
            logger?("Restored position to the cell with id \"\(info.id)\"")
            restored = true
            break
        }
        
        if !restored {
            logger?(
                _storedCellPositions.count > 0 ? "Position wasn't restored :(" : "Nothing to restore"
            )
        }
        
        reset()
        
        return restored
    }
    
    public func keepPosition(animated: Bool, block: () -> Void) {
        logger?("Keep position\(animated ? " (animated)" : "")")
        storePosition()
        UIView.setAnimationsEnabled(false)
        block()
        UIView.setAnimationsEnabled(true)
        restorePosition(animated: animated)
    }
}


class TableViewWithKeepableOffset: UITableView {
    
    var offsetToKeep: CGPoint?
    
    override var contentOffset: CGPoint {
        get { return super.contentOffset }
        set {
            var newValue = newValue
            if let offset = offsetToKeep, newValue != offset {
                newValue = offset
            }
            super.contentOffset = newValue
        }
    }
}
