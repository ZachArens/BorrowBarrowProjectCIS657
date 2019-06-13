//
//  UIViewController+MediaUpload.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/12/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import FirebaseStorage

extension UIViewController {
    // userId:
    func uploadMediaToFireStorage(userId: String?, storageRefWithChilds: StorageReference?, imageToSave : UIImage?) {
        if let image = imageToSave {
            let imageData = image.jpegData(compressionQuality: 0.8)
            let imagePath = "\(userId!)/photos/\(Int(Date.timeIntervalSinceReferenceDate*1000)).jpg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            if let sr = storageRefWithChilds {
                sr.child(imagePath).putData(imageData!, metadata: metadata) {
                    (metadata, error) in if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    let imageRef = sr.child(imagePath)
                    imageRef.downloadURL(completion: { (url, error) in if let error = error {
                        // Handle any errors
                        print("Error getting url to uploaded image: \(error)")
                    } else {
//                        if let str = url?.absoluteString {
//                            saveRefClosure(str)
//                        }
                        
                        }
                        })
                }
            }
        }
    }

}
