# TestiOS

A skeleton that that I use to test out cool libraries that I come across and test out some concepts.

Note that almost everything in the app is a work-in-progress, incomplete and probably messy at times! This is just for testing things out that would otherwise take longer in larger main products.

## Development

1. Clone the library and install the pods using `pod install`
2. Add/remove features you would like to test in HomeViewController

## Features

This is the current list of 'features' that I have built while testing things out

##### Skeleton View

This screen is just a simple test of using [SkeletonView](https://cocoapods.org/pods/SkeletonView) to create a placeholder while information loads.

##### Table selection

Table view with color selection, I made this to test some issues I was having with table view selections.

##### Activity

Used to test adding custom actions to the system share dialog (UIActivityViewController) and actions that can be performed with sharing content.

##### Chat and mentions

Used to test a mockup of a basic chat interface with the ability to mention participants. The messages are stored locally in Realm and served via a notification listening service on the Realm database. So once objects are added to Realm the will display. Mentions aren't currently saved and just served as text. Sent messages alternate between sender/received for now.

##### Images

Used to test the library [Nuke](https://cocoapods.org/pods/Nuke) for loading and displaying remote images

##### Diffable data source

Test using a DiffableDataSource when iOS 13 was released.

### Included libaries:

- PureLayout
- Reusable
- Eureka
- NotificationBannerSwift
- AttributedStringBuilder
- SkeletonView
- RealmSwift
- R.swift
- Aardvark
- SwiftyBeaver

(Note: Not all libraries are currently in use - but are available when needed)
