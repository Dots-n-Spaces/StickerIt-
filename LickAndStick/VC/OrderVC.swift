import Foundation
import UIKit
import SnapKit

class OrderVC: UIViewController {

    override func viewDidLoad() {
        let backIView = UIImageView(image: #imageLiteral(resourceName: "back"))
        backIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.back)))
        view.addSubview(backIView)
        backIView.isUserInteractionEnabled = true
        backIView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Sticker It!"
        titleLabel.font = UIFont(name: "PingFang HK", size: 24.0)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(backIView.snp.centerY)
        }

        let descriptionTextView = UITextView()
        let mailto = URL(string: "mailto:ifitnine@gmail.com")
        var str = NSMutableAttributedString(string: "Happy to see that you found your logo! Currently app operates as a Proof Of The Concept, thus, ordering works only via email: ifitnine@gmail.com. Please, specify size of stickers, number of units and attack vector file your logo.")
        str.addAttribute(NSAttributedStringKey.link, value: mailto!, range: NSRange(location: 67, length: 20))
        str.addAttribute(NSAttributedStringKey.link, value: mailto!, range: NSRange(location: 126, length: 18))
        str.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "PingFang HK", size: 18.0)!, range: NSRange(location: 0, length: str.length))
        descriptionTextView.attributedText = str
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = view.backgroundColor
        view.addSubview(descriptionTextView)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone, .tv, .carPlay, .unspecified:
            descriptionTextView.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
            }
        case .pad:
            descriptionTextView.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }
        }
        var fixedWidth = descriptionTextView.frame.size.width
        descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = descriptionTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        descriptionTextView.frame = newFrame

        let versionLabel = UILabel()
        versionLabel.text = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
        versionLabel.font = UIFont(name: "PingFang HK", size: 10.0)
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
            make.centerX.equalTo(view.snp.centerX)
        }

        let contactsTextView = UITextView()
        let twitter = URL(string: "twitter://user?screen_name=ifitnine")
        str = NSMutableAttributedString(string: "Feedback is welcomed:\n• @IFitNine on Twitter for quick comments.\n• ifitnine@gmail.com for private feedback.")
        str.addAttribute(NSAttributedStringKey.link, value: twitter!, range: NSRange(location: 24, length: 9))
        str.addAttribute(NSAttributedStringKey.link, value: mailto!, range: NSRange(location: 67, length: 18))
        str.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "PingFang HK", size: 14.0)!, range: NSRange(location: 0, length: str.length))
        contactsTextView.attributedText = str
        contactsTextView.isScrollEnabled = false
        contactsTextView.isEditable = false
        contactsTextView.backgroundColor = view.backgroundColor
        view.addSubview(contactsTextView)
        contactsTextView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.bottom.equalTo(versionLabel.snp.top).offset(-15)
        }

        fixedWidth = contactsTextView.frame.size.width
        contactsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newSize = contactsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame = contactsTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        contactsTextView.frame = newFrame
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}
