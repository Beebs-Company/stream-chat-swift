//
//  Channel+Events.swift
//  StreamChatCore
//
//  Created by Alexey Bukhtin on 10/01/2020.
//  Copyright © 2020 Stream.io Inc. All rights reserved.
//

import Foundation

public extension Channel {
    
    /// Observe channel events.
    /// - Parameters:
    ///   - eventType: an event type.
    ///   - completion: a completion block with `Event`.
    /// - Returns: a subscription.
    func onEvent(_ eventType: EventType, _ completion: @escaping ClientCompletion<Event>) -> Subscription {
        return rx.onEvent(eventType).bind(to: completion)
    }
    
    /// Observe a list of events with a given channel id (optional).
    /// - Parameters:
    ///   - eventType: an event type.
    ///   - completion: a completion block with `Event`.
    /// - Returns: a subscription.
    func onEvent(_ eventTypes: [EventType] = [], _ completion: @escaping ClientCompletion<Event>) -> Subscription {
        return rx.onEvent(eventTypes).bind(to: completion)
    }
    
    /// An observable isUnread state of the channel.
    /// - Parameter completion: a completion block with `Bool`.
    /// - Returns: a subscription.
    func isUnread(_ completion: @escaping ClientCompletion<Bool>) -> Subscription {
        return rx.isUnread.asObservable().bind(to: completion)
    }
    
    /// Observe an unread count of messages in the channel.
    /// - Note: Be sure the current user is a member of the channel.
    /// - Note: 100 is the maximum unread count of messages.
    /// - Parameter completion: a completion block with `Int`.
    /// - Returns: a subscription.
    func unreadCount(_ completion: @escaping ClientCompletion<Int>) -> Subscription {
        return rx.unreadCount.asObservable().bind(to: completion)
    }
    
    /// Observe a user mentioned unread count of messages in the channel.
    /// - Note: Be sure the current user is a member of the channel.
    /// - Note: 100 is the maximum unread count of messages.
    /// - Parameter completion: a completion block with `Int`.
    /// - Returns: a subscription.
    func mentionedUnreadCount(_ completion: @escaping ClientCompletion<Int>) -> Subscription {
        return rx.mentionedUnreadCount.asObservable().bind(to: completion)
    }
    
    /// Online users in the channel.
    /// - Note: Be sure users are members of the channel.
    /// - Parameter completion: a completion block with `[User]`.
    /// - Returns: a subscription.
    func onlineUsers(_ completion: @escaping ClientCompletion<[User]>) -> Subscription {
        return rx.onlineUsers.asObservable().bind(to: completion)
    }
}
