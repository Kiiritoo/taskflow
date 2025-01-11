import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';

class BoardController extends GetxController {
  final todoTasks = <TaskModel>[].obs;
  final inProgressTasks = <TaskModel>[].obs;
  final reviewTasks = <TaskModel>[].obs;
  final doneTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    // Dummy data untuk contoh
    todoTasks.value = [
      TaskModel(
        taskId: 'TIS-25',
        title: 'Create user authentication system',
        tag: 'BACKEND',
        tagColor: Colors.purple,
        points: 5,
        assignee: 'John',
      ),
    ];

    inProgressTasks.value = [
      TaskModel(
        taskId: 'TIS-26',
        title: 'Design dashboard UI',
        tag: 'FRONTEND',
        tagColor: Colors.blue,
        points: 3,
        assignee: 'Alice',
        status: 'IN_PROGRESS',
      ),
    ];

    reviewTasks.value = [
      TaskModel(
        taskId: 'TIS-27',
        title: 'Implement API endpoints',
        tag: 'BACKEND',
        tagColor: Colors.orange,
        points: 3,
        assignee: 'Bob',
        status: 'REVIEW',
      ),
    ];

    doneTasks.value = [
      TaskModel(
        taskId: 'TIS-28',
        title: 'Setup project structure',
        tag: 'DEVOPS',
        tagColor: Colors.green,
        points: 2,
        assignee: 'Charlie',
        status: 'DONE',
      ),
    ];
  }

  void createNewTask() {
    Get.toNamed('/tasks/create');
  }

  void moveTask(TaskModel task, String fromStatus, String toStatus) {
    // TODO: Implement drag and drop functionality
  }
} 