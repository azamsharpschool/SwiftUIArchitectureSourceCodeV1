
# SwiftUI Architecture — Source Code

This repository contains the complete source code for the book:

## 📘 SwiftUI Architecture

**Patterns and Practices for Building Scalable Applications**


## 🚀 About the Book

SwiftUI is simple… until your app grows.

What starts as clean and declarative quickly turns into scattered state, tightly coupled views, and logic that becomes harder to reason about.

This book shows you how to build SwiftUI applications that remain simple — even as they scale.

Instead of layering unnecessary abstractions, you will learn how to align your architecture with how SwiftUI actually works.



## 📥 Get the Book

👉 **eBook (Best Option)**
[https://azamsharp.school/swiftui-architecture-book.html](https://azamsharp.school/swiftui-architecture-book.html)

👉 **Amazon Paperback**
[https://www.amazon.com/dp/B0GTBJ3YQ2](https://www.amazon.com/dp/B0GTBJ3YQ2)



Each folder contains the code for that specific chapter so you can follow along easily.



## 🧠 What You’ll Learn

* Structure SwiftUI apps using container and presenter patterns
* Manage state using scalable observable stores
* Avoid overengineering and unnecessary abstractions
* Build production-ready SwiftUI applications
* Keep your code simple, readable, and maintainable



## ⚙️ Requirements

* Xcode 15 or later
* iOS 17 or later
* Swift 5.9+



## ▶️ Getting Started

1. Clone the repository
2. Open the desired chapter folder
3. Open the Xcode project
4. Run the app


## 💡 Notes

* Each chapter is independent
* Some chapters build on previous concepts
* Check comments inside code for explanations



## 🛠 Errata

Mistakes happen. This section tracks corrections and clarifications.

### Budget Name Predicate

In an earlier version, the following was used:

```swift
budget.name.localizedStandardContains(name)
```

This performs a **partial match** and is not suitable for validation or uniqueness checks.

It has been updated to:

```swift
let predicate = #Predicate<Budget> { budget in
    budget.name == name
}
```

Use `localizedStandardContains` for search.
Use `==` when you need exact matching.



## ⭐ Support

If you find this repository helpful:

👉 Star the repo
👉 Share it with other developers



## 👨‍💻 About the Author

Mohammad Azam is a software developer, educator, and creator of AzamSharp School.

He has taught thousands of developers around the world and focuses on helping engineers build real-world applications using Swift and SwiftUI.



## 🌐 Learn More

[https://azamsharp.com](https://azamsharp.com)

