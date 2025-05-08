// lib/features/tasks/presentation/bloc/task_event.dart
import 'package:equatable/equatable.dart';
import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class LoadTasks extends TaskEvent {
  final String groupId;
  const LoadTasks(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class CreateTask extends TaskEvent {
  final String groupId;
  final TaskEntity task;
  const CreateTask(this.groupId, this.task);

  @override
  List<Object?> get props => [groupId, task];
}

class UpdateTask extends TaskEvent {
  final String groupId;
  final TaskEntity task;
  const UpdateTask(this.groupId, this.task);

  @override
  List<Object?> get props => [groupId, task];
}

class DeleteTask extends TaskEvent {
  final String groupId;
  final String taskId;
  const DeleteTask(this.groupId, this.taskId);

  @override
  List<Object?> get props => [groupId, taskId];
}
