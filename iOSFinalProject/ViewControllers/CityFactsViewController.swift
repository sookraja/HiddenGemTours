//
//  CityFactsViewController.swift
//  iOSFinalProject
//
//  Created by Blend Mustafa on 4/14/25.
//

import UIKit
import WebKit

class CityFactsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let encodedCityName = cityName?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        
            let urlAddress = URL(string: "https://www.google.com/search?q=\(encodedCityName)")
            let url = URLRequest(url: urlAddress!)
            webView.load(url)
            webView.navigationDelegate = self
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
