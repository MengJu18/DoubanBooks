//
//  BookCell.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/24.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var lblBookName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSynopsis: UILabel!
    @IBOutlet weak var lblBookImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
