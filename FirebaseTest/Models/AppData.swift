//
//  AppData.swift
//  FirebaseTest
//
//  Created by SHAILENDRA KUSHWAHA on 24/06/21.
//

import Foundation

struct AppKey {
    public static let OTP_VERIFICATION = "firebase_phone_auth"
    public static let USER_LOGGED_ID   = "user_logged_in"
}

class AppData {
    
    public static let shared = AppData()

    init(){

    }
    
    public func saveVerificationId(id:String){
        UserDefaults.standard.setValue(id, forKey: AppKey.OTP_VERIFICATION)
    }
    
    public func getVerificationId() -> String? {
        return UserDefaults.standard.value(forKey: AppKey.OTP_VERIFICATION) as? String
    }
    
    public func saveUserId(id:String){
        UserDefaults.standard.setValue(id, forKey: AppKey.USER_LOGGED_ID)
    }
    
    public func getUserId() -> String? {
        return UserDefaults.standard.value(forKey: AppKey.USER_LOGGED_ID) as? String
    }
}
