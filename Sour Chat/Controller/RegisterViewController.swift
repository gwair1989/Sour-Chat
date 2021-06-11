//
//  RegisterViewController.swift
//  Sour Chat
//
//  Created by Aleksandr Khalupa on 01.02.2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerEmailTF: UITextField!
    
    @IBOutlet weak var passwordRegisterTF: UITextField!
    
    @IBOutlet weak var erorrLabeb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerEmailTF.changeBorderColorAndWidth()
        passwordRegisterTF.changeBorderColorAndWidth()

    }
    
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        guard let password = passwordRegisterTF.text, let email = registerEmailTF.text else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil{
                self.erorrLabeb.text = error!.localizedDescription
            }else{
                UserDefaults.standard.set(true, forKey: KPlist.login)
                self.performSegue(withIdentifier: KSegues.fromRegisterToChat, sender: self)
            }
        }      
    }
}
