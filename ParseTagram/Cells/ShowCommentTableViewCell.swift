//
//  CommentTableViewCell.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/30/20.
//

import UIKit

class ShowCommentTableViewCell: UITableViewCell {

    @IBOutlet var commentTextLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.layer.cornerRadius = authorImageView.frame.height/2
        authorImageView.layer.borderWidth = FeedTableViewCellConstants.imageBorderWidth
        authorImageView.layer.borderColor = FeedTableViewCellConstants.imageBorderColor
    }
    
    func update(commentText: String, authorName: String, authorProfileImage: UIImage?) {
        self.commentTextLabel.text = commentText
        self.nameLabel.text = authorName
        if let authorProfileImage = authorProfileImage{
            self.authorImageView.image = authorProfileImage
        }
        setNeedsDisplay()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
