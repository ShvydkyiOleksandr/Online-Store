//
//  User.swift
//  Online Store
//
//  Created by Олександр Швидкий on 25.01.2023.
//

import Foundation

let previewUser = User(
    firstName: "Alex",
    lastName: "Strong",
    email: "previewUser@gmail.com",
    phone: "0932799330",
    addresses: User.Addresses(
        address: User.Addresses.Address(street: "Heroiv Dnipra", building: "56", apartment: "30"),
        cityName: "Kyiv",
        novaPoshtaNumber: "35")
)

let previewProduct = Product(
    id: productIds[4],
    name: "VOLUME THERAPY SHAMPOO",
    description: "*KEY ACTIVE INGREDIENTS:*\n• Burdock Extract • Nettle Extract • Hydrolyzed Wheat Protein • Irish Red Algae Extract • Hydrolyzed Soy\nProtein • Hydrolyzed Collagen • Vitamin B5 • Hydrolyzed keratin • Coconut oil • Vitamin C • Babassu oil.\n\n**ACTION:**\nTherapeutic shampoo VOLUME from Dr. Sorbie is based on natural ingredients and designed specifically\nfor thin, loose and lacking volume hair.\n\nThe uniquely balanced formula of anti-chlorine shampoo VOLUME gently and delicately cleanses the\nhair and scalp from impurities, penetrates deep into the hair structure, saturating it with necessary trace\nelements and restores damaged areas of hair, acting on it from the inside. It smooths the hair cuticle,\nforming a thin thermal protective film on its surface, which in turn maintains the required level of moisture\nand nutrients inside the hair, thereby providing a prolonged caring effect.\n\nThe synergistic interaction of the bioactive components of the VOLUME shampoo helps to restore the\nelasticity of the hair even at its roots, which significantly increases their basal volume. Prolongs hear styling.\nIt fills thin weakened hair with energy, makes it stronger, denser, voluminous and gives a healthy shine.\nIt has a calming and antiseptic effect in case of inflammation of the scalp, reduces irritation, reduces\noiliness of the skin. Does not over-dry.\nRemoves static electrification of the hair and prevents it from rapid becoming dirty. Does not weigh the\nhair down. It is easily washed off with warm water, provides easy combing and hair styling. With regular\nuse, the shampoo VOLUME maintains a constant volume of hair. The effect is noticeable with the first\nuse of the shampoo.\n\nThis product **can be used daily**.",
    composition: ["Burdock Extract", "Nettle Extract", "Hydrolyzed Wheat Protein", "Irish Red Algae Extract", "Hydrolyzed Soy Protein", "Hydrolyzed Collagen", "Vitamin B5", "Hydrolyzed keratin", "Coconut oil", "Vitamin C", "Babassu oil"],
    volume: 400,
    allVolumes: [400: productIds[4], 1000: productIds[5]],
    article: "DRS 401",
    price: 20.99,
    typeString: "Home care",
    imageUrlString: "https://firebasestorage.googleapis.com:443/v0/b/online-store-32758.appspot.com/o/products%2F6342116D-1C14-435E-9700-B68CBEC8C779?alt=media&token=14e5c884-7ec0-4bed-b00d-72ba92fd7b7a",
    brand: "Dr.Sorbie"
)

let previewNews = News(
    id: "0CBD579B-5053-4BE0-83E5-9D2C20EDE4B0",
    previewImageUrlString: "https://firebasestorage.googleapis.com:443/v0/b/online-store-32758.appspot.com/o/news%2FpreviewNews0?alt=media&token=c94ee339-b17b-48f6-8431-58aa8a676aa4",
    imageUrlString: "https://firebasestorage.googleapis.com:443/v0/b/online-store-32758.appspot.com/o/news%2Fnews0?alt=media&token=f3d8685d-94ef-4282-a50b-e670ad867aad",
    name: "Why choose Dr. Sorbie?",
    shortDescription: "We get a lot of positive feedbacks not only from the masters, but also from their clients on a daily basis. You will fall in love at first sight, and it’s not just big words. Our products do their job at 200%. What’s the secret? Most of the formulas for hair products on the market.",
    description: "We get a lot of positive feedbacks not only from the masters, but also from their clients on a daily basis.\nYou will fall in love at first sight, and it’s not just big words. Our products do their job at 200%.\n\n**What’s the secret?**\n\nMost of the formulas for hair products on the market were created a long time ago and their action is not aimed at restoring hair, but at creating a cosmetic effect. A large number of silicones and just a little bit of really active components reduce the chances of hair to become healthy.\n\n**When creating Dr. Sorbie products, the following ideas were taken as a basis:**\n\nto prolong the vitality of hair, which directly affects their length, appearance and resistance to external influences (paint, hair dryer, sun, etc.) so that the hair after coloring can  be of a better quality than before;\nthe products should be easily combined with each other and perform not one, but many functions;\n to combine modern technology and the power of nature It is also worth mentioning that we are opposed to testing cosmetics on animals and the use of harmful chemical components.\nWe are chosen because our products are as natural and effective as possible."
)

let previewProcedure = Procedure(
    imageUrlString: "https://firebasestorage.googleapis.com:443/v0/b/online-store-32758.appspot.com/o/procedures%2F2BB523FD-0544-42F0-B18C-E7B70B74E3D0?alt=media&token=2e152ee4-9100-4fd8-981a-896db4d378c8",
    name: "Gorgeous Volume Texturizer Spray",
    shortDescription: "The Hair Texturizer Spray moisturizes and gives more consistency to the hair fiber, resulting in shinier, stronger hair with more volume.",
    description: "Gorgeous Volume\nTexturizer Spray\nThe Hair Texturizer Spray moisturizes and gives more consistency to the hair fiber, resulting in shinier, stronger hair with more volume. It is made with an association of vegetable extracts, trace elements from red algae and vitamins. It has a revitalizing, conditioning and moisturizing action, protecting against excess dryness. It helps fight hair loss and favors hair growth.\n\n**HOW TO USE**\n\n1. Shake before using.\n2. With the clean, dry or wet hair, spray the texture product strand by strand, softly pressing the ends.\n3. Do not rinse. Finish as you want.",
    brand: "Brae",
    id: "2BB523FD-0544-42F0-B18C-E7B70B74E3D0"
)

let previewBrand = Brand(
    name: "Brae",
    id: "3304C250-EC52-4DF8-AA50-4AC181A0036E",
    imageUrlString: "https://firebasestorage.googleapis.com:443/v0/b/online-store-32758.appspot.com/o/brands%2F3304C250-EC52-4DF8-AA50-4AC181A0036E?alt=media&token=bd3e266a-f7c2-414e-b291-ced3f052f946"
)

let previewOrder = Order(
    products: [UUID().uuidString : 2, UUID().uuidString : 1, UUID().uuidString : 1, UUID().uuidString : 3],
    receiver: Order.Receiver(firstName: previewUser.firstName, lastName: previewUser.lastName, phone: previewUser.phone!, email: previewUser.email),
    deliveryType: .novaPoshta,
    paymentType: .uponReceipt,
    cityName: "Kyiv",
    content: "\(previewProduct.name);\n \(previewProduct.name);\n \(previewProduct.name);\n \(previewProduct.name).",
    total: "\(7) items for \(String(format: "%0.2f", previewProduct.price * 7))"
)


