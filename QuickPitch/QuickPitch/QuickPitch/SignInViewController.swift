//
//  SignInViewController.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.2
//
//

import UIKit
import AWSMobileHubHelper
import FBSDKLoginKit

class SignInViewController: UIViewController {
    @IBOutlet weak var anchorView: UIView!

    @IBOutlet weak var facebookButton: UIButton!

// Support code for Google provider UI.
    @IBOutlet weak var googleButton: UIButton!

// Support code for custom sign-in provider UI.
    @IBOutlet weak var customProviderButton: UIButton!
    @IBOutlet weak var customCreateAccountButton: UIButton!
    @IBOutlet weak var customForgotPasswordButton: UIButton!
    @IBOutlet weak var customUserIdField: UITextField!
    @IBOutlet weak var customPasswordField: UITextField!
    @IBOutlet weak var leftHorizontalBar: UIView!
    @IBOutlet weak var rightHorizontalBar: UIView!
    @IBOutlet weak var orSignInWithLabel: UIView!
    
    
    var didSignInObserver: AnyObject!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("Sign In Loading.")
        
            didSignInObserver =  NSNotificationCenter.defaultCenter().addObserverForName(AWSIdentityManagerDidSignInNotification,
                object: AWSIdentityManager.defaultIdentityManager(),
                queue: NSOperationQueue.mainQueue(),
                usingBlock: {(note: NSNotification) -> Void in
                    // perform successful login actions here
            })

                // Facebook login permissions can be optionally set, but must be set
                // before user authenticates.
                AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
                
                // Facebook login behavior can be optionally set, but must be set
                // before user authenticates.
//                AWSFacebookSignInProvider.sharedInstance().setLoginBehavior(FBSDKLoginBehavior.Web.rawValue)
                
                // Facebook UI Setup
                facebookButton.addTarget(self, action: "handleFacebookLogin", forControlEvents: .TouchUpInside)
                let facebookButtonImage: UIImage? = UIImage(named: "FacebookButton")
                if let facebookButtonImage = facebookButtonImage{
                    facebookButton.setImage(facebookButtonImage, forState: .Normal)
                } else {
                     print("Facebook button image unavailable. We're hiding this button.")
                    facebookButton.hidden = true
                }
                view.addConstraint(NSLayoutConstraint(item: facebookButton, attribute: .Top, relatedBy: .Equal, toItem: anchorViewForFacebook(), attribute: .Bottom, multiplier: 1, constant: 8.0))
                googleButton.removeFromSuperview()
                customProviderButton.removeFromSuperview()
                customCreateAccountButton.removeFromSuperview()
                customForgotPasswordButton.removeFromSuperview()
                customUserIdField.removeFromSuperview()
                customPasswordField.removeFromSuperview()
                leftHorizontalBar.removeFromSuperview()
                rightHorizontalBar.removeFromSuperview()
                orSignInWithLabel.removeFromSuperview()
                customProviderButton.setImage(UIImage(named: "LoginButton"), forState: .Normal)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(didSignInObserver)
    }
    
    func dimissController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Utility Methods
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        AWSIdentityManager.defaultIdentityManager().loginWithSignInProvider(signInProvider, completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            if error == nil {
                dispatch_async(dispatch_get_main_queue(),{
                        self.navigationController!.popViewControllerAnimated(true)
                })
            }
             print("result = \(result), error = \(error)")
        })
    }

    func showErrorDialog(loginProviderName: String, withError error: NSError) {
         print("\(loginProviderName) failed to sign in w/ error: \(error)")
        let alertController = UIAlertController(title: NSLocalizedString("Sign-in Provider Sign-In Error", comment: "Sign-in error for sign-in failure."), message: NSLocalizedString("\(loginProviderName) failed to sign in w/ error: \(error)", comment: "Sign-in message structure for sign-in failure."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Label to cancel sign-in failure."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - IBActions
    func handleFacebookLogin() {
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }
    

    func anchorViewForFacebook() -> UIView {
        return anchorView
    }
    
}
