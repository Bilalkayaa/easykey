import 'package:equatable/equatable.dart';

class FavsState extends Equatable {
  final List<String> favorites;

  FavsState({required this.favorites});

  @override
  List<Object> get props => [favorites];

  FavsState copyWith({List<String>? favorites}) {
    return FavsState(
      favorites: favorites ?? this.favorites,
    );
  }
}
