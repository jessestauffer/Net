# Net - Mesh Networking App

I created the net app using the p2pkit framework from UEPAA. To begin, sign up for p2pkit to receive an API key at p2pkit.io

This implementation is for iOS (but p2pkit also supports Android)
I wrote the app entirely in Apple’s Swift programming language, as Objective-C is becoming more and more outdated

To begin, open `chat.swift` and paste your api key into the constant at the top labeled `APIKEY`. After doing this, you may build and run the project. Make sure you have bluetooth enabled on your device and also have another nearby device to test the application on.

Once the app launches you will be able to enter a chat username. This can be anything and is used to identify yourself to other users. After tapping get started you will be instantly connected with other users running the app. You can then proceed to send text and picture messages to nearby peers. To see who you are chatting with, tap on the users button in the top left of the navigation bar.

The api allows you to send text messages to others, however, I went ahead and implemented photo messages as well. I did this using custom data dictionaries that are archived and unarchived when delivering and receiving a message. You could also implement audio / video messages in the same manner.

If you have any questions, let me know. I am happy to help with the implementation and transforming the API to fit your needs.
