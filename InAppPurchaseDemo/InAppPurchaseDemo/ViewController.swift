//
//  ViewController.swift
//  InAppPurchaseDemo
//
//  Created by iQlanceMacmini on 24/12/20.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    var productIDs = "com.bidda.bronze"
    var productsArray: SKProduct!
    var planName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        setViewsLayout()
        //requestProductInfo()
    }
    
    func setViewsLayout() {
        self.viewTop.layer.cornerRadius = 10
        self.viewTop.layer.masksToBounds = true
        self.viewBottom.layer.cornerRadius = 10
        self.viewBottom.layer.masksToBounds = true
        self.btnUpdate.layer.cornerRadius = 12
        self.btnUpdate.clipsToBounds = true
    }
    
    @IBAction func btnContinueClicked(_ sender: Any) {
        //self.planName = "Bronze"
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: self.productIDs)
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
            btnUpdate.setTitle("$20", for: .normal)
            print("Fetching Products")
            print("ProductID: \(productID)")
        }else{
            print("Can't make purchases")
        }
    }
    
    func buyProduct(product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // ---------------------------------------------
    // MARK:- In-App Purchase Function
    // —————————————————————————————————————————————
    func requestProductInfo() {

        if SKPaymentQueue.canMakePayments() {
            //let productIdentifiers = NSSet(array: productIDs)
            let productIdentifiers = NSSet(object: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.productIDs) {
                print("Title: " + validProduct.localizedTitle)
                print("Description: " + validProduct.localizedDescription)
                print("Price: " + "\(validProduct.price)")
                buyProduct(product: validProduct);
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }


    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request failed: \(error)")
    }

    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction])

    {
        print("Received Payment Transaction Response from Apple");

        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    //adView.hidden = true
                    break;
                case .failed:
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;



                case .restored:
                    print("Already Purchased");
                    SKPaymentQueue.default().restoreCompletedTransactions()


                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    //adView.hidden = true
                    break;
                default:
                    break;
                }
            }
        }

    }

}

