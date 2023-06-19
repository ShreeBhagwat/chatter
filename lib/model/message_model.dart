class MessageModel {
  String? message;
  String? senderUid;
  String? receiveruid;
  String? timestamp;
  int? type;

  MessageModel(this.message, this.senderUid, this.receiveruid, this.timestamp,
      this.type);

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderUid = json['senderUid'];
    receiveruid = json['receiveruid'];
    timestamp = json['timestamp'];
    type = json['type'];
  }

  // create a toJson
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderUid': senderUid,
      'receiveruid': receiveruid,
      'timestamp': timestamp,
      'type': type
    };
  }
}
