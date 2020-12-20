//
//  QuerySnapshotPublisher.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 11/1/20.
//

import Combine
import Firebase

extension Publishers {
    struct QuerySnapshotPublisher: Publisher {
        typealias Output = QuerySnapshot
        typealias Failure = IncrementError
        
        private let query: Query
        
        init(query: Query) {
            self.query = query
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let querySnapshotSubscription = QuerySnapshotSubscription(subscriber: subscriber, query: query)
            subscriber.receive(subscription: querySnapshotSubscription)
        }
    }
    
    class QuerySnapshotSubscription<S: Subscriber>: Subscription where S.Input == QuerySnapshot, S.Failure == IncrementError {
        private var subscriber: S?
        private var listner: ListenerRegistration?
        
        init(subscriber: S, query: Query) {
            listner = query.addSnapshotListener({ (querySanpshot, error) in
                if let error = error {
                    subscriber.receive(completion: .failure(.default(description: error.localizedDescription)))
                } else if let querySnapshot = querySanpshot {
                    _ = subscriber.receive(querySnapshot)
                } else {
                    subscriber.receive(completion: .failure(.default()))
                }
            })
        }
        
        func request(_ demand: Subscribers.Demand) { }
        func cancel() {
            subscriber = nil
            listner = nil
        }
    }
}
