import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/controller/task_controller.dart';

class AddTaskDialog extends StatelessWidget {
  final taskController = Get.find<TaskController>();

  AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: taskController.titleController,
              decoration: const InputDecoration(
                labelText: 'Title',

              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: taskController.descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 10),
            GetBuilder<TaskController>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(controller.selectedDateTime == null
                          ? 'No Date Selected'
                          : DateFormat.yMMMd().add_jm().format(taskController.selectedDateTime!)),
                      const Spacer(),

                      TextButton(
                        onPressed: () => controller.showDateTimePicker(context),
                        child: controller.selectedDateTime == null ? const Text('Select Date & Time') : const Icon(Icons.edit, size: 18),
                      ) ,
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<DateTimeComponents>(
                            value: DateTimeComponents.dateAndTime,
                            groupValue: controller.selectedRecurrence,
                            onChanged: controller.onRecurrenceChanged,
                          ),
                          const SizedBox(width: 8.0),
                          const Text('Daily'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<DateTimeComponents>(
                            value: DateTimeComponents.dayOfWeekAndTime,
                            groupValue: controller.selectedRecurrence,
                            onChanged: controller.onRecurrenceChanged,
                          ),
                          const SizedBox(width: 8.0),
                          const Text('Weekly'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<DateTimeComponents>(
                            value: DateTimeComponents.dayOfMonthAndTime,
                            groupValue: controller.selectedRecurrence,
                            onChanged: controller.onRecurrenceChanged,
                          ),
                          const SizedBox(width: 8.0),
                          const Text('Monthly'),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => taskController.submit(),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
