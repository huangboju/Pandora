# BonjourSwift

Easily access Bonjour services and domains in Swift
Updated to Swift 3.0

## Installation

### Cocoapods

Add:

pod 'BonjourSwift'

To your pod file. *Make sure you uncomment `use_frameworks!`*

### Manual

Drag `Bonjour.swift` onto your project.

## Usage

### Finding a service

```swift
func startSearch() {
    let browser: Bonjour = Bonjour()
    // This will find all HTTP servers - Check out Bonjour.Services for common services
    browser.findService(Bonjour.Services.Hypertext_Transfer, domain: Bonjour.LocalDomain) { (services) in
        // Do something with your services!
        // services will be an empty array if nothing was found
    }
}
```

### Finding domains

```swift
func startSearch() {
    let browser: Bonjour = Bonjour()
    bonjour.findDomains { (domains) in
        // Do something with your domains!
        // services will be an empty array if nothing was found
    }
}
```

## Features

- Gracefully handle search that fail to find and services or domains
- Adjustable timeouts
- Method documentations
- 100% organic free-range gluten-free vegan-certified