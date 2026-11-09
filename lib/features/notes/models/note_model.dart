
class NoteModel {
  final int? id;
  final String title;
  final String content;

  final String? sourceType;
  final String? sourceId;
  final String? sourceTitle;
  final String? anchorId;

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
    Object? sourceType = _unchanged,
    Object? sourceId = _unchanged,
    Object? sourceTitle = _unchanged,
    Object? anchorId = _unchanged,
    Object? markerX = _unchanged,
    Object? markerY = _unchanged,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      sourceType: identical(sourceType, _unchanged)
          ? this.sourceType
          : sourceType as String?,
      sourceId: identical(sourceId, _unchanged)
          ? this.sourceId
          : sourceId as String?,
      sourceTitle: identical(sourceTitle, _unchanged)
          ? this.sourceTitle
          : sourceTitle as String?,
      anchorId: identical(anchorId, _unchanged)
          ? this.anchorId
          : anchorId as String?,
      markerX: identical(markerX, _unchanged)
          ? this.markerX
          : markerX as double?,
      markerY: identical(markerY, _unchanged)
          ? this.markerY
          : markerY as double?,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

const _unchanged = Object();
