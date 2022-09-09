# ShakeSearch 2.0
## Whats New
Hello, this is the new Shake Search portal: https://shake-search-gui.herokuapp.com/#/
The new version includes:
- Redesigned ui, a little bit more friendly
- Better formatting of results found
- Highlight of the searched word in the results
- Allow case insensitive search
- Bug fixes when searching for words in a particular case

## Dev decisions
About the frontend
- Decided to go with a flutter web version for the front end because of my previous experiences using it and the many benefits that the flutter framework provides.
- Inside the project, I created a clean architecture lean version, separating the responsibilities of presentation, domain and data for better testability and maintainability.
- On the domain layer, wrote only two use cases with basic business rules, one to execute the search on the data repository and the other to highlight the word searched in the results
- On the data layer, I created a network datasource and a local datasource for easier tests purposes, but in the built application only the network datasource is being used.
- On the presentation layer, I used Bloc for state management, and native widgets of flutter for building the ui.

About the backend
- I fixed one bug that could ocurr of array out of bound when trying to slice the complete work from a word in the beginning or final of the text
- Add support for case insensitive by lowering the case in the suffix array and query text


If I had more time
- I Would add tests for the backend service layer.
- Improve error handling in the frontend and backend application, from the user and dev perspective.
- Improve deployment of both applications using ci/cd pipelines
- Test the application with real users and see what I've missed and the next steps

## Running locally
Flutter:
- inside shake_search_web
- get dependencies: flutter pub get
- run locally: flutter run lib/main.dart

Web:
- go build -o bin
- heroku local web -p 5000


---
# ShakeSearch 1.0

Welcome to the Pulley Shakesearch Take-home Challenge! In this repository,
you'll find a simple web app that allows a user to search for a text string in
the complete works of Shakespeare.

You can see a live version of the app at
https://pulley-shakesearch.herokuapp.com/. Try searching for "Hamlet" to display
a set of results.

In it's current state, however, the app is in rough shape. The search is
case sensitive, the results are difficult to read, and the search is limited to
exact matches.

## Your Mission

Improve the app! Think about the problem from the **user's perspective**
and prioritize your changes according to what you think is most useful.

You can approach this with a back-end, front-end, or full-stack focus.

## Evaluation

We will be primarily evaluating based on how well the search works for users. A search result with a lot of features (i.e. multi-words and mis-spellings handled), but with results that are hard to read would not be a strong submission.

## Submission

1. Fork this repository and send us a link to your fork after pushing your changes.
2. Heroku hosting - The project includes a Heroku Procfile and, in its
   current state, can be deployed easily on Heroku's free tier.
3. In your submission, share with us what changes you made and how you would prioritize changes if you had more time.
