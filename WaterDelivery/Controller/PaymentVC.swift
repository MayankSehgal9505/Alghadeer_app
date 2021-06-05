//
//  PaymentVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 02/06/21.
//

import UIKit
import WebKit
enum PaymentStatus: Int {
    case pending = 0
    case success,failure,cancelled
}
protocol  PaymentVCProtocol: class{
    func paymentSccessful(status: Int)
}
class PaymentVC: UIViewController,WKNavigationDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var webView: WKWebView!
    //MARK:- Properties
    weak var delegate: PaymentVCProtocol?
    var urlString = ""
    //MARK:- Local Variables
    var paymentStatus: PaymentStatus = .pending
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    //MARK:- Internal  Methods
    private func loadWebView() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            //self.showHUD(progressLabel: AlertField.loaderString)
            webView.load(request)
        }
        webView.navigationDelegate = self
    }
    private func dismissView() {
        delegate?.paymentSccessful(status: paymentStatus.rawValue)
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismissView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showHUD(progressLabel: AlertField.loaderString)
        print("Next URL \(webView.url?.absoluteString ?? "")")
        if WalletCallBacks.completionUrls.contains(where: { stringUrls -> Bool in
            return (webView.url?.absoluteString ?? "").contains(stringUrls)
        }) {
            paymentStatus = .cancelled
            dismissView()
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide Loader
        print("loaded URL \(webView.url?.absoluteString ?? "")")
        self.dismissHUD(isAnimated: true)
        if WalletCallBacks.completionUrls.contains(where: { stringUrls -> Bool in
            return (webView.url?.absoluteString ?? "").contains(stringUrls)
        }) {
            paymentStatus = .success
            dismissView()
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Error loading url in webview :\(error.localizedDescription)")
        self.dismissHUD(isAnimated: true)
    }
    
    /*func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = webView.url {
            print("url is \(url)")
            if WalletCallBacks.completionUrls.contains(where: { stringUrls -> Bool in
                return (webView.url?.absoluteString ?? "").contains(stringUrls)
            }) {
                paymentStatus = .success
                dismissView()
            }
            decisionHandler(.allow)

        }
    }*/

}