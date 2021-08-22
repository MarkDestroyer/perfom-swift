//
//  AuthViewController.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 08.07.2021.
//

import UIKit
import WebKit
import KeychainAccess

class AuthViewController: UIViewController  {

    let session = Session.instance
    
    @IBOutlet weak var wkWebView: WKWebView! {
        didSet {
            wkWebView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVKAccessToken()
    }
    
    func getVKAccessToken() {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: session.cliendId),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: session.version)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        //print(request.description)
        
        wkWebView.load(request)
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        //делаем системные переходы внутри vk до тех пор пока не перейдем на blank.html
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html", let fragment = url.fragment else {
                //разрешаем переходы
                decisionHandler(.allow)
                return
        }
        
        //перейдя на blank.html сохраняем полученные данные в словарь
        let params = fragment.components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=")}
            .reduce([String: String]()) {
                value, params in
                var dict = value
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
        }
        
        //безопасно извлекаем token и user_id
        guard let token = params["access_token"],
            let userId = params["user_id"],
            let expiresIn = params["expires_in"] else {
                //сделаем вывод оповещения при невозможности извлечения token и user_id
                let alert = UIAlertController(title: "Error", message: "Authorization error", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                print("[Logging] authorization error")
                
                return
        }
        
        //Вводим понимание даты, срока валидности нашего токена
        let realExpire = String(Int(Date().timeIntervalSince1970) + (Int(expiresIn) ?? 0))
        
        //Сохраняем данные в Keychain
        let keychain = Keychain(service: "UserSecrets")
        
        keychain["token"] = token
        keychain["userId"] = userId
        keychain["expiresIn"] = realExpire
        
        //присваиваем значения нашему singleton instance
        Session.instance.token = token
        Session.instance.userId = userId
        Session.instance.version = "5.58"
        
        print("[Logging] token = \(Session.instance.token)")
        print("[Logging] user_id = \(Session.instance.userId)")
   
        //запрещаем переходы
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "toTabs", sender: self)
    }
}

//  performSegue(withIdentifier: "toTabs", sender: self)
