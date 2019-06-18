//
//  EditFriendViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vuong on 6/8/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import FirebaseUI

protocol EditFriendViewControllerDelegate{
    func editFriendViewControllerDelegation(friend: CommunityFriend);
}

class EditFriendViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var firstNameTxtView: UITextField!
    
    @IBOutlet weak var lastNameTxtView: UITextField!
    
    
    @IBOutlet weak var emailTxtView: UITextField!
    
    
    @IBOutlet weak var phoneNumTxtView: UITextField!
    
    
    @IBOutlet weak var cityTxtView: UITextField!
    
    
    @IBOutlet weak var addressTxtView: UITextField!
    
    
    @IBOutlet weak var address2TxtView: UITextField!
    
    @IBOutlet weak var stateTxtView: UITextField!
    
    @IBOutlet weak var zipCodeTxtView: UITextField!
    
    @IBOutlet weak var friendDescriptionTxtView: UITextView!
    
    @IBAction func saveFriendBtn(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func deleteFriend(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true);
    }
   
    
    @IBOutlet weak var editFriendScrollView: UIScrollView!
    
    var friend: CommunityFriend?;
    
    var editFriendDelegation: EditFriendViewControllerDelegate?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFriendInfo();
        // Do any additional setup after loading the view.
        
        let notificationCenter = NotificationCenter.default;
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        friendDescriptionTxtView.delegate = self;
        
        friendDescriptionTxtView.text = "Description";
        friendDescriptionTxtView.textColor = UIColor.lightGray;
        
        friendDescriptionTxtView.becomeFirstResponder();
        
        friendDescriptionTxtView.selectedTextRange = friendDescriptionTxtView.textRange(from: friendDescriptionTxtView.beginningOfDocument, to: friendDescriptionTxtView.beginningOfDocument)
        let _: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dropKeyboard));
    }
    
    /*
     Code for adjusting keyboard from the following source:
     https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard
     */
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            editFriendScrollView.contentInset = .zero
        } else {
            editFriendScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        editFriendScrollView.scrollIndicatorInsets = editFriendScrollView.contentInset
    }
    
    

    func setFriendInfo(){
        
        firstNameTxtView.text = friend?.firstName;
        lastNameTxtView.text = friend?.lastName;
        emailTxtView.text = friend?.email;
        addressTxtView.text = friend?.address1;
        address2TxtView.text = friend?.address2;
        cityTxtView.text = friend?.city;
        stateTxtView.text = friend?.state;
        zipCodeTxtView.text = friend?.zipcode;
        
        
        //friendImageView.image = UIImage(named: ((friend?.friendPhoto!)!)) ?? UIImage(named: "emptyPhoto");
        
        ////Below is the SDWebImage code that just needs to be customized for this page
//        let placeholderImage = UIImage(named: "emptyPhoto")
//        if item.photoURL!.isValidStorageURL() && item.photoURL != nil {
//            let imageRef = Storage.storage().reference(forURL: item.photoURL!)
//            cell.itemPicture?.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
//        } else {
//            cell.itemPicture?.image = placeholderImage
//        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Text View Placeholder code from the following:
    //https://stackoverflow.com/questions/27652227/text-view-uitextview-placeholder-swift
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let currentText:String = friendDescriptionTxtView.text;
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if(updatedText.isEmpty)
        {
            //friendDescriptionTxtView.text = "Description";
            friendDescriptionTxtView.textColor = UIColor.lightGray;
            
            friendDescriptionTxtView.selectedTextRange = friendDescriptionTxtView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            
        }
        else if friendDescriptionTxtView.textColor == UIColor.lightGray && !text.isEmpty
        {
            friendDescriptionTxtView.textColor = UIColor.black;
            friendDescriptionTxtView.text = text;
        }
        else{
            return true
        }
        
        return false;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.view.window != nil{
            if friendDescriptionTxtView.textColor == UIColor.lightGray {
                friendDescriptionTxtView.selectedTextRange = friendDescriptionTxtView.textRange(from: friendDescriptionTxtView.beginningOfDocument, to: friendDescriptionTxtView.beginningOfDocument)
            }
        }
    }
    
    @objc func dropKeyboard(){
        view.endEditing(true);
    }

}
