//
//  ConnexionViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 19/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import TextFieldEffects
import MessageUI
import Alamofire
import SwiftyJSON

class ConnexionViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var connectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.resignFirstResponder()
        self.hideKeyboardWhenTappedAround()
        
        
        
        connectButton.isEnabled = false
        [emailTextField, passwordTextField].forEach({ $0?.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)})

        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectToEseoServer(_ sender: Any) {
        if (emailTextField.text?.hasSuffix("@reseau.eseo.fr"))! {
            let emailTransformed = emailTextField.text?.replacingOccurrences(of: "@", with: "%40")
            let urlString = "http://api.pandfstudio.ovh/login?email=\(emailTransformed!)&password=\(passwordTextField.text!)"
            print("URLSTRING: \(urlString)")
            AF.request(urlString).responseJSON { (responseData) in
                if responseData.result.value != nil {
                    let json = JSON(responseData.result.value!)
                    if json["success"].bool! {
                        let uid = json["infos"]["UID"].string!
                        User.uid = uid
                        UserDefaults.standard.set(User.uid, forKey: "userID")
                        UserDefaults.standard.set(json["infos"]["fullname"].string!.components(separatedBy: " ").first, forKey: "userFirstName")
                        UserDefaults.standard.set(json["infos"]["fullname"].string!, forKey: "userFullName")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Erreur", message: "Nous n'avons pas du tout réussi à te connecter. Réessayes.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Erreur", message: "Nous n'avons pas réussi à te connecter. Réessayes.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Erreur", message: "Mmmh, ça ne semble pas être une adresse Eseo valide... Réessayes !", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["romain.rabouan@reseau.eseo.fr"])
            mail.setMessageBody("J'ai un problème avec l'application Eseo Kami. Aidez-moi.", isHTML: false)
            
            present(mail, animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: "Erreur", message: "Impossible d'envoyer un email. Vérifiez que l'application Mail est bien configurée.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
   
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard
            let email = emailTextField.text, !email.isEmpty,
            let mdp = passwordTextField.text, !mdp.isEmpty
        else {
            connectButton.isEnabled = false
            return
        }
        
        connectButton.isEnabled = true
    }
    
    @IBAction func del(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
