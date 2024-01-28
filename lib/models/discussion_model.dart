// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DiscussionModel {
  final String text;
  final DateTime datePublished;
  final String uid;
  final String researchId;
  final bool isRepliedTo;
  final String discussionId;
  final String repliedTo;
  DiscussionModel({
    required this.text,
    required this.datePublished,
    required this.uid,
    required this.researchId,
    required this.isRepliedTo,
    required this.discussionId,
    required this.repliedTo,
  });

  DiscussionModel copyWith({
    String? text,
    DateTime? datePublished,
    String? uid,
    String? researchId,
    bool? isRepliedTo,
    String? discussionId,
    String? repliedTo,
  }) {
    return DiscussionModel(
      text: text ?? this.text,
      datePublished: datePublished ?? this.datePublished,
      uid: uid ?? this.uid,
      researchId: researchId ?? this.researchId,
      isRepliedTo: isRepliedTo ?? this.isRepliedTo,
      discussionId: discussionId ?? this.discussionId,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'uid': uid,
      'researchId': researchId,
      'isRepliedTo': isRepliedTo,
      'discussionId': discussionId,
      'repliedTo': repliedTo,
    };
  }

  factory DiscussionModel.fromMap(Map<String, dynamic> map) {
    return DiscussionModel(
      text: map['text'] as String,
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      uid: map['uid'] as String,
      researchId: map['researchId'] as String,
      isRepliedTo: map['isRepliedTo'] as bool,
      discussionId: map['discussionId'] as String,
      repliedTo: map['repliedTo'] as String,
    );
  }

  @override
  String toString() {
    return 'DiscussionModel(text: $text, datePublished: $datePublished, uid: $uid, researchId: $researchId, isRepliedTo: $isRepliedTo, discussionId: $discussionId, repliedTo: $repliedTo)';
  }

  @override
  bool operator ==(covariant DiscussionModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.datePublished == datePublished &&
        other.uid == uid &&
        other.researchId == researchId &&
        other.isRepliedTo == isRepliedTo &&
        other.discussionId == discussionId &&
        other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        datePublished.hashCode ^
        uid.hashCode ^
        researchId.hashCode ^
        isRepliedTo.hashCode ^
        discussionId.hashCode ^
        repliedTo.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory DiscussionModel.fromJson(String source) =>
      DiscussionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
