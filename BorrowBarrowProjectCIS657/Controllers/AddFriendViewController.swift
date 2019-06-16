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

class AddFriendViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var cityTxtFld: UITextField!
    @IBOutlet weak var address1TxtFld: UITextField!
    @IBOutlet weak var address2TxtFld: UITextField!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var zipTxtFld: UITextField!
    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var friendDescription: UITextView!
    
    var storageRef: StorageReference?
    var cfStoragePath: StorageReference?
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

        friendImageView?.image = chosenImage ?? UIImage(named: "emptyPhoto")
        
        Auth.auth().addStateDidChangeListener { auth, user in if let user = user {
            self.userId = user.uid
            self.storageRef = Storage.storage().reference().child(self.userId!)
            self.cfStoragePath = self.storageRef!.child("comFriendPics")
            //self.registerForFireBaseUpdates()
            }
        }
        
        friendDescription.delegate = self;
        
        friendDescription.text = "Description";
        friendDescription.textColor = UIColor.lightGray;
        
        friendDescription.becomeFirstResponder();
        
        friendDescription.selectedTextRange = friendDescription.textRange(from: friendDescription.beginningOfDocument, to: friendDescription.beginningOfDocument)
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
        
        let url = self.uploadMediaToFireStorage(userId: userId, storageRefWithChilds: cfStoragePath, imageToSave: friendImageView?.image)
        
        //TODO - need to finish calculation logic for lends and items
        let numLendsCalc = 2
        let numItemsCalc = 3
        
        let newComFriend = CommunityFriend(firstName: firstNameTxtFld.text ?? "", lastName: lastNameTxtFld.text ?? "", email: emailTxtFld.text ?? "", phoneNum: phoneTxtField.text ?? "", address1: address1TxtFld.text ?? "", address2: address2TxtFld.text ?? "", city: cityTxtFld.text ?? "", state: stateTxtFld.text ?? "", zipcode: zipTxtFld.text ?? "", trustYesNo: true, friendPhoto: url, numLends: numLendsCalc, numItems: numItemsCalc)

        if let d = self.delegate {
            d.addFriend(newComFriend: newComFriend)
        }
        
        navigationController?.popViewController(animated: true);
        
    }
    
    //Text View Placeholder code from the following:
    //https://stackoverflow.com/questions/27652227/text-view-uitextview-placeholder-swift
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let currentText:String = friendDescription.text;
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if(updatedText.isEmpty)
        {
            friendDescription.text = "Description";
            friendDescription.textColor = UIColor.lightGray;
            
            friendDescription.selectedTextRange = friendDescription.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            
        }
        else if friendDescription.textColor == UIColor.lightGray && !text.isEmpty
        {
            friendDescription.textColor = UIColor.black;
            friendDescription.text = text;
        }
        else{
            return true
        }
        
        return false;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.view.window != nil{
            if friendDescription.textColor == UIColor.lightGray {
                friendDescription.selectedTextRange = friendDescription.textRange(from: friendDescription.beginningOfDocument, to: friendDescription.beginningOfDocument)
            }
        }
    }
    

}
