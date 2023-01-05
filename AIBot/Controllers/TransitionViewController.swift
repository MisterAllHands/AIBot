//
//  TransitionViewController.swift
//  AIBot
//
//  Created by TTGMOTSF on 20/12/2022.
//

 import UIKit
 import TransitionButton
 import OpenAISwift
 import ChameleonFramework


 class ChatView: CustomTransitionViewController , UITextViewDelegate{
     
     let contentView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = .white
         return view
     }()

     let myTextView: UITextView = {
         let textView = UITextView()
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.font = UIFont.systemFont(ofSize: 17)
         textView.isScrollEnabled = false
         return textView
     }()
     
     private let sendButton: UIButton = {
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setImage(UIImage(systemName: "arrow.up.message.fill"), for: .normal)
         button.tintColor = .flatGreen()
         return button
     }()
     
     
     
     private var model = [ChatMessage(isIncoming: true, text: "What's up Human? ")]
     private var favorites = [Int]()
     var textToCopy: String?
     var shouldStartSelection: Bool?
     
     @IBOutlet weak var myTableView: UITableView!
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(contentView)
         contentView.addSubview(myTextView)
         contentView.addSubview(sendButton)

         // Add constraints to contentView
         NSLayoutConstraint.activate([
             contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             contentView.topAnchor.constraint(equalTo: myTableView.bottomAnchor),
             contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
             contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

         // Add constraints to textView
             myTableView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
             
             
             myTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             myTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
             myTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
             myTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
             myTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
                  
             
             
             
             sendButton.leadingAnchor.constraint(equalTo: myTextView.trailingAnchor),
             sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             sendButton.topAnchor.constraint(equalTo: contentView.topAnchor),
             sendButton.heightAnchor.constraint(equalToConstant: 50)
             
         ])
         
         view.backgroundColor = UIColor(hexString: "022032")
         navigationItem.hidesBackButton = true
         myTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "cell")
         myTableView.allowsMultipleSelectionDuringEditing = true
         textViewCustomization()
         sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
         sendButton.isHidden = false
     }
     
     //MARK: - TextField
    
     
     func textViewDidBeginEditing(_ textView: UITextView) {
         if textView.textColor == .lightGray && myTextView.isFirstResponder {
                 myTextView.text = nil
                 myTextView.textColor = .white
             }
         if let text = textView.text, text.count > 0{
             DispatchQueue.main.async {
                 print("ting")
                 UIView.animate(withDuration: 0.2) {[self] in
                     sendButton.isHidden = false
                     NSLayoutConstraint.activate([
                        myTextView.trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: -5)
                     ])
                 }
             }
         }else{
             DispatchQueue.main.async {
                 print("ting33")
                 UIView.animate(withDuration: 0.2) {[self] in
                     sendButton.isHidden = true
                     NSLayoutConstraint.activate([
                        myTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                     ])
                 }
             }
         }
     }
     
     func textViewCustomization() {
         myTextView.layer.cornerRadius = 20
         contentView.backgroundColor = UIColor(hexString: "022020")
         myTextView.textColor = .lightGray
         myTextView.text = "Message"
         myTextView.backgroundColor = UIColor(hexString: "022032")
             sendButton.isHidden = true
             NSLayoutConstraint.activate([
                myTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
             ])
     }
     
     
   @objc func sendButtonPressed() {
         
        
         if let message = myTextView.text, !message.isEmpty {
             model.append(ChatMessage(isIncoming: false, text: message))
             myTextView.text = nil
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

 extension ChatView {
     
     func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
         
         
         let identifier = NSString(string: "\(indexPath.row)")
         let configuration = UIContextMenuConfiguration(identifier: identifier,
                                                        previewProvider: nil) { _ in
             
             let copy = UIAction(title: "Copy",
                                 image: UIImage(systemName:  "doc.on.doc")
             ){ [self] _ in
                 
                 UIPasteboard.general.string = textToCopy
                 
             }
             
             let share = UIAction(title: "Share",
                                 image: UIImage(systemName: "square.and.arrow.up")
             ){ [self] _ in
                 print("item shared")
                 let shareVC = UIActivityViewController(activityItems: [textToCopy!], applicationActivities: nil)
                 present(shareVC, animated: true)
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
      
         let chatMessage = model[indexPath.row]
         textToCopy = chatMessage.text
         print("ting")
         
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

/*
 


     override func viewDidLoad() {
         super.viewDidLoad()

        
     }
 

 */
