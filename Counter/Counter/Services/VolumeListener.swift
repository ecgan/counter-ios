import Foundation
import AVFoundation
import Combine
import MediaPlayer

/// Volume button listener using AVAudioSession KVO observation
/// Conforms to VolumeListenerProtocol from Interfaces.swift
final class VolumeListener: NSObject, ObservableObject, VolumeListenerProtocol {
    /// Publisher emitting volume button events (after debounce)
    var eventPublisher: AnyPublisher<VolumeEvent, Never> {
        debouncedEventSubject.eraseToAnyPublisher()
    }

    /// Whether the listener is currently active
    @Published private(set) var isListening: Bool = false

    // MARK: - Private Properties

    private let rawEventSubject = PassthroughSubject<VolumeEvent, Never>()
    private let debouncedEventSubject = PassthroughSubject<VolumeEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var previousVolume: Float = 0.5
    private var volumeView: MPVolumeView?

    // Debounce timing
    private let debounceInterval: TimeInterval = TimeInterval(PerformanceContract.debounceIntervalMs) / 1000.0
    private var lastEventTime: Date?

    // MARK: - Initialization

    override init() {
        super.init()
        setupDebounce()
    }

    deinit {
        stopListening()
    }

    // MARK: - VolumeListenerProtocol

    /// Start listening for volume button events
    func startListening() {
        guard !isListening else { return }

        configureAudioSession()
        setupVolumeView()
        startObservingVolume()

        isListening = true
    }

    /// Stop listening for volume button events
    func stopListening() {
        guard isListening else { return }

        stopObservingVolume()
        cleanupVolumeView()
        deactivateAudioSession()

        isListening = false
    }

    // MARK: - Audio Session Configuration

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            previousVolume = audioSession.outputVolume
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    private func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
    }

    // MARK: - Volume View (for intercepting system UI)

    private func setupVolumeView() {
        // Create hidden MPVolumeView to intercept system volume HUD
        let volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 1, height: 1))
        volumeView.isHidden = true
        self.volumeView = volumeView

        // Add to a window if available
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(volumeView)
        }
    }

    private func cleanupVolumeView() {
        volumeView?.removeFromSuperview()
        volumeView = nil
    }

    // MARK: - Volume Observation

    private func startObservingVolume() {
        AVAudioSession.sharedInstance().addObserver(
            self,
            forKeyPath: "outputVolume",
            options: [.new, .old],
            context: nil
        )
    }

    private func stopObservingVolume() {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
    }

    // MARK: - KVO Handler

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == "outputVolume",
              let newVolume = change?[.newKey] as? Float else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        handleVolumeChange(newVolume: newVolume)
    }

    private func handleVolumeChange(newVolume: Float) {
        let now = Date()
        let volumeDelta = newVolume - previousVolume

        guard volumeDelta != 0 else { return }

        let eventType: VolumeEventType = volumeDelta > 0 ? .volumeUp : .volumeDown
        let event = VolumeEvent(type: eventType, timestamp: now)
        rawEventSubject.send(event)

        // Reset volume to middle to allow continuous detection
        resetVolumeToMiddle()
        previousVolume = 0.5
    }

    private func resetVolumeToMiddle() {
        // Find the volume slider in MPVolumeView and reset it
        guard let volumeView = volumeView else { return }

        for subview in volumeView.subviews {
            if let slider = subview as? UISlider {
                DispatchQueue.main.async {
                    slider.value = 0.5
                }
                break
            }
        }
    }

    // MARK: - Debounce Setup

    private func setupDebounce() {
        rawEventSubject
            .filter { [weak self] event in
                guard let self = self else { return false }
                let now = Date()
                if let lastTime = self.lastEventTime {
                    let elapsed = now.timeIntervalSince(lastTime)
                    if elapsed < self.debounceInterval {
                        return false
                    }
                }
                self.lastEventTime = now
                return true
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.debouncedEventSubject.send(event)
            }
            .store(in: &cancellables)
    }
}
