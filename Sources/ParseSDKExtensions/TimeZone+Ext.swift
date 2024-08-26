//
//  TimeZone+Ext.swift
//  Modernistik
//
//  Created by Anthony Persaud on 1/4/18.
//
import ParseSwift
import TimeZoneLocate
import Foundation
import CoreLocation

/**
 This protocol adds special methods to `ParseObject` and subclasses that allow
 for easier handling of timeZone information. It utilizes a combination of
 `TimeZoneLocate` (supports offline) and `CLGeocoder` to provide the
 best-effort timezone identification based on a location.

 To use this functionality, the Parse collection should have a
 `timeZone` column of type `String`, and a `location`
 column of type `GeoPoint` in your Parse database schema.
 You can then have your ParseObject subclasses implement
 the `TimeZoneAccessible` protocol to gain the special handling.

 This protocol will then use add the accessors to the `timeZone` property.
 However, if the property is empty or has an invalid time zone identifier,
 it will use the `location` field with `TimeZoneLocate` to determine
 a fast best-effort guess of the time zone at that location
 (off-line + synchronous), and if available, update the field with
 the more accurate time zone by reverse geocoding the location (network + async).
 */
public protocol TimeZoneAccessible {
    /// A location property that returns the geopoint.
    var location: ParseGeoPoint? { get }
    /// Returns the time zone, either from the stored object, or best-effort
    /// from either `TimeZoneLocate` database or `CLGeocoder`.

    var timeZone: String? { get set }
}

extension TimeZoneAccessible where Self: ParseObject {
    /**
     Returns the time zone for this record. All time zone information in Parse is
     stored using its string identifier. An example identifier is “America/Los_Angeles”.
     If the time zone has not been set or has an invalid identifier, the `TimeZoneLocate` methods
     will be used to get the best-effort timezone (off-line), and if the network connection is available,
     kick of an asynchronous task to update it with a more accurate time zone using `CLGeocoder` by reverse
     geocoding the object's `location` field.
     - note:
      To get the special handling, the `location` field must be set to a
     valid geopoint. If neither the `location` or `timeZone` have
     been set, this object returns the device's current time zone with
     `TimeZone.current`.
     - important:
     To use this functionality, the Parse collection should have a `timeZone` column
     of type `String`, and a `location` column of type `GeoPoint` in your Parse database schema.
     You can then have your ParseObject subclasses implement the `TimeZoneAccessible`
     protocol to gain the special handling.
     */
    public var tz: TimeZone {
        get {
            guard let timeZone, let type = TimeZone(identifier: timeZone) else {
                return .current
            }
            return type
        }
        set {
            timeZone = newValue.identifier
        }
    }

    /// Silently updates the `timeZone` property with an accruate time zone
    /// by reverse geocoding the `location` field, if available.
//    public mutating func updateTimeZone() {
//        let coder = CLGeocoder()
//        guard let loc = location?.location else { return }
//
//        coder.reverseGeocodeLocation(loc) { placemarks, _ in
//            guard let tz = placemarks?.last?.timeZone else { return }
//            self.tz = tz // .identifier
//        }
//    }
}
