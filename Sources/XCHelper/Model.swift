//
//  Configuration.swift
//  xchelper
//
//  Created by Klajd Deda on 10/22/22.
//

import Foundation

public struct VersionInfo: Codable {
    var bundleGetInfoString: String
    var bundleShortVersionString: String
    var bundleVersion: String
    var humanReadableCopyright: String
}

public struct ProductFile: Codable {
    enum CodingKeys: String, CodingKey {
        case sourceURL = "sourceURL"
        case destinationURL = "destinationURL"
        case entitlementsURL = "entitlementsURL"
        case requiresSignature = "requiresSignature"
    }

    var buildProductsURL: URL = FileManager.default.temporaryDirectory

    /// Relative path to Project.buildProductsURL.
    /// Will be properly created during the expandingTilde method
    var sourceURL: URL      // ie: "WhatSize.app"
    
    /// Absolute path to where this needs to be copied at, in the Package or maybe DMG etc
    var destinationURL: URL // ie:"~/Development/Products/Applications"

    /// For some apps we need to handle the `"*.entitlements"` file when signing them
    var entitlementsURL: URL?

    /// If true we shall sign this binary with apple
    var requiresSignature: Bool
}

public struct KeyChain: Codable {
    let developerIDApplication: String  // ie: '"Developer ID Application: ID-DESIGN INC. (ME637H7ZM9)"'
    let developerIDInstall: String      // ie: '"Developer ID Installer: ID-DESIGN INC. (ME637H7ZM9)"'
}

public struct Sparkle: Codable {
    // the sshUserName on the remote apache server
    var sshUserName: String  // ie: "kdeda@id-design.com"
    var companyName: String  // ie: "ID-Design"

    // the file url to use on the remote apache server
    var serverFileURL: URL   // ie: "/var/www/www.whatsizemac.com/software/whatsize7"

    // the url that will point to the sparkle on the apache server
    var serverURL: URL       // ie: "https://www.whatsizemac.com/software/whatsize7"
    
    // absolute file path to the sparkle release folder
    var releaseURL: URL      // ie: "~/Development/git.id-design.com/whatsize7/WhatSize/release"
}

public struct Workspace: Codable {
    // the scheme we are building
    var scheme: String     // ie: "WhatSize"
    
    // the workspace we are building from
    var workspaceURL: URL  // ie: "~/Development/git.id-design.com/whatsize7/WhatSize.xcworkspace"
}

/**
 This code is data driven by what's here.
 Each project shall have a json config with various settings.
 */
public struct Project: Codable {
    ///  Name of this project as defined in the configURL .json configuration payload
    var configName: String
    
    /// Path to the .json configuration payload for this project
    var configURL: URL

    /// Path where the final build products will be located.
    /// These are products from xcodebuild and package maker or maybe a dmg maker
    var buildProductsURL: URL

    var versionInfo: VersionInfo
    var infoPlistFiles: [URL]
    var packageName: String
    var packageIdentifier: String
    var packageRootURL: URL
    var productFiles: [ProductFile]
    var keyChain: KeyChain
    var sparkle: Sparkle
    var workspaces: [Workspace]

    var pathToTGZ: URL {
        return packageRootURL.appendingPathComponent(packageName).appendingPathExtension("tgz")
    }
    
    // created first, raw
    var pathToPKGUnsigned: URL {
        return packageRootURL.appendingPathComponent("\(packageName)Unsigned").appendingPathExtension("pkg")
    }
    
    // created with extras from distribution.xml
    var pathToPKGAdorned: URL {
        return packageRootURL.appendingPathComponent("\(packageName)Adorned").appendingPathExtension("pkg")
    }
    
    // created if we sign the pathToPKGAdorned
    var pathToPKG: URL {
        return packageRootURL.appendingPathComponent(packageName).appendingPathExtension("pkg")
    }
}
