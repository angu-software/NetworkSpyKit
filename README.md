# 🕵 NetworkSpyKit

[![Run Tests](https://github.com/angu-software/NetworkSpyKit/actions/workflows/ci.yml/badge.svg)](https://github.com/angu-software/NetworkSpyKit/actions/workflows/ci.yml)

`NetworkSpyKit` is a lightweight, thread-safe HTTP spy and stub tool for testing code that performs network requests in Swift.

It allows you to:
- Record outgoing `URLRequest`s
- Return predefined or dynamic stubbed responses
- Assert request behavior without hitting the real network
- Keep your tests fast, isolated, and deterministic

---

## ✅ Features

- 🚫 **Never touches the real network**
- 🧪 **Spy** on requests (headers, body, URL, method)
- 🎭 **Stub** custom responses on a per-request basis
- 🧵 **Thread-safe** and safe for parallel test execution
- ☕ Built-in teapot response for fun (and HTTP 418 awareness)

---

## 🧩 Integration

`NetworkSpy` works with any network clients which are [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession)-based.

### 1. Inject `NetworkSpy.sessionConfiguration` into your networking stack or library.

**URLSession**

```swift
import Foundation

import NetworkSpyKit

let networkSpy = NetworkSpy(sessionConfiguration: .default)

let networkClient = URLSession(configuration: networkSpy.sessionConfiguration)
```

**[Alamofire](https://alamofire.github.io/Alamofire/)**

```swift
import Alamofire

import NetworkSpyKit

let networkSpy = NetworkSpy(sessionConfiguration: .af.default)

let networkClient = Alamofire.Session(configuration: sessionConfiguration)
```

**[OpenAPIURLSession](https://github.com/apple/swift-openapi-urlsession)**

```swift
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

import NetworkSpyKit

let networkSpy = NetworkSpy(sessionConfiguration: .default)

let session = URLSession(configuration: sessionConfiguration)
let configuration = URLSessionTransport.Configuration(session: session)

let networkClient = Client(serverURL: serverURL,
                           transport: URLSessionTransport(configuration: configuration))
```

### 2. Provide a `responseProvider` closure to determine what responses should be returned.

> ℹ️ `NetworkSpy`s default response is `418 I'm a teapot`

```swift
        networkSpy.responseProvider = { request in
            return StubbedResponse(statusCode: 200,
                                   data: "A pot of coffee".data(using: .utf8))
        }
```

### 3. Make your request through your network client

> Stubbed responses never touch the real network.
> All requests are intercepted at the protocol layer using a `URLProtocol` subclass under the hood.

---

## 🛠 Usage

### 1. Create a `NetworkSpy` instance

```swift
import NetworkSpyKit

struct MyNetworkingTest {

    private let networkSpy = NetworkSpy(sessionConfiguration: .default)
}
```

### 2. Specify a response

```swift
import NetworkSpyKit

struct MyNetworkingTest {

    private let networkSpy = NetworkSpy(sessionConfiguration: .default)
    
    func whenOrderingCoffee_itSendsACoffeeRequest() async throws {
        networkSpy.responseProvider = { request in
            return StubbedResponse(statusCode: 200,
                                   data: "A pot of coffee".data(using: .utf8))
        }
    }
}
```

### 3. Configure your `URLSession` based network client with `NetworkSpy`s `urlSessionConfiguration`

```swift
import NetworkSpyKit

struct MyNetworkingTest {

    private let networkSpy = NetworkSpy(sessionConfiguration: .default)
    
    func whenOrderingCoffee_itSendsACoffeeRequest() async throws {
        networkSpy.responseProvider = { request in
            return StubbedResponse(statusCode: 200,
                                   data: "A pot of coffee".data(using: .utf8))
        }
        
        let networkClient = makeNetworkClient(urlSessionConfiguration: networkSpy.sessionConfiguration)
    }
}
```

### 4. Send your request through your network client

```swift
import NetworkSpyKit

struct MyNetworkingTest {

    private let networkSpy = NetworkSpy(sessionConfiguration: .default)
    
    func whenOrderingCoffee_itSendsACoffeeRequest() async throws {
        networkSpy.responseProvider = { request in
            return StubbedResponse(statusCode: 200,
                                   data: "A pot of coffee".data(using: .utf8))
        }
        
        let networkClient = makeNetworkClient(urlSessionConfiguration: networkSpy.sessionConfiguration)
        
        try await networkClient.orderCoffee()
    }
}
```

### 5. Evaluate your expeced result

#### Inspecting the outgoing request

`NetworkSpy.recordedRequests` collects all send `URLRequest`, which we can inspect.

```swift
import NetworkSpyKit

struct MyNetworkingTest {

    private let networkSpy = NetworkSpy(sessionConfiguration: .default)
    
    func whenOrderingCoffee_itSendsACoffeeRequest() async throws {
        networkSpy.responseProvider = { request in
            return StubbedResponse(statusCode: 200,
                                   data: "A pot of coffee".data(using: .utf8))
        }
        
        let networkClient = makeNetworkClient(urlSessionConfiguration: networkSpy.sessionConfiguration)
        
        try await networkClient.orderCoffee()
        
        #expect(networkSpy.recordedRequests.first?.url?.path == "/api/coffee/order")
    }
}
```

#### Evaluate response based behavior of your system

In this example we expect that `orderCoffee()` transforms the network response into a `Beverage.aPotOfCoffee`.

```swift
import NetworkSpyKit

struct MyNetworkingTest {

    private let networkSpy = NetworkSpy(sessionConfiguration: .default)
    
    func whenOrderingCoffee_itSendsACoffeeRequest() async throws {
        networkSpy.responseProvider = { request in
            return StubbedResponse(statusCode: 200,
                                   data: "A pot of coffee".data(using: .utf8))
        }
        
        let networkClient = makeNetworkClient(urlSessionConfiguration: networkSpy.sessionConfiguration)
        
        
        let beverage = try await networkClient.orderCoffee()
        
        #expect(beverage == .aPotOfCoffee)
    }
}
```

---

## ☕ Teapot Response (Just for Fun)

`NetworkSpy`s default response is [`418 I'm a teapot`](https://en.wikipedia.org/wiki/Hyper_Text_Coffee_Pot_Control_Protocol)

```swift
let networkSpy = NetworkSpy()
networkSpy.responseProvider = { _ in .teaPot() }
```

Returns:

```text
418 I'm a teapot
Content-Type": "application/json"

{"error": "I'm a teapot"}
````

Because [Hyper Text Coffee Pot Control Protocol](https://en.wikipedia.org/wiki/Hyper_Text_Coffee_Pot_Control_Protocol) is real. Sort of.

---

## 🧵 Thread Safety
    
- `NetworkSpy` uses an internal serial queue to synchronize access.
- You can safely use multiple spies in parallel or across test targets.
- Isolated by using unique headers to associate intercepted requests with the correct `NetworkSpy` instance.

---

## 📦 Installation

**Swift Package Manager**

Add the following to your Package.swift:

```swift
.package(url: "https://github.com/yourusername/NetworkSpyKit.git", from: "1.0.0")
```

Then import it where needed:

```swift
import NetworkSpyKit
```

**CocoaPods**

Add the following line to your Podfile:

```ruby
pod 'NetworkSpyKit'
```

Then run:

```sh
pod install
```
---

## 📄 License

MIT License. See [LICENSE](LICENSE.md) for details.
