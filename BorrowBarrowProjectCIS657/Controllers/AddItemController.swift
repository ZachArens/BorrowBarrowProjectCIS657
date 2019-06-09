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
        
        //Add item here
        
    navigationController?.popViewController(animated: true);

    }
    
    /*Image Picker Code  from sources:
     
        https://stackoverflow.com/questions/24625687/swift-uiimagepickercontroller-how-to-use-it
        https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
     https://www.hackingwithswift.com/example-code/uikit/how-to-take-a-photo-using-the-camera-and-uiimagepickercontroller
     
     */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        itemImageViewer.image = chosenImage;
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
    


}
