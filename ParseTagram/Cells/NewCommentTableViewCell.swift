//
//  NewCommentTableViewCell.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/30/20.
//

import UIKit

class NewCommentTableViewCell: UITableViewCell {
    var id : Int!
    @IBOutlet var commentTextField: UITextField!
    @IBAction func onTapPost(_ sender: UIButton) {
        commentTextField.resignFirstResponder()
        commentTextField.text = ""
    }
    @IBAction func commentTextFieldDidEndEditing(_ sender: UITextField){
        if let commentText = sender.text {
            if commentText == "" {
                return
            }
            NotificationCenter.default.post(name: Notification.Name(getCommentsNotificationKey), object: nil, userInfo: [commentTextKey: commentText, idKey: self.id])
        }
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
