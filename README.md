# TeamDinner
TeamDinner presents a solution for sports teams coordinating dining efforts during game days.
The app is a seamless dinner organization for sports teams, integrating similarities of food delivery
service applications with functionalities to assign parent leaders and splitting payments.
The app incorporates interfaces for login/signup, team landing page, restaurant searching, polling, 
and connection to a third-party cost-splitting app.

# Setup Instructions
## Frontend - Flutter
Install Android Studio at https://developer.android.com/studio

Install Flutter by following the directions at https://docs.flutter.dev/get-started/install

Flutter issues can be diagnosed by running ```flutter doctor``` in terminal

Open the Project in Android Studio and run main.dart after installing an emulator of choice in Android Studio

## Backend - NestJS
### Local Run
Install NestJS by following the directions at https://docs.nestjs.com/first-steps
Install yarn by following the directions at https://classic.yarnpkg.com/lang/en/docs/install
Open the project and run ```yarn start:dev``` on windows or ```yarn start:mac-dev``` on mac

## Firestore
Database is stored on Firestore at https://console.firebase.google.com/u/0/

## Deployed Run - Vercel

Once deployed on Vercel, Frontend baseUrl in Repository files will need to be updated.

Backend can be deployed via vercel at https://vercel.com with the following setup:
### Project Settings:
Framework Preset - Other

Root Directory - "Backend" (check "Include source files outside of the Root Directory in the Build Step."

Node.js Version - 18.x
### Domains:
Git Branch - main
### Git:
Connect to Github Repository
### Environment Variables
Check "Automatically expose System Envionment Variables"

FIREBASE_CLIENT_EMAIL (Found via Firestore service account file)

FIREBASE_PROJECT_ID (Found via Firestore service account file)

FIREBASE_PRIVATE_KEY (Found via Firestore service account file)

NODE_ENV=prod

JWT_SECRET (whatever you choose)

# Release Notes Section

## v 0.5.0
### Features
Backend
* Swagger Documentation completed

Frontend
* Frontend Documentation completed
* Tip total added

### Bug Fixes
* Fixed missing tip value in split payment route

## v 0.4.0
### Features
Backend
* Added Venmo and Tip Percentage to User
* Added split bill functionality
* Added payment tracking

Swagger: https://app.swaggerhub.com/apis-docs/joshbl-dev/team-dinner_api/0.0.3

Frontend
* Iterated on UI for team screens and poll screens
* Added a User Modification page
* Added Logout functionality
* Added Payment tracking system
* Added split bill page

### Bug Fixes
* Login is saved between sessions now

## v 0.3.0
### Features
Backend
* Added poll routes to backend api
* cleaned up code to match convention
* Add poll entity information

Swagger: https://app.swaggerhub.com/apis-docs/joshbl-dev/team-dinner_api/0.0.2

Frontend
* Iterated on UI for team screens
* Added a new logo for TeamDinner
* Created UI for poll pages
* Added Poll Management user functionality

### Bug Fixes
N/A

## v 0.2.0
### Features
Backend
* Added team routes to backend api
* Fixed some broken code
* Add routes for team entity management

Swagger: https://app.swaggerhub.com/apis-docs/joshbl-dev/team-dinner_api/0.0.1

Frontend
* Fixed and created new UI for login and signup screen
* Added a new logo for TeamDinner
* Created UI for team page
* Added Team Management user functionality

### Bug Fixes
N/A


## v 0.1.0
### Features
Backend
* Create a user schema for database
* Login Authentication with JWT tokens
* Setup Nestjs App
* Setup firebase
* Create user routes for registration
* Create API deployment for frontend
* Create user routes for adding friends 

Swagger: https://app.swaggerhub.com/apis-docs/joshbl-dev/team-dinner_api/0.0.1

Frontend
The frontend deliverables started off with setting up the Flutter app and then connecting the backend
to the UI to allow users to register and login with an account.
* Build "create user screen" using Flutter
* Build login screen using Flutter
* Call backend for register route and login route

### Bug Fixes
N/A

 
