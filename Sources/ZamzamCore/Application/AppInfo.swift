//
//  AppInfo.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/29/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle

/// Provides details of the current app.
public protocol AppInfo {}

public extension AppInfo {

	/// App's name.
	var appDisplayName: String? {
		// http://stackoverflow.com/questions/28254377/get-app-name-in-swift
		Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
	}
	
	/// App's bundle ID.
	var appBundleID: String? { Bundle.main.bundleIdentifier }
	
	/// App's current version.
	var appVersion: String? {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}

	/// App current build number.
	var appBuild: String? {
		Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
	}
}

// MARK: - Environment

public extension AppInfo {
	
	/// Check if app is running in TestFlight mode.
	var isInTestFlight: Bool {
		// http://stackoverflow.com/questions/12431994/detect-testflight
		Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
	}

	/// Check if application is running on simulator (read-only).
	var isRunningOnSimulator: Bool {
		// http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
        #if targetEnvironment(simulator)
        return true
		#else
        return false
		#endif
	}
}
