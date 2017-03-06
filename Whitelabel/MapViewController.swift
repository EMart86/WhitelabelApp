//
//  MapViewController.swift
//  Whitelabel
//
//  Created by Martin Eberl on 05.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewModelProtocol {
    var contents: [Content] { get }
    var centerCoordinate: CLLocationCoordinate2D? { get }
    var showUserCoordinate: Bool { get }
}

final class MapViewController: UIViewController {
    class MapItem: NSObject, MKAnnotation {
        let coordinate: CLLocationCoordinate2D
        let title: String?
        let subtitle: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    class func create(_ viewModel: MapViewModelProtocol) -> MapViewController {
        let viewController: MapViewController = StoryboardLoader.MapView.createViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: MapViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    //MARK: - Private Methods
    
    private func setupUI() {
        guard let annotations = annotations else { return }
    
        if let center = viewModel?.centerCoordinate {
            mapView.setCenter(center, animated: true)
        }
        
        mapView.showsUserLocation = viewModel?.showUserCoordinate ?? true
        
        mapView.addAnnotations(annotations)
    }
    
    private func updateUI() {
        
    }
    
    private var annotations: [MKAnnotation]? {
        guard let viewModel = viewModel,
        !viewModel.contents.isEmpty else {
            return nil
        }
        var annotations = [MKAnnotation]()
        //TODO: Add MapItem to annotations
        return annotations
    }
}

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}
