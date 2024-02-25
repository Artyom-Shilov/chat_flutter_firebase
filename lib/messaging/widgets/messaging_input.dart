import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/widgets/animated_send_button.dart';
import 'package:chat_flutter_firebase/messaging/widgets/bottom_sheet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MessagingInput extends StatelessWidget {
  const MessagingInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messagingCubit = BlocProvider.of<MessagingCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Row(children: [
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 0.7,
            child: TextField(
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: MessagingTexts.messageInputHint,
                  border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              controller: messagingCubit.messageInputController,
              onSubmitted: (text) async {
                await messagingCubit.sendTextMessage(authCubit.user!);
              },
              onChanged: (text) {
                messagingCubit.updateInputFieldStatus(text.isEmpty);
              },
            ),
          ),
        ),
        const SizedBox(width: 30, child: AnimatedSendButton()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  builder: (context) {
                    return SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.verticalInset1,
                        ),
                        child: Wrap(
                          children: [
                            BottomSheetItem(
                              isBottomLined: true,
                              text: MessagingTexts.addPhotoFromGalleryRu,
                              icon: const Icon(Icons.photo),
                              onTap: () async {
                               /* FocusManager.instance.primaryFocus?.unfocus();
                                GoRouter.of(context).pop();
                                messagingCubit.clearInput();
                                await messagingCubit
                                    .sendImageFromGallery(authCubit.user!);*/
                              },
                            ),
                            BottomSheetItem(
                              isBottomLined: true,
                              text: MessagingTexts.addVideoFromGalleryRu,
                              icon:
                                  const Icon(Icons.video_collection_outlined),
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                messagingCubit.clearInput();
                                GoRouter.of(context).pop();
                                await messagingCubit
                                    .sendVideoFromGallery(authCubit.user!);
                              },
                            ),
                            BottomSheetItem(
                              isBottomLined: false,
                              text: MessagingTexts.addPhotoFromCameraRu,
                              icon: const Icon(Icons.camera_alt),
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                messagingCubit.clearInput();
                                GoRouter.of(context).pop();
                                await messagingCubit
                                    .sendImageFromCamera(authCubit.user!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ]),
    );
  }
}
