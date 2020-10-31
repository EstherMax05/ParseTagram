//
//  ProfileViewController.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/30/20.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let profileModel = ProfileModel()
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var profileCollectionView: UICollectionView!
    @IBAction func didTapProfileImage(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: ProfileViewControllerConstants.cameraViewSegueId, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileModel.postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewControllerConstants.imageCellId, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = profileModel.postImages[indexPath.row]
        return cell
    }
    
    func updateLayout() {
        let layout = profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cellsPerRow : CGFloat = 4
        let width = (view.frame.width - (layout.minimumInteritemSpacing * (cellsPerRow-1)) - 16)/cellsPerRow
        layout.itemSize = CGSize(width: width, height: (3/2) * width)
        
    }
    
    @objc func updateView() {
        profileImageView.image = profileModel.retrieveProfileImage()
        userNameLabel.text = profileModel.getUserName()
        profileCollectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name(profileUpdatedNotificationKey), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.height/10
        userNameLabel.text = ""
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        // Do any additional setup after loading the view.
        updateObservers()
        updateLayout()
        profileModel.getPosts()
        profileCollectionView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == ProfileViewControllerConstants.cameraViewSegueId {
            let profileCameraViewController = segue.destination as! ProfileCameraViewController
            profileCameraViewController.profileModel = profileModel
        }
    }
    

}
