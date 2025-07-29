import 'package:flutter_dotenv/flutter_dotenv.dart';

var amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "${dotenv.env['AWS_PINPOINT_KEY']!}",
                    "region": "${dotenv.env['AWS_USER_REGION']!}"
                },
                "pinpointTargeting": {
                    "region": "${dotenv.env['AWS_USER_REGION']!}"
                }
            }
        }
    },
    "notifications": {
        "plugins": {
            "awsPinpointPushNotificationsPlugin": {
                "appId": "${dotenv.env['AWS_PINPOINT_KEY']!}",
                "region": "${dotenv.env['AWS_USER_REGION']!}"
            }
        }
    },
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
          "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "${dotenv.env['AWS_IDENTITY_POOL_ID']!}",
                            "Region": "${dotenv.env['AWS_USER_REGION']!}"
                      }
                }
         },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "${dotenv.env['AWS_USER_POOL_ID']!}",
            "AppClientId": "${dotenv.env['AWS_USER_CLIENT_ID']!}",
            "Region": "${dotenv.env['AWS_USER_REGION']!}",
            "AuthFlow": "USER_SRP_AUTH"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "usernameAttributes": ["email"],
            "signupAttributes": [
              "email", "name" , "updated_at", "picture"
             ],
            "passwordProtectionSettings": {
                "passwordPolicyMinLength": 8,
                "passwordPolicyCharacters": []
            }
          }
        },
        "PinpointAnalytics": {
            "Default": {
                "AppId": "${dotenv.env['AWS_PINPOINT_KEY']!}",
                "Region": "${dotenv.env['AWS_USER_REGION']!}"
            }
        },
        "PinpointTargeting": {
             "Default": {
                 "Region": "${dotenv.env['AWS_USER_REGION']!}"
             }
        }
      }
    }
  }
}''';
