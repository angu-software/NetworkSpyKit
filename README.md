# 🕵 NetworkSpyKit

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

## 🛠 Usage
**TODO: generic example from the test cases**

```swift
import NetworkSpyKit

let spy = NetworkSpy(sessionConfiguration: .default) { request in
    return .success(statusCode: 200,
                    bodyData: #"{"message":"Hello"}"#.data(using: .utf8))
}

let modelController = makeModelController(sessionConfiguration: spy.sessionConfiguration)

// trigger network call
try await modelController.fetchSomething()

XCTAssertEqual(spy.recordedRequests.first?.url.path, "/something")
```

## 🧩 Integration

TODO: link to Apple docs of URLSessionConfiguration
**With any `URLSessionConfiguration`-based library**

1.	Inject `spy.sessionConfiguration` into your networking stack or library.
2.	Provide a `responseProvider` closure to determine what responses should be returned.

> Stubbed responses never touch the real network.
> All requests are intercepted at the protocol layer using a URLProtocol subclass under the hood.

---

## 🧵 Thread Safety
	
- `NetworkSpy` uses an internal serial queue to synchronize access.
- You can safely use multiple spies in parallel or across test targets.
- Isolated by using unique headers to associate intercepted requests with the correct `NetworkSpy` instance.

## ☕ Teapot Response (Just for Fun)

```swift
let spy = NetworkSpy()
spy.responseProvider = { _ in .teaPot() }
```

Returns:

**TODO: better layout for response**

```text
Status code: 418
Headers: [:]
Body: { "ERROR": "I'm a teapot" }
````

Because [Hyper Text Coffee Pot Control Protocol](https://en.wikipedia.org/wiki/Hyper_Text_Coffee_Pot_Control_Protocol) is real. Sort of.

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

---

## 📄 License

MIT License. See [LICENSE](LICENSE.md) for details.
