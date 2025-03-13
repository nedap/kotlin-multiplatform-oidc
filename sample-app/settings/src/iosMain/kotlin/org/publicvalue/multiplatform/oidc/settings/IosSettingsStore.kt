package org.publicvalue.multiplatform.oidc.settings

import com.russhwolf.settings.ExperimentalSettingsImplementation
import com.russhwolf.settings.KeychainSettings
import com.russhwolf.settings.set
import kotlinx.cinterop.ExperimentalForeignApi
import platform.Foundation.CFBridgingRetain
import platform.Foundation.NSBundle
import platform.Security.kSecAttrAccessible
import platform.Security.kSecAttrAccessibleAfterFirstUnlock
import platform.Security.kSecAttrService
import platform.Security.kSecAttrAccessGroup

@OptIn(ExperimentalSettingsImplementation::class)
class IosSettingsStore : SettingsStore {

    @OptIn(ExperimentalForeignApi::class)
    private val keyChainSettings by lazy {
        KeychainSettings(
//            kSecAttrService to CFBridgingRetain("${NSBundle.mainBundle.bundleIdentifier}.auth"),
//            kSecAttrService to CFBridgingRetain("3RDHVJ3898.${NSBundle.mainBundle.bundleIdentifier}"),
            kSecAttrService to CFBridgingRetain("com.nedap.healthcare.milo.shared"), // acts as a namespace. Without it, all (shared) stored credentials would exist in a flat structure, making it hard to separate them.
//            kSecAttrAccessGroup to CFBridgingRetain ("3RDHV33898.com.nedap.healthcare.milo.shared"),
            kSecAttrAccessible to kSecAttrAccessibleAfterFirstUnlock,
        )
    }

    override suspend fun get(key: String): String? {
        return keyChainSettings.getStringOrNull(key)
    }

    override suspend fun put(key: String, value: String) {
        keyChainSettings[key] = value
    }

    override suspend fun remove(key: String) {
        keyChainSettings.remove(key)
    }

    override suspend fun clear() {
        keyChainSettings.clear()
    }


}
