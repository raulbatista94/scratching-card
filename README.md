# Scratching Card iOS project
Small project where the user has a coupon card. Has to navigate to scractch screen where using the drag gesture may scratch the card to obtain his coupon.
On the next activation screen he send this code to the Backend, which consumes the code and returns validation info.


## Technologies used: 
- UI built completely in SwiftUI
- Combine for handling events
- Networking in Async Await

### Things to improve:
- Current state of DI is very primitive and definitely should be improved by using some 3rd part solution such as Swinject or something similar
- The way how we detect the scratched area is really primitive and should be definitely improved (or maybe even a 3rd party solution could be used if there is any)
- There is only 1 unit test, more tests to cover other parts of the app should be added. Eventually some UI tests as well.




