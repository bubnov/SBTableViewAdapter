//
//  TableViewAdapter.swift
//  Collections
//
//  Created by Bubnov Slavik on 02/03/2017.
//  Copyright © 2017 Bubnov Slavik. All rights reserved.
//

import UIKit


public class TableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate, CollectionViewAdapterType, ReloadableAdapterType {
    
    //MARK: - Public
    
    public var sections: [CollectionSectionType] = [] {
        willSet {
            for section in sections {
                guard let section = section as? InternalCollectionSectionType else { continue }
                section._index = nil
                section._adapter = nil
            }
        }
        didSet {
            for (i, section) in sections.enumerated() {
                guard let section = section as? InternalCollectionSectionType else { continue }
                section._index = i
                section._adapter = self
            }
        }
    }
    public var mappers: [AbstractMapper] = []
    public var selectionHandler: ((CollectionItemType) -> Void)?
    
    public func assign(to view: UIView) {
        guard let view = view as? UITableView else { fatalError("UITableView is expected") }
        
        tableView = view
        view.delegate = self
        view.dataSource = self
        
        view.estimatedSectionHeaderHeight = 10
        view.estimatedSectionFooterHeight = 10
        view.estimatedRowHeight = 44
        
        view.sectionHeaderHeight = UITableViewAutomaticDimension
        view.sectionFooterHeight = UITableViewAutomaticDimension
        view.rowHeight = UITableViewAutomaticDimension
        
        view.reloadData()
        view.reloadSections(
            NSIndexSet(indexesIn: NSMakeRange(0, view.dataSource!.numberOfSections!(in: view))) as IndexSet,
            with: .automatic
        )
    }
    
    //MARK: - ReloadableAdapterType
    
