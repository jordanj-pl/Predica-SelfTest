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
		var deviceManagerDelegate: MockPRDDeviceManagerDelegate!

		describe("Connecting device") {
			beforeEach {
				fakeCentralManager = FakeCBCentralManager()
				deviceManager = PRDDeviceManager()
				deviceManager.central = fakeCentralManager
				fakeCentralManager.delegate = (deviceManager as! CBCentralManagerDelegate)

				deviceManagerDelegate = MockPRDDeviceManagerDelegate()
				deviceManager.delegate = deviceManagerDelegate
			}

			afterEach {
				fakePeripheral.reset()
			}

			context("when not available") {
				beforeEach {
					deviceManager.connectDevice(fakePeripheralUUID)
				}

				it("returns an error") {
					expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateDisconnected))
					expect(fakeCentralManager.connectPeripheralCalled).to(equal(false))
				}

			}

			context("when available") {
				beforeEach {
					fakeCentralManager.fakePeripherals = [fakePeripheral]
					fakePeripheral.hasCompatibleServices = false
				}

				context("has compatible services") {
					beforeEach {
						fakePeripheral.hasCompatibleServices = true

					}

					context("found characteristics") {
						beforeEach {
							fakePeripheral.hasCompatibleCharacteristic = true
						}

						context("set notify") {
							beforeEach {
							fakePeripheral.mockSetNotify = true
								deviceManager.connectDevice(fakePeripheralUUID)
							}

							it("establishes connection") {
								expect(fakeCentralManager.connectPeripheralCalled).to(equal(true))
								expect(deviceManager.currentPeripheral).to(equal(fakePeripheral))
								 expect(deviceManager.currentPeripheral.delegate?.hash).to(equal(deviceManager.hash))
								expect(fakePeripheral.discoverServicesCalled).to(equal(true))
								expect(fakePeripheral.discoverCharacteristicsCalled).to(equal(true))
								expect(fakePeripheral.setNotifyValueCalled).to(equal(true))

								expect(deviceManagerDelegate.didUpdateDeviceStateCalled).to(equal(true))
								expect(deviceManagerDelegate.didEncounterErrorCalled).to(equal(false))
								expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateConnected))
							}
						}

						context("did not set notify") {
							beforeEach {
								fakePeripheral.mockSetNotify = false
								deviceManager.connectDevice(fakePeripheralUUID)
							}

							it("returns an error") {
								expect(fakeCentralManager.connectPeripheralCalled).to(equal(true))
								expect(deviceManager.currentPeripheral).to(equal(fakePeripheral))
								 expect(deviceManager.currentPeripheral.delegate?.hash).to(equal(deviceManager.hash))
								expect(fakePeripheral.discoverServicesCalled).to(equal(true))
								expect(fakePeripheral.discoverCharacteristicsCalled).to(equal(true))
								expect(fakePeripheral.setNotifyValueCalled).to(equal(true))

								expect(deviceManagerDelegate.didUpdateDeviceStateCalled).to(equal(true))
								expect(deviceManagerDelegate.didEncounterErrorCalled).to(equal(true))
								expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateDisconnected))
							}
						}
					}

					context("did not find characteristics") {
						beforeEach {
							fakePeripheral.hasCompatibleCharacteristic = false
							deviceManager.connectDevice(fakePeripheralUUID)
						}

						it("returns an error") {
							expect(fakeCentralManager.connectPeripheralCalled).to(equal(true))
							expect(deviceManager.currentPeripheral).to(equal(fakePeripheral))
							 expect(deviceManager.currentPeripheral.delegate?.hash).to(equal(deviceManager.hash))
							expect(fakePeripheral.discoverServicesCalled).to(equal(true))
							expect(fakePeripheral.discoverCharacteristicsCalled).to(equal(true))
							expect(fakePeripheral.setNotifyValueCalled).to(equal(false))

							expect(deviceManagerDelegate.didUpdateDeviceStateCalled).to(equal(true))
							expect(deviceManagerDelegate.didEncounterErrorCalled).to(equal(true))
							expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateDisconnected))
						}
					}

				}

				context("does not have compatible services") {
					beforeEach {
						deviceManager.connectDevice(fakePeripheralUUID)
					}

					it("returns an error") {
						expect(fakeCentralManager.connectPeripheralCalled).to(equal(true))
						expect(deviceManager.currentPeripheral).to(equal(fakePeripheral))
						expect(deviceManager.currentPeripheral.delegate?.hash).to(equal(deviceManager.hash))
						expect(fakePeripheral.discoverServicesCalled).to(equal(true))
						expect(fakePeripheral.discoverCharacteristicsCalled).to(equal(false))
						expect(fakePeripheral.setNotifyValueCalled).to(equal(false))
						expect(deviceManager.state).to(equal(PRDDeviceManagerDeviceStateDisconnected))
						expect(deviceManagerDelegate.didUpdateDeviceStateCalled).to(equal(true))
						expect(deviceManagerDelegate.didEncounterErrorCalled).to(equal(true))
					}
				}
			}
		}
	}
}
