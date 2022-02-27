# MarvelCharacters
This project contains an iOS app that displays a list of Marvel characters, as well as a detail page for each and every one of them.

This app is comprised of the following views:

- A list of Marvel characters through which the user can reach their respective details. The user is told they can do that via a detail disclosure button (info bubble). The user can pull to refresh the data, which is paginated in chunks of 20 results. When the focus reaches the bottom of the list, new results are displayed.

<img src="https://user-images.githubusercontent.com/26648516/155891946-061cda2c-9413-4168-a5ef-00d5f22f5b54.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/155891974-e6f9b0f2-4cbc-4f97-875d-84b86615ab4c.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/155891976-3aedd9c1-4199-49e7-b061-d2fe37eb7d89.png" width="400"/>

- A detail view to show a character's detailed info. As well as showing its name, description and thumbnail, the detail view also displays the series and comics they've taken part in. Furthermore, the user can also share the character thumbnail and go to the links provided by the Marvel API (i.e., wiki, detail and comic links). 

<img src="https://user-images.githubusercontent.com/26648516/155892251-368876cb-b173-42ee-95a5-656aecd142c1.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/155892257-63daa3fb-9c10-48ce-991d-362a2cb0fd83.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/155892260-080606a3-d3c3-4829-be38-12f2b3d735c7.png" width="400"/>


## Architecture

The design pattern used to develop this app was MVP (Model-View-Presenter). In terms of model, only `MarvelCharacter` was needed. When it comes to presenter and views, two tuples were used: one for the list view and the other for the detail one.

## Testing

Both UI and unit tests were implemented. The following is a screenshot showing how they passed, demonstrating that the app meets the minimum quality standards.

<img src="https://user-images.githubusercontent.com/26648516/155892623-d6f23404-1e6d-4741-ab1c-3e13d512b688.png" width="300"/>

In the case of the unit tests, a couple of them were created to ascertain the right methods were called on the view whenever the presenter was able to provide a list of characters or an error. As for the UI tests, it was tested that the first two characters (it could be any other two) didn't share the same name (it shouldn't happen) and that a character's name is the same in the list and in the detail.

## Nice touches

An app icon was created, as well as a custom launch screen. On top of that, `Mukta Medium` was imported to be used as a the default font across the app.
