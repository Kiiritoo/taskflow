import 'package:flutter/material.dart';

class TaskModel {
  final String taskId;
  final String title;
  final String description;
  final String tag;
  final Color tagColor;
  final int points;
  final String assignee;
  final String status;
  final DateTime? dueDate;

  TaskModel({
    required this.taskId,
    required this.title,
    this.description = '',
    required this.tag,
    required this.tagColor,
    required this.points,
    required this.assignee,
    this.status = 'TODO',
    this.dueDate,
  });
} 