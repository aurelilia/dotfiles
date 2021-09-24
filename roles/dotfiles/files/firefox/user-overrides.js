/* 0102: Session restore */
user_pref("browser.startup.page", 3);

/* 0104: Custom new tab */
user_pref("browser.newtab.extensionControlled", true);
user_pref("browser.newtab.privateAllowed", false);
user_pref("browser.newtabpage.storageVersion", 1);

/* 0517, 0860: Form autofill */
user_pref("extensions.formautofill.addresses.enabled", true);
user_pref("extensions.formautofill.available", "on");
user_pref("browser.formfill.enable", true);

/* 0701: Enable IPv6 */
user_pref("network.dns.disableIPv6", false);

/* 0703: Re-enable alternative services */
user_pref("network.http.altsvc.enabled", true);
user_pref("network.http.altsvc.oe", true);

/* 0801: Re-enable search in URL bar */
user_pref("keyword.enabled", true);

/* 0803: Keep URL trimming ***/
user_pref("browser.urlbar.trimURLs", true);

/* 0811: Resolve single words */
user_pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 2);

/* 1001, 1007: Keep cache */
user_pref("browser.cache.disk.enable", true);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", false);
user_pref("media.memory_cache_max_size", 8192);
/* 1021: Keep sessions */
user_pref("browser.sessionstore.privacy_level", 0);
/* 1030: Keep shortcut favicons */
user_pref("browser.shell.shortcutFavicons", true);

/* 1241: Re-enable insecure passive content (such as images) on https pages */
user_pref("security.mixed_content.block_display_content", false);

/* 1246: Re-enable HTTP background requests [FF82+] */
user_pref("dom.security.https_only_mode_send_http_background_request", true);

/* 1603: Always send referrer (breaks pixiv) */
user_pref("network.http.referer.XOriginPolicy", 0);

/* 2001: Re-enable WebRTC **/
user_pref("media.peerconnection.enabled", true);
/* 2022: Re-enable screen sharing ***/
user_pref("media.getusermedia.screensharing.enabled", true);
user_pref("media.getusermedia.browser.enabled", true);
user_pref("media.getusermedia.audiocapture.enabled", false);
/* 2031: Re-enable autoplay of HTML5 media if you interacted with the site **/
user_pref("media.autoplay.blocking_policy", 0);

/* 2302, 2305: Re-enable service workers ***/
user_pref("dom.serviceWorkers.enabled", true);
user_pref("dom.push.enabled", true);

/* 2404: Re-enable clipboard commands (cut/copy) from "non-privileged" content */
user_pref("dom.allow_cut_copy", true);

/* 2405: Re-enable "Confirm you want to leave" dialog on page close */
user_pref("dom.disable_beforeunload", false);

/* 2420, 2422: Re-enable asm.js + WASM */
user_pref("javascript.options.asmjs", true);
user_pref("javascript.options.wasm", true);

/* 2522: Re-enable WebGL (Web Graphics Library) */
user_pref("webgl.disabled", false);
user_pref("webgl.enable-webgl2", true);
user_pref("webgl.disable-fail-if-major-performance-caveat", true); 

/* 2603: Keep temp files opened with an external application */
user_pref("browser.helperApps.deleteTempFileOnExit", false);

/* 2701, 2702: i like cookies */
user_pref("network.cookie.cookieBehavior", 4);
user_pref("network.cookie.thirdparty.sessionOnly", false);
user_pref("network.cookie.thirdparty.nonsecureSessionOnly", false);

/* 2802: Don't tell Firefox to clear items on shutdown */
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

/* 4001: Disable First Party Isolation */
user_pref("privacy.firstparty.isolate", false);

/* 450-: Disable privacy.resistFingerprinting */
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.resistFingerprinting.block_mozAddonManager", false);
user_pref("privacy.resistFingerprinting.letterboxing", false);
user_pref("browser.startup.blankWindow", true);
user_pref("ui.prefersReducedMotion", 0);


user_pref("_user.js.parrot", "all done!");
