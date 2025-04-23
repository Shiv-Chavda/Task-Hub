import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/app/theme.dart';
import 'package:task_tracker/app/theme_switcher.dart';
import 'package:task_tracker/auth/auth_service.dart';
import 'package:task_tracker/dashboard/task_model.dart';
import 'package:task_tracker/dashboard/task_tile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _taskController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    
    // Load tasks when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showAddTaskBottomSheet() {
    final isDarkMode = AppTheme.isDarkMode(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? AppTheme.darkSurfaceColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _taskController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  hintText: 'What do you need to do?',
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_taskController.text.trim().isNotEmpty) {
                    await Provider.of<TaskProvider>(context, listen: false)
                        .addTask(_taskController.text.trim());
                    if (mounted) {
                      _taskController.clear();
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Add Task'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          const ThemeSwitcher(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                  size: 50,
                ),
              );
            }
            
            if (taskProvider.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: isDarkMode ? AppTheme.darkSecondaryColor : AppTheme.secondaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first task to get started',
                      style: TextStyle(
                        color: isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showAddTaskBottomSheet,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Task'),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];
                  return TaskTile(
                    task: task,
                    onDelete: () async {
                      await taskProvider.deleteTask(task.id);
                    },
                    onToggle: () async {
                      await taskProvider.toggleTaskCompletion(task.id);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskBottomSheet,
        backgroundColor: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
