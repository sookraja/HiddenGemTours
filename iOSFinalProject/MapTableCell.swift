//
//  MapTableCell.swift
//  iOSFinalProject
//
//  Created by Edgar Ponce on 2025-04-13.
//

import UIKit

class MapTableCell: UITableViewCell {

    @IBOutlet var instruction : UILabel!
    @IBOutlet var distance : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
