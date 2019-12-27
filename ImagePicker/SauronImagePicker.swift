//
//  SauronImagePicker.swift
//  aaaa
//
//  Created by Horacio Guzman on 11/20/18.
//  Copyright © 2018 Horacio Guzman. All rights reserved.
//

import Foundation
import UIKit
import AVKit

@objc public protocol SauronImagePickerDelegate{
    @objc func SauronImagePickerDelegateDidSelect(_ image: UIImage)
    @objc func SauronImagePickerDelegateUserCancel()
    @objc func SauronImagePickerDelegateError(error: Error)
}

open class SauronImagePicker: NSObject{
    
    @objc public var viewController: UIViewController?
    @objc public var delegate: SauronImagePickerDelegate?
    private var picker = UIImagePickerController()
    
    public init<T: UIViewController>(contex viewController: T) where T: SauronImagePickerDelegate {
        self.viewController = viewController
        self.delegate = viewController
    }
    
    public override init() {
        super.init()
    }
    
    @objc public func present(){
        
        self.picker.sourceType = .camera
        self.picker.delegate = self
        
        if self.checkIfDescriptionIsPresent() == true{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                if CameraPermissionStatus() == true{
                    DispatchQueue.main.async {
                        self.viewController?.present(self.picker, animated: true, completion: nil)
                    }
                }else{
                    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined{
                        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (ok) in
                            //print("Ok: \(ok)")
                            if ok == true{
                                DispatchQueue.main.async {
                                    self.viewController?.present(self.picker, animated: true, completion: nil)
                                }
                            }
                        }
                    }else{
                        PresentCameraSettings()
                    }
                }
            }else{
                self.delegate?.SauronImagePickerDelegateError(error: SauronError(description: "This device doesnt allow camera"))
            }
        }else{
            self.delegate?.SauronImagePickerDelegateError(error: SauronError(description: "You must add camera usage description in Info.plist"))
        }
        
        
    }
    
    private func checkIfDescriptionIsPresent()->Bool{
        if let url =  Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let myDict = NSDictionary(contentsOf: url) as? [String:Any],
                let _ = myDict["NSCameraUsageDescription"] as? String{
            return true
        }else{
            return false
        }
    }
    
    private func CameraPermissionStatus()->Bool{
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            return true
        case .denied:
            return false
        case .notDetermined:
            return false
        case .restricted:
            return false
        }
    }
    
    private func PresentCameraSettings(){
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        // Handle
                    })
                }
            }
        })
        DispatchQueue.main.async {
            self.viewController?.present(alertController, animated: true) {
                
            }
        }
    }
}

extension SauronImagePicker: UIImagePickerControllerDelegate{
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ////print("User cancel")
        self.picker.dismiss(animated: true, completion: {
            self.delegate?.SauronImagePickerDelegateUserCancel()
        })
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ////print("User select")
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if SauronAnalytics.AllowSendPhotos(){
                let stringImage = tempImage.resizeImage(newWidth: 150.0)._64baseEncoded()
                if NetworkManager.canSendPhoto() {
                    NetworkService.sendImages(images: [stringImage]) { (error) in
                        if error != nil{
                            //print("Error uploading taken image")
                            //print(error?.localizedDescription ?? "Error uploading")
                            PersistanceService.shared.savePhoto(string: stringImage)
                        }else{
                            //print("Image uploaded")
                        }
                    }
                }else{
                    PersistanceService.shared.savePhoto(string: stringImage)
                }
            }else{
                //print("Dont allowed to send photos")
            }
            self.picker.dismiss(animated: true, completion: {
                self.delegate?.SauronImagePickerDelegateDidSelect(tempImage)
            })
        }else{
            self.picker.dismiss(animated: true, completion: {
                
            })
        }
    }
}

extension SauronImagePicker: UINavigationControllerDelegate{
    
}
