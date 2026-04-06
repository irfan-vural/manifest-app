import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/coach_repository.dart';
import 'coaches_state.dart';

class CoachesCubit extends Cubit<CoachesState> {
  final CoachRepository repository;

  //  ilk  initial state ile başlıyor
  CoachesCubit({required this.repository}) : super(CoachesInitial());

  Future<void> fetchCoaches() async {
    // loading state
    emit(CoachesLoading());

    try {
      final coaches = await repository.getCoaches();

      // loadaed state
      emit(CoachesLoaded(coaches));
    } catch (e) {
      // error state
      emit(CoachesError('Koçlar yüklenirken bir hata oluştu: ${e.toString()}'));
    }
  }
}
