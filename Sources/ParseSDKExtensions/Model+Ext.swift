//
//  Model+Ext.swift
//  Modernistik
//
//  Created by Anthony Persaud on 1/4/18.
//

import Foundation
import ParseSwift

extension ParseACL {
    public func setAccessFor(user: (any ParseUser)?, read: Bool = true, write: Bool = false) {
        if let user = user {
            setAccessFor(user: user, read: read, write: write)
        }
    }

    public func setFullAccessFor(user: (any ParseUser)?) {
        setAccessFor(user: user, read: true, write: true)
    }
}

extension ParseUser {
    /// Alias for `User.current?.objectId`
    public static var currentUserId: String? {
        return current?.objectId
    }

    /// Whether the current user is logged in.
    public static var isAvailable: Bool {
        return current != nil
    }

    /// Whether the current user is anonymous (unregistered)
    public static var isAnonymous: Bool {
        guard let current else { return false }
        return ParseAnonymous().isLinked(with: current)
    }

    /// Whether the current user is logged in and is not anonymous.
    public static var isRegistered: Bool {
        return isAvailable && !isAnonymous
    }

    /// Returns the current user only if they are logged in and not in an anonymous state.
    ///
    /// - Returns: The user if they are registered and logged in.
    public static func registeredUser() -> Self? {
        if let current, ParseAnonymous().isLinked(with: current) == false {
            return current
        }
        return nil
    }
}

public func == (x: any ParseUser, y: any ParseUser) -> Bool {
    return x.objectId == y.objectId && x.objectId != nil && y.objectId != nil
}

extension ParseInstallation {
    public static func registerPush(deviceToken: Data, block: BooleanResultBlock? = nil) {
        guard current.hasValue else { return }
        // TODO setter inaccessible
//        current?.setDeviceToken(deviceToken)
        saveInstallation(block: block)
    }

    /// Saves (eventually) the current installation in background.
    public static func saveInstallation(block: BooleanResultBlock? = nil) {
        guard let current else { return }
        current.save { result in
            switch result {
            case .failure(let error):
                block?(false, error)
            case .success(_):
                block?(true, nil)
            }
        }
    }
}
