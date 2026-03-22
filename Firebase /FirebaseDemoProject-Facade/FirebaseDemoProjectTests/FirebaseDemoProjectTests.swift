import Testing
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
@testable import FirebaseDemoProject

struct FirebaseDemoProjectTests {

    private let emulatorHost = "127.0.0.1"
    private let authPort = 9099
    private let firestorePort = 8080
    private var userStore: UserStore

    init() {
        // Configure Firebase once
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        let auth = Auth.auth()
        let db = Firestore.firestore()

        // Connect to local emulators
        auth.useEmulator(withHost: emulatorHost, port: authPort)
        db.useEmulator(withHost: emulatorHost, port: firestorePort)

        userStore = UserStore(auth: auth, db: db)
    }

    @MainActor
    @Test
    func testCreateUserWithDetails() async throws {
        // Use a unique email to avoid collisions
        let email = "johndoe+\(UUID().uuidString)@example.com"

        let userInfo = UserInfo(
            email: email,
            password: "password",
            name: "John Doe",
            licensePlateNumber: "304DFG",
            role: .driver
        )

        // Register the user
        let result = try await userStore.register(userInfo: userInfo)
        #expect(result, "User registration should succeed")

        // Wait briefly for the listener to update user info
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Verify that the user was created and details loaded
        #expect(userStore.signedIn)
        #expect(userStore.userInfo != nil)

        if let loaded = userStore.userInfo {
            #expect(loaded.name == "John Doe")
            #expect(loaded.licensePlateNumber == "304DFG")
            #expect(loaded.role == .driver)
        }

        //firebase emulators:exec "swift test"
        
        // Clean up by signing out
        try userStore.logout()
        #expect(!userStore.signedIn, "User should be signed out after logout")
    }
}
