
class NoteModel {
  final int? id;
  final String title;
  final String content;

  final String? sourceType;
  final String? sourceId;
  final String? sourceTitle;
  final String? anchorId;

  // Normalized image coordinates (0.0 to 1.0)
  final double? markerX;
  final double? markerY;

  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.sourceType,
    this.sourceId,
    this.sourceTitle,
    this.anchorId,
    this.markerX,
    this.markerY,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      sourceType: map['source_type'] as String?,
      sourceId: map['source_id'] as String?,
      sourceTitle: map['source_title'] as String?,
      anchorId: map['anchor_id'] as String?,
      markerX: (map['marker_x'] as num?)?.toDouble(),
      markerY: (map['marker_y'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'source_type': sourceType,
      'source_id': sourceId,
      'source_title': sourceTitle,
      'anchor_id': anchorId,
      'marker_x': markerX,
      'marker_y': markerY,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    String? sourceType,
    String? sourceId,
    String? sourceTitle,
    String? anchorId,
    double? markerX,
    double? markerY,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      anchorId: anchorId ?? this.anchorId,
      markerX: markerX ?? this.markerX,
      markerY: markerY ?? this.markerY,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
