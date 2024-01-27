import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResearchModel {
  final String title;
  final String pdfUrl;
  final int fundingRaised;
  final int commentCount;
  final DateTime datePublished;
  final String uid;
  final String summary;
  final String id;
  ResearchModel({
    required this.title,
    required this.pdfUrl,
    required this.fundingRaised,
    required this.commentCount,
    required this.datePublished,
    required this.uid,
    required this.summary,
    required this.id,
  });

  ResearchModel copyWith({
    String? title,
    String? pdfUrl,
    int? fundingRaised,
    int? commentCount,
    DateTime? datePublished,
    String? uid,
    String? summary,
    String? id,
  }) {
    return ResearchModel(
      title: title ?? this.title,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      fundingRaised: fundingRaised ?? this.fundingRaised,
      commentCount: commentCount ?? this.commentCount,
      datePublished: datePublished ?? this.datePublished,
      uid: uid ?? this.uid,
      summary: summary ?? this.summary,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'pdfUrl': pdfUrl,
      'fundingRaised': fundingRaised,
      'commentCount': commentCount,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'uid': uid,
      'summary': summary,
      'id': id,
    };
  }

  factory ResearchModel.fromMap(Map<String, dynamic> map) {
    return ResearchModel(
      title: map['title'] as String,
      pdfUrl: map['pdfUrl'] as String,
      fundingRaised: map['fundingRaised'] as int,
      commentCount: map['commentCount'] as int,
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      uid: map['uid'] as String,
      summary: map['summary'] as String,
      id: map['id'] as String,
    );
  }

  @override
  String toString() {
    return 'ResearchModel(title: $title, pdfUrl: $pdfUrl, fundingRaised: $fundingRaised, commentCount: $commentCount, datePublished: $datePublished, uid: $uid, summary: $summary, id: $id)';
  }

  @override
  bool operator ==(covariant ResearchModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.pdfUrl == pdfUrl &&
        other.fundingRaised == fundingRaised &&
        other.commentCount == commentCount &&
        other.datePublished == datePublished &&
        other.uid == uid &&
        other.summary == summary &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        pdfUrl.hashCode ^
        fundingRaised.hashCode ^
        commentCount.hashCode ^
        datePublished.hashCode ^
        uid.hashCode ^
        summary.hashCode ^
        id.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory ResearchModel.fromJson(String source) =>
      ResearchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
