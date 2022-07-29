//
//  XandrAd.swift
//  permutive-ios-appnexus
//

import Foundation
import Permutive_iOS

struct XandrAd {
    let auctionId: String?
    let brandCategoryId: Int?
    let buyerMemberId: Int?
    let creativeId: Int?
    let mediaSubtypeId: Int?
    let mediaTypeId: Int?
    let source: String?
    let adType: String?
    
    func asEventProperties() throws -> EventProperties {
        let properties = try EventProperties(["auction_id": auctionId])
        if let brandCategoryId = brandCategoryId {
            try properties.set(number: NSNumber(value: brandCategoryId), forKey: "brand_category_id")
        }
        if let buyerMemberId = buyerMemberId {
            try properties.set(number: NSNumber(value: buyerMemberId), forKey: "buyer_member_id")
        }
        if let creativeId = creativeId {
            try properties.set(number: NSNumber(value: creativeId), forKey: "creative_id")
        }
        if let mediaTypeId = mediaTypeId {
            try properties.set(number: NSNumber(value: mediaTypeId), forKey: "media_type_id")
        }
        if let mediaSubtypeId = mediaSubtypeId {
            try properties.set(number: NSNumber(value: mediaSubtypeId), forKey: "media_sub_type_id")
        }
        if let source = source {
            try properties.set(string: source, forKey: "source")
        }
        if let adType = adType {
            try properties.set(string: adType, forKey: "type")
        }
        return properties
    }
}
