//
//  NotificationService.swift
//  InsiderNotificationService
//
//  Created by Taha on 2.10.2024.
//

import UserNotifications

let APP_GROUP = "group.com.unluco.piapiri"

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...

            let nextButtonText = ">>"
            let goToAppText = "Launch App"

            InsiderPushNotification.showInsiderRichPush(
                request,
                appGroup: APP_GROUP as String,
                nextButtonText: nextButtonText,
                goToAppText: goToAppText,
                success: { attachment in
                    if let attachment = attachment {
                        bestAttemptContent.attachments = bestAttemptContent.attachments + [attachment as UNNotificationAttachment]
                        print(bestAttemptContent.attachments)
                    }
                    print(bestAttemptContent.attachments)
                    contentHandler(bestAttemptContent)
                    print(bestAttemptContent.attachments)
            })
            print(bestAttemptContent.attachments)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
