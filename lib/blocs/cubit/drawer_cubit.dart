// drawer_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerCubit extends Cubit<int> {
  DrawerCubit() : super(0); // Počáteční hodnota pro domovskou stránku

  void setPageIndex(int index) {
    emit(index);
  }
}
