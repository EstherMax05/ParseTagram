//
//  FeedModel.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import Foundation
import Parse

struct Post {
    let image: UIImage
    let caption: String?
    let author: User
    init(image: UIImage, caption: String?, author: User) {
        self.image = image
        self.caption = caption
        self.author = author
    }
}

struct User {
    var name : String
    var picture : UIImage?
    
    init(name: String, picture: UIImage?) {
        self.name = name
        self.picture = picture ?? UIImage.init(named: defaultImageName)
    }
}

class FeedModel {
    var posts = [Post]()
    let query = PFQuery(className: ParseConstants.postsClass)
    var user: User!
    
    func getPosts(queryLimit: Int = ParseConstants.queryLimit) {
        query.includeKey(ParseConstants.authorKey)
        query.limit = queryLimit
        query.findObjectsInBackground { (pfPosts, error) in
            if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
            } else {
                if let pfPosts = pfPosts {
                    var tempPosts = [Post]()
                    for pfPost in pfPosts {
                        let postCaption = pfPost[ParseConstants.captionKey] as? String
                        let postAuthor = pfPost[ParseConstants.authorKey] as! PFUser
                        // self.user = User(name: postAuthor.username!, picture: nil)
                        let postImageFile = pfPost[ParseConstants.imageKey] as! PFFileObject
                        if let postImageUrl = postImageFile.url {
                            let postImage = self.getImage(url: postImageUrl)
                            tempPosts.append(Post(image: postImage!, caption: postCaption, author: User(name: postAuthor.username!, picture: nil)))
                        } else{
                            print(ParseConstants.errorString1)
                        }
                    }
                    self.posts = tempPosts
                    NotificationCenter.default.post(name: Notification.Name(getPostsNotificationKey), object: nil)
                }
            }
        }
    }
    
    func storePosts(_ post: Post) -> (error: String?, success: Bool) {
        var returnVal = true
        var errorText : String?
        let pfPost = PFObject(className: ParseConstants.postsClass)
        
        if let imageData = post.image.pngData(), let pfImageData = PFFileObject(data: imageData) {
            pfPost[ParseConstants.imageKey] = pfImageData
        }
        if let caption = post.caption{
            pfPost[ParseConstants.captionKey] = caption
        }
        if let author = PFUser.current(){
            pfPost[ParseConstants.authorKey] =  author
        }
        
        pfPost.saveInBackground { (success, error) in
            if !success {
                returnVal = false
                errorText = error?.localizedDescription as String?
            } else { self.getPosts() }
        }
        return (error: errorText, success: returnVal)
    }
    
    private func getImage(data: Data)->UIImage?{
        return UIImage.init(data: data)
    }
    
    private func getImage(url: String) -> UIImage? {
        if let actualURL = URL(string: url) {
            if let actualImage = try? Data(contentsOf: actualURL) {
                return UIImage(data: actualImage)
            }
        }
        return nil
    }
    
    func getPost(at index: Int) -> Post? {
        if index < posts.count && index >= 0 {
            return posts[index]
        }
        return nil
    }
    
    func getNumberOfPosts() -> Int {
        return posts.count
    }
    
    func getUserName() -> String? {
        return PFUser.current()?.username
    }
    
    init(){
        getPosts()
    }
}
