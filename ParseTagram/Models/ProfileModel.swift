//
//  ProfileModel.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/30/20.
//

import Foundation
import Parse

class ProfileModel {
    let user = PFUser.current()!
    var postImages = [UIImage]()
    func updateImage(to image: UIImage) {
        if let imageData = image.pngData(), let pfImageData = PFFileObject(data: imageData) {
//            user[ParseConstants.imageKey] = pfImageData
            user.setValue(pfImageData, forKey: ParseConstants.imageKey)
            user.saveInBackground { (success, error) in
                if !success {
                    guard let errorMsg = error?.localizedDescription else {return}
                    print(errorMsg)
                } else {
                    self.notifyObsevers()
                }
                
            }
        }
    }
    
    func getUserName() -> String {
        return user.username ?? ""
    }
    
    func retrieveProfileImage() -> UIImage? {
        guard let profileImageFile = user[ParseConstants.imageKey] as? PFFileObject else {return nil}
        guard let profileImageUrl = profileImageFile.url else { return nil }
        return Utility.getImage(url: profileImageUrl)
    }
    
    func getPosts(queryLimit: Int = ParseConstants.queryLimit) {
        let query = PFQuery(className: ParseConstants.postsClass)
        query.includeKey(ParseConstants.authorKey)
//        query.whereKey(ParseConstants.objectIdKey, contains: user.objectId)
        query.limit = queryLimit
        query.findObjectsInBackground { [self] (pfPosts, error) in
            if let error = error{
                // Log details of the failure
                print(error.localizedDescription)
                return
            }
            if let pfPosts = pfPosts {
                var tempPostImages = [UIImage]()
                for pfPost in pfPosts {
                    let postImageFile = pfPost[ParseConstants.imageKey] as! PFFileObject
                    if let postImageUrl = postImageFile.url, let postImage = Utility.getImage(url: postImageUrl){
                            tempPostImages.append(postImage)
                    } else {
                        print(ParseConstants.errorString1)
                    }
                }
                self.postImages = tempPostImages
                notifyObsevers()
            }
        }
    }
    
    private func notifyObsevers(){
        NotificationCenter.default.post(name: Notification.Name(profileUpdatedNotificationKey), object: nil)
    }
}
