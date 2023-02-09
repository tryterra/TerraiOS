# TerraiOS

This framework allows you to any integration offered by [Terra](https://tryterra.co)

The docs here are updated to latest version: 1.3.+

For older docs and version please see [here](https://github.com/tryterra/TerraiOS/blob/52d1f4b442473bbe41f74940a366558a421bbe02/README.md)

## Specification (Only read this section if something breaks)

This library supports only iOS 13+ and is implemented with Swift 5.7

## Setup (The useful stuff)

This framework can be divided into two parts. 
- Connection to in-app providers: APPLE HEALTH and FREESTYLELIBRE
- Connection to the REST API

To fully make use of this package, you will need a developer account enrolled in [Apple's developer program](https://developer.apple.com/programs/). 

The framework must be added as a dependency to your project. This can be done simply by editting your App's dependencies and adding `TerraiOS` as a dependency with the following location: `https://github.com/tryterra/TerraiOS.git`.
You will also need to add `TerraiOS` to Frameworks as well!

This will then allow you to import the framework as `import TerraiOS`.

### For APPLE HEALTH

This library uses HealthKit for iOS v13+. It thus would not work on iPad or MacOS or any platform that does not support [Apple HealthKit](https://developer.apple.com/health-fitness/).
Please add HealthKit as a capability to the project as well as to Frameworks.

Also you must include the following keys in your `Info.plist` file:
`Privacy - Health Share Usage Description` and `Privacy - Health Records Usage Description`

### For FREESTYLELIBRE 

This library will use "Near Field Communication Tag Reading" capability. Add this to your capabilities and add `Privacy-NFC Scan Usage Description` as a key to your project's `Info.plist`. 

To use a custom message, add a String field `Terra - NFC Scan Request 
Message` to your `Info.plist`

### Background Delivery

The framework automatically assumes you want to use Background Delivery if you initialise a connection for Apple Health. 

To enable this, you will need to enable a few things:

- Enable Background Delivery in HealthKit Entitlements
- Add Background Modes as a Capability to your project and enable Background Fetch and Background Processing
- Add the `Permitted background task scheduler identifiers` key to your `info.plist` with one item:
  - `co.tryterra.data.post.request`
  
After this, you will have to simply run:
```swift
Terra.setUpBackgroundDelivery()
```
in your app delegate's `didFinishLaunchingWithOptions` delegate function, i.e:

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Terra.setUpBackgroundDelivery()
        // Override point for customization after application launch.
        return true
    }
```
Thats it!

  
## Time to have some fun ;)

To use this framework for Apple Health and Freestylelibre, you will need to be acquainted with a class called `TerraManager`. It will manage all your connections and data getting functionalities. 

You can create one as such:

```swift
Terra.instance(devId: String, referenceId: String?, completion: @escaping (TerraManager?, TerraError?) -> Void)
```

- `devId: String` ➡ The developer identifier given to your after you signed up on [Terra](https://dashboard.tryterra.co)
- `referenceId: String?` ➡ This is used by you to identify a user from your server to a terra user
- `completion: @escaping (TerraManager?, TerraError?) -> Void` ➡ A callback function that is called when the TerraManager class is initialised. If an error has occurred in creation, then the completion will return a TerraError class. **Highly recommended to wait for this callback before proceeding**

**You will need to initialise this class everytime your app comes up from terminated or stopped state. It sets up all the previous connections that has been initialised**

## Initialise Connections
After the initialisation of the Terra object, you will need to initialise a connection to the provider you want. This only needs to be done once per connection.

```swift
initConnection(type: Connections, token: String, customReadTypes: Set<HKObjectType>, schedulerOn: Bool, completion: @escaping (Bool, TerraError?) -> Void))
```
**Arguments** 
- `type: Connections` ➡  An ENUM from the Connections class signifying the connection you wish to initiate for.
- `token: String` ➡ A token used for authentication. Generate one here: https://docs.tryterra.co/reference/generate-authentication-token
- (Optional) `customReadTypes: Set<CustomPermissions>` ➡ This is defaulted as an empty `Set`. If you want to make a more granular permissions request, you may send us a set of `CustomPermissions`: An enum provided so you do not need to interact with HealthKit. 
- `schedulerOn: Bool`  ➡ A boolean dictating if you wish turn on background delivery. Defaults to true. Please see **Background Delivery** section for setup.
- `completion: @escaping (Bool, TerraError?) -> Void`  ➡ A callback with a boolean dictating if the initialisation succeeds. 

**This will pull up any necessary Permissions logs!**

## Checking Authentication
You may now check if a user has authenticated with their device to a specific `Connection`:

```swift
Terra.checkAuthentication(connection: Connections, devId: String, completion: @escaping(Bool) -> Void)
```
When the function's completion function is called, the `Bool` argument signifies if the connection is authenticated or not. 
**Function not necessary! Mainly for debug purposes**

A more useful function for this purpose would be:

```swift
terra.getUserid(type: Connections) -> String?
```
This function is synchronous and returns the `user_id` right away or `nil` if none exists.

The framework allows you to disconnect users using our [`deauthenticateUser`](https://docs.tryterra.co/reference/deauthenticate-user) endpoint. However we recommend doing this request from the backend as the API Key is required here. Please only use this for testing purposes.

```swift
Terra.disconnectTerra(devId: String, xAPIKey: String, userId: String)
```

## Subscriptions (new in 1.2.0)

We have removed the need for callbacks in the getter functions. They were slow, hard to maintain, and wasteful (as most of the data is not processed in the frontend). Instead, we replace it with a subscription system. 

After you have confirmed a connection with Apple Health, you can pass us an update handler ideally in your app delegate's `didFinishLaunchingWithOptions` function, so it is set everytime the app launches. This can be done as such:

```swift
Terra.updateHandler = {type: DataTypes, update: Update -> Void in 
  // process updates in here
} 
```

In this case, `DataTypes` are the datatypes you have subscribed to, and `Update` is a data model in this form:

```swift
public struct Update: Codable{
    public var lastUpdated: Date?
    public var samples: [TerraData]
}

public struct TerraData: Codable{
    public let value: Double
    public let timestamp: Date
}
```

You can subscribe for datatypes as follows (only needs to be done once):

```swift
func subscribe(forDataTypes dataTypes: Set<DataTypes>, completion: @escaping(Bool, TerraError?) -> Void)
```

DataTypes can be:
STEPS
HEART_RATE
HEART_RATE_VARIABILITY
CALORIES
DISTANCE

After the call, your update handler will be called with the corresponding datatypes whenever new ones are available. This includes the next time you open your app. 

Scenario: You subscribed for steps data. You close your app and do not go back for 5 days. The next time you open it, your update handler will be called with all 5 days worth of steps, without you needing to query for it and would execute a lot faster as it is only steps. 

## Getting Data

Data will ideally be sent to your webhook by the scheduler (can only run whenever the app is open). 

However, you may also obtain data manually. 

### Body Data

```swift
getBody(type: Connections, startDate: Date, endDate: Date, toWebhook: Bool, completion: @escaping (Bool, TerraBodyDataPayloadModel?, TerraError?) -> Void)
```

### Activity Data

```swift
getActivity(type: Connections, startDate: Date, endDate: Date, toWebhook: Bool, completion: @escaping (Bool, TerraActivityDataPayloadModel?, TerraError?) -> Void)
```


### Daily Data

```swift
getDaily(type: Connections, startDate: Date, endDate: Date, toWebhook: Bool, completion: @escaping (Bool, TerraDailyDataPayloadModel?, TerraError?) -> Void)
```


### Sleep Data

```swift
getSleep(type: Connections, startDate: Date, endDate: Date, toWebhook: Bool, completion: @escaping (Bool, TerraSleepDataPayloadModel?, TerraError?) -> Void)
```


### Nutrition Data

```swift
getNutrition(type: Connections, startDate: Date, endDate: Date, toWebhook: Bool, completion: @escaping (Bool, TerraNutritionDataPayloadModel?, TerraError?) -> Void)
```

### Menstruation Data

```swift
getMenstruation(type: Connections, startDate: Date, endDate: Date, toWebhook: Bool, completion: @escaping (Bool, TerraMenstruationDataPayloadModel?, TerraError?) -> Void)
```

### Athlete Data

```swift
terra.getAthlete(type: Connections, toWebhook: Bool, completion: @escaping (Bool, TerraAthleteDataPayloadModel?, TerraError?) -> Void)
```

These functions that take `Date` as an argument, also takes `Time Interval` (Unix timestamp starting from 1st January 1970)

The completion will be called with 3 arguments:
- Bool -> If the request was successful or not. If not, a TerraError instance will also be called
- TerreDataPayload -> A payload for each data type. If `toWebhook` is set to true, this returns a class with a property `reference` referring to the payload reference sent to your webhook. If `toWebhook` is set to false, then this returns the entire Terra normalised payload. 

## Post data

We also provide functions to post data to Apple Health Kit. Currently the following is implemented:

### Nutrition

```swift
terra.postNutrition(type: Connections, payload: TerraNutritionData, completion: @escaping (Bool) -> Void)
```

**N.B** `TerraNutritionData` has a public constructor!

### Body

```swift
terra.postBody(type: Connections, payload: TerraBodyData, completion: @escaping (Bool) -> Void)
```

**N.B** `TerraBodyData` has a public constructor!

### FreeStyleLibre Specifications

You can activate a sensor using

```swift
terra.activateSensor(completion: @escaping (Bool) -> Void)
```

For reading a sensor you may use:

```swift
readGlucoseData(completion: @escaping (FSLSensorDetails) -> Void)
```

`FSLSensorDetails` is a data struct for the data returned by the sensor. It follows the following format:

```swift
public struct FSLSensorDetails: Codable{
    public var sensor_state: String
    public var status: String
    public var serial_number: String = String()
    public var data: TerraGlucoseData = TerraGlucoseData()
}
```

`TerraGlucoseData` follows the same structure as shown in our [glucose data field from our models](https://docs.tryterra.co/reference/v2#body)


## Connect to Terra's Rest API within this SDK

You may if you wish make Terra API request using this SDK as well. 

You will simply need to instantiate a `TerraClient` class as follows:

```swift
let terra: TerraClient = TerraClient(user_id: <TERRA USER ID>, dev_id: <YOUR DEV ID>, xAPIKey: <YOUR X API KEY>)
```

Using this client, you may make requests to endpoints such as `/activity`, `/body`, etc. (More info [here](https://docs.tryterra.co/reference/http-requests)).

To do this, you simply have to call:

```swift
terra.getDaily(startDate: Date, endDate: Date, toWebhook: Bool = true, completion: @escaping(TerraDailyDataPayloadModel) -> Void)
```

`toWebhook` is default set to true.

Simiarly, you can get Activity, Body, and Sleep using `getActivity()`, `getBody()`, and `getSleep()` respectively. They all use the same arguments. 

You may also get Athlete data by `getAthlete(toWebhook: Bool, completion: @escaping(TerraAthleteDataPayloadModel) -> Void)` where the date arguments are not needed.

These functions that take `Date` as an argument, also takes `Time Interval` (Unix timestamp starting from 1st January 1970)

Each function has a completion callback with the models built in!

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

And then you can generate an authentication url (code uses FITBIT as an example) by running:

```swift
terraClient.authenticateUser(resource: Resource, completion: @escaping (AuthenticateUserPayload) -> Void)
```

You can then deauthenticate a user by:

```swift
terraClient.deauthenticateUser(forUser userId: String, completion: @escaping (DeauthenticateUserPayload) -> Void)

```
