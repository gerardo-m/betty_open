# Change Log

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.0] - 2022-12-31

### Added

- Tie breakers for single match predictions
- Now you can delete saved event and items

### Changed

- After accepting an invitation it redirects to the edit predictions screen
- After publishing an event it redirects to the published event screen
- Finished events now have a separate screen and the regular events screen now only shows active events
- Add limits to item count in events and participants in published events
- CreatedAt and UpdatedAt dates are now saved for events

## [0.5.2] - 2022-12-04

### Fixed

- Fixed not showing correctly a prediction after it was sent.

## [0.5.1] - 2022-12-01

### Changed

- Updated dependencies

### Fixed

- Participants can't be invited twice

## [0.5.0] - 2022-11-30

### Added

- Splash screen

### Changed

- Initialization now generates the username the first time you open the app
- Now the app start while the dependencies are loading. Should reduce start time

### Fixed

- Crashes when loading ads. I hope

## [0.4.1] - 2022-11-29

### Added

- Notifications

## [0.4.0] - 2022-11-28

### Added

- Positions table to event types

### Changed

- Event item type is now shown in event item widget

### Fixed

- Event results being overwritten after changing event status to finished

## [0.3.0] - 2022-11-24

### Added

- Google authentication

### Fixed

- Not accepted participants showing in ranking calculation
- Publish button being enabled before saving an event
- Home screen buttons looking normal when disabled

## [0.2.0] - 2022-11-21

### Added

- Added coming soon screen to hide incomplete functions
- Personalized theme and images
- Interstitial ads when publishing events, finishing events and sending predictions
- About us dialog

### Changed

- Created a new theme
- Now you have to save before sending an event

### Fixed

- Event results not being updated in the Event collection
- Participants not reloading in the published event screen
- My prediction not being retrieved from the remote repository (local was fine)

## [0.1.2] - 2022-11-14

### Added

- Added crashlytics support

### Fixed

- Solved profile being created with blank values

## [0.1.1] - 2022-11-13

### Fixed

- Config problems with firebase

## [0.1.0] - 2022-11-13

### Added

- Outlined main screen
- Outlined events screen
- Outlined predictions screen
- Outlined groups screen
- Outlined profile screen
- Events management, saving and publishing
- Add participants to events
- Make predictions, saving and sending
- Calculate participants points and ranking

### Changed

- N/A

### Fixed

- N/A

