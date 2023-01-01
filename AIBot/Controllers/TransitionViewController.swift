//
//  TransitionViewController.swift
//  AIBot
//
//  Created by TTGMOTSF on 20/12/2022.
//

import UIKit
import TransitionButton
import OpenAISwift


class ChatView: CustomTransitionViewController , UITextFieldDelegate{
    
    private var model = [ChatMessage(isIncoming: true, text: "What's up Human? ")]
    private var favorites = [Int]()
    var textToCopy: String = ""
    var shouldStartToCopy: Bool = false
    let pasteBoard = UIPasteboard.general
    var shouldStartSelection: Bool?
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "022032")
        myTextField.delegate = self
        myTextField.layer.cornerRadius = 20
        navigationItem.hidesBackButton = true
        myTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    //MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
     
        if let message = textField.text, !message.isEmpty {
            model.append(ChatMessage(isIncoming: false, text: message))
            textField.text = nil
            self.myTableView.reloadData()
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
        return true
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
       
        if let message = myTextField.text, !message.isEmpty {
            model.append(ChatMessage(isIncoming: false, text: message))
            myTextField.text = nil
            self.myTableView.reloadData()
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
}
//MARK: - Context Menu

extension ChatView{
    
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        
        let identifier = NSString(string: "\(indexPath.row)")
        let configuration = UIContextMenuConfiguration(identifier: identifier,
                                                       previewProvider: nil) { _ in
            
            let copy = UIAction(title: "Copy",
                                image: UIImage(systemName:  "doc.on.doc")
            ){ [self] _ in
                
                shouldStartToCopy = true
                pasteBoard.string = textToCopy
                
            }
            
            let share = UIAction(title: "Share",
                                image: UIImage(systemName: "square.and.arrow.up")
            ){ _ in
                print("item shared")
            }
            
            let favorite = UIAction(title: self.favorites.contains(indexPath.row) == true ? "Add To Favorites" : "Remove from Favorites",
                            image: self.favorites.contains(indexPath.row) ? UIImage(systemName: "star") : UIImage(systemName: "star.fill"),
                                identifier: nil,
                                state: .off
            ){ _ in

                if self.favorites.contains(indexPath.row) == true{
                    self.favorites.removeAll(where: {$0 == indexPath.row})
                }else{
                    self.favorites.append(indexPath.row)
                }
            }
            
            let select = UIMenu(title: "",options: .displayInline, children: [
                UIAction(title: "Select",image: UIImage(systemName: "checkmark.circle"), handler: { _ in
                    self.shouldStartSelection = true
                })
            ])
            return UIMenu(title: "",
                          children: [copy, share, favorite, select])
        }
        return configuration
    }
  
    

     func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        guard let identifier = configuration.identifier as? String else { return nil }
        let index = Int(identifier)
        guard let cell = myTableView.cellForRow(at: .init(row: index!, section: 0)) as? ChatTableViewCell else {return nil}
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.messageImage, parameters: parameters)
        
    }

}


//MARK: - TableView Methods

extension ChatView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        let chatMessage = model[indexPath.row]
        cell.chatMessage = chatMessage
        myTableView.allowsSelection = true
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedBackgroundView
        cell.backgroundColor = UIColor(hexString: "022032")
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
        
            
    }
    

    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {

        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        if shouldStartSelection == true{
            self.setEditing(true, animated: true)
        }else{
            self.setEditing(false, animated: true)
        }
    }
    
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("ting")
    }
    
 
}
