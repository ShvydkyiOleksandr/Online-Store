//
//  PaymentHandler.swift
//  Online Store
//
//  Created by Олександр Швидкий on 19.01.2023.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

final class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
    ]
    
    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    func startPayment(products: [Product], total: Double, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        
        products.forEach { product in
            let item = PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(string: "\(product.price)"), type: .final)
            paymentSummaryItems.append(item)
        }
        
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total)"), type: .final)
        paymentSummaryItems.append(total)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems // Set paymentSummaryItems to the paymentRequest
        paymentRequest.merchantIdentifier = "merchant.com.oleksandrShvidkyi.Online-Store"
        paymentRequest.merchantCapabilities = .capability3DS // A security protocol used to authenticate users
        paymentRequest.countryCode = "UA"
        paymentRequest.currencyCode = "UAH"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks // Types of cards supported
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    if let completionHandler = self.completionHandler {
                        completionHandler(true)
                        print("success")
                    }
                } else {
                    if let completionHandler = self.completionHandler {
                        completionHandler(false)
                        print("failure")
                    }
                }
            }
        }
    }
}
