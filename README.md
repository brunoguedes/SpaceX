# Sample project to demonstrate the use of FlowCoordinator + MVVM + Rx

## Project Details

This project uses a FlowCoordinator to manage navigation. This class is responsible to instantiate the main `UINavigationController` and push `ViewControllers` in the correct order.

Each `ViewController` is responsible for fetching data, creating a `ViewModel` and binding to the `Views` to present.

To fetch data, the `ViewControllers` use the `SpaceXService`. This class has methods to return `Observable<ModelType>` for each api call the app consumes.
[API reference](https://docs.spacexdata.com/?version=latest)

To make the code testable, `SpaceXService` can be instanciated with a `MockBaseService` that conforms to the `BaseServiceProtocol`. (Dependency Injection via Constructor)

The unit tests use mock data extracted from the SpaceX APIs.

* iOS Deployment Target = 13.1
* Works with dark mode
* Tested using iPhone6s, iPhone 11, iPhone Pro Max
* No 3rd party libraries were use apart from Rx ones

## ViewControllers

### `LaunchesViewController`

Display a list of launches basic information retrieved from the `All Launches` endpoint. The list is sorted by date or mission name and is grouped in sections. Users can filter only successful missions.  

### `MissionDetailsViewController`

Display more detailed information about the launch and the rocket. Retrives information from the `One Launch` and the `One Rocket` endpoints. Since `One Rocket` receives a `rocket_id` as input and it comes from the response of the `One Launch` call. In the `SpaceXService`, I've implemented the `getLaunchAndRocketDetails` method which performs both calls in the right order and produces a `(LaunchDetails, RocketDetails)` output.

The current implementation outputs an error if any of the calls fail. As an improvement, would be nice to only output an error if the first call fails and produce something like  `(LaunchDetails, RocketDetails?)` instead.

### `WebPageViewController`

Present the Wikipedia page about the rocket.

## ViewModels

### `LaunchesViewModel`

Combine the latest launches (model) retrieved from SpaceX API, with the filter and sorting parameters to produce a `Observable` sequence. I'm using `RxDataSources` so I can easily bind to the `UITableView`.

###  `LaunchViewModel`

`LaunchTableViewCell` ViewModel

### `MissionDetailsViewModel`

`MissionDetailsViewController` ViewModel
