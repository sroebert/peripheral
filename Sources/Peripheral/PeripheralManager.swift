import Foundation
import CoreBluetooth

class PeripheralManager: NSObject, CBPeripheralManagerDelegate {

    // MARK: - Singleton

    static let shared = PeripheralManager()

    // MARK: - Private Vars

    private var peripheralManager: CBPeripheralManager!

    private var uuid: UUID?
    private var serviceUUID: UUID?

    private var data: [String: Any]?

    // MARK: - Lifecycle

    private override init() {
        super.init()

        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    // MARK: - Advertise

    func startAdvertising(
        uuid: UUID,
        serviceUUID: UUID
    ) {
        peripheralManager.stopAdvertising()
        peripheralManager.removeAllServices()
        
        self.uuid = uuid
        self.serviceUUID = serviceUUID

        let cbServiceUUID = CBUUID(nsuuid: serviceUUID)
        let service = CBMutableService(type: cbServiceUUID, primary: true)
        service.characteristics = [
            CBMutableCharacteristic(
                type: CBUUID(nsuuid: UUID()),
                properties: [.read],
                value: "test".data(using: .utf8),
                permissions: [.readable]
            )
        ]
        peripheralManager.add(service)

        var data: [String: Any] = [:]
        data[CBAdvertisementDataServiceUUIDsKey] = [cbServiceUUID]
        data[CBAdvertisementDataManufacturerDataKey] = "mock".data(using: .utf8)
        self.data = data

        if peripheralManager.state == .poweredOn {
            startAdvertising(
                uuid: uuid,
                serviceUUID: serviceUUID,
                data: data
            )
        }
    }

    private func startAdvertising(
        uuid: UUID,
        serviceUUID: UUID,
        data: [String: Any]
    ) {
        peripheralManager.startAdvertising(data)
        print("Started advertising \(uuid.uuidString), and service \(serviceUUID.uuidString)")
    }

    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        print("Stopped advertising")
    }

    // MARK: - CBPeripheralManagerDelegate

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            guard
                let uuid = uuid,
                let serviceUUID = serviceUUID,
                let data = data
            else {
                return
            }
            startAdvertising(
                uuid: uuid,
                serviceUUID: serviceUUID,
                data: data
            )

        default:
            peripheral.stopAdvertising()
        }
    }
}
