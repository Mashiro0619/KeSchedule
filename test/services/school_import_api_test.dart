import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sked/models/school_import_models.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/services/school_import_api.dart';

class _StreamingClient extends http.BaseClient {
  _StreamingClient(this.onSend);

  final Future<http.StreamedResponse> Function(http.BaseRequest request) onSend;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return onSend(request);
  }
}

class _DelayedResponseClient extends http.BaseClient {
  _DelayedResponseClient(this.delay);

  final Duration delay;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future<void>.delayed(delay);
    return http.StreamedResponse(const Stream<List<int>>.empty(), 200);
  }
}

Map<String, dynamic> _minimalCourseJson([String name = 'Imported Course']) {
  return {
    'name': name,
    'dayOfWeek': 1,
    'semesterWeeks': [1],
    'periods': [1],
    'startMinutes': 480,
    'endMinutes': 525,
  };
}

void main() {
  group('SchoolImportApi.buildResponseFromPhpDone', () {
    Map<String, dynamic> timetableJson() {
      return {
        'name': 'Spring Timetable',
        'startDate': '2026-02-23',
        'totalWeeks': 20,
        'periodTimeSet': {
          'name': 'Imported periods',
          'periodTimes': [
            {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
            {'index': 2, 'startMinutes': 535, 'endMinutes': 580},
          ],
        },
        'courses': [
          {
            'name': 'Algebra',
            'teacher': 'Lin',
            'location': 'A101',
            'dayOfWeek': 1,
            'semesterWeeks': [1, 2, 3],
            'periods': [1, 2],
            'startMinutes': 480,
            'endMinutes': 580,
            'credit': 2,
            'remarks': 'Lab',
            'customFields': {'campus': 'North'},
          },
        ],
      };
    }

    test(
      'preserves timetable fields from an official streaming done event',
      () {
        final response = SchoolImportApi.buildResponseFromPhpDone({
          'done': true,
          'ok': true,
          'meta': {
            'sourceUrl': 'https://example.test/timetable',
            'pageTitle': 'Timetable',
            'parser': 'official',
            'warnings': ['trimmed navigation'],
          },
          'timetable': timetableJson(),
        });

        expect(response.meta.sourceUrl, 'https://example.test/timetable');
        expect(response.meta.parser, 'official');
        expect(response.meta.warnings, ['trimmed navigation']);
        expect(response.timetable.name, 'Spring Timetable');
        expect(response.timetable.startDate, DateTime(2026, 2, 23));
        expect(response.timetable.totalWeeks, 20);
        expect(response.timetable.periodTimeSet.name, 'Imported periods');
        expect(response.timetable.periodTimeSet.periodTimes, hasLength(2));
        expect(response.timetable.periodTimeSet.periodTimes.first.index, 1);
        expect(response.timetable.courses.single.name, 'Algebra');
        expect(response.timetable.courses.single.teacher, 'Lin');
        expect(response.timetable.courses.single.periods, [1, 2]);
        expect(
          response.timetable.courses.single.customFields['campus'],
          'North',
        );
      },
    );

    test('accepts a bare timetable object from manual stream editing', () {
      final response = SchoolImportApi.buildResponseFromPhpDone(
        timetableJson(),
      );

      expect(response.timetable.name, 'Spring Timetable');
      expect(response.timetable.startDate, DateTime(2026, 2, 23));
      expect(response.timetable.periodTimeSet.periodTimes, hasLength(2));
      expect(response.timetable.courses.single.location, 'A101');
    });

    test('does not invent missing class or period times', () {
      final response = SchoolImportApi.buildResponseFromPhpDone({
        'done': true,
        'ok': true,
        'timetable': {
          'name': 'Untimed Timetable',
          'startDate': '2026-02-23',
          'periodTimeSet': {
            'name': 'Untimed periods',
            'periodTimes': [
              {'index': 1},
            ],
          },
          'courses': [
            {
              'name': 'Seminar',
              'dayOfWeek': 2,
              'semesterWeeks': [1],
              'periods': [1],
            },
          ],
        },
      });

      expect(response.timetable.periodTimeSet.periodTimes, isEmpty);
      expect(response.timetable.courses.single.startMinutes, 0);
      expect(response.timetable.courses.single.endMinutes, 0);
    });

    test('preserves error messages from failed done events', () {
      expect(
        () => SchoolImportApi.buildResponseFromPhpDone({
          'done': true,
          'ok': false,
          'message': 'No timetable found.',
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'No timetable found.',
          ),
        ),
      );
    });

    test('rejects wrapped done events with malformed timetable objects', () {
      expect(
        () => SchoolImportApi.buildResponseFromPhpDone({
          'done': true,
          'ok': true,
          'timetable': [
            {'name': 'Not a timetable object'},
          ],
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Import response format is invalid.',
          ),
        ),
      );
    });

    test('rejects done events without any timetable payload', () {
      expect(
        () => SchoolImportApi.buildResponseFromPhpDone({
          'done': true,
          'ok': true,
          'meta': {'parser': 'official'},
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Import response format is invalid.',
          ),
        ),
      );
    });

    test('rejects explicit empty-course timetable payloads', () {
      expect(
        () => SchoolImportApi.buildResponseFromPhpDone({
          'done': true,
          'ok': true,
          'timetable': {
            'name': 'Empty Course Timetable',
            'startDate': '2026-02-23',
            'courses': [],
          },
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Import response format is invalid.',
          ),
        ),
      );
    });
  });

  group('SchoolImportApi custom OpenAI streaming', () {
    test('model list request reports a timeout clearly', () async {
      final api = SchoolImportApi(
        requestTimeout: const Duration(milliseconds: 1),
        client: _DelayedResponseClient(const Duration(milliseconds: 50)),
      );

      expect(
        () => api.fetchCustomModels(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'sk-test',
        ),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Model list request timed out.',
          ),
        ),
      );
    });

    test('model list ignores entries without string ids', () async {
      final api = SchoolImportApi(
        client: _StreamingClient((request) async {
          return http.StreamedResponse(
            Stream<List<int>>.fromIterable([
              utf8.encode(
                jsonEncode({
                  'data': [
                    {'id': 'z-model'},
                    {'id': 42},
                    {'id': ' a-model '},
                    {'id': null},
                    {
                      'id': {'name': 'nested'},
                    },
                    'malformed',
                    {'id': 'z-model'},
                  ],
                }),
              ),
            ]),
            200,
          );
        }),
      );

      final models = await api.fetchCustomModels(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'sk-test',
      );

      expect(models, ['a-model', 'z-model']);
    });

    test('custom import ignores non-string message content parts', () async {
      final responseJson = {
        'ok': true,
        'meta': {
          'sourceUrl': '',
          'pageTitle': '',
          'parser': '',
          'warnings': [],
        },
        'timetable': {
          'name': 'Segmented Timetable',
          'startDate': '2026-02-23',
          'totalWeeks': 18,
          'periodTimeSet': {'name': '', 'periodTimes': []},
          'courses': [_minimalCourseJson('Segmented Course')],
        },
      };
      final encodedResponse = jsonEncode(responseJson);
      final splitAt = encodedResponse.indexOf('Segmented');
      final firstPart = encodedResponse.substring(0, splitAt);
      final secondPart = encodedResponse.substring(splitAt);
      final api = SchoolImportApi(
        client: _StreamingClient((request) async {
          return http.StreamedResponse(
            Stream<List<int>>.fromIterable([
              utf8.encode(
                jsonEncode({
                  'choices': [
                    {
                      'message': {
                        'content': [
                          {'type': 'output_text', 'text': firstPart},
                          {'type': 'output_text', 'text': 42},
                          {'type': 'output_text', 'text': secondPart},
                          {
                            'type': 'output_text',
                            'text': {'nested': 'bad'},
                          },
                        ],
                      },
                    },
                  ],
                }),
              ),
            ]),
            200,
          );
        }),
      );

      final result = await api.importCurrentPageWithRawResponse(
        const SchoolImportPagePayload(
          url: 'https://example.test/page',
          title: 'Example page',
          html: '<table>demo</table>',
          locale: 'zh',
          sourceHint: schoolImportParserSourceCustomOpenAi,
        ),
        parserSettings: const SchoolImportParserSettings(
          source: schoolImportParserSourceCustomOpenAi,
          customBaseUrl: 'https://api.example.com/v1',
          customApiKey: 'sk-test',
          customModel: 'gpt-4.1-mini',
        ),
      );

      expect(result.response.meta.sourceUrl, 'https://example.test/page');
      expect(result.response.meta.parser, 'custom-openai:gpt-4.1-mini');
      expect(result.response.timetable.name, 'Segmented Timetable');
    });

    test('custom import rejects error-shaped model responses', () async {
      final api = SchoolImportApi(
        client: _StreamingClient((request) async {
          return http.StreamedResponse(
            Stream<List<int>>.fromIterable([
              utf8.encode(
                jsonEncode({
                  'choices': [
                    {
                      'message': {
                        'content': jsonEncode({'error': 'No timetable'}),
                      },
                    },
                  ],
                }),
              ),
            ]),
            200,
          );
        }),
      );

      await expectLater(
        api.importCurrentPageWithRawResponse(
          const SchoolImportPagePayload(
            url: 'https://example.test/page',
            title: 'Example page',
            html: '<table>demo</table>',
            locale: 'zh',
            sourceHint: schoolImportParserSourceCustomOpenAi,
          ),
          parserSettings: const SchoolImportParserSettings(
            source: schoolImportParserSourceCustomOpenAi,
            customBaseUrl: 'https://api.example.com/v1',
            customApiKey: 'sk-test',
            customModel: 'gpt-4.1-mini',
          ),
        ),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Import response parse failed.\n\nNo timetable',
          ),
        ),
      );
    });

    test('official stream reports connection timeout clearly', () async {
      final api = const SchoolImportApi(
        requestTimeout: Duration(milliseconds: 1),
      );
      final client = _DelayedResponseClient(const Duration(milliseconds: 50));

      final events = await api
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
            ),
            client: client,
          )
          .toList();

      expect(events, hasLength(1));
      expect(events.single, isA<ParseError>());
      expect(
        (events.single as ParseError).message,
        'Import request timed out.',
      );
    });

    test('official stream reports idle stream timeout clearly', () async {
      final api = const SchoolImportApi(
        streamIdleTimeout: Duration(milliseconds: 1),
      );
      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.periodic(
            const Duration(milliseconds: 50),
            (_) => utf8.encode(''),
          ),
          200,
        );
      });

      final events = await api
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
            ),
            client: client,
          )
          .toList();

      expect(events, hasLength(1));
      expect(events.single, isA<ParseError>());
      expect((events.single as ParseError).message, 'Import stream timed out.');
    });

    test(
      'official stream times out while reading non-2xx error bodies',
      () async {
        final api = const SchoolImportApi(
          streamIdleTimeout: Duration(milliseconds: 1),
        );
        final client = _StreamingClient((request) async {
          return http.StreamedResponse(
            Stream<List<int>>.periodic(
              const Duration(milliseconds: 50),
              (_) => utf8.encode('still failing'),
            ),
            500,
          );
        });

        final events = await api
            .importCurrentPageStream(
              const SchoolImportPagePayload(
                url: 'https://example.test/page',
                title: 'Example page',
                html: '<table>demo</table>',
                locale: 'zh',
              ),
              client: client,
            )
            .toList();

        expect(events, hasLength(1));
        expect(events.single, isA<ParseError>());
        expect(
          (events.single as ParseError).message,
          'Import error response timed out.',
        );
      },
    );

    test('official stream truncates oversized non-2xx error bodies', () async {
      final oversizedBody = 'x' * (40 * 1024);
      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(oversizedBody)]),
          500,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
            ),
            client: client,
          )
          .toList();

      final message = (events.single as ParseError).message;
      expect(message, startsWith('Import request failed (500).'));
      expect(message, contains('[response body truncated]'));
      expect(message.length, lessThan(34 * 1024));
    });

    test('official stream handles non-string delta and error values', () async {
      final ndjson =
          '${jsonEncode({'delta': 42})}\n'
          '${jsonEncode({'error': 42})}\n';
      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(ndjson)]),
          200,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
            ),
            client: client,
          )
          .toList();

      expect(events.whereType<ParseDelta>().single.text, '');
      expect(events.whereType<ParseError>().single.message, 'Unknown error');
    });

    test('requests JSON mode and parses fenced streamed JSON', () async {
      late Map<String, dynamic> capturedBody;
      late Map<String, String> capturedHeaders;

      final responseJson = {
        'ok': true,
        'meta': {
          'sourceUrl': '',
          'pageTitle': '',
          'parser': '',
          'warnings': [],
        },
        'timetable': {
          'name': 'Streamed Timetable',
          'startDate': '2026-02-23',
          'totalWeeks': 18,
          'periodTimeSet': {'name': '', 'periodTimes': []},
          'courses': [
            {
              'name': 'Streamed Course',
              'teacher': '',
              'location': '',
              'dayOfWeek': 1,
              'semesterWeeks': [1],
              'periods': [1],
              'startMinutes': 0,
              'endMinutes': 0,
              'credit': 0,
              'remarks': '',
              'customFields': {},
            },
          ],
        },
      };
      final streamedContent = '```json\n${jsonEncode(responseJson)}\n```';
      final sseBody =
          'data: ${jsonEncode({
            'choices': [
              {
                'delta': {'content': streamedContent},
              },
            ],
          })}\n\n'
          'data: [DONE]\n\n';

      final client = _StreamingClient((request) async {
        capturedHeaders = request.headers;
        capturedBody =
            jsonDecode((request as http.Request).body) as Map<String, dynamic>;
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(sseBody)]),
          200,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
              sourceHint: schoolImportParserSourceCustomOpenAi,
            ),
            parserSettings: const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
            client: client,
          )
          .toList();

      expect(capturedHeaders['authorization'], 'Bearer sk-test');
      expect(capturedBody['stream'], isTrue);
      expect(capturedBody['response_format']['type'], 'json_object');
      expect(events.whereType<ParseError>(), isEmpty);
      expect(
        events.whereType<ParseDelta>().map((event) => event.text).join(),
        streamedContent,
      );
      final done = events.whereType<ParseDone>().single;
      expect(done.response.meta.sourceUrl, 'https://example.test/page');
      expect(done.response.meta.parser, 'custom-openai:gpt-4.1-mini');
      expect(done.response.timetable.name, 'Streamed Timetable');
      expect(done.response.timetable.courses.single.name, 'Streamed Course');
    });

    test('custom stream rejects EOF before done marker', () async {
      final responseJson = {
        'ok': true,
        'timetable': {
          'name': 'Truncated Timetable',
          'startDate': '2026-02-23',
          'courses': [],
        },
      };
      final sseBody =
          'data: ${jsonEncode({
            'choices': [
              {
                'delta': {'content': jsonEncode(responseJson)},
              },
            ],
          })}\n\n';
      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(sseBody)]),
          200,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
              sourceHint: schoolImportParserSourceCustomOpenAi,
            ),
            parserSettings: const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
            client: client,
          )
          .toList();

      expect(events.whereType<ParseDone>(), isEmpty);
      final error = events.whereType<ParseError>().single;
      expect(error.message, 'Connection closed unexpectedly.');
    });

    test('custom stream parses array content delta parts', () async {
      final responseJson = {
        'ok': true,
        'meta': {
          'sourceUrl': '',
          'pageTitle': '',
          'parser': '',
          'warnings': [],
        },
        'timetable': {
          'name': 'Segmented Stream Timetable',
          'startDate': '2026-02-23',
          'totalWeeks': 18,
          'periodTimeSet': {'name': '', 'periodTimes': []},
          'courses': [_minimalCourseJson('Segmented Stream Course')],
        },
      };
      final encodedResponse = jsonEncode(responseJson);
      final splitAt = encodedResponse.indexOf('Segmented');
      final firstPart = encodedResponse.substring(0, splitAt);
      final secondPart = encodedResponse.substring(splitAt);
      final sseBody =
          'data: ${jsonEncode({
            'choices': [
              {
                'delta': {
                  'content': [
                    {'type': 'output_text', 'text': firstPart},
                    {'type': 'output_text', 'text': 42},
                    {'type': 'output_text', 'text': secondPart},
                    {
                      'type': 'output_text',
                      'text': {'nested': 'bad'},
                    },
                  ],
                },
              },
            ],
          })}\n\n'
          'data: [DONE]\n\n';

      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(sseBody)]),
          200,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
              sourceHint: schoolImportParserSourceCustomOpenAi,
            ),
            parserSettings: const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
            client: client,
          )
          .toList();

      expect(events.whereType<ParseError>(), isEmpty);
      expect(
        events.whereType<ParseDelta>().map((event) => event.text).join(),
        encodedResponse,
      );
      final done = events.whereType<ParseDone>().single;
      expect(done.response.meta.sourceUrl, 'https://example.test/page');
      expect(done.response.meta.parser, 'custom-openai:gpt-4.1-mini');
      expect(done.response.timetable.name, 'Segmented Stream Timetable');
    });

    test('falls back when custom stream meta fields are malformed', () async {
      final responseJson = {
        'ok': true,
        'meta': {
          'sourceUrl': 42,
          'pageTitle': ['bad'],
          'parser': 42,
          'warnings': 'bad',
        },
        'timetable': {
          'name': 'Malformed Meta Timetable',
          'startDate': '2026-02-23',
          'totalWeeks': 18,
          'periodTimeSet': {'name': '', 'periodTimes': []},
          'courses': [_minimalCourseJson('Malformed Meta Course')],
        },
      };
      final sseBody =
          'data: ${jsonEncode({
            'choices': [
              {
                'delta': {'content': jsonEncode(responseJson)},
              },
            ],
          })}\n\n'
          'data: [DONE]\n\n';

      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(sseBody)]),
          200,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
              sourceHint: schoolImportParserSourceCustomOpenAi,
            ),
            parserSettings: const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
            client: client,
          )
          .toList();

      expect(events.whereType<ParseError>(), isEmpty);
      final done = events.whereType<ParseDone>().single;
      expect(done.response.meta.sourceUrl, 'https://example.test/page');
      expect(done.response.meta.pageTitle, 'Example page');
      expect(done.response.meta.parser, 'custom-openai:gpt-4.1-mini');
      expect(done.response.meta.warnings, isEmpty);
    });

    test('custom stream reports response parse failures clearly', () async {
      final responseJson = {
        'ok': false,
        'message': 'No timetable found.',
        'meta': {
          'sourceUrl': '',
          'pageTitle': '',
          'parser': '',
          'warnings': [],
        },
        'timetable': {
          'name': '',
          'startDate': '',
          'totalWeeks': 18,
          'periodTimeSet': {'name': '', 'periodTimes': []},
          'courses': [],
        },
      };
      final sseBody =
          'data: ${jsonEncode({
            'choices': [
              {
                'delta': {'content': jsonEncode(responseJson)},
              },
            ],
          })}\n\n'
          'data: [DONE]\n\n';

      final client = _StreamingClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([utf8.encode(sseBody)]),
          200,
        );
      });

      final events = await const SchoolImportApi()
          .importCurrentPageStream(
            const SchoolImportPagePayload(
              url: 'https://example.test/page',
              title: 'Example page',
              html: '<table>demo</table>',
              locale: 'zh',
              sourceHint: schoolImportParserSourceCustomOpenAi,
            ),
            parserSettings: const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
            client: client,
          )
          .toList();

      expect(events.whereType<ParseDone>(), isEmpty);
      final error = events.whereType<ParseError>().single;
      expect(error.message, startsWith('Import response parse failed.'));
      expect(error.message, contains('No timetable found.'));
      expect(error.message, isNot(contains('Unable to connect')));
    });
  });
}
