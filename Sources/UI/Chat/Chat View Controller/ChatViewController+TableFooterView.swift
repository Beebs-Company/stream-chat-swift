//
//  ChatViewController+TableFooterView.swift
//  StreamChat
//
//  Created by Alexey Bukhtin on 04/05/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import UIKit
import StreamChatCore

// MARK: - Table Footer View

extension ChatViewController {
    
    func updateFooterView() {
        guard let footerView = tableView.tableFooterView as? ChatFooterView, let presenter = channelPresenter else {
            return
        }
        
        footerView.hide()
        
        guard InternetConnection.shared.isAvailable else {
            footerView.isHidden = false
            footerView.textLabel.text = "Attente de réseau..."
            return
        }
        
        guard Client.shared.webSocket.isConnected else {
            footerView.isHidden = false
            footerView.textLabel.text = "Chargement..."
            footerView.activityIndicatorView.startAnimating()
            return
        }
        
        guard !presenter.typingUsers.isEmpty, let user = presenter.typingUsers.first?.user else {
            return
        }
        
        footerView.isHidden = false
        footerView.textLabel.text = presenter.typingUsersText()
        footerView.avatarView.update(with: user.avatarURL, name: user.name, baseColor: style.incomingMessage.chatBackgroundColor)
        footerView.hide(after: TypingUser.timeout)
    }
}
