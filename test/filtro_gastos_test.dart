import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Backend de gastos falso con tres gastos sembrados: dos de comida y uno de
/// transporte.
class _Backend implements HttpClientAdapter {
  /// Cada prueba recibe un usuario distinto para abrir su propia caja de Hive.
  static var _usuarios = 0;
  final idUsuario = ++_usuarios;
  final gastos = <Map<String, dynamic>>[
    {'id': 1, 'descripcion': 'Almuerzo', 'monto': 6.5, 'categoria': 'comida', 'fecha': '2026-10-08'},
    {'id': 2, 'descripcion': 'Taxi', 'monto': 3.25, 'categoria': 'transporte', 'fecha': '2026-10-08'},
    {'id': 3, 'descripcion': 'Cena', 'monto': 12.0, 'categoria': 'comida', 'fecha': '2026-10-09'},
  ];

  ResponseBody _json(Object? cuerpo, int codigo, [Map<String, List<String>> h = const {}]) =>
      ResponseBody.fromString(jsonEncode(cuerpo), codigo,
          headers: {Headers.contentTypeHeader: ['application/json'], ...h});

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? cuerpo, Future<void>? cancelar) async {
    final ruta = o.path;
    if (ruta == '/usuarios/token') return _json({'access_token': 'tok-a@b.com', 'token_type': 'bearer'}, 200);
    if (ruta == '/usuarios/me') return _json({'id': idUsuario, 'email': 'a@b.com'}, 200);
    if (ruta == '/gastos/categorias') {
      return _json({'categorias': ['comida', 'transporte', 'entretenimiento', 'otros'], 'limite_por_categoria': 500.0}, 200);
    }
    if (ruta == '/gastos/' && o.method == 'GET') return _json(gastos, 200, {'x-total-count': ['${gastos.length}']});
    return _json({'detail': 'ruta no prevista en la prueba: $ruta'}, 404);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => Hive.init(Directory.systemTemp.createTempSync('hive_filtro').path));

  /// Monta la app con el backend falso, la sesión iniciada y los gastos cargados.
  Future<void> montar() async {
    Get.reset();
    Get.testMode = true;
    FlutterSecureStorage.setMockInitialValues({});
    final api = Get.put(ApiClient(dio: Dio(BaseOptions(baseUrl: 'http://backend'))..httpClientAdapter = _Backend()));
    final auth = Get.put(AuthController(api: api));
    await auth.iniciarSesion('a@b.com', 'clave-1234');
    final gastos = Get.put(GastosController());
    for (var i = 0; i < 200 && gastos.gastos.isEmpty; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> abrirGastos(WidgetTester tester) async {
    await tester.runAsync(montar);
    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await tester.pump();
  }

  testWidgets('Al elegir «comida» solo se ven los gastos de comida', (tester) async {
    await abrirGastos(tester);
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);
    expect(find.text('Taxi'), findsNothing);
  });

  testWidgets('«Todas» vuelve a mostrar todos los gastos', (tester) async {
    await abrirGastos(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();
    expect(find.text('Taxi'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);
  });
}
