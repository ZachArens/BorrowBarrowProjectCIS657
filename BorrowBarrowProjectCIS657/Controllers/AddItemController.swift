//
//  AddItemController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vong on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class AddItemController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    var imgPickerCtrl: UIImagePickerController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        imgPickerCtrl = UIImagePickerController();

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var itemImageViewer: UIImageView!
    
    @IBAction func openCameraBtn(_ sender: UIButton) {
        
        imgPickerCtrl.sourceType = .camera
        imgPickerCtrl.allowsEditing = true
        imgPickerCtrl.delegate = self
        present(imgPickerCtrl, animated: true);
    }
    
    @IBAction func openPhotoLibBtn(_ sender: UIButton) {
        
        imgPickerCtrl.sourceType = .photoLibrary;
        imgPickerCtrl.delegate = self;
        present(imgPickerCtrl, animated: true);
    }
    
    
    /*Image Picker Code  from sources:
     
        https://stackoverflow.com/questions/24625687/swift-uiimagepickercontroller-how-to-use-it
        https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
     https://www.hackingwithswift.com/example-code/uikit/how-to-take-a-photo-using-the-camera-and-uiimagepickercontroller
     
     */
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        
        let chosenImg: UIImage = image;
        
        //Set Image View to image
        
        itemImageViewer.image = chosenImg;
        

        
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
