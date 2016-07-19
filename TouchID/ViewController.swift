//
//  ViewController.swift
//  TouchID
//
//  Created by JHJG on 2016. 7. 18..
//  Copyright © 2016년 KangJungu. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testTouchID(sender: UIButton) {
        let context = LAContext()
        
        var error:NSError?
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            //디바이스가 터치아이디를 사용할수 있음
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Access requires authentication",
                                   reply: { (success, error) in
                                    dispatch_async(dispatch_get_main_queue()){
                                        if error != nil{
                                            switch error!.code {
                                            case LAError.SystemCancel.rawValue :
                                                self.notifyUser("Session cancelled", err: error?.localizedDescription)
                                            case LAError.UserCancel.rawValue :
                                                self.notifyUser("Please try again", err: error?.localizedDescription)
                                            case LAError.UserFallback.rawValue :
                                                self.notifyUser("Authentication", err: "Password option selected")
                                            //패스워드를 얻는 사용자 정의 코드가 옴
                                            default :
                                                self.notifyUser("Authentication failed", err: error?.localizedDescription)
                                            }
                                        }else{
                                            self.notifyUser("Authentication Successful", err: "You now have full access")
                                        }
                                    }
                                })
        }else{
            //디바이스가 터치아이디를 사용할 수 없음 
            switch error!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",err: error?.localizedDescription)
            case LAError.PasscodeNotSet.rawValue :
                notifyUser("A passcode has not been set",err: error?.localizedDescription)
            default :
                notifyUser("TouchID not available",err: error?.localizedDescription)
                
            }
        }
        
    }
    
    func notifyUser(msg: String, err: String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

