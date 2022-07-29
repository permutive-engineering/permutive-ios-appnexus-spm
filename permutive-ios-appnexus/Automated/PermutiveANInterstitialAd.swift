//
//  PermutiveANInterstitialAd.swift
//  permutive-ios-appnexus
//

import CoreGraphics
import Permutive_iOS
import class AppNexusSDK.ANInterstitialAd
import protocol AppNexusSDK.ANInterstitialAdDelegate

@objc
public class PermutiveANInterstitialAd: ANInterstitialAd {
    private lazy var passthrough: PermutiveANInterstitialAdPassthrough = {
        .init(target: self, 
              adSize: frame.size, 
              tagId: memberId, 
              targetId: inventoryCode ?? placementId)
    }()
    
    @objc
    public var tracker: EventTrackable? {
        get { passthrough.tracker }
        set { passthrough.update(tracker: newValue) }
    }
    
    @objc
    public override var delegate: ANInterstitialAdDelegate? {
        get { passthrough }
        set { passthrough.delegate = newValue }
    }
    
    @objc
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc
    public init(frame: CGRect, tracker: EventTrackable) {
        super.init(frame: frame)
        self.passthrough = .init(target: self, 
                                 tracker: tracker, 
                                 adSize: frame.size)
    }
    
    @objc
    public override init(placementId: String) {
        super.init(placementId: placementId)
    }
    
    @objc
    public init(placementId: String, tracker: EventTrackable) {
        super.init(placementId: placementId)
        self.passthrough = .init(target: self, 
                                 tracker: tracker, 
                                 targetId: placementId)
    }
    
    @objc
    public override init(memberId: Int, inventoryCode: String) {
        super.init(memberId: memberId, inventoryCode: inventoryCode)
    }
    
    @objc
    public init(memberId: Int, inventoryCode: String, tracker: EventTrackable) {
        super.init(memberId: memberId, inventoryCode: inventoryCode)
        self.passthrough = .init(target: self, 
                                 tracker: tracker, 
                                 tagId: memberId,
                                 targetId: inventoryCode)
    }
}

extension PermutiveANInterstitialAd: CustomKeyTargetable { }

#if DEBUG
internal extension PermutiveANInterstitialAd {
    convenience init(sdk: EventTrackable & SDK & AnyObject) {
        self.init(placementId: "")
        self.passthrough = .init(target: self, tracker: sdk, sdk: sdk)
    }
}
#endif
