//
//  ChatTableViewCell.swift
//  AIBot
//
//  Created by TTGMOTSF on 23/12/2022.
//

import UIKit
import ChameleonFramework

class ChatTableViewCell: UITableViewCell {

    let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    
    let messageImage: UIImageView = {
        let messageImage = UIImageView()
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        return messageImage
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet{
            messageImage.image = chatMessage.isIncoming ? UIImage(named: "chat_bubble_received") : UIImage(named: "chat_bubble_sent")
            messageLabel.text = chatMessage.text
            
            if chatMessage.isIncoming{
                changeImage("chat_bubble_received")
                messageImage.tintColor = FlatSkyBlue()
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
                changeImage("chat_bubble_sent")
                messageImage.tintColor = FlatGreen()
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageImage)
        addSubview(messageLabel)
        addConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 18),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            
            messageImage.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -15),
            messageImage.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -15),
            messageImage.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 15),
            messageImage.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            
        ])
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        trailingConstraint.isActive = true
    }
    
    func changeImage(_ name: String){
        if let image = UIImage(named: name){
            messageImage.image = image
                .resizableImage(withCapInsets:
                                    UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
        }
    }
}
