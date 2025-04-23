import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker/dashboard/task_model.dart';
import 'package:uuid/uuid.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;
  final uuid = const Uuid();

  Future<List<Task>> getTasks(String userId) async {
    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map<Task>((json) => Task.fromJson(json)).toList();
  }

  Future<Task> createTask(String title, String userId) async {
    final taskId = uuid.v4();
    final now = DateTime.now();

    final newTask = Task(
      id: taskId,
      title: title,
      isCompleted: false,
      userId: userId,
      createdAt: now,
    );

    await supabase.from('tasks').insert(newTask.toJson());
    return newTask;
  }

  Future<void> deleteTask(String taskId) async {
    await supabase.from('tasks').delete().eq('id', taskId);
  }

  Future<void> updateTask(Task task) async {
    await supabase
        .from('tasks')
        .update({
          'title': task.title,
          'is_completed': task.isCompleted,
        })
        .eq('id', task.id);
  }
}