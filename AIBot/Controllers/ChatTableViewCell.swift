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
    
    
    let bubbleBackgroundView: UIView = {
        let bubbleBackground = UIView()
        bubbleBackground.layer.cornerRadius = 20
        bubbleBackground.translatesAutoresizingMaskIntoConstraints = false
        return bubbleBackground
    }()
    
    
    let messageImage: UIImageView = {
        let messageImage = UIImageView()
        messageImage.image = UIImage(named: "AIimage")
        messageImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return messageImage
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet{
            bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? .flatSkyBlue() : .flatGreen()
            messageLabel.text = chatMessage.text
            
            if chatMessage.isIncoming{
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageImage)
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
       
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 20),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -12),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            
            messageImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
           
        ])
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    }
}
