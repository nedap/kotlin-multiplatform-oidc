package org.publicvalue.multiplatform.oidc.sample

actual object PlatformConstants : Constants {
    override val redirectUrl: String = "com.nedap.healthcare.logistics.demo://auth"
}