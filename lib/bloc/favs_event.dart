import 'package:equatable/equatable.dart';

abstract class FavsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToFavorites extends FavsEvent {
  final String item;

  AddToFavorites(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveFromFavorites extends FavsEvent {
  final String item;

  RemoveFromFavorites(this.item);

  @override
  List<Object> get props => [item];
}

class LoadItems extends FavsEvent {}
