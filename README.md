<center><b><h1>Book My Tickets</h1></b></center>
<br/>

#### Short Note

This is a movie ticket booking website to demonstrate how the tickets are booked in online ticket booking system
<br/>

<center><b>Tech Stacks</b></center>
<br/>

Front-End  | Back-End
------------- | -------------
Flutter (For UI/UX)  | Flask (For API)
Firebase (For Hosting)  | Vercel(For Hosting) 

<br/>

#### System Design

Flowchart

![flowchart](https://github.com/google/googletest/assets/94751436/5f502f30-f388-49ef-9db6-3b627ece47ad)

<br/>

#### Database Schema

For Database, Firebase Firestore is used here. It is a NoSQL Database.

Main Collections
<ol>
  <li>Movies</li>
  <ul>Movie Id</ul>
  <ul>Movie Name</ul>
  <ul>Movie Description</ul>
  <ul>Ratings</ul>
  <ul>Cover URL</ul>
  <ul>Poster URL</ul>
  <ul>Actors</ul>
  <ul>Theatre Name</ul>
  <ul>Theatre Location</ul>
  <li>Theatres</li>
  <ul>
  <li>Dates</li>
    <ul>
      date at time in 24hrs
    </ul>
  </ul>
  <li>Users</li>
  <ul>
    <li>User Email</li>
    <li>Unique UID</ui>
  </ul>
  <ul>
    <li>Bookings</li>
    <ul>
      <li>Booking ID</li>
      <li>Booked At</li>
      <li>Seats</li>
    </li>
  </ul>
</ol>

<br/>

### Screenshots

Tested on 3 Devices for responsible designs
* Laptop (For Large Screens)
* IPad Air (For Tablet Screens)
* Samsung A52 S (For Mobile Screens)

Web  | Tablet | Mobile
:-------------: | :-------------: | :-------------:
Login Screen | | 
![Login-web](https://github.com/google/googletest/assets/94751436/8b28db48-11ab-4f95-99be-0f215fce7467) | ![Login-Tab](https://github.com/google/googletest/assets/94751436/af23262f-cec4-4584-b3c7-15876ef3ad18) | ![Login-Mob](https://github.com/google/googletest/assets/94751436/cee9c23c-de14-4a39-9459-23e7753c81d7)
Signup Screen | |
![Sigup-Web](https://github.com/google/googletest/assets/94751436/f1cf77a4-d987-4179-bb5c-a7a1eb8f9373) | ![Signup-Tab](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/4aff2274-95c9-415e-84ff-f8f7591b966b)
Home Screen | |
![Home-Web](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/ce8aa5ea-9445-46ae-95e7-4db344a2be20) | ![Home-Tab](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/5339e0eb-21da-4955-8aaf-a88a4a879ea3) | ![Home-Mob](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/3ae92540-7bd0-4471-a0d4-38c3af5d9d20)
Booking Selection
![Selection-Web](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/e465acef-efae-4f43-8190-fd633d3e77b3) | ![Selection=Tab](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/2dd63590-b80f-4c29-8981-96be6896791f) | ![Selection-Mob](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/81dd6487-dc21-45df-84c3-fac33d0a743e)
Seat Selection
![Seats-Web](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/3fd2f6b2-b7c4-4cd8-bf25-f4ec87286da9) | |
Booking History
![History-Web](https://github.com/ShankaraNarayanaa/bob-frontend/assets/94751436/a7b4adb4-e61b-4b89-b010-2b37eccab9f7) | |

<br/>

### Milestones Completed

- [x] Login and Signup Authentication (Using Firebase AutH)
- [x] Browse Movies (Fetched Data using OMDB API, Store and retrieved using Flask API with Firestore)
- [x] View Showtimes (Hard Coded Showtimes)
- [x] Seat Selection (Connected with firestore)
- [x] Booking
- [ ] Booking Confirmation & Notification
- [x] QR Code (Using Library in Flutter)
- [x] Booking History (Using Firestore)
- [x] UX
- [x] Deployment (Frontend in Firebase Hosting, Backend in Vercel)

<br/>

### Deployment Links

Frontend: https://book-my-tickets-4213f.web.app/
<br/>
Backend: https://vercel-test-pi-seven.vercel.app/
