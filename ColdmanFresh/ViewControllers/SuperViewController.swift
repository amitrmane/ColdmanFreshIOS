//
//  SuperViewController.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
//import Material

class SuperViewController: UIViewController {

    internal var hideNavBar = true
    internal var _isLogInView = false
     var hideLogo = false
    fileprivate let warningMessageLabel:UILabel = UILabel()
    
    internal var isStatusBarHidded:Bool = false
    {
        didSet
        {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isStatusBarHidded = false
        navigationItem.hidesBackButton =  true
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: -50, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT + 100))
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        activityIndicator.isHidden = true
//        self.view.addSubview(activityIndicator)
        // Do any additional setup after loading the view.
        
//        self.view.backgroundColor = UIColor(hexString: "fff0f0")
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hideNavBar
        {
            self.navigationController?.isNavigationBarHidden = true
        }else
        {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    internal func setBackButton() {
        if ((navigationController?.navigationBar) != nil)
        {
            var backBtn = UIImage(named: "BackButton")
            
            backBtn = backBtn?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController!.navigationBar.backIndicatorImage = backBtn;
            navigationController!.navigationBar.backIndicatorTransitionMaskImage = backBtn;
        }
    }
    internal func addLeftBarButton(with image:UIImage)
    {
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action:  #selector(backButtonClicked), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layoutSubviews()
        
        let container  = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        container.addSubview(btn)
        //container.backgroundColor = UIColor.gray
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: container)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.view.endEditing(true)
    }
    
    @objc internal func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc internal func leftBarButtonAction()
    {
        self.view.endEditing(true)
    }
    override var prefersStatusBarHidden : Bool {
        return isStatusBarHidded
    }
    
