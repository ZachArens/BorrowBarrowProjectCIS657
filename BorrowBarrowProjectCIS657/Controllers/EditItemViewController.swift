//
//  EditItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vuong on 6/8/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//
import UIKit
import SDWebImage
import FirebaseUI
import FirebaseAuth
protocol EditItemViewControllerDelegate{
    func returnEditedItemDelegation(item: ToolShedItem, index: Int?);
}
class EditItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextView: UITextField!
    @IBOutlet weak var itemDetailsTextView: UITextView!
    
    
    @IBAction func toggleRequests(_ sender: UISwitch) {
        item?.reqYesNo = sender.isOn;
    }
    
    
    @IBOutlet weak var restrictionsTextView: UITextView!
    
    @IBAction func photoLibBtn(_ sender: UIButton) {
        imgPickerCtrl.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imgPickerCtrl.allowsEditing = true;
        imgPickerCtrl.delegate = self;
        present(imgPickerCtrl, animated: true);
    }
    
    @IBAction func cameraBtn(_ sender: UIButton) {
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
    
    //    @IBAction func toggleRequests(_ sender: UISwitch) {
    //    }
    
    
    var imgPickerCtrl: UIImagePickerController!;
    
    var editItemDelegate: EditItemViewControllerDelegate?;
    
    var item: ToolShedItem?;
    var itemIndex: Int?
    
    var userId: String?
    var tsStoragePath: StorageReference?
    
    var storageRef: StorageReference?
    var chosenImage: UIImage?
    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        //Save to database and popViewCtrl
        item?.itemName = itemNameTextView.text;
        item?.itemDescription = itemDetailsTextView.text;
        item?.requirements = restrictionsTextView.text;
        
        item?.photoURL = self.uploadMediaToFireStorage(userId: userId, storageRefWithChilds: tsStoragePath, imageToSave: itemImageView?.image);
        editItemDelegate?.returnEditedItemDelegation(item: item!, index: itemIndex);
        
        _ = navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        
        //Remove item from database and popViewCtrl
        
        _ = navigationController?.popViewController(animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        super.viewDidLoad();
        imgPickerCtrl = UIImagePickerController();
        
        Auth.auth().addStateDidChangeListener { auth, user in if let user = user {
            self.userId = user.uid
            let storageRef = Storage.storage().reference().child(self.userId!)
            self.tsStoragePath = storageRef.child("toolShedPics")
            //self.registerForFireBaseUpdates()
            }
        }
        
        setItemInfo();
        // Do any additional setup after loading the view.
    }
    
    
    func setItemInfo()
    {
        
        //itemImageView.image = UIImage(named: (item?.photoURL!)!) ?? UIImage(named: "emptyPhoto");
        
        let placeholderImage = UIImage(named: "emptyPhoto")
        if item!.photoURL!.isValidStorageURL() && item!.photoURL != nil {
            let imageRef = Storage.storage().reference(forURL: item!.photoURL!)
            itemImageView?.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
        } else {
            itemImageView?.image = placeholderImage
        }
        itemNameTextView.text = item!.itemName;
        let index = "Index is \(itemIndex ?? -1)"
        let itemDescriptText = "\(item!.itemDescription ?? "")" ;
        itemDetailsTextView.text = itemDescriptText
        itemDetailsTextView.text = item!.requirements
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        itemImageView.image = chosenImage;
        dismiss(animated: true, completion: nil)
        //Set Image View to image
        //        self.itemImageViewer.image = chosenImage;
    }
}
