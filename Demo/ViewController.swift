import UIKit
import EtherealCereal

class ViewController: UIViewController {

    let etherealCereal = EtherealCereal()

    lazy var privateKeyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    lazy var publicKeyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubview(self.privateKeyLabel)
        self.view.addSubview(self.publicKeyLabel)
        self.view.addSubview(self.addressLabel)

        let margin = CGFloat(16)
        let topMargin = CGFloat(100)
        let minHeight = CGFloat(36)

        self.privateKeyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.privateKeyLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topMargin).isActive = true
        self.privateKeyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.privateKeyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.publicKeyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.publicKeyLabel.topAnchor.constraint(equalTo: self.privateKeyLabel.bottomAnchor, constant: margin).isActive = true
        self.publicKeyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.publicKeyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.addressLabel.topAnchor.constraint(equalTo: self.publicKeyLabel.bottomAnchor, constant: margin).isActive = true
        self.addressLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.addressLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        print("Private key generated: \(self.etherealCereal.privateKey)")
        print("Public key generated: \(self.etherealCereal.publicKey)")
        print("Address: \(self.etherealCereal.address)")

        let privateKeyString = NSMutableAttributedString(string: "Private key: \(self.etherealCereal.privateKey)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        privateKeyString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (privateKeyString.string as NSString).range(of: "Private key:"))

        let publicKeyString = NSMutableAttributedString(string: "Public key: \(self.etherealCereal.publicKey)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        publicKeyString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (publicKeyString.string as NSString).range(of: "Public key:"))

        let addressString = NSMutableAttributedString(string: "Address: \(self.etherealCereal.address)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        addressString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (addressString.string as NSString).range(of: "Address:"))

        self.privateKeyLabel.attributedText = privateKeyString
        self.publicKeyLabel.attributedText = publicKeyString
        self.addressLabel.attributedText = addressString

        print("Signature: \(self.etherealCereal.sign(message: "Hello all!"))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

