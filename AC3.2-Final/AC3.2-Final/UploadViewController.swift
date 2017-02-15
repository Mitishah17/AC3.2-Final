//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Miti Shah on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var uploadTextView: UITextView!
    @IBOutlet weak var uploadImageView: UIImageView!
    var databaseReference: FIRDatabaseReference!
    var user: FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.databaseReference = FIRDatabase.database().reference().child("images")
        FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
            if let error = error {
                print(error)
            } else {
                self.user = user
            }
        })
        handleTap()
       


    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [ String(kUTTypeImage) ]
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion:  nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info ["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[" UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadImageView.image = selectedImage
            sendToStorage()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

    
       func sendToStorage() {
        // add name to message and then data to firebase database
     

                let linkRef = self.databaseReference.childByAutoId()
                //let image = UIImage(cgImage: uploadImageView.image as! CGImage)
                let storage = FIRStorage.storage()
                let storageRef = storage.reference()
                var spaceRef = storageRef.child("images/\(linkRef.key))")
                let jpeg = UIImageJPEGRepresentation(uploadImageView.image!, 0.5)
                
                
                let metadata = FIRStorageMetadata()
                metadata.cacheControl = "public,max-age=300";
                metadata.contentType = "image/jpeg";
                
                
                let _ = spaceRef.put(jpeg!, metadata: nil) { (metadata, error) in
                    guard metadata != nil else {
                        print("put error")
                        return
                    }
                let link = Link(key: linkRef.key, userID: (self.user?.uid)!, comment: self.uploadTextView.text)
                let dict = link.asDictionary
                
                // Put in Database
                linkRef.setValue(dict) { (error, reference) in
                    if let error = error {
                        print(error)
                    } else {
                        print(reference)
                        
                        //Put in Storage
                        self.dismiss(animated: true, completion: nil)
                    }
                    }
                }
 
        }


    @IBAction func UploadAction(_ sender: UIBarButtonItem) {
        sendToStorage()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
