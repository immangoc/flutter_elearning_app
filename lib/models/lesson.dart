class Lesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final int duration;
  final List<Resource> resources;
  final bool isPreview;
  final bool isLocked;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.description,
    required this.duration,
    required this.resources,
    this.isPreview = false,
    this.isLocked = true,
    this.isCompleted = false,
  });
  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    int? duration,
    List<Resource>? resources,
    bool? isPreview,
    bool? isLocked,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      resources: resources ?? this.resources,
      isPreview: isPreview ?? this.isPreview,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        videoUrl: json['videoUrl'],
        duration: json['duration'],
        resources: (json['resources'] as List)
            .map((resource) => Resource.fromJson(resource))
            .toList(),
        isPreview: json['isPreview'] ?? false,
        isLocked: json['isLocked'] ?? true,
        isCompleted: json['isCompleted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'videoUrl': videoUrl,
        'duration': duration,
        'resources': resources.map((resource) => resource.toJson()).toList(),
        'isPreview': isPreview,
        'isLocked': isLocked,
        'isCompleted': isCompleted,
      };
  String get videoStreamUrl{
    //add your video streaming URL logic here
    //this could be a URL from a video hosting service or a local file path
    return videoUrl;
  }

  }


class Resource{
  final String id;
  final String title;
  final String type;
  final String url;

  Resource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json['id'],
    title: json['title'],
    type: json['type'],
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'url': url,
  };

}