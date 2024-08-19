//
//  Modernistik
//  Copyright © 2016 Modernistik LLC. All rights reserved.
//

import Modernistik
import ParseSwift
import Foundation
import UIKit

/// Alias to block type `PFIdResultBlock` with signature `(result,error)`.
public typealias FunctionResultBlock<T> = (T?, Error?) -> Void
/// Alias to block type `PFGeoPointResultBlock` with signature `(geopoint,error)`.
public typealias GeoPointResultBlock = (ParseGeoPoint?, Error?) -> Void

// temp
public typealias BooleanResultBlock = (Bool, Error?) -> Void


/// Alias to `ParseUser`. Subclass this to add properties to your user class.
//public typealias HyperdriveUser = ParseUser

/// Alias to `ParseRole`.
//public typealias HyperdriveRole = ParseRole

/// Alias to `ParseInstallation`.
//public typealias HyperdriveInstallation = ParseInstallation

/// Alias to `PFSubclassing` protocol.
/// ## Discussion
/// The reason for the alias is that we will be making additional enhancements with Swift and
/// protocol extensions to make things easier to setup.
//public typealias ParseSubclassing = ParseSubclassing

/// Alias to `PFCachePolicy`
//public typealias QueryCachePolicy = PFCachePolicy

/// Alias to `PFQuery`
//public typealias Query = PFQuery
/// Alias to `ParseGeoPoint`
//public typealias GeoPoint = ParseGeoPoint

/// Alias to `PFFile`
//public typealias ParseFile = ParseFile

/// Alias for `[String: Any]`
public typealias Params = [String: Any]

struct HyperdriveCloud: ParseCloud {
    typealias ReturnType = Bool
    
    var functionJobName: String
}



/**
 Protocol that defines an clean interface with interacting with Modernistik Hyperdrive server.
 It is recommended for classes that will encapsulate the SDK connecting to the server to implement
 this protocol.
 ## Example
 ````
 class MyAppServer : Hyperdrive {
    enum Function: String {
        case helloWorld
        case myCloudCodeMethodName
        // ... other methods listed here.
    }
 }
 ````

 Doing so will allow the extensions to Hyperdrive to be applied to your class providing a
 standard interface to making API calls. You can then connect and setup the stack by calling the method
 `setup` and, if needed, set any default `ACLs` for created objects.

 ````
 // Connect
 MyAppServer.setup(
        serverUrl:"<server_url>",
    applicationId:"<app id>,
        clientKey:"<client id>")

 // optional: Set default public acls
 MyAppServer.setupDefaultPublicACL(
            read: true, write: false
 )

 // optional: Fetch config when app becomes active
 MyAppServer.updateConfiguration()
 ````
 Those methods should be called early in the launch of your `UIApplicationDelegate`.
 */
public protocol Hyperdrive {
    /// An enum type for implementors of the Hyperdrive protocol that should list all cloud function names.
    /// It is highly recommended for this to be of type `String`.
    associatedtype Function: RawRepresentable

    /// A **synchronous** API to call a cloud function.
    ///
    /// - Parameter function: The name of the function.
    /// - Parameter params: The parameters to send to the function.
    /// - Returns: The result of the function.
    /// - Throws: The server error that was returned.
    static func call(function: String, with params: Params?) throws -> Any

    /// An **asynchronous** API to call a cloud function.
    ///
    /// - Parameter function: The name of the function.
    /// - Parameter params: The parameters to send to the function.
    /// - Parameter block: The block to execute when the function call finished. It should have the following argument signature: `(result,error)`.
//    static func callInBackground(function: String, with params: Params?, block: FunctionResultBlock?)

    /**
     The method to call to initiate configuration and connection to the Hyperdrive server.

     - Parameter serverUrl: The server url of the Hyperdrive server. (ex. http://localhost:1337/parse)
     - Parameter applicationId: The application id defined on the server.
     - Parameter clientKey: The client key defined on the server.
     */
    static func setup(serverUrl: String, applicationId: String, clientKey: String)

    /// Method to fetch updated configuration (Parse Config) from the server. If successful, it
    /// will send a `HyperdriveConfigUpdatedNotification` notification.
    ///
    /// - Parameter completion: A completion handler when the fetch has been completed.
    static func updateConfiguration(completion: ResultBlock?)
}

extension Hyperdrive where Function.RawValue == String {
    /**
     A **synchronous** API to call a cloud function.
      ## Example

      ````
      class MyAppServer : Hyperdrive {
         enum Function: String {
             case helloWorld
         }
      }

      let params = ["key":"value"]

      MyAppServer.call(function: .helloWorld, with: params)
      ````

     - Parameter function: One of the `Function` enums defined in your Hyperdrive class.
     - Parameter params: The parameters to send to the function.
     - Returns: The result of the function.
     - Throws: The server error that was returned.
     */
    @discardableResult
    public static func call(function: Function, with params: Params? = nil) throws -> Any {
        // TODO how to add params?
        try HyperdriveCloud(functionJobName: function.rawValue).runFunction()
    }

