//
//  RequestTargeting.swift
//  permutive-ios-appnexus
//

import Foundation
import protocol AppNexusSDK.ANAdProtocolFoundation
import Permutive_iOS

/// Protocol defining the method which need to be accessible from our iOS SDK
/// Used for testing purposes.
protocol SDK {
    var reactions: [String: [Int]] { get }
    var currentUserId: String? { get }
    func measure(_ metric: Metric)
}

extension Permutive: SDK {}

/// Protocol defining hability to add targeting information.
protocol CustomKeyTargetable {
    /// Returns Permutive targeting
    /// - Parameter sdk: The Permutive SDK
    /// - Returns: Appnexus targeting
    func targeting(_ sdk: SDK) -> [[String: String]]
    /// Adds Permutive targeting to entity implementing Customizable protocol
    /// - Parameter targeting: The targeting info to add
    func addPermutiveTargeting(_ targeting: [[String: String]])
}

/// Default behaviour for Entity implementing both Customizable and ANAdProtocolFoundation protocol
extension CustomKeyTargetable where Self: ANAdProtocolFoundation {
    func targeting(_ sdk: SDK) -> [[String: String]] {
        CustomTargeting.targeting(sdk)
    }
    
    func addPermutiveTargeting(_ targeting: [[String: String]]) {
        targeting.forEach {
            $0.forEach { key, value in
                self.addCustomKeyword(withKey: key, value: value)
            }
        } 
    }
}

struct CustomTargeting {
    static func targeting(_ sdk: SDK) -> [[String: String]] {
        guard let reactions = sdk.reactions["appnexus_adserver"] else { return [] }
        var targeting = reactions.map { ["permutive": String($0)] }
        targeting.append(["ptime": DateFormatter.iso8601.string(from: Date())])
        if let puid = sdk.currentUserId {
            targeting.append(["puid": puid])
        }
        return targeting
    }
}

fileprivate
extension DateFormatter {
    static let iso8601: ISO8601DateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime,
                                   .withTimeZone]
        return formatter
    }()
}
