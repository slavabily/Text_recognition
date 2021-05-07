/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import MobileCoreServices
import TesseractOCR

class ViewController: UIViewController {
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // IBAction methods
  @IBAction func backgroundTapped(_ sender: Any) {
    view.endEditing(true)
  }
  
  @IBAction func takePhoto(_ sender: Any) {
    // 1
    let imagePickerActionSheet =
      UIAlertController(title: "Snap/Upload Image",
                        message: nil,
                        preferredStyle: .actionSheet)

    // 2
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraButton = UIAlertAction(
        title: "Take Photo",
        style: .default) { (alert) -> Void in
        // 1
        self.activityIndicator.startAnimating()
        // 2
        let imagePicker = UIImagePickerController()
        // 3
        imagePicker.delegate = self
        // 4
        imagePicker.sourceType = .camera
        // 5
        imagePicker.mediaTypes = [kUTTypeImage as String]
        // 6
        self.present(imagePicker, animated: true, completion: {
          // 7
          self.activityIndicator.stopAnimating()
        })

      }
      imagePickerActionSheet.addAction(cameraButton)
    }

    // 3
    let libraryButton = UIAlertAction(
      title: "Choose Existing",
      style: .default) { (alert) -> Void in
      self.activityIndicator.startAnimating()
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      imagePicker.mediaTypes = [kUTTypeImage as String]
      self.present(imagePicker, animated: true, completion: {
        self.activityIndicator.stopAnimating()
      })
    }
    imagePickerActionSheet.addAction(libraryButton)

    // 4
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
    imagePickerActionSheet.addAction(cancelButton)

    // 5
    present(imagePickerActionSheet, animated: true)
  }

  // Tesseract Image Recognition
  func performImageRecognition(_ image: UIImage) {
    // 1
    if let tesseract = G8Tesseract(language: "eng+fra") {
      // 2
      tesseract.engineMode = .tesseractCubeCombined
      // 3
      tesseract.pageSegmentationMode = .auto
      // 4
      tesseract.image = image
      // 5
      tesseract.recognize()
      // 6
      textView.text = tesseract.recognizedText
    }
    // 7
    activityIndicator.stopAnimating()
  }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // 1
    guard let selectedPhoto =
      info[.originalImage] as? UIImage else {
        dismiss(animated: true)
        return
    }
    // 2
    activityIndicator.startAnimating()
    // 3
    dismiss(animated: true) {
      self.performImageRecognition(selectedPhoto)
    }

  }
}
