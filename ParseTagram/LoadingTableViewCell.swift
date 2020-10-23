//
//  LoadingTableViewCell.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet var noPostsLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        noPostsLabel.text = "Loading posts..."
    }
    
    func doneLoading() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.stopAnimating()
        noPostsLabel.text = "No posts to load"
    }

}
