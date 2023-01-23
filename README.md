# FluttScore

## Description
*FluttScore* is a mobile and web football application that offers all the latest standings, results and match events from 960 football leagues from 164 countries. Application allows to create an account, add leagues to favourites and predict results of every fixture for free.

## Features
- Home screen with navbar:
    - List of 164 countries

        <img src="https://user-images.githubusercontent.com/102852926/214076538-0224410f-bace-4f95-ae45-3f4f7084cfa4.jpg" width="300"/>
    

    <br>
 
    - Search action for countries and leagues

        <img src="https://user-images.githubusercontent.com/102852926/214076564-71cbf2f7-6e90-405c-95ba-72cda5de5c1b.jpg" width="300"/>
    
    <br>
 

    - List of favourite leagues

        <img src="https://user-images.githubusercontent.com/102852926/214076545-e8ecfa22-cf30-4326-9ea3-bc8bede23a7d.jpg" width="300"/>


    <br>
 
    - Profile screen with history of bets and global ranking


        <img src="https://user-images.githubusercontent.com/102852926/214076593-8724d946-6d3f-4078-9e69-0cdb6cd0f7ef.jpg" width="300" />
        <img src="https://user-images.githubusercontent.com/102852926/214076561-40a5f5d2-b693-4f15-a349-391d36a6d34c.jpg" width="300" /> 

    <br>
 

- Leagues screen - list of leagues with 'Add to favourites' action

    <img src="https://user-images.githubusercontent.com/102852926/214076472-564beb3b-dd38-45ae-b188-835f752d4983.jpg" width="300"/>
    
    <br>


- League details screen
    - Standings

        <img src="https://user-images.githubusercontent.com/102852926/214076573-0d6d76b4-f6e4-4d94-ba2c-b1d1b7dca552.jpg" width="300"/>
        <img src="https://user-images.githubusercontent.com/102852926/214076549-d70e200d-c28e-4ed2-8d7e-fe030eafb6fb.jpg" width="300"/>
    
    <br>

    - Finished fixtures

        <img src="https://user-images.githubusercontent.com/102852926/214076578-0276e292-9e55-41cd-9ce6-c7bfe5b81354.jpg" width="300"/>

    <br>
 
    - Live fixtures
    - Upcoming fixtures

        <img src="https://user-images.githubusercontent.com/102852926/214076590-fef764df-2f7b-4968-b016-6897177a0f03.jpg" width="300"/>

    <br>
 

- Fixture details screen with match events and bet info

    <img src="https://user-images.githubusercontent.com/102852926/214076556-62419bf5-e6e0-4dc3-bacf-d01cba125a4b.jpg" width="300"/>

    <br>
 

- Light/dark mode button on every screen

    <img src="https://user-images.githubusercontent.com/102852926/214076554-ba861de3-f247-4e06-869d-be5912e38727.jpg" width="300"/>
    
    <br>
 
    
- Login page

    <img src="https://user-images.githubusercontent.com/102852926/214076583-356b929d-1f01-466f-a22b-d129c0d29a11.jpg" width="300"/>


    <br>
 
- Sign up page

    <img src="https://user-images.githubusercontent.com/102852926/214076588-89e4ed85-33a8-42cf-8345-daef680ac3a4.jpg" width="300"/>

    <br>
 

- Reset password page

    <img src="https://user-images.githubusercontent.com/102852926/214076585-f990bc8a-1a4c-4a62-a94b-6dfac28d9361.jpg" width="300"/>

    <br>
 

- Email verification page

    <img src="https://user-images.githubusercontent.com/102852926/214076576-26218e54-da24-4a75-9c10-4d57d397ab34.jpg" width="300"/>

    <br>
 
## Betting module
Betting points are awarded as follows:
- correct result = **5 pts**
- correct goal difference and winner = **4 pts**
- correct winner = **3 pts**
- correct one team score = **2 pts**
- correct 'both team to score' = **1 point**
- incorrect = **-1 point**

Bets are settled 15 minutes after the end of the match.

## Integrations
Application uses:
- [api-football](https://www.api-football.com/) to fetch latest standings, results and events
- Firestore Database to fetch countries, leagues, bets and users data.

## Firestore schema

![firestore-schema drawio](https://user-images.githubusercontent.com/102852926/214071718-c016c31b-64d6-473f-a67f-af25847b4770.png)

    <br>
 
## Technology
Flutter packages used in project:
- http
- flutter_svg
- grouped_list
- email_validator
- collection
- transparent_image
- provider

## Test account:
- Email: deniw78979@quamox.com
- Password: adminadmin

## Contact
- Linkedin: [Mikołaj Nowak](https://www.linkedin.com/in/nowak-mikolaj-f/)
- Email: nowak.mikolaj19@gmail.com