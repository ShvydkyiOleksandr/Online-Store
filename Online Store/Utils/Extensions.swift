//
//  Extensions.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
        return dateFormatter.string(from: self)
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = max(hScale, vScale) // scaleToFill
            let resizeSize = CGSize(width: size.width * scale, height: size.height * scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width - newSize.width) / 2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height - newSize.height) / 2.0
            }
            
            draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}

extension ObservableObject {
    func runInMainThread(after time: Double = 0, execute: @escaping () -> Void) {
        if Thread.isMainThread {
            execute()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                execute()
            }
        }
    }
    
    func runInMainThreadSync(execute: @escaping () -> Void) {
        DispatchQueue.main.sync {
            execute()
        }
    }
}
