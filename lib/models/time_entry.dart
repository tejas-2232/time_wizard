import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TimeEntry {
  final String id;
  final String username;
  final String? taskName;
  final String? projectName;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  
  TimeEntry({
    String? id,
    required this.username,
    this.taskName,
    this.projectName,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();
  
  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }
  
  String get formattedStartTime {
    return DateFormat('MMM d, yyyy - h:mm a').format(startTime);
  }
  
  String get formattedEndTime {
    if (endTime == null) {
      return 'In progress';
    }
    return DateFormat('h:mm a').format(endTime!);
  }
  
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  TimeEntry copyWith({
    String? id,
    String? username,
    String? taskName,
    String? projectName,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
  }) {
    return TimeEntry(
      id: id ?? this.id,
      username: username ?? this.username,
      taskName: taskName ?? this.taskName,
      projectName: projectName ?? this.projectName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'taskName': taskName,
      'projectName': projectName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
  
  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      username: json['username'],
      taskName: json['taskName'],
      projectName: json['projectName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      isCompleted: json['isCompleted'],
    );
  }
  
  List<String> toSheetsRow() {
    return [
      id,
      username,
      taskName ?? '',
      projectName ?? '',
      DateFormat('yyyy-MM-dd').format(startTime),
      DateFormat('HH:mm:ss').format(startTime),
      endTime != null ? DateFormat('HH:mm:ss').format(endTime!) : '',
      formattedDuration,
    ];
  }
}