//
//  GeoPoint+Ext.swift
//  Bolts
//
//  Created by Anthony Persaud on 1/4/18.
//

import ParseSwift
import CoreLocation

extension CLLocationCoordinate2D {
    /// Returns a geoPoint object from this location.
    public var geoPoint: ParseGeoPoint {
        (try? ParseGeoPoint(coordinate: self)) ?? .zero
    }
}

extension CLLocation {
    /// Return a ParseGeoPoint representing this CLLocation
    public var geoPoint: ParseGeoPoint? {
        (try? ParseGeoPoint(location: self)) ?? .zero
    }
}

extension ParseGeoPoint {
    public static var zero: ParseGeoPoint {
        (try? ParseGeoPoint(latitude: 0, longitude: 0)) ?? .zero
    }

    /// A convenience setter and getter to convert between PFGeoPoints and CLLocation objects
    public var location: CLLocation {
        get {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.coordinate.latitude
            longitude = newValue.coordinate.longitude
        }
    }

    // estimate within 0.69 miles
    public var estimated: ParseGeoPoint {
        return rounded(digits: 1)
    }

    public func rounded(digits: Double = 1) -> ParseGeoPoint {
        let multiplier = pow(10, digits)
        let lat = round(multiplier * latitude) / multiplier // weird that it comes back as .00000000001
        let lng = round(multiplier * longitude) / multiplier
        return (try? ParseGeoPoint(latitude: lat, longitude: lng)) ?? .zero
    }
}

public func == (l: ParseGeoPoint, r: ParseGeoPoint) -> Bool {
    return l.latitude == r.latitude && l.longitude == r.longitude
}

extension ParseGeoPoint {
    /// Gets the timeZone at this particular location
    public var timeZone: TimeZone {
        return location.timeZone
    }
}
