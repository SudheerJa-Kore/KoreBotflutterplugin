
//  SDKConfiguration.swift
//  KoreBotSDKDemo
//
//  Created by developer@kore.com on 12/16/16.
//  Copyright © 2016 Kore Inc. All rights reserved.

import UIKit
import korebotplugin

public class SDKConfiguration: NSObject {

    struct dataStoreConfig {
        static let resetDataStoreOnConnect = true // This should be either true or false. Conversation with the bot will be persisted, if it is false.
    }


   public struct botConfig {
       public static var clientId = "cs-1e845b00-81ad-5757-a1e7-d0f6fea227e9" // Copy this value from Bot Builder SDK Settings ex. cs-5250bdc9-6bfe-5ece-92c9-ab54aa2d4285

       public static var clientSecret = "5OcBSQtH/k6Q/S6A3bseYfOee02YjjLLTNoT1qZDBso=" // Copy this value from Bot Builder SDK Settings ex. Wibn3ULagYyq0J10LCndswYycHGLuIWbwHvTRSfLwhs=

       public static var botId =  "st-b9889c46-218c-58f7-838f-73ae9203488c" // Copy this value from Bot Builder -> Channels -> Web/Mobile Client  ex. st-acecd91f-b009-5f3f-9c15-7249186d827d

       public static var chatBotName = "SDKBot" // Copy this value from Bot Builder -> Channels -> Web/Mobile Client  ex. "Demo Bot"
       public static var tenantId = "620415a603ee27d50d2a47fa"

       public static var identity = "rajasekhar.balla@kore.com"//"sainath.bhima@kore.com"// This should represent the subject for JWT token. This can be an email or phone number, in case of known user, and in case of anonymous user, this can be a randomly generated unique id.

       public static var isAnonymous = true // This should be either true (in case of known-user) or false (in-case of anonymous user).
    }


   public struct serverConfig {
       public static var JWT_SERVER = String(format: "https://mk2r2rmj21.execute-api.us-east-1.amazonaws.com/dev/") // Replace it with the actual JWT server URL, if required. Refer to developer documentation for instructions on hosting JWT Server.

       public static func koreJwtUrl() -> String {
            return String(format: "%@users/sts", JWT_SERVER)
        }

      public  static var BOT_SERVER = String(format: "https://bots.kore.ai")
      public  static var JWT_NewSERVER = String(format: "https://bots.kore.ai/")
      public  static var Branding_SERVER = String(format: "https://bots.kore.ai/")
      public  static var SessionOut_Url = String(format: "https://bots.kore.ai")
      public  static var Login_Url = String(format: "https://bots.kore.ai/")

      public static var KORE_SERVER = String(format: "https://bots.kore.ai/")
    }

    struct widgetConfig {
        static let clientId = "<client-id>" // Copy this value from Bot Builder SDK Settings ex. cs-5250bdc9-6bfe-5ece-92c9-ab54aa2d4285

        static let clientSecret = "<client-secret>" // Copy this value from Bot Builder SDK Settings ex. Wibn3ULagYyq0J10LCndswYycHGLuIWbwHvTRSfLwhs=

        static let botId =  "<bot-id>" // Copy this value from Bot Builder -> Channels -> Web/Mobile Client  ex. st-acecd91f-b009-5f3f-9c15-7249186d827d

        static let chatBotName = "<bot-name>" // Copy this value from Bot Builder -> Channels -> Web/Mobile Client  ex. "Demo Bot"

        static let identity = "<identity-email> or <random-id>"// This should represent the subject for JWT token. This can be an email or phone number, in case of known user, and in case of anonymous user, this can be a randomly generated unique id.

        static let isAnonymous = true // This should be either true (in case of known-user) or false (in-case of anonymous user).

        static let isPanelView = false // This should be either true (in case of Show Panel) or false (in-case of Hide Panel).
    }

    // googleapi speech API_KEY
    struct speechConfig {
        static let API_KEY = "<speech_api_key>"
    }
}
