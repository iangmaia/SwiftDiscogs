//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import XCTest

class ToggleStackViewTests: XCTestCase {

    func testSetActiveViewHidesAllOtherSubviews() {
        let stack = ToggleStackView()
        (1..<10).forEach { (_) in
            let subview = UIView()
            subview.isHidden = false
            stack.addArrangedSubview(subview)
        }
        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)

        stack.activeView = activeSubview

        stack.arrangedSubviews.forEach { (subview) in
            if subview != activeSubview {
                XCTAssertTrue(subview.isHidden)
            } else {
                XCTAssertFalse(subview.isHidden)
            }
        }
    }

    func testAddArrangedSubviewToEmptyStackMakesSubviewTheActiveView() {
        let stack = ToggleStackView()
        XCTAssertNil(stack.activeView)

        let subview = UIView()
        stack.addArrangedSubview(subview)
        XCTAssertEqual(subview, stack.activeView)
        XCTAssertFalse(subview.isHidden)
    }

    func testAddHiddenArrangedSubviewToEmptyStackMakesSubviewTheActiveView() {
        let stack = ToggleStackView()
        XCTAssertNil(stack.activeView)

        let subview = UIView()
        subview.isHidden = true
        stack.addArrangedSubview(subview)
        XCTAssertEqual(subview, stack.activeView)
        XCTAssertFalse(subview.isHidden)
    }

    func testRemoveArrangedViewMakesFirstArrangedViewTheActiveView() {
        let stack = ToggleStackView()
        (1..<10).forEach { (_) in
            let subview = UIView()
            subview.isHidden = false
            stack.addArrangedSubview(subview)
        }
        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)

        stack.activeView = activeSubview
        stack.removeArrangedSubview(activeSubview)

        stack.arrangedSubviews.enumerated().forEach { (index, subview) in
            if index == 0 {
                XCTAssertEqual(stack.activeView, subview)
                XCTAssertFalse(subview.isHidden)
            } else {
                XCTAssertTrue(subview.isHidden)
            }
        }
    }

    func testRemoveInactiveArrangedViewLeaveArrangedViewAsIs() {
        let stack = ToggleStackView()
        (1..<10).forEach { (_) in
            let subview = UIView()
            subview.isHidden = false
            stack.addArrangedSubview(subview)
        }

        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)
        stack.activeView = activeSubview

        let firstSubview = stack.arrangedSubviews.first!
        stack.removeArrangedSubview(firstSubview)

        XCTAssertEqual(stack.activeView, activeSubview)
    }

}
