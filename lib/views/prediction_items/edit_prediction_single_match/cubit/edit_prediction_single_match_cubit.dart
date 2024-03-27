import 'package:betty/models/prediction_item/prediction_single_match_item.dart';
import 'package:betty/services/prediction_items_service.dart';
import 'package:betty/utils/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'edit_prediction_single_match_state.dart';

class EditPredictionSingleMatchCubit extends Cubit<EditPredictionSingleMatchState> {

  final PredictionItemsService _predictionItemsService = GetIt.instance.get<PredictionItemsService>();
  PredictionSingleMatchItem? editingItem;

  EditPredictionSingleMatchCubit() : super(EditPredictionSingleMatchInitial());

  void loadPredictionItem(String id, PredictionItemSource source)async{
    _loading();
    await _predictionItemsService.loadPredictionItem(id, source);
    PredictionSingleMatchItem item = _predictionItemsService.currentEditingPredictionItem as PredictionSingleMatchItem;
    editingItem = PredictionSingleMatchItem.copyFrom(item);
    _emitEditingItem();
  }

  void changeWinner(SingleMatchWinner winner){
    editingItem!.winner = winner;
    _emitEditingItem();
  }

  void changeTieBreakerWinner(SingleMatchWinner winner){
    editingItem!.tieBreakerWinner = winner;
    _emitEditingItem();
  }

  void changeTeam1Score(int score){
    editingItem!.team1Score = score;
    _emitEditingItem();
  }

  void changeTeam2Score(int score){
    editingItem!.team2Score = score;
    _emitEditingItem();
  }

  void changeTeam1TieBreakerScore(int score){
    editingItem!.team1TieBreakerScore = score;
    _emitEditingItem();
  }

  void changeTeam2TieBreakerScore(int score){
    editingItem!.team2TieBreakerScore = score;
    _emitEditingItem();
  }

  void save(){
    PredictionSingleMatchItem item = _predictionItemsService.currentEditingPredictionItem as PredictionSingleMatchItem;
    item.team1Score = editingItem!.team1Score;
    item.team2Score = editingItem!.team2Score;
    item.winner = editingItem!.winner;
    item.team1TieBreakerScore = editingItem!.team1TieBreakerScore;
    item.team2TieBreakerScore = editingItem!.team2TieBreakerScore;
    item.tieBreakerWinner = editingItem!.tieBreakerWinner;
    item.adjustWinners();
  }

  void _emitEditingItem(){
    EPredictionSingleMatchItem predictionItem = editingItem!.toEPredictionItem() as EPredictionSingleMatchItem;//EPredictionSingleMatchItem(id: id, predictionId: '', eventItemId: '', team1: 'Team1Cubit', team2: 'Team2Cubit', includeScore: false, winner: SingleMatchWinner.team1, team1Score: 1, team2Score: 0);
    emit(EditPredictionSingleMatchValidState(predictionItem: predictionItem));
  }

  void _loading(){
    EditPredictionSingleMatchState currentState = state;
    if (currentState is EditPredictionSingleMatchValidState){
      emit(EditPredictionSingleMatchLoading(predictionItem: currentState.predictionItem)); 
    }
  }
}
