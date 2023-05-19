//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit
import RealmSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        
        let realmStorage = RealmStorage(realm: try! Realm())
        let networkService = AlamofireService()
        let locationService = LocationService()
        let mainVc = MainAssembly.make(
            networkService: networkService,
            locationService: locationService,
            storageService: realmStorage
        )
        let navigationVc = UINavigationController(rootViewController: mainVc)
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationVc
        window.makeKeyAndVisible()
        self.window = window
    }
}

