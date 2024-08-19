//
//  Error+Ext.swift
//  Modernistik
//
//  Created by Anthony Persaud on 1/4/18.
//

import ParseSwift
import Foundation

extension Error {
    /// Returns `true` if the error is a Parse cache miss (120) error.
    /// See `PFErrorCode.errorCacheMiss`
    public var isCacheMiss: Bool {
        return code == ParseError.Code.cacheMiss.rawValue
    }

    /**
     Returns an error only if we consider this being a critical error. In general,
     all errors are critical except for two Parse errors: cache and sesion errors.

     It is usually expected that you handle errors in your queries and api calls.
     We recomned using the following pattern:
     ````
     if error == nil {
        // success
     } else if let error = error?.validError {
        // handle a non-cache or non-session error
     }
     ````
     ## Cache Errors
     Cache error are light errors but may not affect the continuation of the request. For example,
     if you perform a query with a cache policy of `.cacheThenNetwork` and there are no cached results
     for the query, you will receive a `.errorCacheMiss` (120) error, however, the query will continue
     going to the network to get server results.

     ## Session Errors
     These errors require special handling. In this case, this method will return nil in order to prevent your
     the error handling from executing. However, a `HyperdriveSessionErrorNotification` will be posted to the
     default notification center in order for you to handle the session error and log out the user of the application.
     This design pattern helps you from having to verify session errors in every query or API callback result block.
     */
    public var validError: Error? {
        if isCacheMiss { return nil }
        if isSessionError {
            NotificationCenter.default.post(name: .HyperdriveSessionErrorNotification, object: self, userInfo: nil)
            return nil
        }
        return self
    }

    /// Returns `true` if this error was due to an object not found or
    /// whether a query or object refresh produced no results. This could happen
    /// if the object doesn't exist in the system, or the current user is not allowed
    /// to view the object due to ACLs.
    /// See `PFErrorCode.errorObjectNotFound`
    public var isObjectNotFound: Bool {
        return code == ParseError.Code.objectNotFound.rawValue && domain == "Parse"
    }

    /// Returns `true` if this is a connection failure when connected to Parse server.
    /// See `PFErrorCode.errorConnectionFailed`
    public var isOffline: Bool {
        return code == ParseError.Code.connectionFailed.rawValue && domain == "Parse"
    }

    /// Cloud code script or hook had an error (Ex. before save hook fails)
    /// See `PFErrorCode.scriptError`
    public var isScriptError: Bool {
        return code == ParseError.Code.scriptFailed.rawValue && domain == "Parse"
    }

    /// Returns `true` if this is a Parse validation error.
    /// See `PFErrorCode.validationError`
    public var isValidationError: Bool {
        return code == ParseError.Code.validationFailed.rawValue && domain == "Parse"
    }

    /**
     Whether the error that occurs wasn't critical, and the original request can be retried.
     This may happen for a number of reasons, mostly due to network congestion or throttling.

     ## Rules
        * Errors with codes 3840 and 100, which are `bad json` Parse errors are retriable.
        * Parse errors `errorInternalServer`, `errorConnectionFailed`, `errorTimeout`,
        `errorRequestLimitExceeded`, and `errorExceededQuota` are retriable
        * Anything else is should not cause the app to retry a request to the server.
     */
    public var isRetriable: Bool {
        if code == 3840 || code == 100 {
            // bad json - usually heroku app misconfigured, which returns HTML instead of Parse JSON
            return true
        }
        guard domain == "Parse", let errorCode = ParseError.Code(rawValue: code) else { return false }

        switch errorCode {
        case .internalServer, .connectionFailed, .timeout, .requestLimitExceeded, .exceededQuota:
            return true
        default:
            return false
        }
    }

    /// Returns true if this is a Parse invalid session token error.
    /// A session error occurs when the session token
    /// for the user has expired or has been revoked in Parse.
    /// When this happens, the current user should be logged out of the app.
    public var isSessionError: Bool {
        return code == ParseError.Code.invalidSessionToken.rawValue || code == ParseError.Code.userCannotBeAlteredWithoutSession.rawValue
    }

    /// Return the error code.
    public var code: Int {
        return (self as NSError).code
    }

    /// Return the domain string for the error.
    public var domain: String {
        return (self as NSError).domain
    }
}
