//
//  TakeUntil(Completed)Tests.swift
//  RxSwiftExt
//
//  Created by Patrik Sjöberg on 2018-10-19.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class TakeUntil_Completed_Tests: XCTestCase {
    
    enum TestError: Error { case test }
    
    
    var scheduler: TestScheduler!
    var observer: TestableObserver<Int>!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(Int.self)
    }
    
    func testOtherCompletes() {
        let completable: Completable = Observable.from(["a", "b"])
            .ignoreElements()
        
        _ = Observable.from([1,2,3,4,5])
            .takeUntil(completable)
            .subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(
            observer.events.map { $0.value },
            [.next(1), .next(2), .completed]
        )
    }
    
    func testOtherFails() {
        let completable: Completable = Observable.from([
            RxSwift.Event.next("a"),
            RxSwift.Event.next("b"),
            .error(TestError.test),
            RxSwift.Event.next("c")
        ])
        .dematerialize()
        .ignoreElements()
        
        _ = Observable.from([1,2,3,4,5])
            .takeUntil(completable)
            .subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(
            observer.events.map { $0.value },
            [.next(1), .next(2), .error(TestError.test)]
        )
    }
    
    func testCompletesWithoutItems() {
        let completable = Observable<String>.empty()
            .ignoreElements()
        
        _ = Observable.from([1,2,3,4,5])
            .takeUntil(completable)
            .subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(
            observer.events.map { $0.value },
            [.completed]
        )
    }
    
    func testErrorsWithoutItems() {
        let completable = Observable<String>.error(TestError.test)
            .ignoreElements()
        
        _ = Observable.from([1,2,3,4,5])
            .takeUntil(completable)
            .subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(
            observer.events.map { $0.value },
            [.error(TestError.test)]
        )
    }
    
    func testTakeUntilCompleted() {
        let observable: Observable<String> = Observable.from(["a", "b"])
        
        _ = Observable.from([1,2,3,4,5])
            .takeUntil(completed: observable)
            .subscribe(observer)
        
        scheduler.start()

        XCTAssertEqual(
            observer.events.map { $0.value },
            [.next(1), .next(2), .completed]
        )
    }
}
