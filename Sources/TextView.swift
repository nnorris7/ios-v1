//
//  TextView.swift
//  Canvas
//
//  Created by Sam Soffes on 3/8/16.
//  Copyright © 2016 Canvas Labs, Inc. All rights reserved.
//

import UIKit
import CanvasText

class TextView: UITextView {

	// MARK: - UIView

	// Allow subviews to receive user input
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		for view in subviews {
			if view.userInteractionEnabled && view.frame.contains(point) {
				return view
			}
		}

		return super.hitTest(point, withEvent: event)
	}
	

	// MARK: - UITextInput

	// Only display the caret in the used rect (if available).
	override func caretRectForPosition(position: UITextPosition) -> CGRect {
		var rect = super.caretRectForPosition(position)
		
		if let layoutManager = textContainer.layoutManager {
			layoutManager.ensureLayoutForTextContainer(textContainer)
			
			let characterIndex = offsetFromPosition(beginningOfDocument, toPosition: position)
			
			let height: CGFloat
			
			if characterIndex == 0 {
				// Hack for empty document
				height = 43.82015625
			} else {
				if characterIndex == textStorage.length {
					return rect
				}
				
				let glyphIndex = layoutManager.glyphIndexForCharacterAtIndex(characterIndex)
				
				if UInt(glyphIndex) == UInt.max - 1 {
					return rect
				}
				
				height = layoutManager.lineFragmentUsedRectForGlyphAtIndex(glyphIndex, effectiveRange: nil).size.height
			}
			
			if height > 0 {
				rect.size.height = height
			}
		}
		
		return rect
	}
	
	// Omit empty width rect when drawing selection rects.
	override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
		let selectionRects = super.selectionRectsForRange(range)
		return selectionRects.filter({ selection in
			guard let selection = selection as? UITextSelectionRect else { return false }
			return selection.rect.size.width > 0
		})
	}
}