//
//  ViewController.swift
//  Sour Chat
//
//  Created by Aleksandr Khalupa on 31.01.2021.
//
import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmailTF: UITextField!
    
    @IBOutlet weak var passwordLoginTF: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmailTF.changeBorderColorAndWidth()
        passwordLoginTF.changeBorderColorAndWidth()
        
        if UserDefaults.standard.bool(forKey: KPlist.login){
            performSegue(withIdentifier: KSegues.fromLoginToChat, sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        
        guard let email = loginEmailTF.text, let password = passwordLoginTF.text else{return}
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let errr = error{
                self.errorLabel.text = errr.localizedDescription
            } else{
                self.performSegue(withIdentifier: KSegues.fromLoginToChat, sender: self)
                UserDefaults.standard.set(true, forKey: KPlist.login)
            }
        }
    }
    
    @IBAction func pressedGoToRegiser(_ sender: UIButton) {
    }
}


