To run this app successfully you need to do 3 things in the backend app. 
1/ Add authorized device with simulator/device id
2/ Add participant and assign it to this device
3/ Add video set and assign participant to video set. 

When done run the mobile app with:
`flutter run`

If the setup on the backend has not been completed you will see the error when you run the mobile app saying that is not properly configured. You can copy device ID by tapping error message on the screen. 

The app has been tested only on android tables.
Even though technically it should run on phones and IOS I have never tested it.
Please test it on real or simulator devices that are tablets and running  android OS.


You can do the setup from the admin backend or run with postman/insomnia directly. 
Its recommended to do this as an admin user after being logged in,  as things might have changed with these requests and I did not had time to verify whether tha'ts actually the case. 
Each requests from the one below requires a jwt token. 


1. Add authorized device:

POST https://endpoint/api/authorizeddevices 

```{
  "uuid": "b7cdfa4bbfe33c02"
}```

2. Add Participant (unique device id needs to match device from point 1)
This happens automatically when assigned it in the backend. 

POST https://endpoint/api/participant

{
	"first_name": "Peter",
  "last_name": "Jackson",
	"unique_device_id": "b7cdfa4bbfe33c02"
  "push_notification_id": "1234567"
}

3. Add video set which then needs to be assigned to the participant

POST https://endpoint/api/videoset

{
  name: "Peripherial Arterial Disease programme"
  number_of_weeks: 10,
  videos_in_week: 5
}

4. Add participant progress: (must exist - video set  and participant )
  This is created automatically in the backend. 
{
  {
	"participant_id": 2,
  "fitness_video_set_id": 3,
  "started_date": "2021-08-31T23:00:00.000Z",
  "last_seen_date": "2021-08-31T23:00:00.000Z",
  "percentage_progress": 0,
  "video_stopped_at": "0"
}

5. At least one video must exists in the video set. 


You need to have a file prouard-rules.pro in android/app  with the following content:
(in other for production release to work)
-keep class org.videolan.libvlc.** { *; }
