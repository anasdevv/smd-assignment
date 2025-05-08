// lib/features/tasks/presentation/bloc/task_state.dart
import 'package:equatable/equatable.dart';
import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
