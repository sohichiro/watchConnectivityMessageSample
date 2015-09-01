//
//  InterfaceController.swift
//  watchConnectivitySendMessageSampleWatch Extension
//
//  Created by 長尾 聡一郎 on 2015/09/01.
//  Copyright © 2015年 長尾 聡一郎. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var statusLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()

            print("active Session in InterfaceController")
            dispatch_async(dispatch_get_main_queue(), {
            })
            
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pushDogButton() {
        self.pushButton(0)
    }
    
    @IBAction func pushCatButton() {
        self.pushButton(1)
    }
    
    @IBAction func pushElephantButton() {
        self.pushButton(2)
    }
    
    @IBAction func pushPenginButton() {
        self.pushButton(3)
    }
    
    func pushButton(tag: Int){
        dispatch_async(dispatch_get_main_queue(), {
            self.statusLabel.setText("Sending..")
        })
        
        let message = ["sendMessageToPhone": "\(tag)"]
        
        WCSession.defaultSession().sendMessage(message,
            replyHandler: { (reply) -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    self.statusLabel.setText("Success!")
                })
            },
            errorHandler: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.statusLabel.setText("Error!")
                })
            }
        )
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {

            if let watchInfo = message["sendMessageToWatch"] as? String {
                var show:String
                
                if watchInfo == "0" {
                    show = "🐶"
                }
                else if watchInfo == "1" {
                    show = "🐱"
                }
                else if watchInfo == "2" {
                    show = "🐘"
                }
                else {
                    show = "🐧"
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.statusLabel.setText(show)
                })
            }

        
        replyHandler(["reply" : "OK"])
    }
    
    
}
