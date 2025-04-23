import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_tracker/app/theme.dart';
import 'package:task_tracker/dashboard/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isDarkMode ? AppTheme.darkSurfaceColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                  ? Colors.black.withOpacity(0.2) 
                  : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            leading: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted 
                  ? (isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor)
                  : (isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor),
              ),
            ),
            subtitle: Text(
              'Created: ${_formatDate(task.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor,
              ),
            ),
            trailing: _buildStatusChip(isDarkMode),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isDarkMode) {
    final completedBgColor = isDarkMode 
        ? AppTheme.darkPrimaryColor.withOpacity(0.3) 
        : AppTheme.primaryColor.withOpacity(0.2);
    final pendingBgColor = isDarkMode
        ? Colors.amber.withOpacity(0.3)
        : Colors.amber.withOpacity(0.2);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: task.isCompleted ? completedBgColor : pendingBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        task.isCompleted ? 'Completed' : 'Pending',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: task.isCompleted 
              ? (isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
              : Colors.amber.shade800,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}