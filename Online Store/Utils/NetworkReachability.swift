//
//  NetworkReachability.swift
//  SwiftUICombine
//
//  Created by Олександр Швидкий on 09.08.2022.
//

import Foundation
import SystemConfiguration

class NetworkReachability: ObservableObject {
    @Published var reachable: Bool = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.firebase.google.com")
    
    init() {
        checkConnection()
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let connectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!connectionRequired || canConnectWithoutIntervention)
    }
    
    func checkConnection() {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        reachable = isNetworkReachable(with: flags)
    }
}
