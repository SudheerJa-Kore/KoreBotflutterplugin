//
//  AppLaunchViewController.swift
//  KoreBotSDKDemo
//
//  Created by developer@kore.com on 09/05/16.
//  Copyright © 2016 Kore Inc. All rights reserved.
//

import UIKit
import Alamofire
import korebotplugin
import CoreData
import Foundation

public class AppLaunchViewController: UIViewController {
    
    @IBOutlet weak var authorizationTF: UITextField!
    @IBOutlet weak var xauthTF: UITextField!
    
    
    @IBOutlet weak var imgView: UIImageView!
    // MARK: properties
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var identityTF: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        return Session(configuration: configuration)
    }()
    var kaBotClient = KABotClient()
    let botClient = BotClient()
    var user: KREUser?
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .white)
    
    // MARK: life-cycle events
   public override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialState()
        self.automaticallyAdjustsScrollViewInsets = false
        imgView.contentMode = .scaleAspectFit
        
        //identityTF.text = SDKConfiguration.botConfig.identity
        authorizationTF.backgroundColor = .white
        xauthTF.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessagesViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatMessagesViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardUserInfo: NSDictionary = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
        let keyboardFrameEnd: CGRect = ((keyboardUserInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue?)!.cgRectValue)
        let options = UIView.AnimationOptions(rawValue: UInt((keyboardUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        let durationValue = keyboardUserInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = durationValue.doubleValue
        
        var keyboardHeight = keyboardFrameEnd.size.height;
        if #available(iOS 11.0, *) {
            keyboardHeight -= self.view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        };
        self.bottomConstraint.constant = keyboardHeight + 35
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (Bool) in
            
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let keyboardUserInfo: NSDictionary = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
        let durationValue = keyboardUserInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = durationValue.doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((keyboardUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        self.bottomConstraint.constant = 20
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (Bool) in
            
        })
    }
    
   public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInitialState()
    }
    
   public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
  public  override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  public  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  public  override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//   public init() {
