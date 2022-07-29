//
//  PermutiveANBannerAdView.swift
//  permutive-ios-appnexus
//

import CoreGraphics
import Permutive_iOS
import class AppNexusSDK.ANBannerAdView
import protocol AppNexusSDK.ANBannerAdViewDelegate

@objc
public class PermutiveANBannerAdView: ANBannerAdView {
    private lazy var passthrough: PermutiveANBannerAdViewPassthrough = {
        .init(target: self, 
              sdk: Permutive.shared, 
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
    public override var delegate: ANBannerAdViewDelegate? {
        get { passthrough }
        set { passthrough.delegate = newValue }
    }
    
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
    public override init(frame: CGRect, placementId: String) {
        super.init(frame: frame, placementId: placementId)
    }
    
    
    @objc
    public init(frame: CGRect, placementId: String, tracker: EventTrackable) {
        super.init(frame: frame, placementId: placementId)
        self.passthrough = .init(target: self, 
                                 tracker: tracker,
                                 adSize: frame.size,
                                 targetId: placementId)
    }
    
    @objc
    public override init(frame: CGRect, memberId: Int, inventoryCode: String) {
        super.init(frame: frame, memberId: memberId, inventoryCode: inventoryCode)
    }
    
    @objc
    public init(frame: CGRect, memberId: Int, inventoryCode: String, tracker: EventTrackable) {
        super.init(frame: frame, memberId: memberId, inventoryCode: inventoryCode)
        self.passthrough = .init(target: self, 
                                 tracker: tracker, 
                                 adSize: frame.size,
                                 tagId: memberId,
                                 targetId: inventoryCode)
    }
    
    @objc
    public override init(frame: CGRect, placementId: String, adSize: CGSize) {
        super.init(frame: frame, placementId: placementId, adSize: adSize)
    }
    
    @objc
    public init(frame: CGRect, placementId: String, adSize: CGSize, tracker: EventTrackable) {
        super.init(frame: frame, placementId: placementId, adSize: adSize)
        self.passthrough = .init(target: self, 
                                 tracker: tracker, 
                                 adSize: adSize,
                                 targetId: placementId)
    }
    
    @objc
    public override init(frame: CGRect, memberId: Int, inventoryCode: String, adSize: CGSize) {
        super.init(frame: frame, memberId: memberId, inventoryCode: inventoryCode, adSize: adSize)
    }
    
    @objc
    public init(frame: CGRect, memberId: Int, inventoryCode: String, adSize: CGSize, tracker: EventTrackable) {
        super.init(frame: frame, memberId: memberId, inventoryCode: inventoryCode, adSize: adSize)
        self.passthrough = .init(target: self, 
                                 tracker: tracker, 
                                 adSize: adSize,
                                 tagId: memberId,
                                 targetId: inventoryCode)
    }
}

extension PermutiveANBannerAdView: CustomKeyTargetable { }

#if DEBUG
internal extension PermutiveANBannerAdView {
    convenience init(sdk: EventTrackable & SDK & AnyObject) {
        self.init(frame: .zero)
        self.passthrough = .init(target: self, tracker: sdk, sdk: sdk)
    }
}
#endif
