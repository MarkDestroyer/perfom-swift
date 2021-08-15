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
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        guard let token = params["access_token"],
              let userId = params["user_id"] else {
            print("Что-то пошло не так!")
            return
        }
        
        session.userId = userId
        session.token = token
        
        performSegue(withIdentifier: "toTabs", sender: self)
        
        decisionHandler(.cancel)
    }
}

