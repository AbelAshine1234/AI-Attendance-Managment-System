import 'package:equatable/equatable.dart';
import 'package:project/class/models/ClassName.dart';

abstract class ClassState extends Equatable{
  const ClassState();
  @override
  List<Object?> get props => [];
}
class ClassEmpty extends ClassState{}
class ClassIsLoading extends ClassState{}
class OneClassLoaded extends ClassState{
  final ClassName className;
  OneClassLoaded({required this.className});
  @override
  List<Object?> get props => [className];
}
class AllClassesLoaded extends ClassState{
  final Iterable<ClassName> classNames;

  AllClassesLoaded({required this.classNames});
  @override
  List<Object?> get props => [classNames];
}
class ClassError extends ClassState{
  final String message;

  ClassError({required this.message});
}