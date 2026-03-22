import SwiftUI
import Observation
import Foundation

// MARK: - Models

struct Dependent: Identifiable, Equatable {
    let id: UUID
    let name: String
}

struct User: Identifiable, Equatable {
    let id: UUID
    var dependents: [Dependent] = []
}

struct InsuranceRate: Equatable {
    let monthlyPremium: Decimal
    let deductible: Decimal
    let coverageAmount: Decimal
}

// MARK: - Store Events

enum UserEvent {
    case dependentAdded(dependent: Dependent, userId: UUID)
    case dependentRemoved(dependent: Dependent, userId: UUID)
}

// MARK: - UserStore (Producer)

@MainActor
@Observable
final class UserStore {

    var users: [User] = []

    // One continuation per subscriber
    private var continuations: [UUID: AsyncStream<UserEvent>.Continuation] = [:]

    // Public event stream (a new stream per subscriber)
    func events() -> AsyncStream<UserEvent> {
        AsyncStream { continuation in
            let id = UUID()

            // AsyncStream builder is not MainActor-isolated, so hop to MainActor to mutate state
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.continuations[id] = continuation
            }

            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in
                    guard let self else { return }
                    self.continuations.removeValue(forKey: id)
                }
            }
        }
    }

    // Fan-out emitter
    private func emit(_ event: UserEvent) {
        for continuation in continuations.values {
            continuation.yield(event)
        }
    }

    // Domain action
    func addDependent(_ dependent: Dependent, to userId: UUID) async {
        guard let index = users.firstIndex(where: { $0.id == userId }) else { return }
        users[index].dependents.append(dependent)
        emit(.dependentAdded(dependent: dependent, userId: userId))
    }
}

// MARK: - InsuranceStore (Subscriber)

@MainActor
@Observable
final class InsuranceStore {

    var insuranceRate: InsuranceRate?

    // deinit is not MainActor-isolated, so store the Task in a nonisolated property
    private var listener: Task<Void, Never>?

    func startListening(to events: AsyncStream<UserEvent>) {
        listener?.cancel()

        listener = Task { [weak self] in
            guard let self else { return }

            for await event in events {
                switch event {
                case let .dependentAdded(_, userId):
                    await self.calculateInsurance(for: userId)

                case .dependentRemoved:
                    break
                }
            }
        }
    }

    private func calculateInsurance(for userId: UUID) async {
        insuranceRate = InsuranceRate(
            monthlyPremium: Decimal(Double.random(in: 300...600)),
            deductible: Decimal(Double.random(in: 500...2000)),
            coverageAmount: Decimal(Double.random(in: 10_000...50_000))
        )
    }

    deinit {
        Task { @MainActor [weak self] in
            self?.listener?.cancel()
        }
    }
}

// MARK: - DocumentStore (Another Subscriber)

@MainActor
@Observable
final class DocumentStore {

    private var listener: Task<Void, Never>?

    func startListening(to events: AsyncStream<UserEvent>) {
        listener?.cancel()

        listener = Task {
            for await event in events {
                if case .dependentAdded = event {
                    print("DocumentStore: regenerate documents")
                }
            }
        }
    }

    deinit {
        Task { @MainActor [weak self] in
            self?.listener?.cancel()
        }
    }
}

// MARK: - App Composition Root



// MARK: - View

struct ContentView: View {

    @Environment(UserStore.self) private var userStore
    @Environment(InsuranceStore.self) private var insuranceStore

    var body: some View {
        VStack(spacing: 16) {

            Button("Add Dependent") {
                Task {
                    let dependent = Dependent(id: UUID(), name: "Nancy")
                    await userStore.addDependent(dependent, to: userStore.users.first!.id)
                }
            }

            if let rate = insuranceStore.insuranceRate {
                VStack(spacing: 8) {
                    Text("Monthly Premium: \(rate.monthlyPremium.moneyString)")
                    Text("Deductible: \(rate.deductible.moneyString)")
                    Text("Coverage: \(rate.coverageAmount.moneyString)")
                }
                .font(.headline)
            }
        }
        .padding()
    }
}

// MARK: - Helpers

private extension Decimal {
    var moneyString: String {
        let number = NSDecimalNumber(decimal: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: number) ?? "\(number)"
    }
}
