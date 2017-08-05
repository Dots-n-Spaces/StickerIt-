import Foundation
import UIKit

class OrderVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.magenta

        let backIView = UIImageView(image: #imageLiteral(resourceName: "back"))
        backIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.back)))
        view.addSubview(backIView)
        backIView.isUserInteractionEnabled = true
        backIView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(30)
            make.left.equalTo(view.snp.left).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Order sheet"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(backIView.snp.centerY)
        }

        let descriptionTextView = UILabel()
        descriptionTextView.numberOfLines = 0
        descriptionTextView.text = "Feedback is welcome:\n• @IFitNine on Twitter for quick comments.\n• ifitnine@gmail.com for private feedback."
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.right.equalTo(view.snp.right).offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}
