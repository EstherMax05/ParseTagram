//
//  FeedViewController.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var feedTableView: UITableView!
    var feedModel = FeedModel()
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
    
    func dequeFeedCell(index: Int) -> FeedTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
        print("post: ", feedModel.getPost(at: index))
        if let post = feedModel.getPost(at: index){
            cell.load(profileImage: nil, username: post.author.name, postImage: post.image, captionText: post.caption)
        }
        return cell
    }
    
    func dequeLoadCell(isLoaded: Bool = false) -> LoadingTableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "loadCell") as! LoadingTableViewCell
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedModel.getPosts()
        reloadPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
