//
//  UIControlExtensions.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 18/09/2023.
//

import UIKit
import Combine

extension UIControl {

    @MainActor
    class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void {

        private let subscriber: S?
        private let control: UIControl
        private let event: UIControl.Event

        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event

            self.control.addTarget(self, action: #selector(handleEvent), for: event)
        }

        @objc func handleEvent(_ sender: UIControl) {
            _ = self.subscriber?.receive(())
        }

        nonisolated func request(_ demand: Subscribers.Demand) {}

        nonisolated func cancel() {}
    }

    struct InteractionPublisher: @preconcurrency Publisher {

        typealias Output = Void
        typealias Failure = Never

        private let control: UIControl
        private let event: UIControl.Event

        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }

        @MainActor
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = InteractionSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )

            subscriber.receive(subscription: subscription)
        }
    }

    func publisher(for event: UIControl.Event) -> UIControl.InteractionPublisher {
        return InteractionPublisher(control: self, event: event)
    }

}

