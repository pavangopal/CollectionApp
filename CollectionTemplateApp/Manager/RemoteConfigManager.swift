//
//  RemoteConfigManager.swift
//  MediaOne
//
//  Created by Pavan Gopal on 7/4/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype
import Firebase
import FirebaseRemoteConfig


protocol RemoteConfigManagerDataSource:class {
    func didFetchRemoteConfigValues(remoteConf:FIRRemoteConfig,collection:CollectionModel?)
}


class RemoteConfigManager: NSObject{
    var dataSource: RemoteConfigManagerDataSource?
    var remoteConfig: FIRRemoteConfig!
    var collection:CollectionModel?
    var isRemoteFetched = false

    init(dataSource:RemoteConfigManagerDataSource,collection:CollectionModel?){
        super.init()

        self.dataSource = dataSource
        self.collection = collection

        remoteConfig = FIRRemoteConfig.remoteConfig()
        let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: false )
        remoteConfig.configSettings = remoteConfigSettings!
        remoteConfig.setDefaultsFromPlistFileName("RemoteConfigDefaults")
        fetchConfig()
    }

    func fetchConfig() {

        var expirationDuration = 3600

        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }

        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }

            if !self.isRemoteFetched{
                self.isRemoteFetched = true
                self.didGetRemoteConfigValues()
            }

        }

    }

    func didGetRemoteConfigValues() {
        self.dataSource?.didFetchRemoteConfigValues(remoteConf: remoteConfig,collection:self.collection)
    }
}

