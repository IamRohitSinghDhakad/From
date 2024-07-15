//
//  ChatViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tblVwChatLUserList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVwChatLUserList.delegate = self
        self.tblVwChatLUserList.dataSource = self
        // Do any additional setup after loading the view.
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tblVwChatLUserList.addGestureRecognizer(longPress)
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell")as! ChatTableViewCell
        
        return cell
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.tblVwChatLUserList)
            if let indexPath = self.tblVwChatLUserList.indexPathForRow(at: touchPoint) {
                print(indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "ChatDetailViewController")
    }
    
}
