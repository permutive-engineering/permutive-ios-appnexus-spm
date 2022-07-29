//
//  PermutiveANAdRequest.swift
//  permutive-ios-appnexus
//

import CoreGraphics
import Permutive_iOS
import class AppNexusSDK.ANNativeAdRequest
import protocol AppNexusSDK.ANNativeAdRequestDelegate

@objc
public class PermutiveANNativeAdRequest: ANNativeAdRequest {
    private lazy var passthrough: PermutiveANNativeAdRequestPassthrough = .init(target: self, sdk: Permutive.shared)
    
    @objc
    public var tracker: EventTrackable? {
        get { passthrough.tracker }
        set { passthrough.update(tracker: newValue) }
    }
    
    @objc
    public override var delegate: ANNativeAdRequestDelegate? {
        get { passthrough }
        set { passthrough.delegate = newValue }
    }
    
    @objc
    public override init() {
        super.init()
    }
    
    @objc
    public init(tracker: EventTrackable) {
        super.init()
        self.passthrough = .init(target: self, 
                                 tracker: tracker)
    }
}

extension PermutiveANNativeAdRequest: CustomKeyTargetable { }

#if DEBUG
internal extension PermutiveANNativeAdRequest {
     convenience init(sdk: EventTrackable & SDK & AnyObject) {
         self.init()
         self.passthrough = .init(target: self, tracker: sdk, sdk: sdk)
    }
}
#endif
