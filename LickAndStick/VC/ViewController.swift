import UIKit
import SceneKit
import ARKit
import EasyTipView
import SnapKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARSCNViewDelegate, ARSessionDelegate {

    var arSCNView = ARSCNView()
    var arSession = ARSession()
    var arSessionConfiguration = ARWorldTrackingConfiguration()

    var imageWasSelected = false
    var picNode: SCNNode = SCNNode()
    var curCameraAngle: vector_float3 = vector_float3()
    var picArray: [Any] = []
    var tipsViews: [EasyTipView] = []

    let buyIView = UIImageView(image: #imageLiteral(resourceName: "buy"))
    let chooseImg = UIImageView(image: #imageLiteral(resourceName: "selectImage"))
    let helpIView = UIImageView(image: #imageLiteral(resourceName: "help"))
    let shareIView = UIImageView(image: #imageLiteral(resourceName: "share"))
    var centerView = UIView()

    var aTooltip = EasyTipView(text: "")
    var bTooltip = EasyTipView(text: "")
    var cTooltip = EasyTipView(text: "")
    var dTooltip = EasyTipView(text: "")
    var eTooltip = EasyTipView(text: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        if ARConfiguration.isSupported {
            arSession.delegate = self
            initARSCNView()
            initARSessionConfiguration()

            view.addSubview(arSCNView)
            arSession.run(arSessionConfiguration)

            chooseImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickPic)))
            view.addSubview(chooseImg)
            chooseImg.isUserInteractionEnabled = true
            chooseImg.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
                make.height.equalTo(60)
                make.width.equalTo(60)
            }

            centerView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2, width: 0, height: 0))
            view.addSubview(centerView)

            helpIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showTooltips)))
            view.addSubview(helpIView)
            helpIView.isUserInteractionEnabled = true
            helpIView.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
                make.height.equalTo(40)
                make.width.equalTo(40)
            }

            shareIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openShare)))
            view.addSubview(shareIView)
            shareIView.isUserInteractionEnabled = true
            shareIView.snp.makeConstraints { (make) in
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
                make.height.equalTo(40)
                make.width.equalTo(40)
            }

            buyIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openOrderVC)))
            view.addSubview(buyIView)
            buyIView.isUserInteractionEnabled = true
            buyIView.snp.makeConstraints { (make) in
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
                make.height.equalTo(60)
                make.width.equalTo(60)
            }

            addTooltips()

            let userDefaults = UserDefaults.standard
            if !userDefaults.bool(forKey: "walkthroughPresented") {
                showTooltips()
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

    @objc private func showTooltips() {
        aTooltip.show(forView: chooseImg, withinSuperview: view)
        bTooltip.show(forView: helpIView, withinSuperview: view)
        cTooltip.show(forView: buyIView, withinSuperview: view)
        dTooltip.show(forView: centerView, withinSuperview: view)
        eTooltip.show(forView: shareIView, withinSuperview: view)

        tipsViews.append(aTooltip)
        tipsViews.append(bTooltip)
        tipsViews.append(cTooltip)
        tipsViews.append(dTooltip)
        tipsViews.append(eTooltip)
    }

    private func addTooltips() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        EasyTipView.globalPreferences = preferences

        var preferences2 = EasyTipView.Preferences()
        preferences2.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences2.drawing.foregroundColor = UIColor.white
        preferences2.drawing.backgroundColor = UIColor(hue:0.16, saturation:0.99, brightness:0.6, alpha:1)
        preferences2.drawing.arrowPosition = EasyTipView.ArrowPosition.top

        var preferences3 = EasyTipView.Preferences()
        preferences3.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences3.drawing.foregroundColor = UIColor.white
        preferences3.drawing.backgroundColor = UIColor(hue:0.76, saturation:0.99, brightness:0.6, alpha:1)
        preferences3.drawing.arrowPosition = EasyTipView.ArrowPosition.top

        var preferences4 = EasyTipView.Preferences()
        preferences4.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences4.drawing.foregroundColor = UIColor.white
        preferences4.drawing.backgroundColor = UIColor(hue:0.96, saturation:0.99, brightness:0.6, alpha:1)
        preferences4.drawing.arrowPosition = EasyTipView.ArrowPosition.top

        var preferences5 = EasyTipView.Preferences()
        preferences5.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences5.drawing.foregroundColor = UIColor.white
        preferences5.drawing.backgroundColor = UIColor(hue:0.06, saturation:0.99, brightness:0.6, alpha:1)
        preferences5.drawing.arrowPosition = EasyTipView.ArrowPosition.top

        aTooltip = EasyTipView(text: "Select your Logo here", preferences: preferences, delegate: self)
        bTooltip = EasyTipView(text: "Help is here", preferences: preferences3, delegate: self)
        cTooltip = EasyTipView(text: "Make order here", preferences: preferences4, delegate: self)
        dTooltip = EasyTipView(text: "Touch anywhere on screen to put sticker", preferences: preferences2, delegate: self)
        eTooltip = EasyTipView(text: "Share your masterpiece here", preferences: preferences5, delegate: self)
    }

    @objc func openOrderVC() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone, .tv, .carPlay, .unspecified:
            present(OrderVC(), animated: true) { }
        case .pad:
            let orderVC = OrderVC()
            orderVC.modalPresentationStyle = .popover
            let popover = orderVC.popoverPresentationController!
            popover.permittedArrowDirections = .down
            popover.sourceView = buyIView
            popover.sourceRect = buyIView.bounds
            present(orderVC, animated: true, completion: nil)
        }
    }

    @objc func openShare() {
        let sharingItems = [arSCNView.snapshot()]

        let activityViewController = UIActivityViewController(activityItems: sharingItems.flatMap({$0}), applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
//            let shareViewPoint = shareIView
//            shareViewPoint.snp.makeConstraints({ (make) in
//                make.top.equalTo(shareIView.snp.bottom)
//                make.left.equalTo(shareIView.snp.left).offset(20)
//            })
            activityViewController.popoverPresentationController?.sourceView = shareIView
            activityViewController.popoverPresentationController?.permittedArrowDirections = .right
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: shareIView.bounds.origin.x, y: shareIView.bounds.origin.y+20, width: 1, height: 1)
//            activityViewController.popoverPresentationController?.sourceRect = shareIView.frame
        }
        present(activityViewController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        arSession.run(arSessionConfiguration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        arSession.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @objc func pickPic(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = false
        present(picker, animated: true) { }
    }    
//    func print_Matrix4(matrix: SCNMatrix4) {
//        print("‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹matrix‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹")
//        print(String(format: "\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n", matrix.m11, matrix.m12, matrix.m13, matrix.m14, matrix.m21, matrix.m22, matrix.m23, matrix.m24, matrix.m31, matrix.m32, matrix.m33, matrix.m34, matrix.m41, matrix.m42, matrix.m43, matrix.m44))
//        print("››››››››››››››››››››››››matrix›››››››››››››››››››››››››››››››")
//    }

    @objc func tapped(_ tapper: UITapGestureRecognizer) {
        if imageWasSelected == false {
            moveToScene(image: String.randomEmoji().image()!)
        }

        let location: CGPoint = tapper.location(in: arSCNView)
        let hitTestResults: [ARHitTestResult] = arSCNView.hitTest(location, types: .featurePoint)
        if hitTestResults.count > 0 {
//            let anchor: ARHitTestResult? = hitTestResults.first
//            let hitPointTransform: SCNMatrix4? = SCNMatrix4((anchor?.worldTransform)!)
//            print_Matrix4(matrix: hitPointTransform!)
//            //        // sth like this:
//            //        1.00, 0.00, 0.00, 0.00
//            //        0.00, 1.00, 0.00, 0.00
//            //        0.00, 0.00, 1.00, 0.00
//            //        0.38, -0.12, -0.18, 1.00
//            let hitPointPosition: SCNVector3? = SCNVector3Make((hitPointTransform?.m41)!, (hitPointTransform?.m42)!, (hitPointTransform?.m43)!)
//            // put at nearest anchor
//            picNode.position = hitPointPosition!
//            // face to camera
            picNode.eulerAngles = SCNVector3Make(curCameraAngle.x, curCameraAngle.y, 0)

            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            if let currentFrame = arSCNView.session.currentFrame {
                picNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
                picNode.eulerAngles = SCNVector3Make(curCameraAngle.x, curCameraAngle.y, 0)
            }
        }
    }

    @objc func swipped(_ recognizer: UISwipeGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: arSCNView)
        let results: [SCNHitTestResult] = arSCNView.hitTest(location, options: nil)
        if results.count > 0 {
            let result: SCNHitTestResult? = results.first
            if result?.node == picNode {
                //            if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
                //            {
                //                [self.picNode.geometry setMaterials:@[self.picArray[0]]];
                //            }
            }
        }
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        curCameraAngle = frame.camera.eulerAngles
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageWasSelected = true
            moveToScene(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }

    private func moveToScene(image: UIImage, inFront: Bool = false) {
        picNode.removeFromParentNode()

        let material = SCNMaterial()
        material.diffuse.contents = image
        picArray.append(material)
        let constWidth: CGFloat = 0.15
        let scale: CGFloat? = image.size.width / constWidth
        let picPlane = SCNPlane(width: constWidth, height: image.size.height / scale!)
        picPlane.materials = [material]
        let picNodeNew = SCNNode(geometry: picPlane)
        picNodeNew.transform = SCNMatrix4MakeTranslation(picNodeNew.position.x, picNodeNew.position.y, -0.5)
        if picNodeNew.parent == nil {
            arSCNView.scene.rootNode.addChildNode(picNodeNew)
        }
        picNode = picNodeNew
    }

    // MARK: - ARSCNViewDelegate

    func initARSessionConfiguration() {
        arSessionConfiguration = ARWorldTrackingConfiguration()
        arSessionConfiguration.planeDetection = .horizontal
        arSessionConfiguration.isLightEstimationEnabled = true
    }

    func initARSCNView() {
        //1.Create an AR view
        arSCNView = ARSCNView(frame: view.bounds)
        //2.Set the agent to catch the level to return in the proxy callback
        arSCNView.delegate = self
        //2.Set the view session
        arSCNView.session = arSession
        //3.Automatically refresh the light (3D games used, here can be ignored)
        arSCNView.automaticallyUpdatesLighting = true
        // Open debug
//        arSCNView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        // Add gestures
        let tapper = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        arSCNView.addGestureRecognizer(tapper)
        // Handle left slip
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipped))
        swipeLeftRecognizer.direction = .left
        arSCNView.addGestureRecognizer(swipeLeftRecognizer)
        // Handle right slippery
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipped))
        swipeRightRecognizer.direction = .right
        arSCNView.addGestureRecognizer(swipeRightRecognizer)
    }

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}

extension ViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "walkthroughPresented")
        userDefaults.synchronize()

        for tip in tipsViews {
            tip.dismiss()
        }
        tipsViews.removeAll()
    }
}
