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
        self.picture = picture ?? UIImage.init(named: "person.circle.fill")
    }
}

class FeedModel {
    var posts = [Post]()
    let query = PFQuery(className: "Posts")
    var user: User!
    
    func getPosts(queryLimit: Int = 20) {
        query.includeKey("author")
        query.limit = queryLimit
        query.findObjectsInBackground { (pfPosts, error) in
            if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
            } else {
                if let pfPosts = pfPosts {
                    var tempPosts = [Post]()
                    for pfPost in pfPosts {
                        let postCaption = pfPost["caption"] as? String
                        let postAuthor = pfPost["author"] as! PFUser
                        // self.user = User(name: postAuthor.username!, picture: nil)
                        let postImageFile = pfPost["image"] as! PFFileObject
                        if let postImageUrl = postImageFile.url {
                            let postImage = self.getImage(url: postImageUrl)
                            tempPosts.append(Post(image: postImage!, caption: postCaption, author: User(name: postAuthor.username!, picture: nil)))
                        } else{
                            print("postless post found")
                        }
                    }
                    self.posts = tempPosts
                }
            }
        }
    }
    
    func storePosts(_ post: Post) -> Bool {
        var returnVal = true
        let pfPost = PFObject(className: "Posts")
        
        if let imageData = post.image.pngData(), let pfImageData = PFFileObject(data: imageData) {
            pfPost["image"] = pfImageData
        }
        if let caption = post.caption{
            pfPost["caption"] = caption
        }
        if let author = PFUser.current(){
            pfPost["author"] =  author
        }
        
        pfPost.saveInBackground { (success, error) in
            if !success {
                returnVal = false
            }
        }
        return returnVal
    }
    
    func createUser(with username: String, and password: String) -> (String?, Bool) {
        var errorText: String?
        var wasSuccessful = true
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackground { (succeeded, error) in
            if let error = error as NSError? {
              let errorString = error.userInfo["error"] as? NSString
              // Show the errorString somewhere and let the user try again.
              print("Error! ", errorString)
                errorText = errorString as String?
                wasSuccessful = false
            }
        }
        return (errorText, wasSuccessful)
    }
    
    func login(with username: String, and password: String) -> (String?, Bool)  {
        var errorText: String?
        var wasSuccessful = true
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user == nil {
              // The login failed. Check error to see why.
                print("Error! ", error?.localizedDescription)
                errorText = error?.localizedDescription as String?
                wasSuccessful = false
            }
        }
        return (errorText, wasSuccessful)
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
    
    init(){
        getPosts()
    }
}
