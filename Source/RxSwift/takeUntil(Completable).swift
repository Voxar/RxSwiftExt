//
//  takeUntil.swift
//  RxSwiftExt
//
//  Created by Patrik Sjöberg on 2018-10-19.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    /**
     Returns the elements from the source observable sequence until the other completable completes or errors out.
     
     - seealso: [takeUntil operator on reactivex.io](http://reactivex.io/documentation/operators/takeuntil.html)
     
     - parameter other: Observable sequence that terminates propagation of elements of the source sequence.
     - returns: An observable sequence containing the elements of the source sequence up to the point the other sequence interrupted further propagation.
     */
    public func takeUntil(_ other: Completable) -> Observable<E> {
        let otherStopped = other.asObservable().materialize()
            // throw errors propagate throw errors
            .map{ try $0.error.flatMap({ throw $0 }) }
        return takeUntil(otherStopped)
    }
    
    /**
     Returns the elements from the source observable sequence until the other observable sequence completes or errors out.
     
     - seealso:
        - `takeUntil(_ other: Completable)`
        - [takeUntil operator on reactivex.io](http://reactivex.io/documentation/operators/takeuntil.html)
     
     - parameter other: Observable sequence that terminates propagation of elements of the source sequence.
     - returns: An observable sequence containing the elements of the source sequence up to the point the other sequence interrupted further propagation.
     */
    public func takeUntil<O: ObservableType>(completed other: O) -> Observable<E> {
        return takeUntil(other.ignoreElements())
    }
}
