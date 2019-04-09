//
//  RARFImagePickerModel.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2019/03/17.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

public final class RARFImagePickerModel: NSObject {

    public func mediaSegue(vc: UIViewController,bool: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let pic = UIImagePickerController()
            if bool == true { pic.mediaTypes = [kUTTypeMovie as String] }
            pic.allowsEditing = false
            pic.delegate = (vc as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            vc.present(pic, animated: true)
        }
    }
}
