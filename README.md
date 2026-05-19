# Kaon Sa Kuan

Kaon Sa Kuan is a Flutter food decision app made as a final project output for CMSC 156. 
Kaon Sa Kuan helps users decide where to eat in local restaurants in Miagao by asking a series of guided questions, similar to how the Akinator works. 
Instead of browsing multiple restaurant options and hardly thinking about where to eat, the users will simply be asked questions related to budget, food preference, location, and cravings. 
Based on the user’s responses, the app recommends a suitable restaurant or food place within Miagao.

> **Note:** Currently, Kaon Sa Kuan is only available for **Android** devices.
## Features

- View approved restaurants
- Search restaurants by name, description, location, food category, and tags
- Filter restaurants by location and food type
- Add new restaurant submissions for admin review
- Message Chat Reporting
- Upload restaurant photos through Cloudinary
- Get restaurant recommendations through a rule-based decision algorithm
- View restaurant details such as location, price range, opening hours, and tags
- Submit restaurant reports

## Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Cloudinary
- Node.js seed script using Firebase Admin

## Restaurant Management & Reporting

The app features a distinct separation of privileges between standard users and admin to ensure data quality:

### User Capabilities
* Users do not have to log in and can access the app anonymously.
* **Submitting Restaurants:** Users can add new restaurants they discover. However, these submissions are placed in a pending queue. They **must be approved by an Admin** before they are displayed on the user home page.
* **Sending Reports:** Users can send reports regarding missing, closed, or inaccurate restaurant details. This reporting system works as a **message chat**, allowing users to communicate the issue clearly.

### Admin Capabilities
* Currently, there is only one admin account. 
* **Creating & Approving Restaurants:** The admin is responsible for reviewing and approving user-submitted restaurants. Additionally, the admin can bypass the approval queue and can **directly create and publish** restaurants to the home page.
* **Receiving Reports:** The admin can receive user reports through a **message chat interface**, where they can read the feedback and take appropriate action on the restaurant data. However, the admin cannot reply with a response, and since users are anonymous, they cannot see the specific user profile who submitted the report.

## Recommendation Algorithm

The app uses a rule-based weighted scoring algorithm. Each approved restaurant is scored based on the user's answers.

The algorithm considers:

- Budget match
- Food category match
- Specific craving match
- Location match
- Meal tag match
- Opening hours match
- Tie-breaker preference

The restaurant with the highest score is shown as the recommendation.

The algorithm uses structured restaurant fields instead of plain text matching:

```dart
foodCategory
foodType
averageCostMin
averageCostMax
budgetTags
location
openTime
closeTime
mealTags
```

## Firestore Restaurant Shape
\
## Project Structure

```bash
.
└── Kaon-sa-Kuan/
    ├── android/      # Android-specific configuration
    ├── assets        # fonts and images
    ├── lib           # contains all MAIN.dart, screens, database config, and widgets
    ├── data          # Firebase functions
      ├── controllers  # Controller classes
      ├── services     # Service classes
      └── static       # Static data  
    ├── models        # Database objects
    ├── screens       # App screens, made from reusable widgets
        ├── user      # Configured only for user side
    ├── services      # Cloudinary and Restaurant services
    ├── utils         # App colors, etc.
      └── constants    # App constants
    ├── widgets       # Reusable widgets   
      ├── user      # Configured only for user side
    ├── main.dart               # Entry point of the app
    ├── scripts                 # Temporary seeder 
    ├── .gitignore              # Ignore "trash" files
    ├── analysis_options.yaml   # Rules for code style 
    ├── pubspec.lock            # A "snapshot" of exact package versions
    ├── pubspec.yaml            # Assets, fonts, and dependencies
    └── README.md               # notes
```

## Setup 
Before these commands, a proper ADB setup is required. As an alternative, a virtual android device within the IDE may also be used.

Install Flutter dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

## Firebase Setup

The app uses Firebase for authentication and restaurant data. It utilizes google-services.json for its database integration.

Required Firebase services:

- Firebase Authentication
- Cloud Firestore

## Internet Requirement

While Kaon Sa Kuan can be run offline, it is intended and recommended to be used online.

An internet connection is needed for:

- Fetching restaurant data from Firestore
- Adding restaurant submissions
- Uploading images to Cloudinary
- Firebase authentication
- Reports and live data updates

Firestore may show cached data if it was previously loaded, but the app should be treated as an online app.

## Members
- Michaela Borces (UI/UX App User-side)
- Julia Louise Contreras (Backend Admin-side)
- Samantha Lodenn Lansoy (UI/UX App Admin-side)
- Jasmine Magadan (Backend User-side)


