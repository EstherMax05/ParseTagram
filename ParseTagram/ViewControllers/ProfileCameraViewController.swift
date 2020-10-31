//
//  ProfileCameraViewController.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/30/20.
//

import UIKit

class ProfileCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var profileModel : ProfileModel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var errorNoticeLabel: UILabel!
    @IBAction func submitTapped(_ sender: UIButton) {
        if let image = imageView.image {
            profileModel.updateImage(to: image)
            self.navigationController?.popViewController(animated: true)
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
