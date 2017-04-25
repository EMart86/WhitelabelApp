//
//  MasterViewModel.swift
//  Whitelabel
//
//  Created by Martin Eberl on 27.02.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import CoreLocation
import ObjectMapper

class MasterViewModel: MasterViewModelProtocol {
    internal func load() {}
    
    private let loader: ContentLoader?
    fileprivate let locationProvider: LocationProvider?
    
    let title = "Master"
    
    private(set) var content: [Time]?
    private(set) var sections: [Section]?
    private(set) var isLoading: Bool = false
    private var timer: Timer?
    private let timeStore: TimeStore
    
    weak var delegate: MasterViewModelDelegate?
    
    init(loader: ContentLoader? = nil, locationProvider: LocationProvider? = nil, timeStore: TimeStore) {
        self.loader = loader
        self.locationProvider = locationProvider
        self.timeStore = timeStore
        content = timeStore.models()?.value
        
        timeStore.models()?.onValueChanged {[weak self] (models: [Time]) in
            self?.content = models
            self?.delegate?.signalUpdate()
        }
        
        if LocationProvider.authorizationStatus == .authorizedWhenInUse {
            locationProvider?.delegate = self
        }
    }
    
    init(content: [Any], timeStore: TimeStore) {
        self.content = nil
        self.loader = nil
        self.locationProvider = nil
        self.timeStore = timeStore
    }
    
//    func load() {
//        guard let loader = loader else { return }
//        
//        locationProvider?.startLocationUpdate()
//        
//        isLoading = true
//        delegate?.signalUpdate()
//        
//        loader.load(contentResponse: {[weak self] response in
//            self?.isLoading = false
//            switch response {
//            case .success(let content):
//                self?.content = content
//                self?.setupContent()
//                break
//            case .fail(let error):
//                self?.content = nil
//                self?.setupContent()
//                break
//            }
//            self?.delegate?.signalUpdate()
//        })
//    }
    
    var numberOfItems: Int? {
        guard let sections = sections else {
            return nil
        }
        return sections.count
    }
    
    func nuberOfCellItems(at index: Int) -> Int {
        guard let section = section(at: index) else {
            return 0
        }
        
        return section.content?.count ?? 0
    }
    
    func sectionViewModel(at index: Int) -> OverviewHeaderView.ViewModel? {
        guard
            let section = section(at: index),
            let title = section.title else {
                return nil
        }
        
        return OverviewHeaderView.ViewModel(title: title, buttonTitle: section.action)
    }
    
    func numberOfCells(at index: Int) -> Int? {
        guard let section = section(at: index) else {
            return nil
        }
        
        return section.content?.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> ViewCell.ViewModel? {
        guard let section = section(at: indexPath.section),
            let contents = section.content,
            contents.indices.contains(indexPath.row) else {
                return nil
        }
        
        let content = contents[indexPath.row]
        
        return ViewCell.ViewModel(
            imageUrl: nil,
            title: "",
            description: "",
            distance: nil)
    }
    
    func did(change searchText: String) {
        //TODO: filter text by search text
        delegate?.signalUpdate()
    }
    
    func didCloseSearch() {
        setupContent()
        delegate?.signalUpdate()
    }
    
    //MARK: - Private Methods
    
    
    private func section(at index: Int) -> Section? {
        guard let sections = sections,
            sections.indices.contains(index) else {
                return nil
        }
        return sections[index]
    }
    
    private func setupContent() {
        if loader != nil {
            sections = [
                Section(title: "Section 1", action: "Show more", content: nil)
            ]
        }
    }
    
    private func stopLocationUpdates() {
        locationProvider?.endLocationUpdate()
    }
    
    fileprivate func stopLocationUpdates(after seconds: TimeInterval) {
        guard timer == nil else {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: {[weak self] _ in
            self?.timer = nil
            
            self?.stopLocationUpdates()
        })
    }
}

extension MasterViewModel: OverviewHeaderViewDelegate {
    func didPressButton(overview: OverviewHeaderView) {
    }
}

extension MasterViewModel: LocationProviderDelegate {
    func didUpdate(authorizationStatus: CLAuthorizationStatus) {}
    func didUpdate(location: CLLocation) {
        delegate?.signalUpdate()
        
        stopLocationUpdates(after: 10)
    }
}
