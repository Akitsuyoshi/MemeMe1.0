//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by 秋山剛 on 2018/03/04.
//  Copyright © 2018 秋山剛. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var toolBar: UIToolbar!
    
    
    let imagePicker = UIImagePickerController()
    
    let memeTextAttributes : [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2
    ]
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        textFieldSet(textf: topTextField, dic: memeTextAttributes)
        textFieldSet(textf: bottomTextField, dic: memeTextAttributes)
    }
    
    func textFieldSet(textf: UITextField, dic: [String: Any]) {
        textf.delegate = self
        textf.contentVerticalAlignment = .center
        textf.textAlignment = .center
        textf.text = (textf == topTextField) ? "TOP": "BOTTOM"
        textf.borderStyle = .none
        textf.backgroundColor = .clear
        textf.defaultTextAttributes = dic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = (uiImageView.image == nil) ? false: true;
        subscribeToKeyboardNotification()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeKeyboardNotification()
    }
    
    // MARK: functions for keyboad notifications
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    // MARK: Actions to choose the image from album, and camera
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        imageSet(sourceType: .savedPhotosAlbum)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        if cameraButton.isEnabled {
            imageSet(sourceType: .camera)
        }
    }
    
    func imageSet(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        if sourceType == .camera {
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func share() {
        if shareButton.isEnabled {
            let img: UIImage = generateMemedImage();
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
            activityViewController.completionWithItemsHandler = {
                (activity, success, items, error) in
                if (success && error == nil) {
                    self.save()
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }else if (error != nil) {
                    print(error!)
                }
            }
        }
    }
    
    func save() {
        
        let meme = Memes(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: uiImageView.image!, memedImage: generateMemedImage())
        
        // this is the code for saving to the app's delegate's memes array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        self.toolBar.isHidden = true
        self.navBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.toolBar.isHidden = false
        self.navBar.isHidden = false
        
        return memedImage
    }
    
    // MARK : - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uiImageView.contentMode = .scaleAspectFit
            uiImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK : - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textAlignment = .center
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
