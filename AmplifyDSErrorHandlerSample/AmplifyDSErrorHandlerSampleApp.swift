import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin
import ClientRuntime
import SwiftUI

@main
struct AmplifyDSErrorHandlerSampleApp: App {

    init() {
        do {
            // AmplifyModels is generated in the previous step
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels(), configuration: .custom(errorHandler: dataStoreErrorHandler))
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSAPIPlugin())

            SDKLoggingSystem.initialize(logLevel: .debug)
            Amplify.Logging.logLevel = .debug


            try Amplify.configure()
            print("Amplify configured with DataStore plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


//MARK: - AmplifyDSErrorHandlerSampleApp
extension AmplifyDSErrorHandlerSampleApp {

    func dataStoreErrorHandler(_ amplifyError: AmplifyError) {
        print("dataStoreErrorHandler called with: \(amplifyError)")
    }
}
