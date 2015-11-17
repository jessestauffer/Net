# NET README - MESH NETWORKING APP

I CREATED THE NET APP USING THE P2PKIT FRAMEWORK FROM UEPAA. TO BEGIN, SIGN UP FOR P2PKIT TO RECEIVE AN API KEY AT p2pkit.io

THIS IMPLEMENTATION IS FOR iOS (BUT P2PKIT ALSO SUPPORTS ANDROID)
I WROTE THE APP ENTIRELY IN APPLE’S SWIFT PROGRAMMING LANGUAGE, AS OBJECTIVE-C IS BECOMING MORE AND MORE OUTDATED

TO BEGIN, OPEN `Chat.swift` AND PASTE YOUR API KEY INTO THE CONSTANT AT THE TOP LABELED `APIKey`. AFTER DOING THIS, YOU MAY BUILD AND RUN THE PROJECT. MAKE SURE YOU HAVE BLUETOOTH ENABLED ON YOUR DEVICE AND ALSO HAVE ANOTHER NEARBY DEVICE TO TEST THE APPLICATION ON.

ONCE THE APP LAUNCHES YOU WILL BE ABLE TO ENTER A CHAT USERNAME. THIS CAN BE ANYTHING AND IS USED TO IDENTIFY YOURSELF TO OTHER USERS. AFTER TAPPING GET STARTED YOU WILL BE INSTANTLY CONNECTED WITH OTHER USERS RUNNING THE APP. YOU CAN THEN PROCEED TO SEND TEXT AND PICTURE MESSAGES TO NEARBY PEERS. TO SEE WHO YOU ARE CHATTING WITH, TAP ON THE USERS BUTTON IN THE TOP LEFT OF THE NAVIGATION BAR.

THE API ALLOWS YOU TO SEND TEXT MESSAGES TO OTHERS, HOWEVER, I WENT AHEAD AND IMPLEMENTED PHOTO MESSAGES AS WELL. I DID THIS USING CUSTOM DATA DICTIONARIES THAT ARE ARCHIVED AND UNARCHIVED WHEN DELIVERING AND RECEIVING A MESSAGE. YOU COULD ALSO IMPLEMENT AUDIO / VIDEO MESSAGES IN THE SAME MANNER.

IF YOU HAVE ANY QUESTIONS, LET ME KNOW. I AM HAPPY TO HELP WITH THE IMPLEMENTATION AND TRANSFORMING THE API TO FIT YOUR NEEDS.
