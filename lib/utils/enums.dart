enum EventItemType { 
  singleMatch(label: 'Partido simple'), positionsTable(label: 'Tabla de posiciones');
  
  const EventItemType({required this.label});
  final String label;
}
enum EventStatus {
  open(label: 'Abierto'), closed(label: 'Cerrado'), finished(label: 'Finalizado');

  const EventStatus({required this.label});
  final String label;
}
enum GroupAddOptions { create, search}
enum AuthenticationMethod {anonymous, google}

enum PredictionItemSource {prediction, eventResult}