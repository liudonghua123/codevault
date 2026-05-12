import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codevault/app.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CodeVaultApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}