import UIKit
import AVKit
import AVFoundation
import MLKit

import MobileCoreServices

class ViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imm = UIImage()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    @IBAction func pushed(_ sender: Any) {
        showPhotoMenu()
    }
    func showPhotoMenu() {
        
      let alert = UIAlertController(title: nil, message: nil,
                           preferredStyle: .actionSheet)

      let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
                                  handler: nil)
      alert.addAction(actCancel)

      let actLibrary = UIAlertAction(title: "Choose From Library",
                                     style: .default, handler: { (UIAlertAction) in
                                        //api call, buyVoucher
                                        self.choosePhotoFromLibrary()
                                })
      alert.addAction(actLibrary)

      present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "seg")
            {
                let nextVC = segue.destination as! ImVC
                nextVC.im3 = imm
            }
    }
    func choosePhotoFromLibrary() {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .photoLibrary
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info:
                       [UIImagePickerController.InfoKey : Any]) {

        imm = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        performSegue(withIdentifier: "seg", sender: nil)
    }
}
  
