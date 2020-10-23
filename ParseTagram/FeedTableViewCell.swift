//
//  FeedTableViewCell.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var postedImageView: UIImageView!
    @IBOutlet var userNameCaptionLabel: UILabel!
    @IBOutlet var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    func load(profileImage: UIImage?, username: String, postImage: UIImage, captionText: String?) {
        print("fasdfksajlajksd")
        print("fasdfksajlajksd: username ", username)
        if let image = profileImage{
            profileImageView.image = image
        }
        userNameLabel.text = username
        userNameCaptionLabel.text = username
        postedImageView.image = postImage
        if let caption = captionText {
            captionLabel.text = caption
        } else {
            captionLabel.text = ""
        }
        self.setNeedsDisplay()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
