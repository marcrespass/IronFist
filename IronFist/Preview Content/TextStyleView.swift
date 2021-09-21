//
//  TextStyleView.swift
//  IronFist
//
//  Created by Marc Respass on 9/14/21.
//

import SwiftUI

/*
 /// A font with the large title text style.
 public static let largeTitle: Font

 /// A font with the title text style.
 public static let title: Font

 /// Create a font for second level hierarchical headings.
 public static let title2: Font

 /// Create a font for third level hierarchical headings.
 public static let title3: Font

 /// A font with the headline text style.
 public static let headline: Font

 /// A font with the subheadline text style.
 public static let subheadline: Font

 /// A font with the body text style.
 public static let body: Font

 /// A font with the callout text style.
 public static let callout: Font

 /// A font with the footnote text style.
 public static let footnote: Font

 /// A font with the caption text style.
 public static let caption: Font

 */
struct TextStyleView: View {
    var body: some View {
        VStack {
            Text("Hello!").font(.title)
            Text("Hello!").font(.title2)
            Text("Hello!").font(.title3)
            Text("Hello!").font(.headline) // smaller but bold
            Text("Hello!").font(.subheadline) // smaller - regular
            Text("Hello!").font(.body) // maybe the same as headline - regular
            Text("Hello!").font(.callout) // slightly smaller than body
            Text("Hello!").font(.footnote) // smaller
            Text("Hello!").font(.caption) // smaller
        }
    }
}

struct TextStyleView_Previews: PreviewProvider {
    static var previews: some View {
        TextStyleView()
    }
}
