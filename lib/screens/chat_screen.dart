import 'package:chatter/model/message_model.dart';
import 'package:chatter/providers/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  ChatScreen({super.key, required this.name, required this.uid});
  final String name;
  final String uid;

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatNotifer = ref.watch(chatProvider);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(name),
          onTap: () {
            chatNotifer.fetchAllMessage();
          },
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          chatNotifer.allMessages.isNotEmpty
              ? Positioned(
                  top: 0,
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: ListView.builder(
                    itemCount: chatNotifer.allMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatNotifer.allMessages[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(message.message!),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.red,
              child: SafeArea(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 85,
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () async {
                          if (messageController.text.isEmpty) return;
                          final timeStamp =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          final senderUid =
                              FirebaseAuth.instance.currentUser!.uid;
                          MessageModel messageModel = MessageModel(
                              messageController.text,
                              senderUid,
                              uid,
                              timeStamp,
                              0);
                          chatNotifer.setMessage(messageModel);
                          await chatNotifer.sendMessage().then((value) {
                            messageController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
