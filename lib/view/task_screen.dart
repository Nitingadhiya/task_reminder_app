import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/controller/task_controller.dart';

class TaskListScreen extends StatelessWidget {
  final taskController = Get.put(TaskController());
  TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Reminder App'),
      ),
      body: GetBuilder<TaskController>(builder: (controller) {
        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            String recurrenceType = task.recurrenceType == "dateAndTime" ? "Daily" : task.recurrenceType == "dayOfWeekAndTime" ? "Weekly"  : task.recurrenceType == "dayOfMonthAndTime" ? "Monthly" : "";
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: ListTile(
                title: Text("${task.title} ${recurrenceType.isNotEmpty ? " - $recurrenceType" : ""}"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), side: BorderSide(color: Theme.of(context).splashColor)),
                subtitle: Text('Reminder: ${DateFormat.yMMMd().add_jm().format(task.reminderTime)}'),
                trailing: StreamBuilder<DateTime>(
                    stream: controller.currentTimeStream,
                    builder: (context, snapshot) {
                      if (task.recurrenceType.isEmpty && (snapshot.data?.isAfter(task.reminderTime) ?? false)) {
                        return const Icon(Icons.done, color: Colors.green);
                      } else if (snapshot.data != null) {
                        return IconButton(
                            onPressed: () => controller.showDeleteConfirmationDialog(context, index),
                            icon: const Icon(Icons.delete_outline, color: Colors.red));
                      } else {
                        return const SizedBox();
                      }
                    }),
              ).paddingOnly(bottom: controller.tasks.last ==task ? 80 : 0 ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => taskController.openAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
