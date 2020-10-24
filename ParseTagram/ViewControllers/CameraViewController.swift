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
            let storeResult = feedModel.storePosts(post)
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
        let scaledImage = scaleImage(toSize: size, image: image)
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
        
    }
    func scaleImage(toSize newSize: CGSize, image: UIImage) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = image.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
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
