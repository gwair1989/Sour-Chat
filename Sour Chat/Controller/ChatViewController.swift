//
//  ChatViewController.swift
//  Sour Chat
//
//  Created by Aleksandr Khalupa on 01.02.2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTF: UITextField!
    
    let db = Firestore.firestore()
    var massages:[SenderAndMassage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.dataSource = self
        chatTF.changeBorderColorAndWidth()
        navigationItem.hidesBackButton = true
        title = "Sour Chat"
        chatTableView.register(UINib(nibName: "MassedgeTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        readDataFromFirebace()
    }
    
    
    @IBAction func pressedSendMessege(_ sender: UIButton) {
        
        guard let email = Auth.auth().currentUser?.email, let messedge = chatTF.text, messedge != "" else{return}
        
        let secondsFrom1970 = Date().timeIntervalSince1970
        var ref: DocumentReference?
        ref = db.collection(KFirebase.keyAllMaseges).addDocument(data: [
            KFirebase.keySender: email,
            KFirebase.keyMessage: messedge,
            KFirebase.keyDate: secondsFrom1970
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                DispatchQueue.main.async {
                    self.chatTF.text = ""
                }
            }
        }
    }
    
    func readDataFromFirebace(){
        db.collection(KFirebase.keyAllMaseges).order(by: KFirebase.keyDate).addSnapshotListener() { (querySnapshot, err) in
            self.massages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let queryhots = querySnapshot?.documents else {return}
                for document in queryhots {
                    guard let messege = document.data()[KFirebase.keyMessage] as? String,
                          let senderEmail = document.data()[KFirebase.keySender] as? String else {return}
                    let dataFromFB = SenderAndMassage(sender: senderEmail, massageOfTable: messege)
                    self.massages.append(dataFromFB)
                }
                DispatchQueue.main.async {
                    self.chatTableView.reloadData()
                    self.chatTableView.scrollToRow(at: IndexPath(row: self.massages.count - 1, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    @IBAction func pressedSigOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            UserDefaults.standard.set(false, forKey: KPlist.login)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    //    MARK: - TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MassedgeTableViewCell
        
        cell.chatLabel.text = "\(indexPath.row + 1). \(massages[indexPath.row].massageOfTable)"
        if massages[indexPath.row].sender == Auth.auth().currentUser?.email{
            cell.cahatBackgroundImage.image = #imageLiteral(resourceName: "chatBackgroundRight")
            cell.currentUserAvatar.isHidden = false
            cell.guestAvatarImage.isHidden = true
        }else{
            cell.cahatBackgroundImage.image = #imageLiteral(resourceName: "chatBackgroundLeft")
            cell.currentUserAvatar.isHidden = true
            cell.guestAvatarImage.isHidden = false
        }
        return cell
    }
}

