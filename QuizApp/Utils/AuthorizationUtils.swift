import UIKit

struct Authorization {
    
    var accessToken: String?
    var userId: Int?
    var username: String?
    
    init(accessToken: String, userId: Int, username: String) {
        self.accessToken = accessToken
        self.userId = userId
        self.username = username
    }
}

class AuthorizationUtils {
    
    private static let TOKEN_KEY = "accessToken"
    private static let USER_ID = "userId"
    private static let USERNAME = "username"
    
    static func getUserId() -> Int {
        return UserDefaults.standard.integer(forKey: USER_ID)
    }
    
    static func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: TOKEN_KEY)
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: USERNAME)
    }
    
    static func isUserLoggedIn() -> Bool {
        return getAccessToken() != nil
    }
    
    static func loginUser(auth: Authorization) {
        UserDefaults.standard.set(auth.accessToken, forKey: TOKEN_KEY)
        UserDefaults.standard.set(auth.userId, forKey: USER_ID)
        UserDefaults.standard.set(auth.username, forKey: USERNAME)
    }
    
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: USER_ID)
        UserDefaults.standard.removeObject(forKey: USERNAME)
    }
    
}
