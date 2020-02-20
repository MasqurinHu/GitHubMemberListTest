# Github member list

* create for **xcode 10.3**
* Development environment **Xcode 11.3.1** and above
* Development language **Swift 5.2** 
* support **iOS 12.4 and above** 

## Project Architecture: MVVM-C

* M: Model, data layer, network connection layer
* V: View presents data or returns user click event
* VM: ViewModel contains the calculation logic for presenting data on the screen. Any interaction triggered from the View is delegated to the Interactor or Coordinator depending on the type of interaction.
* C: Coordinator is mainly responsible for navigation between pictures. With a simple interface you can navigate from one screen to another. When leading to a different Coordinator, it will prepare all required objects for the new process and initialize it (including ViewController, ViewModel, Interactor, and a new Coordinator).
* [APPCODA-Introduction to MVVMC] (https://www.appcoda.com.tw/mvvmc-explained/).
* [Nelson talks about iOS architecture] (https://chiahsien.github.io/post/common-ios-architecture-from-mvc-to-viper-with-redux/).

-
### Package management tool: [Swift Packge Manager] (https://swift.org/package-manager/)
##### SPM related files are not included in Git
### Using the kit

1. [ILottie] (https://github.com/airbnb/lottie-ios)

Quick and easy to use animation processing suite, thanks to Airbnb

## Note

Why can I For the whole work, the most time-consuming is the use of code layout. Usually in a formal project, most of the layout will use storyboard or xib to accelerate development, except for some interactive special effects that require code.

Why do I use MVVM-C? It is a product of continuous code refactoring, which greatly reduces the burden on viewController. The extra C is a router concept. View and viewController are simply responders, responsible for drawing and receiving events. After acceptance, it is up to the viewModel to decide how to handle it and affect the display of the view at the same time. As for the navigation to another location after the event is over, it will be handled by the coordinator, so in subsequent modifications,
Where the screen logic is modified, there will be no business logic and navigation code, which avoids other problems caused by the modification.

What is the difference between mvvm-c and viper? For me, it is a lightweight viper with similar functions. Do n’t add things you do n’t need. When everything is used, the only difference from viper is the name. .