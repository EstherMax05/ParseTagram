//
//  FeedModel.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import Foundation
import Parse

class Post {
    let image: UIImage
    let caption: String?
    let author: User
    let objectId: String?
    var comments = [Comment]()
    init(image: UIImage, caption: String?, author: User, objectId: String? = nil) {
        self.image = image
        self.caption = caption
        self.author = author
        self.objectId = objectId
    }
    
    func addComment(_ comment: Comment) {
        comments.append(comment)
    }
    func getNumberOfComments() -> Int {
        return self.comments.count
    }
}

struct Comment {
    let text: String
    let postId: String
    let author: User
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
    var posts = [Post](){
        didSet {
            print("DidSet!")
        }
    }
    let query = PFQuery(className: ParseConstants.postsClass)
    var user: User!
    
    func getPosts(queryLimit: Int = ParseConstants.queryLimit) {
        query.includeKeys([ParseConstants.authorKey, ParseConstants.commentsClass.lowercased(), ParseConstants.commentsClass.lowercased()+"."+ParseConstants.authorKey])
        query.limit = queryLimit
        query.findObjectsInBackground { [self] (pfPosts, error) in
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
                        guard let postID = pfPost.objectId else {
                            print("Post ID not found")
                            continue
                        }
                        var authorProfileImage: UIImage?
                        if let authorImageFile = postAuthor[ParseConstants.imageKey] as? PFFileObject, let authorImageUrl = authorImageFile.url {
                            authorProfileImage = self.getImage(url: authorImageUrl)
                        }
                        
                        let postImageFile = pfPost[ParseConstants.imageKey] as! PFFileObject
                        if let postImageUrl = postImageFile.url {
                            let postImage = self.getImage(url: postImageUrl)
                            var currPost = Post(image: postImage!, caption: postCaption, author: User(name: postAuthor.username!, picture: authorProfileImage), objectId: postID)
                            if let pfComments = pfPost[ParseConstants.commentsClass.lowercased()] as? [PFObject] {
                                var comments = [Comment]()
                                for pfComment in pfComments{
                                    do {
                                        try pfComment.fetchIfNeeded()
                                    } catch {
                                        print("Could not fetch")
                                        continue
                                    }
                                    print("commentText: ", pfComment[ParseConstants.textKey])
                                    let commentText = pfComment[ParseConstants.textKey] as! String
                                    let commentAuthor = pfComment[ParseConstants.authorKey] as! PFUser
                                    print("commentAuthor: ", commentAuthor)
                                    do {
                                        try commentAuthor.fetchIfNeeded()
                                    } catch {
                                        print("Could not fetch")
                                        continue
                                    }
                                    
                                    var postAuthorProfileImage: UIImage?
                                    if let postAuthorProfileImageFile = commentAuthor[ParseConstants.imageKey] as? PFFileObject, let authorImageUrl = postAuthorProfileImageFile.url {
                                        postAuthorProfileImage = self.getImage(url: authorImageUrl)
                                    }
                                    
                                    let comment = Comment(text: commentText, postId: pfPost.objectId!, author: User(name: commentAuthor.username!, picture: postAuthorProfileImage))
                                    comments.append(comment)
                                }
                                currPost.comments = comments
                            }
                            tempPosts.append(currPost)
                        } else{
                            print(ParseConstants.errorString1)
                        }
                    }
                    print("Will set! ")
                    self.posts = tempPosts
                    self.notifyObsevers()
                    print("Notified! ")
                }
            }
        }
    }
    
    private func notifyObsevers(){
        NotificationCenter.default.post(name: Notification.Name(getPostsNotificationKey), object: nil)
    }
    
    func logout() {
        PFUser.logOut()
    }
    
    func storePost(_ post: Post) -> (error: String?, success: Bool) {
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
        // FIXME:- storePost will always return (true, String? because save in background will not be done till later
        return (error: errorText, success: returnVal)
    }
    
    func storeComment(_ comment: Comment, postPosition: Int) {
        let query = PFQuery(className: ParseConstants.postsClass)
        query.whereKey(ParseConstants.objectIdKey, contains: comment.postId)
        query.limit = 1
        
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    // The find succeeded.
                    print("Successfully retrieved \(objects.count) scores.")
                    // Do something with the found objects
                    if objects.count != 1{
                        print(ParseConstants.errorString2)
                    }
                    self.saveCommentToPost(comment: comment, post: objects[0], postPosition: postPosition)
                    
            }
        }
    }
    
    private func saveCommentToPost(comment: Comment, post: PFObject, postPosition: Int){
        let pfComment = PFObject(className: ParseConstants.commentsClass)
        pfComment[ParseConstants.textKey] = comment.text
        pfComment[ParseConstants.postKey] = post
        pfComment[ParseConstants.authorKey] = PFUser.current()!
        
        post.add(pfComment, forKey: ParseConstants.commentsClass.lowercased())
        post.saveInBackground { (success, innerError) in
            if !success {
                print(innerError?.localizedDescription as Any)
            } else {
                self.getPost(at: postPosition)?.addComment(comment)
                self.notifyObsevers()
            }
        }
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
    
    func getComment(at commentIndex: Int, forPostAt postIndex: Int) -> Comment? {
        if postIndex < posts.count && postIndex >= 0 {
            let comments = posts[postIndex].comments
            if commentIndex < comments.count && commentIndex >= 0 {
                return comments[commentIndex]
            }
        }
        return nil
    }
    
    private func getPfPost(with objectId: String) {
        let query = PFQuery(className: ParseConstants.postsClass)
        query.whereKey(ParseConstants.objectIdKey, contains: objectId)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    // The find succeeded.
                    print("Successfully retrieved \(objects.count) scores.")
                    // Do something with the found objects
                    for object in objects {
                        print(object.objectId as Any)
                    }
                }
        }
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
