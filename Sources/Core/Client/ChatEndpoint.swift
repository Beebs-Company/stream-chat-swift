//
//  ChatEndpoint.swift
//  StreamChatCore
//
//  Created by Alexey Bukhtin on 01/04/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import Foundation

/// Chat endpoints.
public enum ChatEndpoint {
    // MARK: - Client Endpoints
    
    /// Get a guest token.
    case guestToken(User)
    
    // MARK: - Device Endpoints
    
    // case addDevice(deviceId: String, User) ⚠️
    // case devices(User) ⚠️
    // case removeDevice(deviceId: String) ⚠️
    
    // MARK: - Channels Endpoints
    
    /// Get a list of channels.
    case channels(ChannelsQuery)
    
    // MARK: - Channel Endpoints
    
    /// Get a channel data.
    case channel(ChannelQuery)
    /// Send a message to a channel.
    case sendMessage(Message, Channel)
    /// Upload an image to a channel.
    case sendImage(_ fileName: String, _ mimeType: String, Data, Channel)
    /// Upload a file to a channel.
    case sendFile(_ fileName: String, _ mimeType: String, Data, Channel)
    /// Send a read event.
    case sendRead(Channel)
    /// Create a channel.
    case createChannel(Channel)
    
    // MARK: - Message Endpoints
    
    /// Get a thread data.
    case replies(Message, Pagination)
    /// Send a message action.
    case sendMessageAction(MessageAction)
    /// Delete a message.
    case deleteMessage(Message)
    /// Add a reaction to the message.
    case addReaction(_ reactionType: String, Message)
    /// Delete a reaction from the message.
    case deleteReaction(_ reactionType: String, Message)
    //case flagMessage(Message) ⚠️
    //case unflagMessage(Message) ⚠️
    
    // MARK: - Event Endpoints
    
    /// Send an event to a channel.
    case sendEvent(EventType, Channel)
    
    // MARK: - User Endpoints
    
    /// Get a list of users.
    case users(UsersQuery)
    //case updateUser(User) ⚠️
    //case updateUsers(User) ⚠️
    //case muteUser(User) ⚠️
    //case unmuteUser(User) ⚠️
}

extension ChatEndpoint {
    var method: Client.Method {
        switch self {
        case .channels, .replies, .users:
            return .get
        case .deleteMessage, .deleteReaction:
            return .delete
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .guestToken:
            return "guest"
        case .channels:
            return "channels"
        case .channel(let query):
            return path(to: query.channel, "query")
        case .createChannel(let channel):
            return path(to: channel)
        case .replies(let message, _):
            return path(to: message, "replies")
            
        case let .sendMessage(message, channel):
            if message.id.isEmpty {
                return path(to: channel, "message")
            }
            
            return path(to: message)
            
        case .sendMessageAction(let messageAction):
            return path(to: messageAction.message, "action")
        case .deleteMessage(let message):
            return path(to: message)
        case .sendRead(let channel):
            return path(to: channel, "read")
        case .addReaction(_, let message):
            return path(to: message, "reaction")
        case .deleteReaction(let reactionType, let message):
            return path(to: message, "reaction/\(reactionType)")
        case .sendEvent(_, let channel):
            return path(to: channel, "event")
        case .sendImage(_, _, _, let channel):
            return path(to: channel, "image")
        case .sendFile(_, _, _, let channel):
            return path(to: channel, "file")
        case .users:
            return "users"
        }
    }
    
    var queryItem: Encodable? {
        if case .replies(_, let pagination) = self {
            return pagination
        }
        
        return nil
    }
    
    var queryItems: [String: Encodable]? {
        let payload: Encodable
        
        switch self {
        case .channels(let query):
            payload = query
        case .users(let query):
            payload = query
        default:
            return nil
        }
        
        return ["payload": payload]
    }
    
    var body: Encodable? {
        switch self {
        case .channels,
             .replies,
             .deleteMessage,
             .deleteReaction,
             .sendImage,
             .sendFile,
             .users:
            return nil
        case .guestToken(let user):
            return ["user": user]
        case .channel(let query):
            return query
        case .createChannel(let channel):
            return channel
        case .sendMessage(let message, _):
            return ["message": message]
        case .sendMessageAction(let messageAction):
            return messageAction
        case .addReaction(let reactionType, _):
            return ["reaction": ["type": reactionType]]
        case .sendEvent(let event, _):
            return ["event": ["type": event]]
        case .sendRead:
            return Empty()
        }
    }
    
    var isUploading: Bool {
        switch self {
        case .sendImage,
             .sendFile:
            return true
        default:
            return false
        }
    }
    
    private func path(to channel: Channel, _ subPath: String? = nil) -> String {
        return "channels/\(channel.type.rawValue)/\(channel.id)\(subPath == nil ? "" : "/\(subPath ?? "")")"
    }
    
    private func path(to message: Message, _ subPath: String? = nil) -> String {
        return "messages/\(message.id)\(subPath == nil ? "" : "/\(subPath ?? "")")"
    }
}