//
//  HapticManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/14.
//

import CoreHaptics

class HapticManager: ObservableObject {
    
    static let shared = HapticManager()
    private init() {}
    
    @Published var engine: CHHapticEngine?
    @Published var isEngineLoad: Bool = false
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try self.engine?.start()
            isEngineLoad = true
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func stopHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        self.engine?.stop()
        self.engine = nil
        isEngineLoad = false
    }
    
    func playCustomVibration(_ value: Float) {
        // 진동 이벤트 생성
        var events = [CHHapticEvent]()
        let value = value * 0.8 + 0.2
        print(value)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: value)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: value)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.0)
        //TimeInterval(datas["times"])
        events.append(event)
        
        // 진동 패턴 생성
        let pattern = try? CHHapticPattern(events: events, parameters: [])
        
        // 플레이어 생성 및 패턴 연결
        let player = try? self.engine?.makePlayer(with: pattern!)
        
        // 진동 재생
        try? player?.start(atTime: 0)
    }
}
