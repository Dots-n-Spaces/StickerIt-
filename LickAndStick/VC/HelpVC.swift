import Foundation
import UIKit
import SnapKit

class HelpVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cyan

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
        titleLabel.text = "Lick&Stick"
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

        let contactsTextView = UITextView()
        let twitter = URL(string: "twitter://user?screen_name=ifitnine")
        let mailto = URL(string: "mailto:ifitnine@gmail.com")
        let str = NSMutableAttributedString(string: "Feedback is welcome:\n• @IFitNine on Twitter for quick comments.\n• ifitnine@gmail.com for private feedback.")
        str.addAttribute(NSAttributedStringKey.link, value: twitter!, range: NSRange(location: 23, length: 9))
        str.addAttribute(NSAttributedStringKey.link, value: mailto!, range: NSRange(location: 66, length: 18))
        str.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "PingFang HK", size: 14.0)!, range: NSRange(location: 0, length: str.length))
        contactsTextView.attributedText = str
        contactsTextView.isScrollEnabled = false
        contactsTextView.backgroundColor = view.backgroundColor
        view.addSubview(contactsTextView)
        contactsTextView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(15)
            make.right.equalTo(view.snp.right).offset(-15)
            make.centerY.equalTo(view.snp.centerY)
        }

        let fixedWidth = contactsTextView.frame.size.width
        contactsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = contactsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = contactsTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        contactsTextView.frame = newFrame

        let versionLabel = UILabel()
        versionLabel.text = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp.centerX)
        }
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}
