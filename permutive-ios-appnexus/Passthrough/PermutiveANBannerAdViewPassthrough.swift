//
//  ANBannerAdViewPassthrough.swift
//  permutive-ios-appnexus
//

import Foundation
import Permutive_iOS
import protocol AppNexusSDK.ANBannerAdViewDelegate

class PermutiveANBannerAdViewPassthrough: Passthrough<ANBannerAdViewDelegate> & ANBannerAdViewDelegate {
    // MARK: - ANAdDelegate
    
    func adDidReceiveAd(_ ad: Any) {
        delegate?.adDidReceiveAd?(ad)
    }
    
    func lazyAdDidReceiveAd(_ ad: Any) {
        delegate?.lazyAdDidReceiveAd?(ad)
    }
    
    func ad(_ loadInstance: Any, didReceiveNativeAd responseInstance: Any) {
        delegate?.ad?(loadInstance, didReceiveNativeAd: responseInstance)
    }
    
    func ad(_ ad: Any, requestFailedWithError error: Error) {
        delegate?.ad?(ad, requestFailedWithError: error)
    }
    
    func adWasClicked(_ ad: Any) {
        delegate?.adWasClicked?(ad)
    }
    
    func adWasClicked(_ ad: Any, withURL urlString: String) {
        delegate?.adWasClicked?(ad, withURL: urlString)
    }
    
    func adDidLogImpression(_ ad: Any) {
        /// Where ANBannerAdView: ANAdView
        trackAdImpression(ad)
        delegate?.adDidLogImpression?(ad)
    }
    
    func adWillClose(_ ad: Any) {
        delegate?.adWillClose?(ad)
    }
    
    func adDidClose(_ ad: Any) {
        delegate?.adDidClose?(ad)
    }
    
    func adWillPresent(_ ad: Any) {
        delegate?.adWillPresent?(ad)
    }
    
    func adDidPresent(_ ad: Any) {
        delegate?.adDidPresent?(ad)
    }
    
    func adWillLeaveApplication(_ ad: Any) {
        delegate?.adWillLeaveApplication?(ad)
    }
}

