# Predica - Assignment

Recruitment task from Predica.

## Installing

- Clone repository using `git clone` or download zip file and unpack in convienient location.
- Run `pod update`.
- Open file Predica-SelfTest.xcworkspace e.g. `open Predica-SelfTest.xcworkspace`
- Change bundle identifier to whatever you get used to use in your organisation, preferably starting with reverse domain.
- If running on physical device make sure to download matching provisioning profile or set `Automatically Manage Signing`

## Working with mocked device

Please note that at the time of writing the code I did not have real BLE device serving as blood pressure monitor. The imlementation bases on service documentation from bluetooth.com as well as BLE blood pressure monitor described in BLP_v1.0.1.pdf.

Exemplary test data to be used with BLE device emulator e.g. LightBlue 0x40100c1007342d0e110b07e3. These 12-byte data contains following information encoded (as per org.bluetooth.characteristic.blood_pressure_measurement):
- 0x40 - flags: 01000000 i.e. unit mmHg, timestamp is present, remaining flags are not set;
- 0x100C - systolic pressure 120 (SFLOAT, IEEE-11073, 16-bit float including 12-bit mantissa and 4-bit exponent, https://www.bluetooth.com/specifications/assigned-numbers/format-types/);
- 0x1007 - diastolic pressure 70 (SFLOAT);
- 0x342D0E110B07E3 - datetime 2019.11.17 14:45:52 (org.bluetooth.characteristic.date_time);

## Notes

Please note that this is just demo made purely as recruitment tasks. There are lot of thing to be done in order to use in production environment especially exception handling.
 
