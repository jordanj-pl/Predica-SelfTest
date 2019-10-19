//
//  DeviceManagerTests.swift
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 18/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

import Quick
import Nimble

class DeviceManagerSpec: QuickSpec {
    override func spec() {
		var fakeCentralManager: FakeCBCentralManager!
		let fakePeripheralUUID = UUID(uuidString: "b38a2c4c-8ac5-4b14-a161-f9ba2134882b")!
		let fakePeripheral = FakeCBPeripheral(identifier: fakePeripheralUUID)
		var deviceManager: PRDDeviceManager!

		describe("Connecting device") {
			beforeEach {
				fakeCentralManager = FakeCBCentralManager()
				deviceManager = PRDDeviceManager()
				deviceManager.central = fakeCentralManager
				fakeCentralManager.delegate = (deviceManager as! CBCentralManagerDelegate)
			}

			it("connect to device when not available") {
				deviceManager.connectDevice(fakePeripheralUUID)

				expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateDisconnected))
				expect(fakeCentralManager.connectPeripheralCalled).to(equal(false))

			}

			it("connect to available device") {
				fakeCentralManager.fakePeripherals = [fakePeripheral]

				deviceManager.connectDevice(fakePeripheralUUID)


				expect(fakeCentralManager.connectPeripheralCalled).to(equal(true))
				expect(deviceManager.currentPeripheral).to(equal(fakePeripheral))
				//TODO expect(deviceManager.currentPeripheral.delegate).to(equal(deviceManager))
				expect(fakePeripheral.discoverServicesCalled).to(equal(true))
				expect(fakePeripheral.discoverCharacteristicsCalled).to(equal(true))
				expect(fakePeripheral.setNotifyValueCalled).to(equal(true))
				expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateConnected))
			}
		}
	}
}
