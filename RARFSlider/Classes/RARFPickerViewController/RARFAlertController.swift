//
//  RARFAlertController.swift
//  Nimble
//
//  Created by 永田大祐 on 2019/04/10.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
final class RARFAlertObject: NSObject {

    func alertSave(views: UIViewController, title: String,exporter: AVAssetExportSession, composition: RARFMutableComposition) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let stringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
            .font : UIFont.systemFont(ofSize: 22.0)
        ]
        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
        alertController.setValue(string, forKey: "attributedTitle")
        alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)
        let noBt = UIAlertAction(title: "No", style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
        }
        let okBt = UIAlertAction(title: "OK", style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            composition.exportDidFinish(exporter)
        }
        alertController.addAction(noBt)
        alertController.addAction(okBt)
        views.present(alertController, animated: true, completion: nil)
    }

    func alertSave(views: UIViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("Failed", comment: ""), message: "", preferredStyle: .alert)
        let stringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
            .font : UIFont.systemFont(ofSize: 22.0)
        ]
        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
        alertController.setValue(string, forKey: "attributedTitle")
        alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)
        let okBt = UIAlertAction(title: "OK", style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okBt)
        views.present(alertController, animated: true, completion: nil)
    }
}
