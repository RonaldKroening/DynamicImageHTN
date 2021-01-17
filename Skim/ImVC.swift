import UIKit
import AVKit
import AVFoundation
import MLKit
import MobileCoreServices
import Vision
import VisionKit
import UIKit


class ImVC : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var im3 = UIImage()
    var qrMessage = ""
    @IBOutlet weak var imV: UIImageView!
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.allSystemTypes.rawValue)
        let matches = detector.matches(in: qrMessage, options: [], range: NSRange(location: 0, length: qrMessage.utf16.count))
        
        guard let match = matches.first else {return}
        
        
        print(match.resultType)
        
        if match.resultType == .link {
            UIApplication.shared.open(match.url!, options: [:], completionHandler: nil)
        } else if match.resultType == .phoneNumber {
            qrMessage = qrMessage.filter { $0 != " " }
            if let url = URL(string: "tel://\(qrMessage)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imV.image = im3
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imV.isUserInteractionEnabled = true
        imV.addGestureRecognizer(tapGestureRecognizer)
        checkImage(i: im3)
        // Do any additional setup after loading the view.
    }
//    check_image(imV.image)
    func checkImage(i : UIImage){
        let visionImage = VisionImage(image: i)
        visionImage.orientation = i.imageOrientation
        let textRecognizer = TextRecognizer.textRecognizer()
        textRecognizer.process(visionImage) { result, error in
          guard error == nil, let result = result else {
            // Error handling
            return
          }
            let resultText = result.text
            self.qrMessage = resultText
//            for block in result.blocks {
//                let blockText = block.text
//                let blockLanguages = block.recognizedLanguages
//                let blockCornerPoints = block.cornerPoints
//                let blockFrame = block.frame
//                for line in block.lines {
//                    let lineText = line.text
//                    let lineLanguages = line.recognizedLanguages
//                    let lineCornerPoints = line.cornerPoints
//                    let lineFrame = line.frame
//                    for element in line.elements {
//                        extract_Entities(text: element.text, extractor:
                        //<#T##EntityExtractor?#>, locale: <#Locale?#>)
//
                        
//                    }
//            }
        //}

    }
        func extract_Entities(text: String!, extractor: EntityExtractor!, locale: Locale!) {
          extractor.annotateText(
            text,
            completion: {
              [weak self]
              result, error in

              guard let self = self else { return }
              let output = NSMutableAttributedString()
              let input = text.mutableCopy() as! NSMutableAttributedString
              input.removeAttribute(
                NSAttributedString.Key.backgroundColor, range: NSMakeRange(0, input.string.count))
              if error != nil {
              }
              if result?.count == 0 {
                
              } else {
                for annotation in result! {
                    let entities = annotation.entities
                    for entity in entities {
                        var str = get_String_From_Annotation(text: text, range: annotation.range)
                        switch entity.entityType {
                          case EntityType.URL:
                            let url = URL(string: "tel://\(str)")
                            
                          case EntityType.phone:
                                let url = URL(string: "tel://\(str)")
                            UIApplication.shared.open(url!)
                                case EntityType.address:
                                  var add = "http://maps.apple.com/?address="+str
                                    UIApplication.shared.openURL(NSURL(string: add)! as URL)
                                case EntityType.email:
                                  let url = URL(string: "mailto:\(str)")
                                    UIApplication.shared.open(url!)
                                  default:
                                    print("Entity: %@", entity);
                                }
                          
                          }
                }
              }
            })
        }
        func email(e: String){
            let url = URL(string: "mailto:\(e)")
              UIApplication.shared.open(url!)
        }
        func phone(e: String){
            let url = URL(string: "tel://\(e)")
        UIApplication.shared.open(url!)
        }
        func maps(e: String){
            var add = "http://maps.apple.com/?address="+e
            UIApplication.shared.openURL(NSURL(string: add)! as URL)
        }
        func website(e: String){
            UIApplication.shared.openURL(NSURL(string:e) as! URL)
        }
        func make_Button(ch : Int, xc : Double, yc: Double ){
            var e: String
            if(ch == 0){
                e = "email"
            }else if(ch == 1){
                e = "phone"
            }else if(ch == 2){
                e = "maps"
            }else if(ch == 3){
                e = "website"
            }
            
            var myButton = UIButton(frame: CGRect(x: xc, y: yc, width: 100, height: 50))
            myButton.addTarget(self, action: #selector(e1), for: .touchUpInside)
            

            
        }
        func get_String_From_Annotation(text: String!, range: NSRange) -> String{
            let temp = Array(text)
            var l = range.lowerBound
            var h = range.upperBound + 1
            return String(temp[l ..< h])
        }
    }
    @objc func e1(_ sender: UIButton) {
        // Code
    }
}

