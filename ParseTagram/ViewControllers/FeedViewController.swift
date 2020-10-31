//
//  FeedViewController.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var feedTableView: UITableView!
    @IBAction func didLogout(_ sender: Any) {
//        UserDefaults.standard.set(false, forKey: LoginViewControllerConstants.loggedInDefaultKey)
        feedModel.logout()
        let loginViewController = storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: false, completion: nil)
        
    }
    
    let tableRefreshControl = UIRefreshControl()
    
    var feedModel = FeedModel()
    var querySize = ParseConstants.queryLimit
    var viewHasAppeared = false
    var isDoneLoading = false
    var numberOfPosts = -1
    
    private let numberOfNonCommentCellsPerPost = 2
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // comments + post + comment entry cell
        return (feedModel.getPost(at: section)?.getNumberOfComments() ?? ((-1*numberOfNonCommentCellsPerPost) + 1)) + numberOfNonCommentCellsPerPost
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch numberOfPosts {
        case 1...:
            let postIndex = indexPath.section
            let rowIndex = indexPath.row - numberOfNonCommentCellsPerPost
            switch rowIndex {
            case 0 - numberOfNonCommentCellsPerPost:
                return dequeFeedCell(index: postIndex)
            case 1 - numberOfNonCommentCellsPerPost:
                return dequeAddCommentCell(postIndex: postIndex)
            default:
                return dequeShowCommentCell(postIndex: postIndex, commentIndex: rowIndex)
            }
        case 0:
            return dequeLoadCell(isLoaded: true)
        default:
            return dequeLoadCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch numberOfPosts {
        case 1...:
            return UITableView.automaticDimension
        default:
            return view.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexPath. roe: ", indexPath.row)
        if indexPath.row+1 >= querySize && isDoneLoading{
            isDoneLoading = false
            querySize += ParseConstants.queryIncrement
            feedModel.getPosts(queryLimit: querySize)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return max(1, numberOfPosts)
    }
    
    func dequeFeedCell(index: Int) -> FeedTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedViewControllerConstants.feedCellId) as! FeedTableViewCell
        if let post = feedModel.getPost(at: index){
            cell.load(profileImage: post.author.picture, username: post.author.name, postImage: post.image, captionText: post.caption)
        }
        return cell
    }
    
    func dequeLoadCell(isLoaded: Bool = false) -> LoadingTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedViewControllerConstants.loadCellId) as! LoadingTableViewCell
        if isLoaded{
            cell.doneLoading()
        } else {
            cell.startLoading()
        }
        return cell
    }
    
    func dequeShowCommentCell(postIndex: Int, commentIndex: Int) -> ShowCommentTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedViewControllerConstants.showCommentCellId) as! ShowCommentTableViewCell
        if let comment = feedModel.getComment(at: commentIndex, forPostAt: postIndex) {
            cell.update(commentText: comment.text, authorName: comment.author.name, authorProfileImage: comment.author.picture)
        }
        return cell
    }
    
    func dequeAddCommentCell(postIndex: Int) -> NewCommentTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedViewControllerConstants.addCommentCellId) as! NewCommentTableViewCell
        cell.id = postIndex
        return cell
    }
    
    func reloadPosts() {
        numberOfPosts = feedModel.getNumberOfPosts()
        feedTableView.reloadData()
    }
    
    @objc func updatePosts() {
        reloadPosts()
    }
    
    @objc func resetPosts() {
        querySize = ParseConstants.queryLimit
        feedModel.getPosts()
        reloadPosts()
        tableRefreshControl.endRefreshing()
    }
    
    @objc func updateComment(_ updateCommentNotification: NSNotification) {
        if let textDict = updateCommentNotification.userInfo {
            guard let text = textDict[commentTextKey] as? String else {return}
            guard let id = textDict[idKey] as? Int else {return}
            guard let post = feedModel.getPost(at: id) else {return}
            guard let postId = post.objectId else {return}
            let comment = Comment(text: text, postId: postId, author: post.author)
            feedModel.storeComment(comment, postPosition: id)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePosts), name: Notification.Name(getPostsNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateComment(_:)), name: Notification.Name(getCommentsNotificationKey), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewHasAppeared = true
        isDoneLoading = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        tableRefreshControl.addTarget(self, action: #selector(resetPosts), for: .valueChanged)
        feedTableView.refreshControl = tableRefreshControl
        
        updateObservers()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == FeedViewControllerConstants.cameraSegue {
            let vc = segue.destination as! CameraViewController
            vc.feedModel = feedModel
        }
    }
    

}
