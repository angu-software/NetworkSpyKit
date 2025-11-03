Pod::Spec.new do |s|
  s.name             = 'NetworkSpyKit'
  s.version          = '1.1.0'
  s.summary          = 'A lightweight, thread-safe HTTP spy and stub tool for testing code that performs network requests in Swift.'

  s.description      = <<-DESC
`NetworkSpyKit` is a lightweight, thread-safe HTTP spy and stub tool for testing code that performs network requests in Swift.

It allows you to:
- Record outgoing `URLRequest`s
- Return predefined or dynamic stubbed responses
- Assert request behavior without hitting the real network
- Keep your tests fast, isolated, and deterministic
DESC

  s.homepage         = 'https://github.com/angu-software/NetworkSpyKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'angu-software'
  s.source           = { :git => 'https://github.com/angu-software/NetworkSpyKit.git', :tag => s.version.to_s }

  s.swift_version    = '6.1'
  s.platform     = :ios, '13.0'
  s.platform     = :osx, '10.15'

  s.source_files = 'Sources/NetworkSpyKit/**/*.swift'
end
