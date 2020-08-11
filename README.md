# MTLight

A lightweight personal finance app built with RxSwift and MVVM architecture. Currently, the account and transaction data are loaded from local JSON files.

## Architecture

#### Layered architecture

- This app uses the layered architecture pattern. A clear separation of concerns between different layers makes an app easier to maitain and extend.
- In the future, if we want to update the app to fetch data from a server, we simply need to update the implementation details for the service layer.

#### MVVM

- The presentation layer is implemented using the MVVM (Model-View-ViewModel) pattern.
- MVVM increases testability since the business logic is decoupled from the view.

## Third Party Libraries

####  RxSwift

- [RxSwift](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Why.md) does a great job of simplifying asynchronous logic through declarative code.
- MVVM (Model-View-ViewModel) architecture and RxSwift play together nicely. RxSwift makes it really simple to bind the data to the view.

#### SwiftGen

- [SwiftGen](https://github.com/SwiftGen/SwiftGen) automatically generates Swift code for resources (i.e. images, localized strings), to make them type-safe to use. No more typos!

## Next Steps

- Display a placeholder view when there are no transactions associated with an account
- Display an activity indicator while loading data
- Make tests more robust (i.e. add more variants for success cases, add error cases)
