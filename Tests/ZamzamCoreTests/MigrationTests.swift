//
//  MigrationTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/30/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import ZamzamCore

final class MigrationTests: XCTestCase {
    
}

extension MigrationTests {
    
    func testMigrationReset() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation3.fulfill()
        }
        
        migration.reset()
        
        let expectation4 = self.expectation(description: "Expecting block to be run again for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation4.fulfill()
        }
        
        let expectation6 = self.expectation(description: "Expecting block to be run again for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation6.fulfill()
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testMigrationChained() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0")
        
        migration
            .perform(forVersion: "0.9") {
                expectation1.fulfill()
            }
            .perform(forVersion: "0.9") {
                XCTFail("Should not execute a block for the same version twice")
            }
            .perform(forVersion: "1.0") {
                expectation2.fulfill()
            }
            .perform(forVersion: "1.0") {
                XCTFail("Should not execute a block for the same version twice")
            }
            .perform(forVersion: "2.0") {
                XCTFail("Should not execute a block for a future version")
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testMigrationBuild() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        migration.perform(forVersion: "0.9") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation2.fulfill()
        }
        
        migration.perform(forVersion: "1.0") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testMigratesOnFirstRun() {
        let migration: Migration = .makeMigration(forVersion: "1.1")
        let expectation = self.expectation(description: "Should execute migration after reset")
        
        migration.perform(forVersion: "1.0") {
            expectation.fulfill()
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testMigratesOnce() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation = self.expectation(description: "Expecting block to be run")
        migration.perform(forVersion: "0.9") {
            expectation.fulfill()
        }
        
        migration.perform(forVersion: "0.9") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run")
        migration.perform(forVersion: "1.0") {
            expectation2.fulfill()
        }
        
        migration.perform(forVersion: "1.0") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testMigratesPreviousVersionBlocks() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation2.fulfill()
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testMigratesVersionInNaturalSortOrder() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        migration.perform(forVersion: "0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.perform(forVersion: "0.10") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1")
        migration.perform(forVersion: "1") {
            expectation3.fulfill()
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testRunsApplicationUpdateBlockOnce() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        let expectation = self.expectation(description: "Should only call block once")
        
        migration.performUpdate {
            expectation.fulfill()
        }
        
        migration.performUpdate {
            XCTFail("Expected applicationUpdate to be called only once")
        }
        
        waitForAllExpectations()
    }
}

extension MigrationTests {
    
    func testRunsApplicationUpdateBlockOnlyOnceWithMultipleMigrations() {
        let migration: Migration = .makeMigration(forVersion: "1.0")
        
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.8")
        migration.perform(forVersion: "0.8") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.perform(forVersion: "0.10") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Should call the applicationUpdate only once no matter how many migrations have to be done")
        migration.performUpdate {
            expectation4.fulfill()
        }
        
        waitForAllExpectations()
    }
}

// MARK: - Helpers

private extension MigrationTests {
    
    func waitForAllExpectations() {
        waitForExpectations(timeout: 5) {
            guard let error = $0 else { return }
            print("waitForAllExpectations timeout: \(error)")
        }
    }
}

private extension Migration {
    private class TempClassForBundle {}
    
    static func makeMigration(forVersion version: String) -> Migration {
        let migration = Migration(
            userDefaults: UserDefaults(suiteName: "MigrationTests")!,
            bundle: Bundle(for: TempClassForBundle.self)
        )
        
        // Simulate build version
        migration.set(version: version)
        
        migration.reset()
        
        return migration
    }
}