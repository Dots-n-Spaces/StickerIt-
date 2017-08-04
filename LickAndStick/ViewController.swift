import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARSCNViewDelegate, ARSessionDelegate {

    var arSCNView = ARSCNView()
    var arSession = ARSession()
    var arSessionConfiguration = ARSessionConfiguration()

    var picNode: SCNNode = SCNNode()
    var curCameraAngle: vector_float3 = vector_float3()
    var picArray: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arSession.delegate = self
        initARSCNView()
        initARSessionConfiguration()

        view.addSubview(arSCNView)
        arSession.run(arSessionConfiguration)
        
        let choosePicBtn = UIButton(type: .plain)
        choosePicBtn.setTitle("Choose a photo", for: .normal)
        choosePicBtn.sizeToFit()
        choosePicBtn.center = CGPoint(x: 40, y: UIScreen.main.bounds.size.height - 30)
        choosePicBtn.addTarget(self, action: #selector(self.pickPic), for: .touchUpInside)
        view.addSubview(choosePicBtn as UIView)
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
        picker.allowsEditing = true
        present(picker, animated: true) { }
    }
    
    func print_Matrix4(matrix: SCNMatrix4) {
        print("‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹matrix‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹")
        print(String(format: "\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n", matrix.m11, matrix.m12, matrix.m13, matrix.m14, matrix.m21, matrix.m22, matrix.m23, matrix.m24, matrix.m31, matrix.m32, matrix.m33, matrix.m34, matrix.m41, matrix.m42, matrix.m43, matrix.m44))
        print("››››››››››››››››››››››››matrix›››››››››››››››››››››››››››››››")
    }

    @objc func tapped(_ tapper: UITapGestureRecognizer) {
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
        let pickedImage: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
        let material = SCNMaterial()
        material.diffuse.contents = pickedImage
        picArray.append(material)
        let constWidth: CGFloat = 0.15
        let scale: CGFloat? = (pickedImage?.size.width)! / constWidth
        let picPlane = SCNPlane(width: constWidth, height: (pickedImage?.size.height)! / scale!)
        picPlane.materials = [material]
        let picNodeNew = SCNNode(geometry: picPlane)
        picNodeNew.transform = SCNMatrix4MakeTranslation(0, 0, -0.5)
        if picNodeNew.parent == nil {
            arSCNView.scene.rootNode.addChildNode(picNodeNew)
        }
        self.picNode = picNodeNew
        self.dismiss(animated: true) {

        }
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
