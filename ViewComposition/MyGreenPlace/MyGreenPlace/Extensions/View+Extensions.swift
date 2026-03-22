//
//  View+Extensions.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 1/25/26.
//

import SwiftUI

extension View {
    
    func rounded(radius: CGFloat = 16, style: RoundedCornerStyle = .continuous) -> some View {
        return self.clipShape(RoundedRectangle(cornerRadius: radius, style: style))
    }
}



