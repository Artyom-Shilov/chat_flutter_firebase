# chat_flutter_firebase

Chat app with flutter and firebase


functional:

registration by email and password

sign-in by email and password

sign-in via google

sign-out

chat creation

chat search by chat name

chat joining

chat leaving

sending text, image and video messages

sending local notifications about new messages in a chat (android only)

ability to disable and enable notifications in a chat

saving information about user chats and messages in local storage

internet connection check (android only)



used packages:
bloc, flutter_bloc - state management

build_runner, freezed, freezed_annotation, json_annotation, json_serializable - code generation

firebase_core, firebase_auth, firebase_database, firebase_storage, firebase_messaging - firebase services

go_router - navigation

flutter_hooks - handling operations connected to widget state life-cycle

dio - network

google_fonts - fonts

isar, isar_flutter_libs, isar_generator - local storage

get_it - service locator

intl - date formatting

uuid - id generation

cached_network_image, image_picker, video_player - video and image handling

flutter_local_notifications - notification handling