//
//  CameraViewController.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/17/20.
//

import UIKit
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var feedModel : FeedModel!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captionText: UITextField!
    @IBOutlet var errorNoticeLabel: UILabel!
    @IBAction func submitTapped(_ sender: UIButton) {
        if let image = imageView.image, let name = feedModel.getUserName() {
            let post = Post(image: image, caption: captionText.text, author: User(name: name, picture: nil))
            let storeResult = feedModel.storePost(post)
            if storeResult.success{
                self.navigationController?.popViewController(animated: true)
            } else {
                self.errorNoticeLabel.text = genericFailMessage
            }
        }
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = Utility.scaleImage(toSize: size, image: image)
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
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
