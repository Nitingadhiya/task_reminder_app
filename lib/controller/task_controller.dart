import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../model/task_model.dart';
import '../services/notification_services.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as ti;
import '../utils/timezone_helper.dart';
import '../view/add_task_view.dart';

class TaskController extends GetxController {
  final List<Task> tasks = [];
  DateTimeComponents? selectedRecurrence;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDateTime;
  Stream<DateTime> get currentTimeStream => Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());

  @override
  void onInit() {
    configureLocalTimeZone();
    loadTasks();
    super.onInit();
  }

  // Get & Set Local timezone
  Future<void> configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    String timeZoneName = await TimeZoneHelper.getTimeZoneName();
    ti.setLocalLocation(ti.getLocation(timeZoneName));
  }

  // Get task list initially If we have
  void loadTasks() {
    final storedTasks = storage.read<List>('tasks') ?? [];
    tasks.addAll(storedTasks.map((task) => Task.fromJson(task)).toList());
    update();
  }

  //Save task in Local storage
  void saveTasks() {
    storage.write('tasks', tasks.map((task) => task.toJson()).toList());
  }

  //Delete Task
  Future<void> deleteTask(int index) async {
    tasks.removeAt(index);
    await NotificationService().removeNotification(index + 1);
    HapticFeedback.mediumImpact();
    Get.back();
    update();
    saveTasks();
  }

  //Add Task
  void addTask(String title, String description, DateTime reminderTime) async {
    final newTask = Task(
        title: title,
        description: description,
        reminderTime: reminderTime,
        recurrenceType: selectedRecurrence?.name ?? "");
    tasks.add(newTask);
    saveTasks();
    update();
    try {
      await NotificationService().scheduleDailyTenAMLastYearNotification(
          id: tasks.length, title: title, body: description, scheduledTime: reminderTime, type: selectedRecurrence);
    } catch (e) {
      debugPrint("Failed to schedule notification: $e");
    }
  }

  // Open Task Dialog
  Future<void> openAddTaskDialog(context) async {
    selectedRecurrence = null;
    showDialog(
      context: context,
      builder: (context) {
        return AddTaskDialog();
      },
    );
  }

  // Open DateTime picker
  void showDateTimePicker(context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime.now().add(const Duration(days: 2100)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        update();
      }
    }
  }

  // Recurring events
  void onRecurrenceChanged(DateTimeComponents? value) {
    selectedRecurrence = value;
    update();
  }

  //Confirm Dialog
  Future<void> showDeleteConfirmationDialog(context, int taskIndex) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            // Cancel button
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            // Confirm button
            TextButton(
              onPressed: () => deleteTask(taskIndex),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  //Save Task
  void submit() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty || selectedDateTime == null) {
      return;
    }
    addTask(titleController.text, descriptionController.text, selectedDateTime!);
    HapticFeedback.mediumImpact();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    selectedDateTime = null;
    Get.back();
  }
}