    internal func addLeftBarButton(with image:UIImage, addLibraryButton:Bool = false )
    {
        let btn = CustomButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action:  #selector(leftBarButtonAction), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.shadowColour = .clear
        btn.tintColor = UIColor.white
        btn.layoutSubviews()
        
        let container  = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        container.addSubview(btn)
        //container.backgroundColor = UIColor.gray
        btn.frame = CGRect(x: 0, y: 2, width: 32, height: 32)
        
        if addLibraryButton
        {
            let image = UIImageView(image: UIImage(named:"supportCenter"))
            image.frame = CGRect(x: 0, y: 4, width: 28, height: 28)
            let btnLibrary = CustomButton()
            
            //btnLibrary.setImage(UIImage(named: "libraryWhite"), for: .normal)
            
            btnLibrary.addTarget(self, action:  #selector(showLibrary), for: .touchUpInside)
            btnLibrary.imageView?.contentMode = .scaleAspectFit
            
            btnLibrary.layoutSubviews()
            let containerLib  = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
            // containerLib.backgroundColor = UIColor.white
            containerLib.addSubview(image)
            containerLib.addSubview(btnLibrary)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showLibrary))
            containerLib.addGestureRecognizer(tap)
            
            btnLibrary.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width  = 20
            
            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: container),spacer,UIBarButtonItem(customView: containerLib)]
        }else
        {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: container)
        }
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.view.endEditing(true)
    }
    
    @objc internal func rightBarButtonAction()
    {
        
    }
    
    internal func addCricketorLogoToNavBar()
    {
        if hideLogo {
            let addButton1 = CustomButton(type: .custom)
            addButton1.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            addButton1.setTitle("", for: .normal)
            // addButton.setImage(UIImage(named:"add"), for: .normal)
            addButton1.minimumHitArea = 450.0
            addButton1.titleLabel?.font = UIFont(name:"Helvetica Neue", size: 10.0)
            // addButton1.tag = section
            //        addButton1.addTarget(self, action:  #selector(showMainCalendar), for: .touchUpInside)
            
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: -5, width: 120, height: 40))
            imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "cricketor")
            imageView.image = image
            imageView.backgroundColor = UIColor.clear
            let wrapperView = UIView(frame: CGRect(x: 0, y: -20, width: 120, height: 40))
            wrapperView.addSubview(imageView)
            wrapperView.addSubview(addButton1)
            wrapperView.backgroundColor = UIColor.clear
            navigationItem.titleView = wrapperView
        }
    }
    
    func addButton(with image:UIImage)
    {
        
        let bellImage = UIImageView(image: image)
        bellImage.frame = CGRect(x: 5, y: 0, width: 32, height: 32)
        
        let btnBell = CustomButton()
        
        btnBell.cornerRadius = 14
        btnBell.backgroundColor = UIColor.clear
        
        // btnBell.setImage(UIImage(named:"bell"), for: .normal)
        btnBell.addTarget(self, action:  #selector(rightBarButtonAction), for: .touchUpInside)
        btnBell.imageView?.contentMode = .scaleAspectFit
        btnBell.minimumHitArea = 220.0
        btnBell.layoutSubviews()
        
        let containerBell  = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        
        
        containerBell.addSubview(btnBell)
        containerBell.addSubview(bellImage)
        btnBell.frame = CGRect(x: 4, y: 2, width: 28, height: 28)
        let bellButton  = UIBarButtonItem(customView: containerBell)
        
        self.navigationItem.rightBarButtonItems = [bellButton]
        
    }
    func addRightBarButton(with image:UIImage)
    {
        
        let btn = CustomButton()
        
        btn.cornerRadius = 0
        btn.backgroundColor = UIColor.clear
        btn.shadowColour = UIColor.clear
        
        btn.setImage(UIImage(named:"notification"), for: .normal)
        btn.addTarget(self, action:  #selector(notification), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layoutSubviews()
        
        let container  = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        
        container.addSubview(btn)
        let tap = UITapGestureRecognizer(target: self, action: #selector(notification))
        container.addGestureRecognizer(tap)
        
        // container.backgroundColor = UIColor.red
        btn.frame = CGRect(x: 0, y: 2, width: 27, height: 27)
        _  = UIBarButtonItem(customView: container)
        
        
        let bellImage = UIImageView(image: image)
        bellImage.frame = CGRect(x: 5, y: 0, width: 32, height: 32)
        
        let btnBell = CustomButton()
        
        btnBell.cornerRadius = 15
        btnBell.backgroundColor = UIColor.clear
        
        // btnBell.setImage(UIImage(named:"bell"), for: .normal)
        btnBell.addTarget(self, action:  #selector(logout), for: .touchUpInside)
        btnBell.imageView?.contentMode = .scaleAspectFit
        btnBell.minimumHitArea = 220.0
        btnBell.layoutSubviews()
        
        
        let containerBell  = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        //  containerBell.backgroundColor = UIColor.white
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(logout))
        containerBell.addGestureRecognizer(tap1)
        
        
        containerBell.addSubview(btnBell)
        containerBell.addSubview(bellImage)
        
        btnBell.frame = CGRect(x: 0, y: 2, width: 32, height: 32)
        let bellButton  = UIBarButtonItem(customView: containerBell)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width  = 15
        
        self.navigationItem.rightBarButtonItems = [spacer,bellButton]// [bellButton,spacer,viewsButton]
        //.... Un-Comment above & use line  when Firebase notification done Completelly
        
    }
    
    func isPinCodeValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^[1-9][0-9]{5}$")
        return passwordTest.evaluate(with: password)
    }
    
    //    func showWarningMessageLabel(with message:String)
    //    {
    //        warningMessageLabel.text = message
    //
    //        self.viewDidLayoutSubviews()
    //        UIApplication.shared.beginIgnoringInteractionEvents()
    //        warningMessageLabel.isHidden = false
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
    //            self.hideWarningMessageLabel()
    //        })
    //
    //    }
    // for time being added this method showWarningMessageLabel is not working
    func showError(message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Food App", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideWarningMessageLabel()
    {
        warningMessageLabel.isHidden = true
    }
    @objc internal func showLibrary()
    {
//        let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
//        let nvc = storyBoard.instantiateViewController(withIdentifier: presentedViewController.identifier) as! SupportCenterViewController
//        nvc.isFromMenu = false
//        navigationController?.pushViewController(nvc, animated: true)
//
    }
    
    @objc internal func logout ()
    {
//        let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
//        let nvc = storyBoard.instantiateViewController(withIdentifier: LogoutViewController.identifier) as! LogoutViewController
//
//        self.present(nvc, animated: true, completion: {
//
//        })
    }
    
    @objc internal func notification ()
    {
//        let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
//        let nvc = storyBoard.instantiateViewController(withIdentifier: NotificationViewController.identifier) as! NotificationViewController
//        navigationController?.pushViewController(nvc, animated: true)
        
    }
    
    func showActivityIndicator()
    {
        activityIndicator.center = CGPoint(x: (ScreenSize.SCREEN_WIDTH / 2) , y: (ScreenSize.SCREEN_HEIGHT / 2) - 20)
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator()
    {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showNoRecordsViewWithImage(_ tableView: UITableView) {
        let v1 = UIView(frame: tableView.frame)
        let noDataIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        noDataIV.contentMode = .scaleAspectFit
        noDataIV.center = v1.center
        noDataIV.image = UIImage(named: "nofood")
        v1.addSubview(noDataIV)
        tableView.backgroundView  = v1
    }
    
    func showNoRecordsViewWithLabel(_ tableView: UITableView, message: String) {
        let v1 = UIView(frame: tableView.frame)
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: v1.frame.width, height: v1.frame.height))
        noDataLbl.text = message
        noDataLbl.numberOfLines = 0
        noDataLbl.textAlignment = .center
        noDataLbl.lineBreakMode = .byWordWrapping
//        noDataLbl.center = tableView.center
        v1.addSubview(noDataLbl)
        tableView.backgroundView  = v1
    }
       
    
    func showActivityIndicatorWithView(onView: UIView)
    {
        let view1 = UIView(frame: CGRect(x: 0, y: -40, width: onView.frame.width, height: onView.frame.height + 40))
        print(view1.frame)
//        view1.center = onView.center
        view1.backgroundColor = UIColor.clear
        activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: onView.center, size: CGSize(width: 50, height: 50)))
        activityIndicator.color = UIColor(hexString: "dcdcdc")
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        }
        activityIndicator.startAnimating()
        activityIndicator.tag = 55
        activityIndicator.center = onView.center
        view1.addSubview(activityIndicator)
        view1.tag = 555
        onView.addSubview(view1)
        view1.layoutSubviews()
        onView.bringSubviewToFront(view1)
//        activityIndicator.isHidden = false
//        UIApplication.shared.beginIgnoringInteractionEvents()
//        activityIndicator.startAnimating()
        
    }
    
    func hideActivityIndicatorWithView(fromView: UIView)
    {
        fromView.subviews.forEach { (v) in
            if v.tag == 555 || v.tag == 55 {
                v.removeFromSuperview()
            }
        }

        self.view.subviews.forEach { (v) in
            if v.tag == 555 || v.tag == 55 {
                v.removeFromSuperview()
            }
        }
//        activityIndicator.isHidden = true
//        UIApplication.shared.endIgnoringInteractionEvents()
//        activityIndicator.stopAnimating()
//        activityIndicator.removeFromSuperview()
    }

    func showAlert( _ body: String,title: String = AlertMessages.ALERT_TITLE, dismissButtonTitle: String = "OK",confirmhandler:((UIAlertAction?) -> Void)? = nil)
        
    {
        let alertController = UIAlertController(title: title, message:
            body, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: dismissButtonTitle, style: UIAlertAction.Style.default,handler: confirmhandler))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func showAlertWithAutoDismissal( _ body:NSString,title:NSString = AlertMessages.ALERT_TITLE as NSString, dismissButtonTitle:NSString = "OK",shouldAddConfirmButton:Bool = false ,confirmhandler:((UIAlertAction?) -> Void)? = nil)
        
    {
        let alertController = UIAlertController(title: title as String, message:
            body as String, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: dismissButtonTitle as String, style: UIAlertAction.Style.default,handler: dismissAlertHandler)
        alertController.addAction(action)
        if(shouldAddConfirmButton)
        {
            
            alertController.addAction(UIAlertAction(title: "Yes" as String, style: UIAlertAction.Style.default,handler: confirmhandler))
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            dismissAlertHandler(alert: action)
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func ShowAlertOrActionSheet(preferredStyle: UIAlertController.Style,title:String,message:String,buttons:[String],completionClosure: @escaping (_ action :Int) ->()) {
        
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let closure = { (index: Int) in { (action: UIAlertAction!) -> Void in
            completionClosure(index)
            }
        }
        
        var index = 0
        for button in buttons {
            let action = UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: closure(index))
            alertController.addAction(action)
            index += 1
        }
        if let popoverController = alertController.popoverPresentationController {
            popoverController.permittedArrowDirections = .up
            popoverController.sourceView = self.view
        }
        
        //Present the AlertController
        self.present(alertController, animated: true, completion: nil)
    }

    func showToast(message : String) {
        var windows : UIWindow?
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            windows = sceneDelegate.window
        } else {
            // Fallback on earlier versions
            windows = self.view.window
        }
       
        
        if let rootv = windows?.rootViewController?.view {
            for v in rootv.subviews {
                if v.tag == 12345 {
                    v.removeFromSuperview()
                }
            }
        }
        var _h = message.heightWithConstrainedWidth(ScreenSize.SCREEN_WIDTH / 2, font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!)
        var _y = self.view.frame.size.height - 100
        if _h < 25 {
            _h = 30
        }
        if _h >= 70 {
            _y = self.view.frame.size.height - 150
        }
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.midX - ScreenSize.SCREEN_WIDTH / 4, y: _y, width: ScreenSize.SCREEN_WIDTH / 2, height: _h + 5))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.tag = 12345
        toastLabel.font = UIFont(name: Constants.APP_REGULAR_FONT, size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.layer.cornerRadius = (_h + 5) / 2
        toastLabel.clipsToBounds  =  true
        windows?.rootViewController?.view.addSubview(toastLabel)
        windows?.rootViewController?.view.bringSubviewToFront(toastLabel)
        // self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    func showToastOnView(view: UIView, message : String) {

        for v in view.subviews {
            if v.tag == 12345 {
                v.removeFromSuperview()
            }
        }
        
        var _h = message.heightWithConstrainedWidth(ScreenSize.SCREEN_WIDTH / 2, font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!)
        var _y = view.frame.size.height - 100
        if _h < 25 {
            _h = 30
        }
        if _h >= 70 {
            _y = view.frame.size.height - 150
        }
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.midX - ScreenSize.SCREEN_WIDTH / 4, y: _y, width: ScreenSize.SCREEN_WIDTH / 2, height: _h + 5))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.tag = 12345
        toastLabel.font = UIFont(name: Constants.APP_REGULAR_FONT, size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.layer.cornerRadius = (_h + 5) / 2
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        view.bringSubviewToFront(toastLabel)
        // self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

extension SuperViewController:UITextFieldDelegate, UITextViewDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if textField.tag == 99 {
//            let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/$-_.+!*'(),;/?:@=&%").inverted
//
//            let components = string.components(separatedBy: allowedCharacters)
//            let filtered = components.joined(separator: "")
//
//            if string == filtered {
//                return true
//            } else {
//                return false
//            }
//        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
internal func dismissAlertHandler(alert: UIAlertAction!) {
    
}