//        super.init(nibName: "AppLaunchViewController", bundle: Bundle(for: AppLaunchViewController.self))
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    
    // MARK: known user
    @IBAction func chatButtonAction(_ sender: UIButton!) {
    
        self.chatButton.isUserInteractionEnabled = false
        
        let clientId: String = SDKConfiguration.botConfig.clientId
        let clientSecret: String = SDKConfiguration.botConfig.clientSecret
        let isAnonymous: Bool = SDKConfiguration.botConfig.isAnonymous
        let chatBotName: String = SDKConfiguration.botConfig.chatBotName
        let botId: String = SDKConfiguration.botConfig.botId
        
        var identity: String! = nil
        if (isAnonymous) {
            identity = self.getUUID()
        } else {
            identity = SDKConfiguration.botConfig.identity
        }
        //userIdentity = identityTF.text ?? ""
        authorizationTF.resignFirstResponder()
        xauthTF.resignFirstResponder()
        
        let clientIdForWidget: String = SDKConfiguration.widgetConfig.clientId
        let clientSecretForWidget: String = SDKConfiguration.widgetConfig.clientSecret
        let isAnonymousForWidget: Bool = SDKConfiguration.widgetConfig.isAnonymous
        let chatBotNameForWidget: String = SDKConfiguration.widgetConfig.chatBotName
        let botIdForWidget: String = SDKConfiguration.widgetConfig.botId
        var identityForWidget: String! = nil
        if (isAnonymousForWidget) {
            identityForWidget = self.getUUID()
        } else {
            identityForWidget = SDKConfiguration.widgetConfig.identity
        }
        
        let dataStoreManager: DataStoreManager = DataStoreManager.sharedManager
        dataStoreManager.deleteThreadIfRequired(with: botId, completionBlock: { (success) in
            print("Delete Sucess")
        })
        
        if !clientId.hasPrefix("<") && !clientSecret.hasPrefix("<") && !chatBotName.hasPrefix("<") && !botId.hasPrefix("<") && !identity.hasPrefix("<")  {
            
            if authorizationTF.text != "" && xauthTF.text != ""{
                
                authorizationToken = authorizationTF.text
                xAuthToken = xauthTF.text
                
                activityIndicatorView.center = chatButton.center
                view.addSubview(activityIndicatorView)
                activityIndicatorView.startAnimating()
                

                
                kaBotClient.connect(block: { [weak self] (client, thread) in

                    if !SDKConfiguration.widgetConfig.isPanelView {
                        self?.brandingApis(client: client, thread: thread)
                    }else{
                        if !clientIdForWidget.hasPrefix("<") && !clientSecretForWidget.hasPrefix("<") && !chatBotNameForWidget.hasPrefix("<") && !botIdForWidget.hasPrefix("<") && !identityForWidget.hasPrefix("<") {

                            self?.getWidgetJwTokenWithClientId(clientIdForWidget, clientSecret: clientSecretForWidget, identity: identityForWidget, isAnonymous: isAnonymousForWidget, success: { [weak self] (jwToken) in

                                self?.brandingApis(client: client, thread: thread)

                                }, failure: { (error) in
                                    print(error)
                                    self?.activityIndicatorView.stopAnimating()
                                    self?.chatButton.isUserInteractionEnabled = true
                            })

                        }else{
                            self!.showAlert(title: "Banking Assist Demo", message: "YOU MUST SET WIDGET 'clientId', 'clientSecret', 'chatBotName', 'identity' and 'botId'. Please check the documentation.")
                            self?.activityIndicatorView.stopAnimating()
                            self?.chatButton.isUserInteractionEnabled = true
                        }
                    }

                }) { (error) in
                    self.activityIndicatorView.stopAnimating()
                    self.chatButton.isUserInteractionEnabled = true
                }
            }
            else{
                self.showAlert(title: "Banking Assist Demo", message: "Please enter Authorization and XAuth")
                self.chatButton.isUserInteractionEnabled = true
            }
            
        } else {
            self.showAlert(title: "Banking Assist Demo", message: "Please enter email id")
            self.chatButton.isUserInteractionEnabled = true
        }
    }
    
    func brandingApis(client: BotClient?, thread: KREThread?){
        self.kaBotClient.brandingApiRequest(authInfoAccessToken,success: { [weak self] (brandingArray) in
            print(brandingArray)
            if brandingArray.count > 0{
                brandingShared.hamburgerOptions = (((brandingArray as AnyObject).object(at: 0) as AnyObject).object(forKey: "hamburgermenu") as Any) as? Dictionary<String, Any>
            }
            if brandingArray.count>1{
                let brandingDic = (((brandingArray as AnyObject).object(at: 1) as AnyObject).object(forKey: "brandingwidgetdesktop") as Any)
                let jsonDecoder = JSONDecoder()
                guard let jsonData = try? JSONSerialization.data(withJSONObject: brandingDic as Any , options: .prettyPrinted),
                let brandingValues = try? jsonDecoder.decode(BrandingModel.self, from: jsonData) else {
                    return
                }
                let brandingShared = BrandingSingleton.shared
                brandingShared.brandingInfoModel = brandingValues
                UserDefaults.standard.set("#fd591e", forKey: "ThemeColor")
                themeColor = UIColor.init(hexString: "#fd591e")
                self?.navigateToChatViewController(client: client, thread: thread)
                

            }
            }, failure: { (error) in
                       print(error)
                self.getOfflineBrandingData(client: client, thread: thread)
                
                
                self.activityIndicatorView.stopAnimating()
                self.chatButton.isUserInteractionEnabled = true
        })
    }
    
    func getOfflineBrandingData(client: BotClient?, thread: KREThread?){
           if let path = Bundle.main.path(forResource: "brandingValues", ofType: "json") {
               do {
                   let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                   let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                   if let brandingArray = jsonResult as? NSArray {
                       // do stuff
                      print(jsonResult)
                    if brandingArray.count > 0{
                        brandingShared.hamburgerOptions = (((brandingArray as AnyObject).object(at: 0) as AnyObject).object(forKey: "hamburgermenu") as Any) as? Dictionary<String, Any>
                    }
                    if brandingArray.count>1{
                        let brandingDic = (((brandingArray as AnyObject).object(at: 1) as AnyObject).object(forKey: "brandingwidgetdesktop") as Any)
                        let jsonDecoder = JSONDecoder()
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: brandingDic as Any , options: .prettyPrinted),
                        let brandingValues = try? jsonDecoder.decode(BrandingModel.self, from: jsonData) else {
                            return
                        }
                        let brandingShared = BrandingSingleton.shared
                        brandingShared.brandingInfoModel = brandingValues
                        UserDefaults.standard.set("#3EA3AD", forKey: "ThemeColor")
                        themeColor = UIColor.init(hexString: "#3EA3AD")
                        self.navigateToChatViewController(client: client, thread: thread)}
                    
                   }
               } catch {
                   // handle error
               }
           }
       }
    
    func navigateToChatViewController(client: BotClient?, thread: KREThread?){
        activityIndicatorView.stopAnimating()
        self.chatButton.isUserInteractionEnabled = true
        
        let botViewController = ChatMessagesViewController() //thread: thread
        botViewController.botClient = client
        botViewController.title = SDKConfiguration.botConfig.chatBotName
        
        //Addition fade in animation
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        self.navigationController?.pushViewController(botViewController, animated: false)
    }
    
    // MARK: get JWT token request
    // NOTE: Invokes a webservice and gets the JWT token.
    //       Developer has to host a webservice, which generates the JWT and that should be called from this method.
    func getJwTokenWithClientId(_ clientId: String!, clientSecret: String!, identity: String!, isAnonymous: Bool!, success:((_ jwToken: String?) -> Void)?, failure:((_ error: Error) -> Void)?) {
        
//        // Session Configuration
//        let configuration = URLSessionConfiguration.default
//        
//        //Manager
//        sessionManager = AFHTTPSessionManager.init(baseURL: URL.init(string: SDKConfiguration.serverConfig.JWT_SERVER) as URL?, sessionConfiguration: configuration)
//        
//        // NOTE: You must set your URL to generate JWT.
//        let urlString: String = SDKConfiguration.serverConfig.koreJwtUrl()
//        let requestSerializer = AFJSONRequestSerializer()
//        requestSerializer.httpMethodsEncodingParametersInURI = Set.init(["GET"]) as Set<String>
//        requestSerializer.setValue("Keep-Alive", forHTTPHeaderField:"Connection")
//        
//        // Headers: {"alg": "RS256","typ": "JWT"}
//        requestSerializer.setValue("RS256", forHTTPHeaderField:"alg")
//        requestSerializer.setValue("JWT", forHTTPHeaderField:"typ")
//        
//        let parameters: NSDictionary = ["clientId": clientId as String,
//                                        "clientSecret": clientSecret as String,
//                                        "identity": identity as String,
//                                        "aud": "https://idproxy.kore.com/authorize",
//                                        "isAnonymous": isAnonymous as Bool]
//        
//        sessionManager?.responseSerializer = AFJSONResponseSerializer.init()
//        sessionManager?.requestSerializer = requestSerializer
//        sessionManager?.post(urlString, parameters: parameters, headers: nil, progress: nil, success: { (sessionDataTask, responseObject) in
//            if (responseObject is NSDictionary) {
//                let dictionary: NSDictionary = responseObject as! NSDictionary
//                let jwToken: String = dictionary["jwt"] as! String
//                success?(jwToken)
//            } else {
//                let error: NSError = NSError(domain: "bot", code: 100, userInfo: [:])
//                failure?(error)
//            }
//        }) { (sessionDataTask, error) in
//            failure?(error)
//        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setInitialState() {
        chatButton.alpha = 1.0
        chatButton.isEnabled = true
    }
    
    func getUUID() -> String {
        var id: String?
        let userDefaults = UserDefaults.standard
        if let UUID = userDefaults.string(forKey: "UUID") {
            id = UUID
        } else {
            let date: Date = Date()
            id = String(format: "email%ld%@", date.timeIntervalSince1970, "@domain.com")
            userDefaults.set(id, forKey: "UUID")
        }
        return id!
    }
}
extension AppLaunchViewController{
    func getWidgetJwTokenWithClientId(_ clientId: String!, clientSecret: String!, identity: String!, isAnonymous: Bool!, success:((_ jwToken: String?) -> Void)?, failure:((_ error: Error) -> Void)?) {
        
//        // Session Configuration
//        let configuration = URLSessionConfiguration.default
//        
//        //Manager
//        sessionManager = AFHTTPSessionManager.init(baseURL: URL.init(string: SDKConfiguration.serverConfig.JWT_SERVER) as URL?, sessionConfiguration: configuration)
//        
//        // NOTE: You must set your URL to generate JWT.
//        let urlString: String = SDKConfiguration.serverConfig.koreJwtUrl()
//        let requestSerializer = AFJSONRequestSerializer()
//        requestSerializer.httpMethodsEncodingParametersInURI = Set.init(["GET"]) as Set<String>
//        requestSerializer.setValue("Keep-Alive", forHTTPHeaderField:"Connection")
//        
//        // Headers: {"alg": "RS256","typ": "JWT"}
//        requestSerializer.setValue("RS256", forHTTPHeaderField:"alg")
//        requestSerializer.setValue("JWT", forHTTPHeaderField:"typ")
//        
//        let parameters: NSDictionary = ["clientId": clientId as String,
//                                        "clientSecret": clientSecret as String,
//                                        "identity": identity as String,
//                                        "aud": "https://idproxy.kore.com/authorize",
//                                        "isAnonymous": isAnonymous as Bool]
//        
//        
//        sessionManager?.responseSerializer = AFJSONResponseSerializer.init()
//        sessionManager?.requestSerializer = requestSerializer
//        sessionManager?.post(urlString, parameters: parameters, headers: nil, progress: nil, success: { (sessionDataTask, responseObject) in
//            if (responseObject is NSDictionary) {
//                let dictionary: NSDictionary = responseObject as! NSDictionary
//                let jwToken: String = dictionary["jwt"] as! String
//                self.initializeWidgetManager(widgetJWTToken: jwToken)
//                success?(jwToken)
//                
//            } else {
//                let error: NSError = NSError(domain: "bot", code: 100, userInfo: [:])
//                failure?(error)
//            }
//        }) { (sessionDataTask, error) in
//            failure?(error)
//        }
//        
    }
    
    func initializeWidgetManager(widgetJWTToken: String) {
        
        let widgetManager = KREWidgetManager.shared
        let user = KREUser()
        user.userId = SDKConfiguration.widgetConfig.botId //userId
        user.accessToken = widgetJWTToken
        user.server = SDKConfiguration.serverConfig.KORE_SERVER
        user.tokenType = "bearer"
        user.userEmail = SDKConfiguration.widgetConfig.identity
        user.headers = ["X-KORA-Client": KoraAssistant.shared.applicationHeader]
        widgetManager.initialize(with: user)
        self.user = user
        
        widgetManager.sessionExpiredAction = { (error) in
            DispatchQueue.main.async {
                // NotificationCenter.default.post(name: NSNotification.Name(rawValue: KoraNotification.EnforcementNotification), object: ["type": KoraNotification.EnforcementType.userSessionDidBecomeInvalid])
            }
        }
    }
    
   
}

extension AppLaunchViewController : UITextFieldDelegate{
   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
   public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
extension String {
    func isEmail()->Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
