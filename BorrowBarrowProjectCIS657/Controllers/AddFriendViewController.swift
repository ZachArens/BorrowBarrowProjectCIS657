//
//  AddFriendViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

protocol AddFriendControllerDelegate: class {
    func addFriend(newComFriend: CommunityFriend)
}

class AddFriendViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var storageRef: StorageReference?
    var tsStoragePath: StorageReference?
    fileprivate var userId: String? = ""
    var chosenImage: UIImage?
    
    weak var delegate: AddFriendControllerDelegate?;
    var imgPickerCtrl: UIImagePickerController!;

    @IBAction func cameraFriendBtn(_ sender: UIButton) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imgPickerCtrl.sourceType = .camera
            imgPickerCtrl.allowsEditing = true
            imgPickerCtrl.delegate = self
            present(imgPickerCtrl, animated: true);
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func photoLibFriendBtn(_ sender: UIButton) {
        
        imgPickerCtrl.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imgPickerCtrl.allowsEditing = true;
        imgPickerCtrl.delegate = self;
        present(imgPickerCtrl, animated: true);
    }
    
    @IBOutlet weak var friendImageViewer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPickerCtrl = UIImagePickerController();

//        tsImageView?.image = chosenImage ?? UIImage(named: "emptyPhoto")
        
        Auth.auth().addStateDidChangeListener { auth, user in if let user = user {
            self.userId = user.uid
            self.storageRef = Storage.storage().reference().child(self.userId!)
            self.tsStoragePath = self.storageRef!.child("comFriendPics")
            //self.registerForFireBaseUpdates()
            }
        }
    }
    
    /*Image Picker Code  from sources:
     
     https://stackoverflow.com/questions/24625687/swift-uiimagepickercontroller-how-to-use-it
     https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
     https://www.hackingwithswift.com/example-code/uikit/how-to-take-a-photo-using-the-camera-and-uiimagepickercontroller
     
     */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        friendImageViewer.image = chosenImage;
        dismiss(animated: true, completion: nil)
        //Set Image View to image
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addFriendBtn(_ sender: UIButton) {
        
        //Add if statement to check if logged in
        
        let accountAlert = UIAlertController(title: "Do you have an account?", message: "In order to save your list of friends, you need to login or create an account", preferredStyle: .alert);
        
        accountAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            accountAlert.dismiss(animated: true, completion: nil);
        }))
        
        accountAlert.addAction(UIAlertAction(title: "Login", style: .cancel, handler: {action in
            let signInView = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendView");
            self.present(signInView!, animated: true, completion: nil);
        }))
        
//        let url = self.uploadMediaToFireStorage(userId: userId, storageRefWithChilds: tsStoragePath, imageToSave: tsImageView?.image)
        
//        let newComFriend = CommunityFriend(firstName: String?, lastName: <#T##String?#>, email: <#T##String?#>, phoneNum: <#T##String?#>, address1: <#T##String?#>, address2: <#T##String?#>, city: <#T##String?#>, state: <#T##String?#>, zipcode: <#T##String?#>, trustYesNo: <#T##Bool?#>, friendPhoto: <#T##String?#>)
//
////        (itemName: itemNameTextField.text ?? "", owner: "owner", itemDescription: itemDetailsUITextField.text ?? "", reqYesNo: restrictYNToggle.isOn, requirements: restrictDetailsTextField.text ?? "", photoURL: url, thumbnailURL: "thumbnailURL", lentTo: "")
        if let d = self.delegate {
            d.addFriend(newComFriend: <#T##CommunityFriend#>)
        }
        
        navigationController?.popViewController(animated: true);

        
    }
    

}
