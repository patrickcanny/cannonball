[![cannonball](cannonball.png)](https://devpost.com/software/cannonball-k2q1vj)

Cannonball is a Location-based check-in application that can automatically export event attendees to a Slack Team. 

## Inspiration
The idea behind our mobile application is to create the easiest platform for taking class or student organization attendance. Users can see events that are occuring in their area, and check in to those events easily. After the meeting is over, the organizer can send out an invitation to attendees, asking them to join a Slack channel.

As organizers of club meetings and the like, we are always looking for easy ways to easily track attendance at our meetings, as well as a low stress way of adding them to our communication channels. This app was our proposed solution!

## Challenges
We came into this hackathon knowing that we wanted to rey and build a mobile application, but none of us had any experience in developing a great mobile application. Thus, we had to take some time to research some of our options and determine the best tools to use. We landed on Flutter since it looked like a pretty progressive framework, and we had thought it looked pretty interesting. That being said, learning a new development tool meant that we had a tougher time getting started.

We also ran into a variety of integration challenges between the frontend and backend of our application. Since the Flask API was being developed somewhat independently of the Flutter frontend, we had to troubleshoot some bugs down the stretch. 

## Accomplishments
We're really excited that we are able to host our API on Google App engine, but we're also incredibly proud of the continuous integration pipeline we set up for this app. Rather than having to create and deploy a new build each time we modify our app, we set up a CI pipeline that created a new build each time we pushed to the master branch. This was incredibly helpful, and saved us a lot of time and potential headaches as we were developing the application. 

We also think that it's cool that we were able to implement a pretty diverse and full-fledged tech stack in a relatively short amount of time. Our project is extensible, which is something that we were aiming for with this app. 

## Technologies
We built this app using:
* Flutter - Mobile framework - [docs](https://flutter.io/)
* Flask - API - [docs](http://flask.pocoo.org/docs/1.0/)
* Google App Engine - API Host - [docs](https://cloud.google.com/appengine/docs/flexible/python/)
* Codeship - CI Pipeline - [docs](https://documentation.codeship.com/basic/continuous-deployment/deployment-to-google-app-engine/)
* Google Maps API - Location Services - [docs](https://developers.google.com/maps/documentation/android-sdk/intro)
* Slack API - Slack Team Invitation - [docs](https://api.slack.com/)
