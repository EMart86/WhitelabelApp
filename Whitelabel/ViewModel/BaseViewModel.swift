//
//  BaseViewModelCallback.swift
//  Costplanner
//
//  Created by Martin Eberl on 23.05.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

protocol BaseViewModelCallback: class {
    func signalUpdate()
}

protocol BaseViewModel {

}

protocol BaseViewModelDelegate {
    weak var delegate: BaseViewModelCallback? { get set }
    
    func signalUpdate()
}

internal protocol InternalBaseViewModelObservable {
    var observers: [ObserverBlock<Any>]? { get set }
    
    func add(observer: Any & BaseViewModelCallback)
    func remove(observer: Any & BaseViewModelCallback)
    
    func signalUpdate()
}

protocol BaseViewModelObservable: InternalBaseViewModelObservable {
    var observers: [ObserverBlock<Any>]? { get }
    
    func add(observer: Any & BaseViewModelCallback)
    func remove(observer: Any & BaseViewModelCallback)
    
    func signalUpdate()
}

extension BaseViewModelDelegate {
    func signalUpdate() {
        delegate?.signalUpdate()
    }
}

extension InternalBaseViewModelObservable {
    mutating func add(observer: Any & BaseViewModelCallback) {
        guard !contains(observer: observer) else { return }
        observers?.append(ObserverBlock(object: observer))
    }
    
    private func index(of observer: AnyClass) -> Int? {
        return observers?.index{ if let object = $0.object as? AnyClass { return object == observer } else { return false } }
    }
    
    private func contains(observer: Any & BaseViewModelCallback) -> Bool {
        guard let obsererClass: AnyClass = observer as? AnyClass else { return false }
        return index(of: obsererClass) != nil
    }
    
    mutating func remove(observer: Any & BaseViewModelCallback) {
        guard let obsererClass: AnyClass = observer as? AnyClass ,
            let index = index(of: obsererClass) else { return }
        observers?.remove(at: index)
    }
    
    func signalUpdate() {
        observers?.forEach { if let observer = $0.object as? BaseViewModelCallback { observer.signalUpdate() } }
    }
}
