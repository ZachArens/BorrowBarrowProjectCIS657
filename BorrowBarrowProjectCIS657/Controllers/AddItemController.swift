//
//  AddItemController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vong on 6/1/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class AddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 
    @IBOutlet weak var itemImage: UICollectionView!
    
    @IBAction func cameraAddItemBtn(_ sender: Any) {
        self.openCamera();
    }
    
    
    @IBAction func openLibBtn(_ sender: Any) {
    }
    
    let imagePickerCtrl = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerCtrl.delegate = self;

        // Do any additional setup after loading the view.
    }
    
    func openCamera() {
        
        //imagePickerCtrl.delegate;
        imagePickerCtrl.allowsEditing = true;
        imagePickerCtrl.sourceType = .camera;
        //imagePickerCtrl.mediaTypes = ["public.image"]
        present(imagePickerCtrl, animated: true);
    }
    
    /*
     Code for camera from the following sources:
     
        https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
     https://makeapppie.com/2016/06/28/how-to-use-uiimagepickercontroller-for-a-camera-and-photo-library-in-swift-3-0/
     */
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.editedImage] as? UIImage else{
            
            return self.pickerController(picker, didSelect: nil);
        }
        self.pickerController(picker, didSelect: image);
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?){
        controller.dismiss(animated: true, completion: nil);
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




