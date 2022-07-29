//
//  XandrSlot.swift
//  permutive-ios-appnexus
//

import Foundation
import Permutive_iOS

struct XandrSlot {
    let height: Int?
    let width: Int?
    let tagId: Int?
    let targetId: String?
    let targeting: [(String, String)]?
    
    func asEventProperties() throws -> EventProperties {
        let properties = EventProperties()
        if let height = height {
            try properties.set(number: NSNumber(value: height), forKey: "height")
        }
        if let width = width {
            try properties.set(number: NSNumber(value: width), forKey: "width")
        }
        if let tagId = tagId {
            try properties.set(number: NSNumber(value: tagId), forKey: "tag_id")
        }
        if let targetId = targetId {
            try properties.set(string: targetId, forKey: "target_id")
        }
        if let targeting = targeting {
            let targetingProperties = try targeting.map {
                // Set "value" to be array of tuple's second value
                try EventProperties(["key": $0.0, "value": [$0.1]])
            }
            try properties.set(propertiesList: targetingProperties, forKey: "targeting")
        }
        return properties
    }
}
