//
//  Helper+UpdateVersions.swift
//  xchelper
//
//  Created by Klajd Deda on 10/24/22.
//

import Foundation
import Log4swift
import SwiftCommons

extension Helper {
    // update the info.plist, save it if there are changes
    private func updateInfo(at plistURL: URL) {
        guard let existing = NSMutableDictionary(contentsOf: plistURL)
        else {
            Log4swift[Self.self].error("failed to load plist from: '\(plistURL.path)'")
            return
        }

        let newValue = NSMutableDictionary(dictionary: existing)
        let versionInfo = project.versionInfo

        newValue["CFBundleGetInfoString"] = "\(versionInfo.bundleShortVersionString), \(versionInfo.bundleGetInfoString)"
        newValue["CFBundleShortVersionString"] = versionInfo.bundleShortVersionString
        newValue["CFBundleVersion"] = versionInfo.bundleVersion
        newValue["NSHumanReadableCopyright"] = versionInfo.humanReadableCopyright

        guard newValue != existing
        else {
            Log4swift[Self.self].info("file: '\(plistURL.path)' is up todate")
            return }
        do {
            try newValue.write(to: plistURL)
            Log4swift[Self.self].info("saved: '\(plistURL.path)'")
        } catch {
            Log4swift[Self.self].error("error: '\(error.localizedDescription)'")
        }
    }

    public func updateVersions() {
        project.infoPlistFiles.forEach(updateInfo(at:))
    }
}

