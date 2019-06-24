//
//  PropertyCell.swift
//  Test Apps
//
//  Created by Arief Zainuri on 24/06/19.
//  Copyright © 2019 Arief Zainuri. All rights reserved.
//

import UIKit

class PropertyCell: UICollectionViewCell {
    
    @IBOutlet weak var property: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data: String?{
        didSet{
            if let data = data {
                property.text = data
            }
        }
    }
}
