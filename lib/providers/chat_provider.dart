import 'dart:developer';

import 'package:chatter/FirebaseServices/message_repository.dart';
import 'package:chatter/FirebaseServices/user_repository.dart';
import 'package:chatter/model/message_model.dart';
import 'package:chatter/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserData? _currentUser;
  UserData? _toUser;
  List<UserData> allUsers = [];
  String _messageText = "";
  MessageModel? _messageModel;
  List<MessageModel> _allMessages = [];

  bool get isLoading => _isLoading;
  UserData? get currentUser => _currentUser;
  UserData? get toUser => _toUser;
  String get messageText => _messageText;
  MessageModel? get messageModel => _messageModel;
  List<MessageModel> get allMessages => _allMessages;

  UserRepository _userRepository = UserRepository();
  MessageRepository _messageRepository = MessageRepository();

  void setLoader(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    setLoader(true);
    await _userRepository.fetchAllUsers().then((value) {
      if (value != null) {
        allUsers = value;
      }
    }).catchError((e) {
      print('Failed to fetch all users: $e');
    });
    notifyListeners();
  }

  void setMessage(MessageModel messageModel) {
    _messageModel = messageModel;
  }

  Future<void> sendMessage() async {
    if (messageModel == null) return;
    await _messageRepository.sendMessage(_messageModel!);
  }

  Future<void> fetchAllMessage() async {
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((event) {
      if (event != null) {
        _allMessages =
            event.docs.map((e) => MessageModel.fromJson(e.data())).toList();
        notifyListeners();
      }
    });
  }
}

final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) {
  return ChatProvider();
});
