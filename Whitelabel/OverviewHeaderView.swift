//
//  OverviewHeaderView.swift
//  Whitelabel
//
//  Created by Martin Eberl on 01.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

protocol OverviewHeaderViewDelegate: class {
    func didPressButton(overview: OverviewHeaderView)
}

final class OverviewHeaderView: UITableViewHeaderFooterView, XibLoadable {
    static let xibName = "OverviewHeaderView"
    
    struct ViewModel {
        let title: String
        let buttonTitle: String?
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: OverviewHeaderViewDelegate?
    var viewModel: ViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            button.setTitle(viewModel?.buttonTitle, for: .normal)
            
            applyColor()
        }
    }
    
    func applyColor() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    @IBAction func didPressButton(_ sender: Any) {
        if viewModel?.buttonTitle != nil {
            delegate?.didPressButton(overview: self)
        }
    }
}
