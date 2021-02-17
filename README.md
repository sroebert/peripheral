# peripheral

Simple command line utility to simulate a Bluetooth peripheral by publishing a single service.

## Installing

Make sure Xcode is installed first.

### [Mint](https://github.com/yonaskolb/mint)

mint install sroebert/peripheral

## Usage

```
mint run peripheral
```

Options:

- __--uuid__: The UUID to use for the peripheral (optional, default value is a random UUID).
- __--service__: The service UUID to publish for the peripheral (optional, default value is a random UUID).
