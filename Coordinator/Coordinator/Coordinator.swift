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

protocol CoordinatorDelegate: class {
    func coordinatorDidFinish(_ coordinator: Coordinator, on controller: UIViewController?)
}

protocol Coordinator: class, Startable {
    var parentCoordinador: Coordinator? { get set }
    var rootViewController: UIViewController! { get set }
    var childCoordinators: [Coordinator] { get set }
    weak var delegate: CoordinatorDelegate? { get set }
    
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
    func removeFromParent()
    func finish(in controller: UIViewController?)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinador = self
    }
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
        coordinator.parentCoordinador = self
    }
    
    func removeFromParent() {
        parentCoordinador?.removeChildCoordinator(self)
        parentCoordinador = nil
    }
    
    func finish(in controller: UIViewController?) {
        removeFromParent()
        delegate?.coordinatorDidFinish(self, on: controller)
    }
}
