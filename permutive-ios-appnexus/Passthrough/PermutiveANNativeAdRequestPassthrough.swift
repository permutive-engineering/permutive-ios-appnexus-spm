//
//  PermutiveANNativeAdRequestPassthrough.swift
//  permutive-ios-appnexus
//

import Foundation
import Permutive_iOS
import protocol AppNexusSDK.ANNativeAdRequestDelegate
import class AppNexusSDK.ANNativeAdRequest
import class AppNexusSDK.ANAdResponseInfo
import class AppNexusSDK.ANNativeAdResponse

class PermutiveANNativeAdRequestPassthrough: Passthrough<ANNativeAdRequestDelegate> & ANNativeAdRequestDelegate {
    func adRequest(_ request: ANNativeAdRequest, didReceive response: ANNativeAdResponse) {
        trackAdImpression(request: request, response: response)
        delegate?.adRequest(request, didReceive: response)
    }
    
    func adRequest(_ request: ANNativeAdRequest, didFailToLoadWithError error: Error, with adResponseInfo: ANAdResponseInfo?) {
        delegate?.adRequest(request, didFailToLoadWithError: error, with: adResponseInfo)
    }
}

