import Foundation
import Observation
import Combine

// MARK: - Models

struct Dependent: Identifiable, Equatable {
    let id: Int
    let name: String
}

struct User: Identifiable, Equatable {
    let id: Int
    let name: String
    var dependents: [Dependent] = []
}

struct InsuranceRate: Equatable, CustomStringConvertible {
    let monthlyPremium: Decimal
    let deductible: Decimal
    let coverageAmount: Decimal

    var description: String {
        """
        InsuranceRate(
          monthly: \(monthlyPremium),
          deductible: \(deductible),
          coverage: \(coverageAmount)
        )
        """
    }
}

// MARK: - Stores

@MainActor
@Observable
class UserStore {

    var users: [User] = []

    private let dependentAddedSubject = PassthroughSubject<(Dependent, Int), Never>()

    var dependentAddedPublisher: AnyPublisher<(Dependent, Int), Never> {
        dependentAddedSubject.eraseToAnyPublisher()
    }

    func addUser(_ user: User) {
        users.append(user)
    }

    func addDependent(_ dependent: Dependent, to userId: Int) async {
        guard let index = users.firstIndex(where: { $0.id == userId }) else { return }
        users[index].dependents.append(dependent)
        dependentAddedSubject.send((dependent, userId))
    }
}

@MainActor
@Observable
class InsuranceStore {

    var insuranceRate: InsuranceRate?

    private var cancellables = Set<AnyCancellable>()

    init(userStore: UserStore) {
        userStore.dependentAddedPublisher
            .sink { [weak self] dependent, userId in
                guard let self else { return }
                Task {
                    let rate = await self.calculateInsurance(
                        for: userId,
                        dependent: dependent
                    )
                    self.insuranceRate = rate
                    print("✅ Insurance updated for user \(userId):")
                    print(rate)
                }
            }
            .store(in: &cancellables)
    }

    private func calculateInsurance(
        for userId: Int,
        dependent: Dependent
    ) async -> InsuranceRate {

        // Simulate async work
        try? await Task.sleep(nanoseconds: 300_000_000)

        return InsuranceRate(
            monthlyPremium: Decimal(Double.random(in: 300...600)),
            deductible: Decimal(Double.random(in: 500...2000)),
            coverageAmount: Decimal(Double.random(in: 10_000...50_000))
        )
    }
}

// MARK: - Playground Usage

let userStore = UserStore()
let insuranceStore = InsuranceStore(userStore: userStore)

// Add a user
let user = User(id: 1, name: "Azam")
userStore.addUser(user)

// Add a dependent (this triggers InsuranceStore automatically)
Task {
    let dependent = Dependent(id: 1, name: "Child One")
    await userStore.addDependent(dependent, to: 1)
}
