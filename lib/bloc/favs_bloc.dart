import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favs_event.dart';
import 'favs_state.dart';

class FavsBloc extends Bloc<FavsEvent, FavsState> {
  final FirebaseFirestore firestore;
  String userId;

  FavsBloc({required this.firestore, required this.userId})
      : super(FavsState(
          favorites: [],
        )) {
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<LoadItems>(_onLoadItems);

    // İlk başta verileri yüklemek için LoadItems eventini tetikleyin
    add(LoadItems());
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<FavsState> emit) async {
    final newFavorites = List<String>.from(state.favorites)..add(event.item);
    emit(state.copyWith(favorites: newFavorites));

    // Kullanıcıyı Firestore'dan sorgula ve güncelle
    await _updateUserFavorites(event.item, true);
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<FavsState> emit) async {
    final newFavorites = List<String>.from(state.favorites)..remove(event.item);
    emit(state.copyWith(favorites: newFavorites));

    // Kullanıcıyı Firestore'dan sorgula ve güncelle
    await _updateUserFavorites(event.item, false);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<FavsState> emit) async {
    try {
      final userSnapshot = await firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final favorites = List<String>.from(userDoc['Favs'] ?? []);

        emit(state.copyWith(favorites: favorites));
      } else {
        emit(state.copyWith());
        print('Kullanıcı bulunamadı');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateUserFavorites(String item, bool add) async {
    try {
      // Kullanıcıyı Firestore'dan sorgula
      final userSnapshot = await firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userRef = firestore.collection('users').doc(userDoc.id);

        if (add) {
          // Favorilere ekle
          await userRef.update({
            'Favs': FieldValue.arrayUnion([item])
          });
        } else {
          // Favorilerden çıkar
          await userRef.update({
            'Favs': FieldValue.arrayRemove([item])
          });
        }
      } else {
        print('Kullanıcı bulunamadı');
      }
    } catch (e) {
      print(e);
    }
  }
}
