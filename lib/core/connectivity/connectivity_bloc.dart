import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'connectivity_service.dart';

part 'connectivity_bloc.freezed.dart';

@freezed
class ConnectivityEvent with _$ConnectivityEvent {
  const factory ConnectivityEvent.started() = _Started;
  const factory ConnectivityEvent.statusChanged(ConnectionStatus status) = _StatusChanged;
}

@freezed
class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState({
    @Default(ConnectionStatus.online) ConnectionStatus status,
  }) = _ConnectivityState;
}

@injectable
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectionStatus>? _subscription;

  ConnectivityBloc(this._connectivityService) : super(const ConnectivityState()) {
    on<_Started>(_onStarted);
    on<_StatusChanged>(_onStatusChanged);
  }

  void _onStarted(_Started event, Emitter<ConnectivityState> emit) {
    emit(state.copyWith(status: _connectivityService.currentStatus));
    _subscription = _connectivityService.statusStream.listen((status) {
      add(ConnectivityEvent.statusChanged(status));
    });
  }

  void _onStatusChanged(_StatusChanged event, Emitter<ConnectivityState> emit) {
    emit(state.copyWith(status: event.status));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