    internal func reloadItem(at index: Int, section: Int, animation: UITableViewRowAnimation? = nil) {
        guard let tableView = tableView, section < tableView.numberOfSections, index < tableView.numberOfRows(inSection: section) else { return }
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index, section: section)], with: animation ?? .automatic)
        tableView.endUpdates()
    }
    
    internal func reloadSection(at index: Int, animation: UITableViewRowAnimation? = nil) {
        guard let tableView = tableView, index < tableView.numberOfSections else { return }
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: index), with: animation ?? .automatic)
        tableView.endUpdates()
    }
    
    //MARK: - Private
    
    private weak var tableView: UITableView?
    private var registeredIds: [String] = []
    private enum ViewType {
        case Item, Header, Footer
    }
    
    private func _section(atIndex index: Int) -> CollectionSectionType? {
        guard index < sections.count else { return nil }
        return sections[index]
    }
    
    private func _section(atIndexPath indexPath: IndexPath) -> CollectionSectionType? {
        return _section(atIndex: indexPath.section)
    }
    
    private func _header(atIndex index: Int) -> CollectionItemType? {
        return _item(atIndexPath: IndexPath(item: 0, section: index), viewType: .Header)
    }
    
    private func _footer(atIndex index: Int) -> CollectionItemType? {
        return _item(atIndexPath: IndexPath(item: 0, section: index), viewType: .Footer)
    }
    
    private func _item(atIndexPath indexPath: IndexPath, viewType: ViewType? = .Item) -> CollectionItemType? {
        guard let section = _section(atIndexPath: indexPath) else { return nil }
        
        let item: CollectionItemType?
        switch viewType! {
        case .Item:
            guard indexPath.item < section.items?.count ?? 0 else { return nil }
            item = section.items?[indexPath.item]
        case .Header:
            item = section.header
        case .Footer:
            item = section.footer
        }
        
        guard item != nil else { return nil }
        
        if item!.mapper == nil {
            _ = _resolveMapperForItem(item!, section: section, viewType: viewType)
        }
        
        /// Register views
        let mapper = (item!.mapper)!
        let id = item!.id
        if !registeredIds.contains(id) {
            registeredIds.append(id)
            
            /// Resolve optional nib
            var nib: UINib? = nil
            let className = "\(mapper.targetClass)"
            if Bundle.main.path(forResource: className, ofType: "nib") != nil {
                nib = UINib(nibName: className, bundle: nil)
            }
            
            /// Register class/nib
            switch viewType! {
            case .Item:
                if nib != nil {
                    tableView?.register(nib, forCellReuseIdentifier: id)
                } else {
                    tableView?.register(mapper.targetClass, forCellReuseIdentifier: id)
                }
            case .Header, .Footer:
                if nib != nil {
                    tableView?.register(nib, forHeaderFooterViewReuseIdentifier: id)
                } else {
                    tableView?.register(mapper.targetClass, forHeaderFooterViewReuseIdentifier: id)
                }
            }
        }
        
        return item
    }
    
    private func _resolveMapperForItem(_ item: CollectionItemType, section: CollectionSectionType, viewType: ViewType? = .Item) -> AbstractMapper? {
        if let mapper = item.mapper {
            return mapper
        }
        
        var resolvedMapper: AbstractMapper?
        
        for (_, mapper) in section.mappers.enumerated() {
            if mapper.id == item.id {
                resolvedMapper = mapper
                break
            }
        }
        
        if resolvedMapper == nil {
            for (_, mapper) in mappers.enumerated() {
                if mapper.id == item.id {
                    resolvedMapper = mapper
                    break
                }
            }
        }
        
        if resolvedMapper == nil {
            switch viewType! {
            case .Item:
                resolvedMapper = Mapper<Any, UITableViewCell> { value, cell in
                    cell.textLabel?.text = (value != nil) ? "\(value!)" : nil
                }
            case .Header:
                resolvedMapper = Mapper<Any, TableViewHeaderFooterView> { value, view in
                    view.label.text = (value != nil) ? "\(value!)" : nil
                    view.setNeedsUpdateConstraints()
                    view.invalidateIntrinsicContentSize()
                }
            case .Footer:
                resolvedMapper = Mapper<Any, TableViewHeaderFooterView> { value, view in
                    view.label.text = (value != nil) ? "\(value!)" : nil
                }
            }
        }
        
        item.mapper = resolvedMapper
        
        return resolvedMapper
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = _section(atIndex: section), !section.isHidden else { return 0 }
        return section.items?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = _item(atIndexPath: indexPath as IndexPath) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: item.id) {
                item.mapper?.apply(item.value, to: cell)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = _header(atIndex: section), _section(atIndex: section)?.isHidden != true {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.id) as? TableViewHeaderFooterView {
                headerView.isFirst = (section == 0)
                headerView.tableView = tableView
                header.mapper?.apply(header.value, to: headerView)
                return headerView
            }
        }
        return UITableViewHeaderFooterView()
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = _footer(atIndex: section), _section(atIndex: section)?.isHidden != true {
            if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.id) as? TableViewHeaderFooterView {
                footerView.isFooter = true
                footerView.tableView = tableView
                footer.mapper?.apply(footer.value, to: footerView)
                return footerView
            }
        }
        return UITableViewHeaderFooterView()
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles: [String] = []
        for section in sections {
            if let index = section.index {
                titles.append(index)
            }
        }
        return titles
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return _item(atIndexPath: indexPath as IndexPath)?.editable ?? true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let item = _item(atIndexPath: indexPath as IndexPath) else { return }
        item.commitEditingStyle?(editingStyle, item)
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        guard let item = _item(atIndexPath: indexPath as IndexPath) else { return }
        
        if let handler = item.selectionHandler {
            handler(item)
            return
        }
        
        if let section = _section(atIndex: indexPath.section),
            let handler = section.selectionHandler {
            handler(item)
            return
        }
        
        selectionHandler?(item)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard _header(atIndex: section) != nil else {
            guard tableView.style == .grouped else { return 0 }
            if section > 0, _footer(atIndex: section - 1) != nil {
                return 16
            }
            return 35
        }
        return tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard _footer(atIndex: section) != nil else { return 0 }
        return tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return _item(atIndexPath: indexPath as IndexPath)?.editingStyle ?? .none
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return _item(atIndexPath: indexPath as IndexPath)?.titleForDeleteConfirmationButton
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return _item(atIndexPath: indexPath as IndexPath)?.editActions
    }
}
