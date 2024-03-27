
import 'package:betty/models/prediction_item/prediction_positions_table_item.dart';
import 'package:betty/services/prediction_items_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'edit_prediction_positions_table_state.dart';

class EditPredictionPositionsTableCubit extends Cubit<EditPredictionPositionsTableState> {

  final PredictionItemsService _predictionItemsService = GetIt.instance.get<PredictionItemsService>();
  PredictionPositionsTableItem? _editingItem;

  EditPredictionPositionsTableCubit() : super(EditPredictionPositionsTableInitial());

  void loadPredictionItem(String id, PredictionItemSource source)async{
    _loading();
    await _predictionItemsService.loadPredictionItem(id, source);
    PredictionPositionsTableItem item = _predictionItemsService.currentEditingPredictionItem as PredictionPositionsTableItem;
    _editingItem = PredictionPositionsTableItem.copyFrom(item);
    _emitEditingItem();
  }

  void reorder(int oldIndex, int newIndex){
    TeamWithPoints oldValue = _editingItem!.teams.removeAt(oldIndex);
    _editingItem!.teams.insert(newIndex, oldValue);
    _editingItem!.teams = _editingItem!.teams.toList();
    _emitEditingItem();
  }

  void sort(){
    _editingItem!.teams.sort();
    _emitEditingItem();
  }

  void changePoints(int index, int newValue){
    _editingItem!.teams[index] = _editingItem!.teams[index].copyWith(points: newValue);
  }

  void reloadEditingItem(){
    _emitEditingItem();
  }

  void save(){
    if (_editingItem!.includePoints){
      sort();
    }
    PredictionPositionsTableItem item = _predictionItemsService.currentEditingPredictionItem as PredictionPositionsTableItem;
    item.teams = _editingItem!.teams;
  }

  void _emitEditingItem(){
    EPredictionPositionsTableItem predictionItem = _editingItem!.toEPredictionPositionsTableItem();
    emit(EditPredictionPositionsTableValidState(item: predictionItem));
  }

  void _loading(){
    EditPredictionPositionsTableState currentState = state;
    if (currentState is EditPredictionPositionsTableValidState){
      emit(EditPredictionPositionsTableLoading(item: currentState.item));
    }
  }
}
