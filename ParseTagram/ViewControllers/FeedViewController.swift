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
        UserDefaults.standard.set(false, forKey: LoginViewControllerConstants.loggedInDefaultKey)
        self.dismiss(animated: true, completion: nil)
    }
    
    let tableRefreshControl = UIRefreshControl()
    
    var feedModel = FeedModel()
    var querySize = ParseConstants.queryLimit
    var viewHasAppeared = false
    var isDoneLoading = false
    var numberOfPosts = -1{
        didSet {
            feedTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, numberOfPosts)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch numberOfPosts {
        case 1...:
            return dequeFeedCell(index: indexPath.row)
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
    func dequeFeedCell(index: Int) -> FeedTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedViewControllerConstants.feedCellId) as! FeedTableViewCell
        if let post = feedModel.getPost(at: index){
            cell.load(profileImage: nil, username: post.author.name, postImage: post.image, captionText: post.caption)
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
    
    func updateObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePosts), name: Notification.Name(getPostsNotificationKey), object: nil)
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
