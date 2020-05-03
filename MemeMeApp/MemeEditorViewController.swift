//
//  ViewController.swift
//  MemeMeApp
//
//  Created by Tobias Sattler on 29.03.20.
//  Copyright © 2020 Tobias Sattler. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Enum for Bottom Toolbar buttons
    
    enum BottomToolBarItems: Int {case camera =  1, photoLibrary}
    
    // MARK: Outlets
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageModeToggle: UIBarButtonItem!
    
    // MARK: Additional class properties
    
    var activeTextField: UITextField?
    var memedImage: UIImage?
    
    // MARK: App lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // disable camera button if device has no camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // setup textAttributes for the top and bottom UITextFields
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0
        ]
        
        // Prepare UITextFields (text attributes, alignment, delegate)
        prepareTextField(topTextField, textAttributes: memeTextAttributes)
        prepareTextField(bottomTextField, textAttributes: memeTextAttributes)
        
        // Reset everything to start with a new meme
        prepareNewMeme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Helper functions
    
    func prepareTextField(_ textField:UITextField, textAttributes: [NSAttributedString.Key: Any]) {
        // prepare the given textField style and delegate
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    func prepareNewMeme() {
        // reset image, texts, enabled state of shareButton and memedImage
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFit
        imageModeToggle.image = UIImage(systemName: "rectangle.expand.vertical")
        imageModeToggle.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
        
        memedImage = nil
    }
    
    func toggleToolbars() {
        // show toolbars if hidden - hide them if shown before
        topToolbar.isHidden = !topToolbar.isHidden
        bottomToolbar.isHidden = !bottomToolbar.isHidden
    }
    
    // MARK: Meme handling functions
    
    func save() {
        // creates a Meme object using the previously set class property memedImage
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage!)
        
        // add meme to the appDelegate meme array
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() ->UIImage {
        // hide Toolbars
        toggleToolbars()
        
        // Render image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show Toolbars
        toggleToolbars()
        
        return memedImage
    }
    
    // MARK: IBActions
    @IBAction func toolBarItemAction(_ sender: UIBarButtonItem) {
        
        // Setup the sourceType for the Image Picker depending on which button was clicked
        var sourceType: UIImagePickerController.SourceType!
        switch BottomToolBarItems(rawValue: sender.tag)! {
        case .camera:
            sourceType = .camera
        case .photoLibrary:
            sourceType = .photoLibrary
        }
        
        // Setup UIImagePickerController
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        // generate memed image and set it to the class property memedImage (so that we can use it later again)
        memedImage = generateMemedImage()
        
        // show UIActivityViewController in order to share or save the created Meme
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        // this is needed for iPads
        activityViewController.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func imageModeAction(_ sender: Any) {
        // toggle contentMode of image between scaleAspectFill and scaleAspectFit
        if imageView.contentMode == .scaleAspectFill {
            imageView.contentMode = .scaleAspectFit
            imageModeToggle.image = UIImage(systemName: "rectangle.expand.vertical")
        } else {
            imageView.contentMode = .scaleAspectFill
            imageModeToggle.image = UIImage(systemName: "rectangle.compress.vertical")
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        // if the Cancel-Button of the top Toolbar is clicked, everything needs to be reset to the initial values and editor needs to be closed
        prepareNewMeme()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get the selected / taken image and enable the share + mode Toggle buttons in the Toolbars
        imageView.image = info[.originalImage] as? UIImage
        shareButton.isEnabled = true
        imageModeToggle.isEnabled = true
        
        // close Image Picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clear the text of the text field when editing starts
        textField.text = ""
        
        // store which UITextField is currently being edited (needed for determining whether view needs to be moved in y-direction)
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close Keyboard after pressing return button
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // remove the info, that the UITextField is being edited
        self.activeTextField = nil
    }
    
    // MARK: Keyboard Handling
    
    func subscribeToKeyboardNotifications() {
        // subscribe to the two notifications keyboardWillShow and keyBoardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // remove all Notification Observers that were previously subscribed to
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notfication: Notification) {
        // only move the screen, if bottomTextField is currently active
        if let activeTextField = self.activeTextField, activeTextField == self.bottomTextField {
            view.frame.origin.y = -getKeyboardHeight(notfication)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // reset screen position to y=0 again
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // returns the height of the Keyboard, so that the view can be moved in y-direction accordingly
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

