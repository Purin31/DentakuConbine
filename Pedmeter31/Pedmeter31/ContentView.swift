//
//  ContentView.swift
//  Pedmeter31
//
//  Created by cmStudent on 2022/07/27.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = .init()

    var body: some View {
        VStack {
            if viewModel.isWalking {
                Image(systemName: "figure.walk")
                    .imageScale(.large)
                    .foregroundColor(.green)
                Text("now walking \(viewModel.steps)")
            } else {
                Image(systemName: "figure.stand")
                    .imageScale(.large)
                    .foregroundColor(.red)
                Text("stop")
            }

            if viewModel.isWalking {
                Button {
                    viewModel.stopSteps()
                } label: {
                    Text("止まる")
                }
            } else {
                Button {
                    viewModel.updateSteps()
                } label: {
                    Text("歩く")
                }
            }


        }
    }
}

final class ContentViewModel: ObservableObject {
    let pedometerManager = PedometerManager.shared
    @Published var steps: Int = 0

    @Published var isWalking: Bool = false

    func updateSteps() {
        steps = 0
        guard !isWalking else { return }
        isWalking = true
        pedometerManager.walkingStart { number in
            self.steps = Int(truncating: number)
        }
    }

    func stopSteps() {
        guard isWalking else { return }
        isWalking = false
        pedometerManager.walkingStop()

    }
}

final class PedometerManager {
    static let shared: PedometerManager = .init()

    let pedometer: CMPedometer

    private init() {
        pedometer = CMPedometer()
    }

    func walkingStart(handler: @escaping (NSNumber) -> Void) {
        guard CMPedometer.isStepCountingAvailable() else { return }
        // ここはメインスレッドでは実行されない
        pedometer.startUpdates(from: .now) {data, error in
            guard let data = data else { return }
            
            handler(data.numberOfSteps)
        }
       
    }

    func walkingStop() {
        pedometer.stopUpdates()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
