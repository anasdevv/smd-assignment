// // lib/features/tasks/presentation/bloc/task_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';
// import 'package:smd_project/features/tasks/domain/repositories/task_repository.dart';
// import 'package:smd_project/features/tasks/presentation/bloc/tasks_event.dart';
// import 'package:smd_project/features/tasks/presentation/bloc/tasks_state.dart';

// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   final TaskRepository taskRepository;

//   TaskBloc({this.taskRepository}) : super(TaskInitial());

//   @override
//   Stream<TaskState> mapEventToState(TaskEvent event) async* {
//     if (event is LoadTasks) {
//       yield* _mapLoadTasksToState(event);
//     } else if (event is CreateTask) {
//       yield* _mapCreateTaskToState(event);
//     } else if (event is UpdateTask) {
//       yield* _mapUpdateTaskToState(event);
//     } else if (event is DeleteTask) {
//       yield* _mapDeleteTaskToState(event);
//     }
//   }

//   Stream<TaskState> _mapLoadTasksToState(LoadTasks event) async* {
//   yield TaskLoading();
//   try {
//     yield* taskRepository.getGroupTasks(event.groupId).map((tasks) => TaskLoaded(tasks));
//   } catch (e) {
//     yield TaskError(e.toString());
//   }
// }

//   Stream<TaskState> _mapCreateTaskToState(CreateTask event) async* {
//     try {
//       await taskRepository.createTask(event.groupId, event.task);
//       // Optionally trigger re-fetch of tasks or emit success
//       yield* _mapLoadTasksToState(LoadTasks(event.groupId));
//     } catch (e) {
//       yield TaskError(e.toString());
//     }
//   }

//   Stream<TaskState> _mapUpdateTaskToState(UpdateTask event) async* {
//     try {
//       await taskRepository.updateTask(event.groupId, event.task);
//       yield* _mapLoadTasksToState(LoadTasks(event.groupId));
//     } catch (e) {
//       yield TaskError(e.toString());
//     }
//   }

//   Stream<TaskState> _mapDeleteTaskToState(DeleteTask event) async* {
//     try {
//       await taskRepository.deleteTask(event.groupId, event.taskId);
//       yield* _mapLoadTasksToState(LoadTasks(event.groupId));
//     } catch (e) {
//       yield TaskError(e.toString());
//     }
//   }
// }
