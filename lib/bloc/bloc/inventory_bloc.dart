import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/events/inventory_event.dart';
import 'package:nvcti/bloc/states/inventory_state.dart';
import 'package:nvcti/data/datasources/remote_datasource/inventory_remote_data_source.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRemoteDataSource dataSource;

  InventoryBloc({required this.dataSource}) : super(InventoryLoading()) {
    on<LoadInventoryEvent>((event, emit) async {
      emit(InventoryLoading());
      try {
        final items = await dataSource.fetchInventory();
        emit(InventoryLoaded(items));
      } catch (e) {
        emit(InventoryError(e.toString()));
      }
    });
  }
}
