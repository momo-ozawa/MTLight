# MTLight

A lightweight personal finance app built with RxSwift and MVVM architecture. Currently, all account and transaction data are loaded from local JSON files.

## Notes

### Why RxSwift + MVVM?

- [RxSwift](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Why.md) does a great job of simplifying asynchronous logic through declarative code
- MVVM (Model-View-ViewModel) architecture and RxSwift play together nicely; RxSwift makes it really simple to bind the data to the view 
- MVVM increases testability since there's a clear separation between the view logic and the business logic

### Protocol extensions

- I used protocol extensions to DRY up code by defining default behavior in the protocol themselves, instead of in the individual types 
- For example, ViewControllers conforming to the `AlertDisplayable` protocol are provided with a "free" implementation of `-showErrorAlert:`

## Next Steps

- Display a placeholder view when there are no transactions associated with an account
- Display an activity indicator while loading data
- Make tests more robust (i.e. add more variants for success cases, add error cases)

