//
//  HistoryCell.swift
//  PennLabs
//
//  Created by Matthew Riley on 2017-02-11.
//  Copyright © 2017 Matthew Riley. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setText(text: String) {
        nameLabel.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
