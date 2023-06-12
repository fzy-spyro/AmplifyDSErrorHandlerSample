//

import Amplify
import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Button("Add random todo") {
                viewModel.generateRandomTodo()
            }
            List(viewModel.todos) { todo in 
                Text(todo.name)
            }
        }
        .padding()
        .task {
            await viewModel.observeTodos()
        }
    }
}


@MainActor
final class ContentViewModel: ObservableObject {

    @Published var todos = [Todo]()

    private var todoSubscription: AmplifyAsyncThrowingSequence<DataStoreQuerySnapshot<Todo>>?

    func observeTodos() async {
        let subscription = Amplify.DataStore.observeQuery(for: Todo.self)
        self.todoSubscription = subscription

        do {
            for try await querySnapshot in subscription {
                print("Have: \(querySnapshot.items.count) todos")
                self.todos = querySnapshot.items
            }
        } catch {
            print("Error happend observing todos: \(error)")
        }
    }

    func generateRandomTodo() {
        Task {
            let todo = Todo(name: "This is a todo item created at: \(Date())")
            do {
                try await Amplify.DataStore.save(todo)
            } catch {
                print("Error saving todo: \(error)")
            }
        }
    }
}

extension Todo: Identifiable { }

