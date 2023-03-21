//
//  Order.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import Foundation

struct Order: Codable, Identifiable {
    let products: [String: Int]
    let receiver: Receiver
    let deliveryType: DeliveryType
    let paymentType: PaymentType
    let cityName: String
    let content: String
    let total: String
    var novaPoshtaNumber: String?
    var address: User.Addresses.Address?
    var isPaid = false
    var date = Date()
    var id = UUID().uuidString
    var statusString = Status.notProcessed.rawValue
    var status: Status { Status(rawValue: statusString) ?? .processing }
    var formattedDate: String { date.formatted(.dateTime.hour().minute().day().month().year()) }
    
    init(products: [String : Int],
         receiver: Receiver,
         deliveryType: DeliveryType,
         paymentType: PaymentType,
         cityName: String,
         content: String,
         total: String,
         novaPoshtaNumber: String? = nil,
         address: User.Addresses.Address? = nil,
         isPaid: Bool = false,
         date: Date = Date(),
         statusString: String = Status.notProcessed.rawValue,
         id: String = UUID().uuidString) {
        self.products = products
        self.receiver = receiver
        self.deliveryType = deliveryType
        self.paymentType = paymentType
        self.cityName = cityName.trimmingCharacters(in: .whitespaces)
        self.content = content
        self.total = total
        
        if let trimmedNovaPoshtaNumber = novaPoshtaNumber?.trimmingCharacters(in: .whitespaces), !trimmedNovaPoshtaNumber.isEmpty {
            self.novaPoshtaNumber = trimmedNovaPoshtaNumber
        }

        self.address = address
        self.statusString = statusString
        self.isPaid = paymentType == .withCredit ? true : false
        self.date = date
        self.id = id
    }
    
    struct Receiver: Codable {
        let firstName: String
        let lastName: String
        let phone: String
        let email: String
        
        init(firstName: String, lastName: String, phone: String, email: String) {
            self.firstName = firstName.trimmingCharacters(in: .whitespaces)
            self.lastName = lastName.trimmingCharacters(in: .whitespaces)
            self.phone = phone.trimmingCharacters(in: .whitespaces)
            self.email = email.trimmingCharacters(in: .whitespaces)
        }
    }
    
    enum DeliveryType: String, CaseIterable, Identifiable, Codable {
        case novaPoshta = "Nova Poshta"
        case addressDelivery = "Address delivery"
        
        var id: Self { self }
    }
    
    enum PaymentType: String, CaseIterable, Identifiable, Codable {
        case uponReceipt = "Upon receipt"
        case withCredit = "With credit card"
        case invoiceForPayment = "Invoice for payment"
        
        var id: Self { self }
    }
    
    enum Status: String, Codable {
        case notProcessed = "Not processed"
        case processing = "Processing"
        case processed = "Processed"
        case sentToNovaPoshta = "Sent to nova poshta"
        case deliveredToCourier = "Delivered to the courier"
        case received = "Received"
    }
}
