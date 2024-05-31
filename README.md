# group3-project

Group Details
- Ray Meshack D. Ragas
- Zenn Louie C. Reyes
- Jan Andrew Señires
- CMSC 23 - UV-2L

<b>Elbi Donation System Project: ElGives</b>

<b> Program description: </b>

ElGives is a donation system application built using Flutter. This app serves as a medium for people who are willing to donate, organizations who are willing to manage donations,  and communities who are in need to receive these donations. The users may sign up either as a donor or as an organization. Additionally, an account was made exclusively for admins only. An admin can view information regarding donors, organizations, and the donations. Going in to the technical side of the app, it revolves around asynchronous programming where streams are able to provide data over the network. The data is stored using Google Firebase and is accessed through its API. Authentication and Storage are also utilized to handle user registrations and image uploads respectively. Lastly, some of the notable packages used by the app are flutter_sms which provide access to android's sms feature and qr_code/scanner which provide services to generating and scanning of QR codes.

<b> Installation Instructions: </b>

To run the app, either fork the repository or download the zip file of the code and store it in your preferred directory. Afterwards, run your terminal in the directory of the project "group3-project". Run your emulator or connect your device. Then, enter "flutter pub get" to download all dependencies of the app. Finally, enter "flutter run" and enjoy the app.


<b> How to use: </b>


- Sign Up as Donor

Upon accessing the app, click the Sign Up button below to navigate to the Sign Up as Donor page and start registering as a Donor. Provide a valid input for all the fields in the sign up page. Invalid inputs will give notification. Once filling all fields correctly, press the "Continue" button to finish the registration. You are automatically signed in and will redirect to the Donor's Homepage.


- Sign in as Donor

To sign in as Donor, simply input your correct Donor account email and password in the Sign In page. After logging in, you will redirect to Donor's Homepage.  In Donor's Homepage, a list of organizations will be displayed in the screen. Additionally, donation drives which are linked to an organization. Users may either donate driectly to the organization on the charity drive. To donate, simply tap on the tile corresponding to their preferred organization or charity drive. Fill up the donation form in order to issue a pending donation. A donation could either picked up or dropped off. If you choose via pick up, contact number and address will be required. For drop off, a qr code that the organization must scan will be generated upon submitting. Lastly, there is an option to attach a photo of the donation by tapping the Upload image button. The uploaded image can will be displayed after. Click "Donate" in order to finish the process. In the drawer on the left panel, you may choose to view the details or cancel your pending donations by tapping the Donations tab. To view your profile, select the Donor Details instead.


- Sign up as Organization

To sign up as an organization, access first the Sign Up as Donor page. Click the Join as an Organization button to navigate to the Sign up as Organization page. Start filling up all fields, and once done, click the Continue button to process registration. Note that it is also required to upload proof of legitimacy for the admin's reference. Admin has to approve the registration, thus you won't be able to receive donations yet unless approved.


- Sign in as Organization

To sign in your organization account, simply input your correct organization account email and password in the Sign In page. After logging in, you will redirect to the Organization's Homepage.  In the homepage, a list of donations made to your organization will be displayed in the screen. To update the status of a donation, tap the right most button in a donation's tile. To confirm a donation drop off, tap the QR code scanner on the upper right of the screen and scan the donor's QR code. In the same page, the donation can be linked to a donation drive which is necessary to complete the status of the donation. On the side panel drawer, click Donation Drives and enter details of the Donation Drive to add. Then, go back to the home page and tap the link button to select which donation drive the donation must be sent to. After linking, navigate through the donation drive tab and tap the donation drive of your chosen donation. Click the check button of that donation to view the Completion Page. In the completion page, click the complete button to complete a donation. A photo must be uploaded to show that the donation has been given to its respective donation drive. Afterwards, an sms will be sent to the donor to notify them regarding their donation. Additionally in the drawer, the organization profile can be seen by accessing the Organization Details.

- Sign in as Admin

To sign in as admin, simply input your correct Admin account email and password in the Sign In page. After logging in, you will redirect to Admin's Homepage.  In Admin's Homepage, a list of pending organizations will be displayed in the screen. To approve an organization sign up, click the three dot icon on the right most part of the tile. View the organization's proof of legitimacy by clicking the image name in the modal. Finally, approve the organization sign up by tapping the approve button. To view all donors and their details, select the Donors tab in the side panel drawer, and then clicking the corresponding tile of a donor to view  their profile. On the other hand, the list of approved donations and their corresponding donations can be viewed by tapping the Organizations tab instead in the drawer. 
