//
//  PermutiveANInstreamVideoAd.swift
//  permutive-ios-appnexus
//

import CoreGraphics
import Permutive_iOS
import class AppNexusSDK.ANInstreamVideoAd
import protocol AppNexusSDK.ANInstreamVideoAdLoadDelegate

@objc
public class PermutiveANInstreamVideoAd: ANInstreamVideoAd {
    private lazy var passthrough: PermutiveANInstreamVideoAdLoadPassthrough = {
        let adSize: CGSize? = (bounds.size.width.isZero || bounds.size.height.isZero) ? nil : bounds.size
        return .init(target: self, adSize: adSize, tagId: memberId, targetId: inventoryCode ?? placementId)
    }()
    
    @objc
    public var tracker: EventTrackable? {
        get { passthrough.tracker }
        set { passthrough.update(tracker: newValue) }
    }
    
    @objc
    public override func load(with loadDelegate: ANInstreamVideoAdLoadDelegate?) -> Bool {
        let result = super.load(with: passthrough)
        /// delegate MUST be set after `super.load` to prevent resetting delegate to passthrough
        passthrough.delegate = loadDelegate
        return result
    }
    
    @objc
    public override var loadDelegate: ANInstreamVideoAdLoadDelegate? {
        get { passthrough }
        set { passthrough.delegate = newValue }
    }
    
    @objc
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

extension PermutiveANInstreamVideoAd: CustomKeyTargetable { }

#if DEBUG
internal extension PermutiveANInstreamVideoAd {
    convenience init(sdk: EventTrackable & SDK & AnyObject) {
        self.init(placementId: "")
        self.passthrough = .init(target: self, tracker: sdk, sdk: sdk)
    }
}
#endif
