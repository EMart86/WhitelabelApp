//
//  ClubViewCell.swift
//  Whitelabel
//
//  Created by Martin Eberl on 02.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit
import Kingfisher

final class ViewCell: UITableViewCell, XibLoadable {
    static var xibName = "ClubViewCell"
    
    struct ViewModel {
        let imageUrl: URL?
        let title: String
        let description: String
        let distance: String?
    }
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImageView.layer.cornerRadius = cellImageView.frame.width / 2
        cellImageView.clipsToBounds = true
    }
    
    var viewModel: ViewModel? {
        didSet {
            cellImageView.isHidden = false
            cellImageView.kf.setImage(with: viewModel?.imageUrl, completionHandler: {[weak self] (image, error, cacheType, imageURL) in
                
                self?.cellImageView.isHidden = image == nil
            })
            
            titleLabel.text = viewModel?.title
            descriptionLabel.text = viewModel?.description
            
            if let _ = viewModel?.distance {
                distanceLabel.isHidden = false
            } else {
                distanceLabel.isHidden = true
            }
            
            distanceLabel.text = viewModel?.distance
        }
    }
}
