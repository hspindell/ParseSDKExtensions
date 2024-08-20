//
//  Modernistik
//  Copyright © 2016 Modernistik LLC. All rights reserved.
//

import ParseSwift
import TimeZoneLocate
import Foundation

extension ParseObject {

    /// Returns `true` if this object does not have an objectId.
    public var isNew: Bool {
        isSaved == false
    }
    
    // TODO not sure what this originally represented
    // possibly whether this is a full object or just a pointer shell?
    public var isDataAvailable: Bool {
        // unfetched objects only have objectId and className
        createdAt.hasValue
    }
    
    public func update() {
        
    }
}

/// Adds an extensions to an arrays containing ParseObject subclasses.
extension Sequence where Iterator.Element: ParseObject {
    /// Transforms a list of Parse Objects into a list of
    /// their corresponding objectIds. This method will handle the case
    /// where some objects may not have objectIds.
    public var objectIds: [String] {
        return compactMap { $0.objectId }
    }
}
