//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-12-17.
//

import XCTest
import ZamzamCore

final class NotificationTests: XCTestCase {
    // Test management of notification center memory and auto token release
    // https://github.com/ole/NotificationUnregistering
    
    private static let testNotificationName = Notification.Name(rawValue: "NotificationTests.testNotificationName")
    private let notificationCenter: NotificationCenter = .default
}

extension NotificationTests {
    
    func testUnregisteringEndsObservation() {
        var counter = 0
        var cancellable: Any?
        
        // Subscribe
        cancellable = notificationCenter.addObserver(forName: Self.testNotificationName, object: nil, queue: nil) { _ in
            counter += 1
        }
        
        // Posting notification increments counter (as expected)
        notificationCenter.post(name: Self.testNotificationName, object: nil)
        XCTAssertEqual(counter, 1)
        
        // Unregister
        cancellable.map { notificationCenter.removeObserver($0) }
        cancellable = nil
        
        // Post notification again
        notificationCenter.post(name: Self.testNotificationName, object: nil)
        XCTAssertEqual(counter, 1, "Observer block should not executed again")
    }
}

extension NotificationTests {
    
    func testFailingToUnregisterCausesBlockToStayAliveEvenAfterTokenIsReleased() {
        var counter = 0
        var cancellable: Any?
        
        // Subscribe
        cancellable = notificationCenter.addObserver(forName: Self.testNotificationName, object: nil, queue: nil) { _ in
            counter += 1
        }
        
        // Posting notification increments counter (as expected)
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(counter, 1)
        
        // Release observation token
        if cancellable != nil {
            cancellable = nil
        }
        
        // Post notification again
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(counter, 2, "Attempted released observer still incrementing counter")
    }
}

extension NotificationTests {
    
    func testForgettingToUnregisterCausesBlockToStayAliveEvenAfterObjectIsReleased() {
        var externalCounter = 0
        
        class TestObserver {
            var cancellable: Any?
            
            init(observerBlock: @escaping () -> ()) {
                // Subscribe but never unregisters in deinit
                cancellable = NotificationCenter.default.addObserver(forName: NotificationTests.testNotificationName, object: nil, queue: nil) { _ in
                    observerBlock()
                }
            }
        }
        
        var observer: TestObserver? = TestObserver {
            externalCounter += 1
        }
        
        // Posting notification increments counter (as expected)
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(externalCounter, 1)
        
        // Release observer
        if observer != nil {
            observer = nil
        }
        
        // Post notification again
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(externalCounter, 2, "Attempted released observer still incrementing counter")
    }
}

extension NotificationTests {
    
    func testTokenWrapperAutomaticallyUnregistersOnNil() {
        var counter = 0
        var cancellable: NotificationCenter.Cancellable?
        
        // Subscribe
        notificationCenter.addObserver(forName: Self.testNotificationName, in: &cancellable) { _ in
            counter += 1
        }
        
        // Posting notification increments counter (as expected)
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(counter, 1)
        
        // Destroy observation token
        if cancellable != nil {
            cancellable = nil
        }
        
        // Post notification again
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(counter, 1, "Observer block should not executed again")
    }
}

extension NotificationTests {
    
    func testTokenWrapperAutomaticallyUnregistersOnDeinit() {
        var externalCounter = 0
        
        class TestObserver {
            var cancellable: NotificationCenter.Cancellable?
            
            init(observerBlock: @escaping () -> ()) {
                // Subscribe but no need for deinit registration
                NotificationCenter.default.addObserver(forName: NotificationTests.testNotificationName, in: &cancellable) { _ in
                    observerBlock()
                }
            }
        }
        
        var observer: TestObserver? = TestObserver {
            externalCounter += 1
        }
        
        // Posting notification increments counter (as expected)
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(externalCounter, 1)
        
        // Release observer
        if observer != nil {
            observer = nil
        }
        
        // Post notification again
        notificationCenter.post(name: Self.testNotificationName)
        XCTAssertEqual(externalCounter, 1, "Observer block should not executed again")
    }
}