    /**
     A **asynchronous** API to call a Hyperdrive cloud function.
     ## Example

     ````
     class MyAppServer : Hyperdrive {
        enum Function: String {
            case helloWorld
        }
     }

     let params = ["key":"value"]

     MyAppServer.callInBackground(function: .helloWorld, with: params) { (result, error) in
        // handle result or error
     }
     ````

     - Parameter function: One of the `Function` enums defined in your Hyperdrive class.
     - Parameter params: The parameters to send to the function.
     - Parameter block: The block to execute when the function call finished. It should have the following argument signature: `(result,error)`.
     */
//    public static func callInBackground(function: Function, with params: Params? = nil, block: FunctionResultBlock?) {
//        // TODO "background"? + params
//        try HyperdriveCloud(functionJobName: function.rawValue).runFunction() { result in
////            block?(result)
//        }
//    }
}

extension Hyperdrive {
    /// Returns the config value based on the key.
    ///
    /// - Parameter key: The name of the configuration key.
    /// - Returns: The value for this key if any.
//    public static func config(_ key: String) -> Any? {
//        return nil
//    }

    /// Method to fetch updated configuration (Parse Config) from the server. If successful, it
    /// will send a `HyperdriveConfigUpdatedNotification` notification.
    ///
    /// - Parameter completion: A completion handler when the fetch has been completed.
//    public static func updateConfiguration(completion: ResultBlock? = nil) {
//        ParseConfig.getInBackground { (config, error) -> Void in
//            completion?(error)
//            guard error == nil else { return }
//            NotificationCenter.default.post(name: .HyperdriveConfigUpdatedNotification, object: config, userInfo: nil)
//        }
//    }

    /// Clears all results for queries that have been cached.
    public static func clearCaches() {
        // TODO
//        PFQuery.clearAllCachedResults()
    }

    /**
     The method to call to initiate configuration and connection to the Hyperdrive server. It will also
     automatically enable revocable sessions in background.

     - Parameter serverUrl: The server url of the Hyperdrive server. (ex. http://localhost:1337/parse)
     - Parameter applicationId: The application id defined on the server.
     - Parameter clientKey: The client key defined on the server.
     */
    public static func setup(serverUrl: String, applicationId: String, clientKey: String) {
        guard let serverURL = serverUrl.url else { return }
        let configuration = ParseConfiguration(applicationId: applicationId, clientKey: clientKey, serverURL: serverURL)
//        ParseUser.enableRevocableSessionInBackground()
        ParseSwift.initialize(configuration: configuration)
    }

    /**
     Sets the default public (global) and user read/write priviledges when
     the app or user creates new objects.

     - Parameter read: The default public read ACL to give new objects.
     - Parameter write: The default public write ACL to give new objects.
     - Parameter currentUserAccess: If `true` (default), the ACL that is applied to
     newly-created Parse objects will provide read and write access to the current
     logged in user at the time of creation. If `false`, the provided
     `acl` will be used without modification.
     */
    @discardableResult
    public static func setupDefaultPublicACL(read: Bool, write: Bool, withAccessForCurrentUser currentUserAccess: Bool = true) throws -> ParseACL {
        var defaultACL = ParseACL()
        defaultACL.publicRead = read
        defaultACL.publicWrite = write
        return try ParseACL.setDefaultACL(defaultACL, withAccessForCurrentUser: currentUserAccess)
    }

    /// A **synchronous** API to call a cloud function.
    ///
    /// - Parameter function: The name of the function.
    /// - Parameter params: The parameters to send to the function.
    /// - Returns: The result of the function.
    /// - Throws: The server error that was returned.
//    @discardableResult
//    public static func call(function: String, with params: Params? = nil) throws -> Any {
//        return try ParseCloud.callFunction(function, withParameters: params)
//    }

    /// An **asynnchronous** API to call a cloud function.
    ///
    /// - Parameter function: The name of the function.
    /// - Parameter params: The parameters to send to the function.
    /// - Parameter block: The block to execute when the function call finished. It should have the following argument signature: `(result,error)`.
//    public static func callInBackground(function: String, with params: Params? = nil, block: FunctionResultBlock?) {
//        ParseCloud.callFunction(inBackground: function, withParameters: params, block: block)
//    }
}

extension Notification.Name {
    /// Notification sent when the global config has been updated from the server. You can update the configuration data
    /// by calling `Verdad.config.updateConfiguration` method.
    public static let HyperdriveConfigUpdatedNotification = Notification.Name(rawValue: "HyperdriveConfigUpdatedNotification")

    /**
     Notification sent when the server responds with a session error. This could mean the current logged in user token
     is invalid or has been revoked.
     - attention: When this is received, the application should immediately logout the user as they will not be ble to access
     any non-public readable data from the server.
     */
    public static let HyperdriveSessionErrorNotification = Notification.Name(rawValue: "HyperdriveSessionErrorNotification")
}
