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
        let networkService = AlamofireService()
        
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
        })
        config.deleteRealmIfMigrationNeeded = true

        Realm.Configuration.defaultConfiguration = config
        let realmStorage = RealmStorage(realm: try! Realm())
        
        let locationService = LocationService()
        let mainVc = MainAssembly.make(networkService: networkService,
                                       locationService: locationService,
                                       storageService: realmStorage)
        let navigationVc = UINavigationController(rootViewController: mainVc)
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationVc
        window.makeKeyAndVisible()
        self.window = window
    }
}

