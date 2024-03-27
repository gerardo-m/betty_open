class BettyRoutes{

  static const home = '/';
  static const events = '/events';
  static const finishedEvents = '/finished_events';
  static const predictions = '/predictions';
  static const groups = '/groups';
  static const profile = '/profile';
  static const settings = 'settings';

  /// This route accepts an String as an optional argument
  static const editEvent = '/edit_event';
  /// This route receives a Map with either 'id' or 'eventItemType'
  static const editEventItem = 'edit_event_item';
  static const singleMatch = '/single_match';
  static const editSingleMatch = '/edit_single_match';
  /// This route must receive a String with the event id
  static const publishedEvent = '/published_event';
  static const addParticipant = '/add_participant';
  static const editEventResults = '/edit_event_results';
  static const showEventResults = '/show_event_results';
  /// This route must receive a String with the event id
  static const calculateParticipantsRanking = '/calculate_participants_ranking';
  /// This route must receive a String with the event id
  static const showParticipantsRanking = '/show_participants_ranking';

  /// This route must receive a String with the event id
  static const editPrediction = '/edit_prediction';
  /// This route must receive a Map with 'id', 'eventItemType' and 'source'
  /// 'source' is of the type PredictionItemSource to distinguish between
  /// a prediction or an event result
  static const editPredictionItem = '/edit_prediction_item';
  /// This route must receive a String with the event id
  static const showPrediction = 'show_prediction';
  static const searchEvents = '/search_events';
  
  static const editGroup = '/edit_group';
  static const showGroup = '/show_group';
  static const searchGroups = '/search_groups';

  static const comingSoon = '/coming_soon';
}