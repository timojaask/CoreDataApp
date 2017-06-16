# CoreDataApp

### Usage:
Run `pod install` and open `CoreDataApp.xcworkspace`. Tested with **Xcode 8.3**.

*The project hasn't been migrated to Xcode 9 beta / Swift 4, so it will likely not work there. Use Xcode 8.3.*

### What's used here:

- Adopted master-detail template from Apple, with parts of code replaced or removed entirely. Works okay for this simple scenario, but would not necessarily use it in a real-world project — it depends.

- Wrapped the default CoreData stack into Sync, because it takes care of most of the boilerplate code for adding, deleting, merging and fetching data. It also adds JSON parsing functionality on top of it.

- Used Kingfisher for fetching and caching images. It's a battle-tested library that significantly reduces boilerplate code and handles a lot of edge cases well.

- Used FZAccordionTableView for collapsing albums. The library seems to have some bugs, so I'm not very happy with it, but I was able to work around them. Would probably write my own implementation in a real world project.

### What can be improved:

- With this small codebase, the code is okay as is, but if the app would grow any bigger, some of the logic could be taken out of the view controllers and divided into different responsibilities, to improve testability and maintainability.

- Perhaps consider alternative data flow approaches, for which a good candidate can be Redux-inspired unidirectional data flow library ReSwift. Depending on the needs and skill level of the rest of the team, could get rid of xibs and use reactive functional programming frameworks, such as RxSwift or RAC and do the layout using libraries such as Cartography/SnapKit/PureLayout.

- A promise based or RFP-style programming would make the networking code (BackendApi.swift) a lot simpler and more readable. Even without the use of external libraries, the code could have some refactoring that would make it more declarative.

- Decoupling of CoreData from the rest of the app would make it easier to migrate to a different framework, such as Realm if so desired. Perhaps even more importantly, it would allow writing cleaner tests.

- Add unit and integration tests that would run as a part of continuous integration. It would help when adding new functionality, fixing bugs or refactoring. And prevents developer burnouts :)

- Performance optimizations for merging a lot of items into Core Data. I didn’t have a chance to test the app on a physical device, but I’d suspect this could turn out to be a real bottleneck.

- Add error handling and retry logic – indication of when things go wrong, such as connection error, bad network connectivity, an unexpected response from the server or parsing errors. And retry mechanisms for when things go wrong, so the user wouldn’t have to close and open the app to try again.