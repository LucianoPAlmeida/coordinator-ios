//
//  Coordinator.swift
//  Coordinator
//
//  Created by Luciano Almeida on 18/03/18.
//  Copyright © 2018 Luciano Almeida. All rights reserved.
//
import UIKit

protocol Startable {
    func start()
}

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator,
                              on controller: UIViewController?,
                              with context: CoordinatorContext?)
}

enum CoordinatorState {
    case finished
    case cancelled
}

protocol CoordinatorContext {
    var state: CoordinatorState { get set }
}

public struct AbstractCoordinatorContext: CoordinatorContext {
    var state: CoordinatorState
    
    static var cancelled: CoordinatorContext { return AbstractCoordinatorContext(state: .cancelled) }
    static var finished: CoordinatorContext { return AbstractCoordinatorContext(state: .finished) }
    
}

protocol Coordinator: AnyObject, Startable {
    var parentCoordinador: Coordinator? { get set }
    var rootViewController: UIViewController! { get set }
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
    func removeFromParent()
    func finish(in controller: UIViewController?, with context: CoordinatorContext?)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinador = self
    }
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
    
    func removeFromParent() {
        parentCoordinador?.removeChildCoordinator(self)
        parentCoordinador = nil
    }
    
    func finish(in controller: UIViewController?, with context: CoordinatorContext?) {
        removeFromParent()
        childCoordinators.removeAll()
        delegate?.coordinatorDidFinish(self, on: controller, with: context)
    }
    
}


