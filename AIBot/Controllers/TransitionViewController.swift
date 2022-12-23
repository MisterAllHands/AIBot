//
//  TransitionViewController.swift
//  AIBot
//
//  Created by TTGMOTSF on 20/12/2022.
//

import UIKit
import TransitionButton
import OpenAISwift


class ChatView: CustomTransitionViewController, UITableViewDelegate, UITableViewDataSource  , UITextFieldDelegate{
    
    private var model = [ChatMessage(isIncoming: true, text: "What's up Human? ")]
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextField.delegate = self
        myTextField.layer.cornerRadius = 20
        navigationItem.hidesBackButton = true
        myTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.separatorStyle = .none
    }
    
    //MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let message = textField.text, !message.isEmpty {
            model.append(ChatMessage(isIncoming: false, text: message))
            textField.text = nil
            textField.resignFirstResponder()
            APICaller.share.getResponse(input: message) {[weak self] result in
                switch result{
                case .success(let output):
                    print(output)
                    self?.model.append(ChatMessage(isIncoming: true, text: output))
                    DispatchQueue.main.async {
                        self?.myTableView.reloadData()
                    }
                case .failure:
                    print("Failed to load messages")
                }
            }
        }
        return true
    }

    
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        let chatMessage = model[indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        guard let message = myTextField.text, !message.isEmpty else {
            return
        }
        myTextField.text = nil
        APICaller.share.getResponse(input: message) {[weak self] result in
            switch result{
            case .success(let output):
                self?.model.append(ChatMessage(isIncoming: true, text: output))
                DispatchQueue.main.async {
                    self?.myTableView.reloadData()
                }
            case .failure:
                print("Failed to load messages")
            }
        }
    }
}
