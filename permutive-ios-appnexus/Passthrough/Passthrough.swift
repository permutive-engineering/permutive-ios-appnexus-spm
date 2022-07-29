//
//  AppNexusDelegate.swift
//  permutive-ios-appnexus
//

import CoreGraphics
import Permutive_iOS
import class AppNexusSDK.ANNativeAdRequest
import class AppNexusSDK.ANNativeAdResponse

class Passthrough<Delegate: AnyObject>: NSObject  {
    private(set) weak var tracker: EventTrackable? = nil
    weak var delegate: Delegate?
    weak var sdk: (SDK & AnyObject)?
    
    private var adSize: CGSize?
    private var tagId: Int?
    private var targetId: String?
    private var targeting: [(String, String)]?
    
    init(target: CustomKeyTargetable, 
         tracker: EventTrackable = Permutive.shared,
         sdk: (SDK & AnyObject) = Permutive.shared,
         adSize: CGSize? = nil, 
         tagId: Int? = nil, 
         targetId: String? = nil) {
        
        let timer = ElapsedTimer()
        timer.start()
       
        // Initiation
        let targeting = target.targeting(sdk)
        target.addPermutiveTargeting(targeting)
        self.tracker = tracker
        self.sdk = sdk
        self.adSize = adSize
        self.tagId = tagId
        self.targetId = targetId
        self.targeting = targeting.compactMap {
            guard let first = $0.first else { return nil }
            return (first.key, first.value)
        }
        super.init() 
        
        sdk.measure(.setPermutiveAdListener(duration: timer.duration))       
    }
    
    /// Only update the tracker if it exist.
    /// - Parameter tracker: A tracker object implementing EventTrackable
    func update(tracker: EventTrackable?) {
        guard let tracker = tracker else { return }
        self.tracker = tracker
    }
    
    
    /// For all AN entities which have the response information contained in the ad object
    /// - Parameter ad: An ad object which implement protocol ANNativeAdResponse, ANAdProtocol, ANAdProtocolFoundation or ANAdView.
    func trackAdImpression(_ ad: Any) {
        let metric: Metric = .recordAppNexusAdImpression {
            let slotInfo = Ad.xandrSlot(from: ad, adSize: adSize, tagId: tagId, targetId: targetId, targeting: targeting)
            let adInfo = Ad.xandrAd(from: ad as AnyObject)
            trackAdImpression(adInfo: adInfo, slotInfo: slotInfo, eventTrackable: tracker)   
        }
        sdk?.measure(metric)
    }
    
    /// A special trackAdImpression for ANNativeAdRequest which split response and request in two objects
    /// - Parameters:
    ///   - request: A ANNativeAdRequest entity
    ///   - response: A ANNativeAdResponse entity
    func trackAdImpression(request: ANNativeAdRequest, response: ANNativeAdResponse) {
        let metric: Metric = .recordAppNexusAdImpression {
            let slotInfo = Ad.xandrSlot(from: request, adSize: adSize, tagId: tagId, targetId: targetId, targeting: targeting)
            let adInfo = Ad.xandrAd(from: response as AnyObject)
            trackAdImpression(adInfo: adInfo, slotInfo: slotInfo, eventTrackable: tracker)
        }
        sdk?.measure(metric)
    }
}

private extension Passthrough {
    func trackAdImpression(adInfo: XandrAd?, slotInfo: XandrSlot, eventTrackable: EventTrackable?) {
        guard let tracker = tracker else { return }
        do { 
            try Ad.trackImpression(adInfo: adInfo, slotInfo: slotInfo, eventTrackable: tracker)
        } 
        catch {
            // TODO: [EDGM-40] Add metric info
        }
    }
}
