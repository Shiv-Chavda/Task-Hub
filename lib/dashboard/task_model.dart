import 'package:flutter/foundation.dart';
import 'package:task_tracker/services/supabase_service.dart';

class Task {
  final String id;
  final String title;
  bool isCompleted;
  final String userId;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.userId,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? userId,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TaskProvider extends ChangeNotifier {
  final SupabaseService supabaseService;
  String? userId;
  List<Task> _tasks = [];
  bool _isLoading = false;

  TaskProvider({required this.supabaseService, this.userId});

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    if (userId == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      final fetchedTasks = await supabaseService.getTasks(userId!);
      _tasks = fetchedTasks;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addTask(String title) async {
    if (userId == null) return;
    
    try {
      final newTask = await supabaseService.createTask(title, userId!);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await supabaseService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        
        await supabaseService.updateTask(updatedTask);
        
        _tasks[taskIndex] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}