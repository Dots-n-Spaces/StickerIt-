import UIKit
import SceneKit
import ARKit
import EasyTipView
import SnapKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARSCNViewDelegate, ARSessionDelegate {

    var arSCNView = ARSCNView()
    var arSession = ARSession()
    var arSessionConfiguration = ARSessionConfiguration()

    var imageWasSelected = false
    var picNode: SCNNode = SCNNode()
    var curCameraAngle: vector_float3 = vector_float3()
    var picArray: [Any] = []
    var tipsViews: [EasyTipView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        arSession.delegate = self
        initARSCNView()
        initARSessionConfiguration()

        view.addSubview(arSCNView)
        arSession.run(arSessionConfiguration)

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

        let chooseImg = UIImageView(image: #imageLiteral(resourceName: "selectImage"))
        chooseImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickPic)))
        view.addSubview(chooseImg)
        chooseImg.isUserInteractionEnabled = true
        chooseImg.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }

        let a = EasyTipView(text: "Select your Sticker/Logo here", preferences: preferences, delegate: self)
        a.show(forView: chooseImg, withinSuperview: view)
        tipsViews.append(a)

        let centerView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2, width: 0, height: 0))
        view.addSubview(centerView)
        let d = EasyTipView(text: "Touch anywhere on screen to put stick the logo", preferences: preferences2, delegate: self)
        d.show(forView: centerView, withinSuperview: view)
        tipsViews.append(d)

        let helpIView = UIImageView(image: #imageLiteral(resourceName: "help"))
        helpIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openHelpVC)))
        view.addSubview(helpIView)
        helpIView.isUserInteractionEnabled = true
        helpIView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.top.equalTo(view.snp.top).offset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        let b = EasyTipView(text: "Help is here", preferences: preferences3, delegate: self)
        b.show(forView: helpIView, withinSuperview: view)
        tipsViews.append(b)

        let shareIView = UIImageView(image: #imageLiteral(resourceName: "share"))
        shareIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openShare)))
        view.addSubview(shareIView)
        shareIView.isUserInteractionEnabled = true
        shareIView.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-15)
            make.top.equalTo(view.snp.top).offset(30)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        let e = EasyTipView(text: "Share with employes", preferences: preferences5, delegate: self)
        e.show(forView: shareIView, withinSuperview: view)
        tipsViews.append(e)

        let buyIView = UIImageView(image: #imageLiteral(resourceName: "buy"))
        buyIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openOrderVC)))
        view.addSubview(buyIView)
        buyIView.isUserInteractionEnabled = true
        buyIView.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-15)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }

        let c = EasyTipView(text: "Make order here", preferences: preferences4, delegate: self)
        c.show(forView: buyIView, withinSuperview: view)
        tipsViews.append(c)
    }

    @objc func openHelpVC() {
        present(HelpVC(), animated: true) { }
    }

    @objc func openOrderVC() {
        present(OrderVC(), animated: true) { }
    }

    @objc func openShare() {
//        let sharingItems:[AnyObject?] = [
//            sharingText as AnyObject,
//            sharingImage as AnyObject,
//            sharingURL as AnyObject
//        ]
        let sharingItems = ["Some text here"]

        let activityViewController = UIActivityViewController(activityItems: sharingItems.flatMap({$0}), applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = view
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

    func print_Matrix4(matrix: SCNMatrix4) {
        print("‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹matrix‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹")
        print(String(format: "\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n", matrix.m11, matrix.m12, matrix.m13, matrix.m14, matrix.m21, matrix.m22, matrix.m23, matrix.m24, matrix.m31, matrix.m32, matrix.m33, matrix.m34, matrix.m41, matrix.m42, matrix.m43, matrix.m44))
        print("››››››››››››››››››››››››matrix›››››››››››››››››››››››››››››››")
    }

    @objc func tapped(_ tapper: UITapGestureRecognizer) {
        if imageWasSelected == false {
            moveToScene(image: #imageLiteral(resourceName: "icon"))
        }

        let location: CGPoint = tapper.location(in: arSCNView)
        let hitTestResults: [ARHitTestResult] = arSCNView.hitTest(location, types: .featurePoint)
        if hitTestResults.count > 0 {
            let anchor: ARHitTestResult? = hitTestResults.first
            let hitPointTransform: SCNMatrix4? = SCNMatrix4((anchor?.worldTransform)!)
            print_Matrix4(matrix: hitPointTransform!)
            //        // sth like this:
            //        1.00, 0.00, 0.00, 0.00
            //        0.00, 1.00, 0.00, 0.00
            //        0.00, 0.00, 1.00, 0.00
            //        0.38, -0.12, -0.18, 1.00
            let hitPointPosition: SCNVector3? = SCNVector3Make((hitPointTransform?.m41)!, (hitPointTransform?.m42)!, (hitPointTransform?.m43)!)
            // put at nearest anchor
            picNode.position = hitPointPosition!
            // face to camera
            picNode.eulerAngles = SCNVector3Make(curCameraAngle.x, curCameraAngle.y, 0)
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
        arSessionConfiguration = ARSessionConfiguration()
        //1.Create a world tracking session configuration (using ARWorldTrackingSessionConfiguration effect is better), need A9 chip support
        let configuration = ARWorldTrackingSessionConfiguration()
        //2.Set the tracking direction (tracking plane, used later)
        configuration.planeDetection = .horizontal
        arSessionConfiguration = configuration
        //3.Adaptive light (the camera from dark to strong light fast transition effect will be gentle)
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
//        arSCNView.debugOptions = SCNDebugOptions(rawValue: SCNDebugOptions.RawValue(UInt8(ARSCNDebugOptions.showWorldOrigin.rawValue) | UInt8(ARSCNDebugOptions.showFeaturePoints.rawValue)))
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
        for tip in tipsViews {
            tip.dismiss()
        }
        tipsViews.removeAll()
    }
}
