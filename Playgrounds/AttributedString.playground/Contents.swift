//: Playground - noun: a place where people can play

import UIKit
import Foundation

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

func makeUnderlineText(fulltext: String, underlineText: String? = nil) -> NSAttributedString {
    
    let attributesNormal = [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
    let attributesUnderline = [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    
    if let underlineText = underlineText {
        let rangeUnderline = fulltext.range(of: underlineText)
        if let rangeUnderline = rangeUnderline {
            let nsRange = fulltext.nsRange(from: rangeUnderline)
            let result = NSMutableAttributedString(string: fulltext, attributes: attributesNormal)
            result.addAttributes(attributesUnderline, range: nsRange)
            return result
        }
    }
    
    // All text is underline
    return NSAttributedString(string: fulltext, attributes: attributesUnderline)
}

makeUnderlineText(fulltext: "click ici.", underlineText: "ici")
makeUnderlineText(fulltext: "click ici.", underlineText: "bad")
makeUnderlineText(fulltext: "click ici.")


