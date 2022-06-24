# TerraiOS

This framework allows developers to connect to Apple Health and Freestylelibre1 through Terra! It also contains all necessary class and functions to connect to Terra's REST API.

## Specification (Only read this section if something breaks)

This library supports only iOS 13+ and is implemented with Swift 5.0

## Setup (The useful stuff)

As said, this framework allows connection to Apple Health and FreeStyleLibre1 through Terra. To fully make use of this package, you will need a developer account enrolled in [Apple's developer program](https://developer.apple.com/programs/). 

The framework must be added as a dependency to your project. This can be done simply by editting your App's dependencies and adding `TerraiOS` as a dependency with the following location: `https://github.com/tryterra/TerraiOS.git`.
You will also need to add `TerraiOS` to Frameworks as well!

This will then allow you to import the framework as `import TerraiOS`.

### To connect to APPLE HEALTH

This library uses HealthKit for iOS v13+. It thus would not work on iPad or MacOS or any platform that does not support [Apple HealthKit](https://developer.apple.com/health-fitness/).
Please add HealthKit as a capability to the project as well as to Frameworks.

Also you must include the following keys in your `Info.plist` file:
`Privacy - Health Share Usage Description` and `Privacy - Health Records Usage Description`

### To connect to FREESTYLELIBRE 

This library will use "Near Field Communication Tag Reading" capability. Add this to your capabilities and add `Privacy-NFC Scan Usage Description` as a key to your project's `Info.plist`. 

### Scheduler 

To enable scheduler, you will have to follow the steps:
- Enable `Background Modes` in Signing & Capabilities. 
- Enable `Background Fetch` and `Background Processing` in Background Modes
- Add the `Permitted background task scheduler identifiers` key into your `info.plist` and add the following items under this key:
  - `co.tryterra.applehealth.dailyScheduler`
  - `co.tryterra.applehealth.nutritionScheduler`
  - `co.tryterra.applehealth.sleepScheduler`
  - `co.tryterra.applehealth.bodyScheduler`
- Finally, in your app delegate, you will have to instantiate the task handlers. Call the following lines under `application:willFinishLaunchingWithOptions` in your `AppDelegate.swift` file:
  - ```swift
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "co.tryterra.applehealth.bodyScheduler", using: DispatchQueue.global()) { task in
            appleHealthScheduler(task: task as! BGProcessingTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "co.tryterra.applehealth.dailyScheduler", using: DispatchQueue.global()) { task in
            appleHealthScheduler(task: task as! BGProcessingTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "co.tryterra.applehealth.sleepScheduler", using: DispatchQueue.global()) { task in
            appleHealthScheduler(task: task as! BGProcessingTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "co.tryterra.applehealth.nutritionScheduler", using: DispatchQueue.global()) { task in
            appleHealthScheduler(task: task as! BGProcessingTask)
        } 
  
  
## Time to have some fun ;)

To use this framework, you will need to be acquainted with a class called `Terra`. It will manage all your connections and data getting functionalities. 

You can create one as such:

```swift
let terra: Terra = try! Terra(devId: String,
                         // xAPIKey: String, // From 1.0.10 onwards, this is not needed.
                         referenceId: String?,
                         bodyTimer: Double, 
                         dailyTimer: Double
                         nutritionTimer: Double 
                         sleepTimer: Double)
```

**Please note this initialisation can fail by throwing the following errors: TerraError.HealthKitUnavailable, TerraError.UnexpectedError. Catch them and handle appropriately instead of forcing try!**

- devId : This is your dev_id given by Terra
- referenceId: This is used by you to identify a user from your server to a terra user
- bodyTimer: The body timer for scheduler in seconds
- dailyTimer: The daily timer for scheduler in seconds
- nutritionTimer: The nutrition timer for scheduler in seconds 
- sleepTimer: The sleep timer for scheduler in seconds

## Initialise Connections
After the initialisation of the Terra object, you can initialise connections as such:

```swift
initConnection(type: Connections, token: String, permissions: Set<Permissions>, customReadTypes: Set<HKObjectType>, writePermissions: Set<Permissions>, schedulerOn: Bool, completion: @escaping (Bool) -> Void))
```
**Arguments** 
- type: The connection you wish to initiate for
- token: A token used for authentication. Generate one here: https://docs.tryterra.co/reference/generate-authentication-token
- (Optional) permissions: A set of `Permissions` you wish to request permissions for. Enums: ACTIVITY, BODY, DAILY, SLEEP, ATHLETE, NUTRITION. Defaults to all.
- (Optional) customReadTypes: This is defaulted as an empty `Set`. If you want to make a more granular permissions request, you may import HeatlhKit and provide this argument with a Set of `HKObjectType`s. For example: `HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!`. 
- (Optional) writePermissions: A set of permissions to write to healthkit. **Currently takes only Nutrition**
- (Optional) schedulerOn: A boolean dictating if you wish to turn on the scheduler. Defaults to true. Please see **Scheduler** section for setup.
- (Optional **RECOMMENDED**) completion: A callback with a boolean dictating if the initialisation succeeds. 

**This will pull up any necessary Permissions logs!**

## Checking Authentication
You may now check if a user has authenticated with their device to a specific `Connection`:

```swift
terra.checkAuthentication(connection: Connections)
```
This would return a `Boolean` that signifies if the device is registered or not. 

`Connections` is an enum currently taking: `.APPLE_HEALTH` and `.FREESTYLE_LIBRE`

## Getting Data

Data will ideally be sent to your webhook by the scheduler (can only run whenever the app is open). 

However, you may also obtain data manually. 

### Body Data

```swift
terra.getBody(type: Connections, startDate: Date, endDate: Date)
```

### Activity Data

```swift
terra.getActivity(type: Connections, startDate: Date, endDate: Date)
```


### Daily Data

```swift
terra.getBody(type: Connections, startDate: Date, endDate: Date)
```


### Sleep Data

```swift
terra.getSleep(type: Connections, startDate: Date, endDate: Date)
```


### Nutrition Data

```swift
terra.getNutrition(type: Connections, startDate: Date, endDate: Date)
```

### Athlete Data

```swift
terra.getAthlete(type: Connections)
```

These functions that take `Date` as an argument, also takes `Time Interval` (Unix timestamp starting from 1st January 1970)

The data will always be sent to your webhook. However if you require the data on the spot, you may get it from the completion callback function as follows:

```swift
terra.getActivity(type: Connections, startDate: Date, endDate: Date){success, data in 
    //success -> A boolean to signify the function completed successfully
    // data -> A data array corresponding to our data models
}
```

### FreeStyleLibre Specifications

You will need to start a scan session for reading FreeStyleLibre1 Sensor data! This can be done by:

```swift
try! terra.readGlucoseData()
```

**N.B Be careful!** This function can throw a **TerraError.SensorExpired** error when attempting to read an expired sensor.

## Deauthorize

To deauthorize a user, all you have to do is run the following:

```swift
terra.disconnectTerra(Connections)
```

## Connect to Terra's Rest API within this SDK

You may if you wish make Terra API request using this SDK as well. 

You will simply need to instantiate a `TerraClient` class as follows:

```swift
let terra: TerraClient = TerraClient(user_id: <TERRA USER ID>, dev_id: <YOUR DEV ID>, xAPIKey: <YOUR X API KEY>)
```

Using this client, you may make requests to endpoints such as `/activity`, `/body`, etc. (More info [here](https://docs.tryterra.co/http-endpoints)).

To do this, you simply have to call:

```swift
terra.getDaily(startDate: Date, endDate: Date , toWebhook: true)!
```

`toWebhook` is default set to true.

Simiarly, you can get Activity, Body, and Sleep using `getActivity()`, `getBody()`, and `getSleep()` respectively. They all use the same arguments. 

You may also get Athlete data by `getAthlete(toWebhook: true)` where the date arguments are not needed.

These methods return a payload corresponding to our data models and HTTP responses. 
For example:

```swift
let activityData = terra.getActivity(startDate: startDate, endDate: endDate, toWebhook: false)!
```
These functions that take `Date` as an argument, also takes `Time Interval` (Unix timestamp starting from 1st January 1970)

In this case you can access the user data by accessing `activityData.user`, user_id by: `activityData.user.user_id` and the data array by `activityData.data`. This is similar to the structure returned by our [Payloads Models](https://docs.tryterra.co/data-models-mark-ii)

```json
{
    "status": "success",
    "type": "activity",
    "user": {
        "user_id": "b3a63gegd-ege1-42bf-a8ff-f6f1fege6e2a26",
        "provider": "GOOGLE",
        "last_webhook_update": "2022-01-12T08:00:00.036208+00:00"
    },
    "data": [...]
}
```

### Authenticate and Deauthenticate User without Widget

This package also embeds the `/authenticateUser` and `/deauthenticateUser` endpoint.

This can be called by using the `TerraAuthClient` class:

```swift 
let terraAuthClient: TerraAuthClient = TerraAuthClient(dev_id: DEVID, xAPIKey: XAPIKEY)
```

And then you can generate an authentication url (code uses FITBIT as an example) by running:

```swift
terraAuthClient.authenticateUser(resource: "FITBIT")
```

You can then deauthenticate a user by:

```swift
terraAuthClient.deauthenticateUser(user_id: "USER_ID")

```



