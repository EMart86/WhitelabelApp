//
//  MasterViewController.swift
//  Whitelabel
//
//  Created by Martin Eberl on 27.02.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

protocol MasterViewModelProtocol: OverviewHeaderViewDelegate {
    var title: String { get }
    var isLoading: Bool { get }
    func load()
    var delegate: MasterViewModelDelegate? { get set }
    
    var numberOfItems: Int? { get }
    func sectionViewModel(at index: Int) -> OverviewHeaderView.ViewModel?
    func numberOfCells(at index: Int) -> Int?
    func cellViewModel(at indexPath: IndexPath) -> ViewCell.ViewModel?
    
    func did(change searchText: String)
    func didCloseSearch()
}

protocol MasterViewModelDelegate: class {
    func signalUpdate()
    func showMap(with contents: [Content])
    func showList(with contents: [Content])
}

public class MasterViewController: UITableViewController, UISearchBarDelegate {

    var detailViewController: DetailViewController? = nil

    var viewModel: MasterViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
            viewModel?.load()
        }
    }
    
    class func create(_ viewModel: MasterViewModelProtocol) -> MasterViewController {
        let viewController: MasterViewController = StoryboardLoader.ListView.createViewController()
        viewController.viewModel = viewModel
        return viewController
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    //MARK: - Helper
    
    private func setupUI() {
        refresh()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.registerHeaderFooterView(xibLoadable: OverviewHeaderView.self)
        tableView.registerCell(xibLoadable: ViewCell.self)
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    @objc private func refresh() {
        viewModel?.load()
    }
    
    fileprivate func updateUI() {
        navigationItem.title = viewModel?.title
        
        if let refreshing = viewModel?.isLoading, refreshing {
            tableView.refreshControl?.beginRefreshing()
        } else {
            tableView.refreshControl?.endRefreshing()
        }
        
        tableView.reloadData()
        
        guard let viewModel = viewModel else { return }
        
        if let count = viewModel.numberOfItems, count > 0 {
            tableView.backgroundColor = .white
        }
        
    }

    // MARK: - Segues

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            }
        }
    }

    // MARK: - Table View
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfItems ?? 0
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfCells(at: section) ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = viewModel?.sectionViewModel(at: section) else {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let view = tableView.dequeueHeaderFooterView(OverviewHeaderView.self) as? OverviewHeaderView,
            let sectionViewModel = viewModel?.sectionViewModel(at: section) else {
            return nil
        }
        view.viewModel = sectionViewModel
        view.delegate = viewModel
        return view
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: ViewCell = tableView.dequeueCell(),
            let cellViewModel = viewModel?.cellViewModel(at: indexPath) else {
                return UITableViewCell()
        }
        cell.viewModel = cellViewModel
        return cell
    }
    
    //MARK: - UISearchBar Delegate
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.did(change: searchText)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        viewModel?.didCloseSearch()
    }
}

extension MasterViewController: MasterViewModelDelegate {
    func signalUpdate() {
        updateUI()
    }
    
    func showMap(with content: [Content]) {
        let viewModel = MapViewModel(contents: content)
        let viewController = MapViewController.create(viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showList(with content: [Content]) {
        let viewModel = MasterViewModel(content: content)
        let viewController = MasterViewController.create(viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
