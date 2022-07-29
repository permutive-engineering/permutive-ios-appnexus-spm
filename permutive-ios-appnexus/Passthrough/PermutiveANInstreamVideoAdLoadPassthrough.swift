//
//  ANInstreamVideoAdLoadPassthrough.swift
//  permutive-ios-appnexus
//

import Foundation
import Permutive_iOS
import protocol AppNexusSDK.ANInstreamVideoAdLoadDelegate

class PermutiveANInstreamVideoAdLoadPassthrough: Passthrough<ANInstreamVideoAdLoadDelegate> & ANInstreamVideoAdLoadDelegate {
    func adDidReceiveAd(_ ad: Any) {
        /// Where ANInsteamVideoAd: ANAdView
        trackAdImpression(ad)
        delegate?.adDidReceiveAd(ad)
    }
    
    func ad(_ ad: Any, requestFailedWithError error: Error) {
        delegate?.ad?(ad, requestFailedWithError: error)
    }
}

