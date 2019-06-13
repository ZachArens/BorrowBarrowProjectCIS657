//
//  AddItemController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vong on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

protocol AddItemControllerDelegate: class {
    func addItem(newTSItem: ToolShedItem)
}

class AddItemController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDetailsUITextField: UITextView!
    @IBOutlet weak var restrictYNToggle: UISwitch!
    @IBOutlet weak var restrictDetailsTextField: UITextView!
    @IBOutlet weak var tsImageView: UIImageView!
    
    var storageRef: StorageReference?
    var tsStoragePath: StorageReference?
    fileprivate var userId : String? = ""
    var chosenImage: UIImage?

    
    weak var delegate: AddItemControllerDelegate?;
    var imgPickerCtrl: UIImagePickerController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        imgPickerCtrl = UIImagePickerController();
        
        tsImageView?.image = chosenImage ?? UIImage(named: "emptyPhoto")

        Auth.auth().addStateDidChangeListener { auth, user in if let user = user {
            self.userId = user.uid
            self.storageRef = Storage.storage().reference().child(self.userId!)
            self.tsStoragePath = self.storageRef!.child("toolShedPics")
            //self.registerForFireBaseUpdates()
            }
        }
    }
    
    @IBOutlet weak var itemImageViewer: UIImageView!
    
    
    /*
        Camera code and alert based on the following sources:
        https://stackoverflow.com/questions/41717115/how-to-uiimagepickercontroller-for-camera-and-photo-library-in-the-same-time-in
     */
    @IBAction func openCameraBtn(_ sender: UIButton) {
        
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
    
    @IBAction func openPhotoLibBtn(_ sender: UIButton) {
        
        imgPickerCtrl.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imgPickerCtrl.allowsEditing = true;
        imgPickerCtrl.delegate = self;
        present(imgPickerCtrl, animated: true);
    }
    
    
    @IBAction func addItemBtn(_ sender: UIButton) {
        
        
        let newTSItem = ToolShedItem(itemName: itemNameTextField.text ?? "", owner: "owner", itemDescription: itemDetailsUITextField.text ?? "", reqYesNo: restrictYNToggle.isOn, requirements: restrictDetailsTextField.text ?? "", photo: "photo", lentTo: "")
        if let d = self.delegate {
            d.addItem(newTSItem : newTSItem)
        }
        
        self.uploadMediaToFireStorage(userId: userId, storageRefWithChilds: tsStoragePath, imageToSave: chosenImage)
        navigationController?.popViewController(animated: true);

    }
    
    /*Image Picker Code  from sources:
     
        https://stackoverflow.com/questions/24625687/swift-uiimagepickercontroller-how-to-use-it
        https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
     https://www.hackingwithswift.com/example-code/uikit/how-to-take-a-photo-using-the-camera-and-uiimagepickercontroller
     
     */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        itemImageViewer.image = chosenImage;
        dismiss(animated: true, completion: nil)
        //Set Image View to image
        self.itemImageViewer.image = chosenImage;
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
