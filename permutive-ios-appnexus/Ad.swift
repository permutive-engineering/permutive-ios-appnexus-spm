//
//  Ad.swift
//  permutive-ios-appnexus
//

import Foundation
import protocol AppNexusSDK.ANAdProtocol
import class AppNexusSDK.ANNativeAdResponse
import class AppNexusSDK.ANAdResponseInfo
import class AppNexusSDK.ANAdView
import class AppNexusSDK.ANNativeAdRequest
import protocol AppNexusSDK.ANAdProtocolFoundationCore
import Permutive_iOS
import CoreGraphics

final class Ad {
    
    static func xandrAd(from response: AnyObject) -> XandrAd? {
        var adResponseInfo: ANAdResponseInfo?
        
        if let nativeAdResponse = response as? ANNativeAdResponse {
            adResponseInfo = nativeAdResponse.adResponseInfo
        }
        else if response.conforms(to: ANAdProtocol.self) {
            adResponseInfo = response.adResponseInfo
        }
        
        guard let adResponseInfo = adResponseInfo,
              let auctionId = adResponseInfo.auctionId,
              !auctionId.isEmpty else {
            return nil
        }
        var creativeId: Int? = nil
        if let adResponseCreativeId = adResponseInfo.creativeId {
            creativeId = Int(adResponseCreativeId)
        }
        return XandrAd(auctionId: auctionId,
                       brandCategoryId: nil,
                       buyerMemberId: adResponseInfo.memberId,
                       creativeId: creativeId,
                       mediaSubtypeId: nil,
                       mediaTypeId: Int(clamping: adResponseInfo.adType.rawValue),
                       source: adResponseInfo.contentSource,
                       adType: nil)
    }
    
    /// A constructor to build XandrSlot
    /// - Parameters:
    ///   - ad: An ad that was received on loading/impression; Must be of ANAdView or ANNativeAdRequest type
    ///   - adSize: The size of the ad, if specified; If a valid ad was passed as paramet, its value will be used instead.
    ///   - tagId: the tag id of the ad, if specified; If a valid ad was passed as paramet, its value will be used instead.
    ///   - targetId: the target id of the ad, if specified; If a valid ad was passed as paramet, its value will be used instead.
    ///   - targeting: the targeting applied to the ad, if specified; If a valid ad was passed as paramet, its value will be used instead.
    /// - Returns: A XandrSlot object
    static func xandrSlot(from ad: Any,
                          adSize: CGSize? = nil,
                          tagId: Int? = nil,
                          targetId: String? = nil,
                          targeting: [(String, String)]? = nil) -> XandrSlot {
        var size = adSize?.tuple
        var tagId = tagId
        var targetId = targetId
        
        switch ad {
        case let ad as ANAdView:
            size = (size == nil || size?.width == 0 || size?.height == 0) ? ad.bounds.size.tuple : size
            tagId = tagId ?? ad.memberId
            targetId = targetId ?? ad.inventoryCode ?? ad.placementId
        case let ad as ANNativeAdRequest:
            tagId = ad.memberId
            targetId = ad.inventoryCode ?? ad.placementId
        case let ad as ANAdProtocolFoundationCore:
            tagId = tagId ?? ad.memberId
        default: break
        }
        return XandrSlot(height: size?.height,
                         width: size?.width,
                         tagId: tagId,
                         targetId: targetId,
                         targeting: targeting)
    }
     
    static func trackImpression(adInfo: XandrAd?,
                                slotInfo: XandrSlot,
                                eventTrackable: EventTrackable) throws {
        guard let adInfo = adInfo else { return }
        
        let eventName = "AppNexusAdImpression"
        let adProperties = try adInfo.asEventProperties()
        let slotProperties = try slotInfo.asEventProperties()
        
        let properties = try EventProperties(["ad": adProperties, "slot": slotProperties])
        try eventTrackable.track(event: eventName, properties: properties)
    }
}

fileprivate
extension CGSize {
    var tuple: (height: Int, width: Int) {
        (height: Int(height), width: Int(width))
    }
}
