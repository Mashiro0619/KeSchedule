import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/school_import_models.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/services/general_calendar_ics_service.dart';
import 'package:sked/services/import_export_service.dart';

void main() {
  const service = ImportExportService();

  GeneralEvent event({
    String id = 'event',
    String calendarId = 'cal',
    String title = 'Event',
  }) {
    return GeneralEvent(
      id: id,
      calendarId: calendarId,
      title: title,
      startDateTimeIso: '2026-05-25T09:00:00.000',
      endDateTimeIso: '2026-05-25T10:00:00.000',
    );
  }

  GeneralSchedule schedule({
    String id = 'cal',
    String name = 'Work',
    List<GeneralEvent> events = const [],
  }) {
    return GeneralSchedule(id: id, name: name, events: events);
  }

  GeneralScheduleData data({
    List<GeneralSchedule>? schedules,
    String activeScheduleId = 'cal',
    List<GeneralReminderAcknowledgement> acknowledgements = const [],
  }) {
    return GeneralScheduleData(
      activeScheduleId: activeScheduleId,
      schedules: schedules ?? [schedule()],
      reminderAcknowledgements: acknowledgements,
    );
  }

  String envelope(List<GeneralSchedule> schedules) {
    return encodeGeneralScheduleDataEnvelope(
      GeneralScheduleExportData(schedules: schedules),
    );
  }

  CourseItem course({
    String id = 'course',
    String name = 'Algebra',
    int dayOfWeek = 1,
    List<int> periods = const [1],
    int startMinutes = 8 * 60,
    int endMinutes = (8 * 60) + 45,
    Map<String, dynamic> customFields = const {},
  }) {
    return CourseItem(
      id: id,
      name: name,
      teacher: '',
      location: '',
      dayOfWeek: dayOfWeek,
      semesterWeeks: const [1],
      periods: periods,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      timeRange: buildTimeRange(startMinutes, endMinutes),
      credit: 0,
      remarks: '',
      customFields: customFields,
    );
  }

  PeriodTimeSet periodSet({
    String id = 'set1',
    String name = 'Set 1',
    List<CoursePeriodTime>? periodTimes,
  }) {
    return PeriodTimeSet(
      id: id,
      name: name,
      periodTimes: periodTimes ?? buildPeriodTimesForCount(2),
    );
  }

  TimetableData timetable({
    String id = 'table1',
    String name = 'Table 1',
    String periodTimeSetId = 'set1',
    List<CourseItem>? courses,
  }) {
    return TimetableData(
      id: id,
      config: TimetableConfig(
        name: name,
        startDate: DateTime(2026, 2, 23),
        totalWeeks: 18,
        periodTimeSetId: periodTimeSetId,
      ),
      courses: courses ?? [course()],
    );
  }

  StudentModeData studentData({
    List<TimetableData>? timetables,
    List<PeriodTimeSet>? periodTimeSets,
    String activeTimetableId = 'table1',
    Map<String, String> conflictDisplayCourseIds = const {},
    Map<String, int> courseNameColorValues = const {},
  }) {
    return StudentModeData(
      activeTimetableId: activeTimetableId,
      timetables: timetables ?? [timetable()],
      periodTimeSets: periodTimeSets ?? [periodSet()],
      conflictDisplayCourseIds: conflictDisplayCourseIds,
      courseNameColorValues: courseNameColorValues,
    );
  }

  String timetableEnvelope(TimetableExportData data) {
    return encodeTimetableDataEnvelope(data);
  }

  SchoolImportResponse schoolResponse({
    String timetableName = 'Imported school table',
    String periodSetName = 'Imported periods',
    List<Map<String, int>> periodTimes = const [
      {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
      {'index': 2, 'startMinutes': 530, 'endMinutes': 575},
    ],
    Map<String, dynamic> customFields = const {'courseCode': 'CS101'},
    List<int> periods = const [1],
    int startMinutes = 0,
    int endMinutes = 0,
  }) {
    return SchoolImportResponse(
      meta: const SchoolImportMeta(
        sourceUrl: 'https://example.test',
        pageTitle: 'Example',
        parser: 'test',
        warnings: [],
      ),
      timetable: SchoolImportTimetableDraft(
        name: timetableName,
        startDate: DateTime(2026, 2, 23),
        totalWeeks: 18,
        periodTimeSet: ImportedPeriodTimeSetDraft(
          name: periodSetName,
          periodTimes: [
            for (final item in periodTimes)
              ImportedPeriodTimeDraft(
                index: item['index']!,
                startMinutes: item['startMinutes']!,
                endMinutes: item['endMinutes']!,
              ),
          ],
        ),
        courses: [
          ImportedCourseDraft(
            name: 'Imported Course',
            teacher: 'Teacher',
            location: 'Room 1',
            dayOfWeek: 1,
            semesterWeeks: const [1, 2],
            periods: periods,
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            credit: 2,
            remarks: 'Remark',
            customFields: customFields,
          ),
        ],
      ),
    );
  }

  group('general JSON export', () {
    test('exports only selected calendars', () {
      final source = data(
        schedules: [
          schedule(id: 'work', name: 'Work'),
          schedule(id: 'home', name: 'Home'),
        ],
        activeScheduleId: 'work',
      );

      final exported = service.exportSelectedGeneralSchedulesJson(
        source,
        const ['home'],
        localeCode: defaultLocaleCode,
      );
      final decoded = decodeGeneralScheduleDataEnvelope(exported);

      expect(decoded.schedules, hasLength(1));
      expect(decoded.schedules.single.id, 'home');
    });

    test('throws when no selected calendar exists', () {
      expect(
        () => service.exportSelectedGeneralSchedulesJson(data(), const [
          'missing',
        ], localeCode: defaultLocaleCode),
        throwsFormatException,
      );
    });
  });

  group('general JSON import', () {
    test(
      'decodes general schedule envelope while ignoring malformed entries',
      () {
        final source = ImportExportEnvelope(
          schema: generalScheduleDataSchema,
          version: importExportVersion,
          data: {
            'schedules': [
              schedule(id: 'valid', name: 'Valid').toJson(),
              'bad',
              null,
            ],
          },
        ).encode();

        final decoded = decodeGeneralScheduleDataEnvelope(source);

        expect(decoded.schedules, hasLength(1));
        expect(decoded.schedules.single.id, 'valid');
      },
    );

    test('adds selected calendars as new and de-duplicates ids', () {
      final current = data(
        schedules: [schedule(id: 'work', name: 'Work')],
        activeScheduleId: 'work',
      );
      final source = envelope([
        schedule(id: 'work', name: 'Imported Work'),
        schedule(id: 'home', name: 'Imported Home'),
      ]);

      final mutation = service.importSelectedGeneralSchedulesJson(
        current,
        source,
        scheduleIds: const ['work', 'home'],
        mode: GeneralScheduleImportMode.addAsNew,
        localeCode: defaultLocaleCode,
      );

      expect(mutation.result.importedCount, 2);
      expect(mutation.result.scheduleNames, ['Imported Work', 'Imported Home']);
      expect(mutation.data.schedules, hasLength(3));
      expect(
        mutation.data.schedules.map((item) => item.id).toSet(),
        hasLength(3),
      );
      expect(mutation.data.activeScheduleId, mutation.data.schedules.last.id);
    });

    test(
      'replaces active calendar and clears its reminder acknowledgements',
      () {
        final current = data(
          schedules: [
            schedule(
              id: 'active',
              name: 'Active',
              events: [event(id: 'old', calendarId: 'active')],
            ),
          ],
          activeScheduleId: 'active',
          acknowledgements: const [
            GeneralReminderAcknowledgement(
              occurrenceKey: 'active|old|2026-05-25T09:00:00.000',
              updatedAtIso: '2026-05-25T08:55:00.000',
            ),
          ],
        );
        final source = envelope([
          schedule(
            id: 'replacement',
            name: 'Replacement',
            events: [event(id: 'new', calendarId: 'replacement')],
          ),
        ]);

        final mutation = service.importSelectedGeneralSchedulesJson(
          current,
          source,
          scheduleIds: const ['replacement'],
          mode: GeneralScheduleImportMode.replaceActive,
          localeCode: defaultLocaleCode,
        );

        expect(mutation.result.importedCount, 1);
        expect(mutation.data.activeScheduleId, 'active');
        expect(mutation.data.activeSchedule.name, 'Replacement');
        expect(mutation.data.activeSchedule.events.single.calendarId, 'active');
        expect(mutation.data.reminderAcknowledgements, isEmpty);
      },
    );

    test('throws when replace-active receives multiple calendars', () {
      final source = envelope([
        schedule(id: 'a', name: 'A'),
        schedule(id: 'b', name: 'B'),
      ]);

      expect(
        () => service.importSelectedGeneralSchedulesJson(
          data(),
          source,
          scheduleIds: const ['a', 'b'],
          mode: GeneralScheduleImportMode.replaceActive,
          localeCode: defaultLocaleCode,
        ),
        throwsFormatException,
      );
    });
  });

  group('general ICS import', () {
    test('imports warnings into the structured result', () {
      const source = '''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:test-warning
DTSTART:20260525T090000
DTEND:20260525T100000
SUMMARY:Imported
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR
''';

      final mutation = service.importGeneralSchedulesIcs(
        data(),
        source,
        mode: GeneralScheduleImportMode.addAsNew,
        localeCode: defaultLocaleCode,
      );

      expect(mutation.result.importedCount, 1);
      expect(mutation.result.icsWarnings, hasLength(1));
      expect(
        mutation.result.icsWarnings.single.code,
        GeneralCalendarIcsWarningCode.unsupportedFields,
      );
      expect(mutation.data.schedules, hasLength(2));
    });

    test('localizes empty ICS errors through locale code', () {
      expect(
        () => service.previewImportGeneralSchedulesIcs(
          'BEGIN:VCALENDAR\nEND:VCALENDAR',
          localeCode: 'zh',
        ),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            '导入文件没有日程。',
          ),
        ),
      );
    });
  });

  group('student JSON export', () {
    test('decodes period time envelope while ignoring malformed entries', () {
      final source = ImportExportEnvelope(
        schema: periodTimesSchema,
        version: importExportVersion,
        data: {
          'periodTimes': [
            const CoursePeriodTime(
              index: 1,
              startMinutes: 480,
              endMinutes: 525,
            ).toJson(),
            'bad',
            null,
          ],
        },
      ).encode();

      final decoded = decodePeriodTimesEnvelope(source);

      expect(decoded, hasLength(1));
      expect(decoded.single.index, 1);
    });

    test('exports selected timetables with linked period time sets', () {
      final source = studentData(
        timetables: [
          timetable(id: 'table1', name: 'A', periodTimeSetId: 'set1'),
          timetable(id: 'table2', name: 'B', periodTimeSetId: 'set2'),
        ],
        periodTimeSets: [
          periodSet(id: 'set1', name: 'Set A'),
          periodSet(id: 'set2', name: 'Set B'),
        ],
      );

      final exported = service.exportSelectedTimetablesJson(source, const [
        'table2',
      ], localeCode: defaultLocaleCode);
      final decoded = decodeTimetableDataEnvelope(exported);

      expect(decoded.timetables.map((item) => item.id), ['table2']);
      expect(decoded.periodTimeSets.map((item) => item.id), ['set2']);
    });
  });

  group('student JSON import', () {
    test('decodes app data envelope with malformed nested modes safely', () {
      final source = ImportExportEnvelope(
        schema: appDataSchema,
        version: importExportVersion,
        data: {
          'activeMode': 'student',
          'studentMode': 'bad',
          'generalMode': 'bad',
          'themeSeedColorValue': 'bad',
          'colorfulUiColorValues': {'ok': 0xFF123456, 'bad': 'nope'},
        },
      ).encode();

      final decoded = decodeAppDataEnvelope(source);

      expect(decoded.studentMode.timetables, isEmpty);
      expect(decoded.generalMode.schedules, isNotEmpty);
      expect(decoded.themeSeedColorValue, defaultThemeSeedColorValue);
      expect(decoded.colorfulUiColorValues, {'ok': 0xFF123456});
    });

    test('normalizes duplicate student ids and stale display preferences', () {
      final duplicateData = AppData(
        activeMode: AppMode.student,
        studentMode: StudentModeData(
          activeTimetableId: 'dup',
          timetables: [
            timetable(
              id: 'dup',
              name: 'First',
              periodTimeSetId: 'set',
              courses: [
                course(
                  id: 'course',
                  name: 'Algebra',
                  startMinutes: 600,
                  endMinutes: 645,
                ).copyWith(timeRange: 'stale'),
              ],
            ),
            timetable(
              id: 'dup',
              name: 'Second',
              periodTimeSetId: 'set',
              courses: [course(id: 'course', name: 'Physics')],
            ),
          ],
          periodTimeSets: [
            periodSet(id: 'set'),
            periodSet(id: 'set'),
          ],
          conflictDisplayCourseIds: const {
            'dup|1|480|525|course,missing': 'course',
            'bad-key': 'course',
          },
        ),
        generalMode: GeneralScheduleData.createDefault(),
      );

      final normalized = service.normalizeAppData(
        duplicateData,
        localeCode: defaultLocaleCode,
      );

      expect(
        normalized.studentMode.timetables.map((item) => item.id).toSet(),
        hasLength(2),
      );
      expect(
        normalized.studentMode.periodTimeSets.map((item) => item.id).toSet(),
        hasLength(2),
      );
      expect(
        normalized.studentMode.timetables
            .expand((item) => item.courses)
            .map((item) => item.id)
            .toSet(),
        hasLength(2),
      );
      expect(normalized.studentMode.activeTimetableId, 'dup');
      expect(
        normalized.studentMode.timetables.first.courses.single.timeRange,
        '10:00 - 10:45',
      );
      expect(normalized.studentMode.conflictDisplayCourseIds, isEmpty);
    });

    test('keeps preview ids stable for files with missing timetable ids', () {
      final source = timetableEnvelope(
        TimetableExportData(
          timetables: [
            timetable(id: '', name: 'First', periodTimeSetId: ''),
            timetable(id: '', name: 'Second', periodTimeSetId: ''),
          ],
          periodTimeSets: const [],
        ),
      );
      final preview = service.previewImportTimetables(
        source,
        localeCode: defaultLocaleCode,
      );

      final mutation = service.importSelectedTimetablesJson(
        studentData(timetables: const [], activeTimetableId: ''),
        source,
        timetableIds: [preview.last.id],
        mode: TimetableImportMode.addAsNew,
        localeCode: defaultLocaleCode,
      );

      expect(preview.map((item) => item.id), ['table', 'table_1']);
      expect(mutation.importedCount, 1);
      expect(mutation.selectedTimetable!.config.name, 'Second');
    });

    test('adds selected timetable as new and maps bundled period set ids', () {
      final current = studentData(
        timetables: [
          timetable(
            id: 'table1',
            name: 'Current',
            courses: [course(id: 'current_course', name: 'Algebra')],
          ),
        ],
        periodTimeSets: [periodSet(id: 'set1')],
      );
      final source = timetableEnvelope(
        TimetableExportData(
          timetables: [
            timetable(
              id: 'table1',
              name: 'Imported',
              periodTimeSetId: 'set1',
              courses: [course(id: 'imported_course', name: 'Physics')],
            ),
          ],
          periodTimeSets: [periodSet(id: 'set1', name: 'Imported Set')],
        ),
      );

      final mutation = service.importSelectedTimetablesJson(
        current,
        source,
        timetableIds: const ['table1'],
        mode: TimetableImportMode.addAsNew,
        localeCode: defaultLocaleCode,
      );

      final appended = mutation.selectedTimetable!;
      expect(mutation.importedCount, 1);
      expect(mutation.data.timetables, hasLength(2));
      expect(mutation.data.periodTimeSets, hasLength(2));
      expect(appended.id, isNot('table1'));
      expect(appended.config.periodTimeSetId, isNot('set1'));
      expect(
        mutation.data.periodTimeSets.map((item) => item.id),
        contains(appended.config.periodTimeSetId),
      );
      expect(mutation.data.activeTimetableId, appended.id);
      expect(mutation.data.courseNameColorValues.keys, contains('Physics'));
    });

    test('adds imported timetables with globally unique course ids', () {
      final current = studentData(
        timetables: [
          timetable(
            id: 'current',
            courses: [course(id: 'dup', name: 'Current')],
          ),
        ],
      );
      final source = timetableEnvelope(
        TimetableExportData(
          timetables: [
            timetable(
              id: 'imported',
              periodTimeSetId: 'import_set',
              courses: [
                course(id: 'dup', name: 'Imported A'),
                course(id: 'dup', name: 'Imported B'),
              ],
            ),
          ],
          periodTimeSets: [periodSet(id: 'import_set')],
        ),
      );

      final mutation = service.importSelectedTimetablesJson(
        current,
        source,
        timetableIds: const ['imported'],
        mode: TimetableImportMode.addAsNew,
        localeCode: defaultLocaleCode,
      );

      final allCourseIds = mutation.data.timetables
          .expand((item) => item.courses)
          .map((item) => item.id)
          .toList();
      expect(allCourseIds.toSet(), hasLength(allCourseIds.length));
      expect(mutation.selectedTimetable!.courses.map((item) => item.id), [
        'dup_copy',
        'dup_copy_1',
      ]);
    });

    test('replaces active timetable and can reuse an existing period set', () {
      final current = studentData(
        timetables: [
          timetable(
            id: 'active',
            name: 'Current',
            courses: [course(id: 'old', name: 'Old')],
          ),
          timetable(
            id: 'other',
            name: 'Other',
            courses: [course(id: 'shared', name: 'Other')],
          ),
        ],
        periodTimeSets: [
          periodSet(id: 'set1'),
          periodSet(id: 'set2', name: 'Manual Target'),
        ],
        activeTimetableId: 'active',
        conflictDisplayCourseIds: const {
          'active|1|480|525|old,another': 'old',
          'other|1|480|525|shared': 'shared',
        },
      );
      final source = timetableEnvelope(
        TimetableExportData(
          timetables: [
            timetable(
              id: 'imported',
              name: 'Replacement',
              periodTimeSetId: 'import_set',
              courses: [course(id: 'shared', name: 'Replacement Course')],
            ),
          ],
          periodTimeSets: [periodSet(id: 'import_set')],
        ),
      );

      final mutation = service.importSelectedTimetablesJson(
        current,
        source,
        timetableIds: const ['imported'],
        mode: TimetableImportMode.replaceActive,
        localeCode: defaultLocaleCode,
        importBundledPeriodTimeSets: false,
        targetPeriodTimeSetId: 'set2',
      );

      expect(mutation.importedCount, 1);
      expect(mutation.data.periodTimeSets, hasLength(2));
      expect(mutation.data.activeTimetableId, 'active');
      expect(mutation.selectedTimetable!.id, 'active');
      expect(mutation.selectedTimetable!.config.name, 'Replacement');
      expect(mutation.selectedTimetable!.config.periodTimeSetId, 'set2');
      expect(mutation.selectedTimetable!.courses.single.id, 'shared_copy');
      expect(mutation.data.conflictDisplayCourseIds, {
        'other|1|480|525|shared': 'shared',
      });
    });

    test(
      'preserves existing course colors and adds colors for new courses',
      () {
        final current = studentData(
          courseNameColorValues: const {'Algebra': 0xFF123456},
        );
        final source = timetableEnvelope(
          TimetableExportData(
            timetables: [
              timetable(
                id: 'imported',
                periodTimeSetId: 'import_set',
                courses: [
                  course(id: 'a', name: 'Algebra'),
                  course(id: 'b', name: 'Physics'),
                ],
              ),
            ],
            periodTimeSets: [periodSet(id: 'import_set')],
          ),
        );

        final mutation = service.importSelectedTimetablesJson(
          current,
          source,
          timetableIds: const ['imported'],
          mode: TimetableImportMode.addAsNew,
          localeCode: defaultLocaleCode,
        );

        expect(mutation.data.courseNameColorValues['Algebra'], 0xFF123456);
        expect(mutation.data.courseNameColorValues['Physics'], isNotNull);
        expect(
          mutation.data.courseNameColorValues['Physics'],
          isNot(0xFF123456),
        );
      },
    );
  });

  group('school import apply', () {
    test('adds as new with bundled periods and preserves custom fields', () {
      final current = studentData();

      final mutation = service.applySchoolImportRequest(
        current,
        SchoolImportApplyRequest(
          response: schoolResponse(),
          mode: TimetableImportMode.addAsNew,
          importBundledPeriodTimeSet: true,
        ),
        localeCode: defaultLocaleCode,
      );

      final imported = mutation.selectedTimetable!;
      final importedSet = mutation.data.periodTimeSets.firstWhere(
        (item) => item.id == imported.config.periodTimeSetId,
      );
      expect(mutation.data.timetables, hasLength(2));
      expect(mutation.data.periodTimeSets, hasLength(2));
      expect(imported.config.name, 'Imported school table');
      expect(imported.courses.single.customFields['courseCode'], 'CS101');
      expect(imported.courses.single.startMinutes, 480);
      expect(imported.courses.single.endMinutes, 525);
      expect(importedSet.name, 'Imported periods');
      expect(importedSet.periodTimes, hasLength(2));
    });

    test('sanitizes malformed school imported periods and time ranges', () {
      final current = studentData();

      final mutation = service.applySchoolImportRequest(
        current,
        SchoolImportApplyRequest(
          response: schoolResponse(
            periods: const [2, 2, -1, 99],
            startMinutes: 2000,
            endMinutes: -5,
          ),
          mode: TimetableImportMode.addAsNew,
          importBundledPeriodTimeSet: true,
        ),
        localeCode: defaultLocaleCode,
      );

      final course = mutation.selectedTimetable!.courses.single;
      expect(course.periods, [2]);
      expect(course.startMinutes, 530);
      expect(course.endMinutes, 575);
      expect(course.timeRange, '08:50 - 09:35');
    });

    test('adds as new without bundled periods by reusing target set', () {
      final current = studentData(
        periodTimeSets: [
          periodSet(id: 'set1'),
          periodSet(id: 'set2', name: 'Manual Target'),
        ],
      );

      final mutation = service.applySchoolImportRequest(
        current,
        SchoolImportApplyRequest(
          response: schoolResponse(),
          mode: TimetableImportMode.addAsNew,
          importBundledPeriodTimeSet: false,
          targetPeriodTimeSetId: 'set2',
        ),
        localeCode: defaultLocaleCode,
      );

      expect(mutation.data.periodTimeSets.map((item) => item.id), [
        'set1',
        'set2',
      ]);
      expect(mutation.selectedTimetable!.config.periodTimeSetId, 'set2');
    });

    test(
      'keeps school imported course time unknown when nothing can resolve it',
      () {
        final current = studentData(
          periodTimeSets: [
            periodSet(id: 'set1'),
            periodSet(id: 'set2', name: 'Manual Target'),
          ],
        );

        final mutation = service.applySchoolImportRequest(
          current,
          SchoolImportApplyRequest(
            response: schoolResponse(
              periodTimes: const [],
              periods: const [],
              startMinutes: 0,
              endMinutes: 0,
            ),
            mode: TimetableImportMode.addAsNew,
            importBundledPeriodTimeSet: false,
            targetPeriodTimeSetId: 'set2',
          ),
          localeCode: defaultLocaleCode,
        );

        final course = mutation.selectedTimetable!.courses.single;
        expect(course.periods, isEmpty);
        expect(course.startMinutes, 0);
        expect(course.endMinutes, 0);
        expect(course.timeRange, '00:00 - 00:00');
      },
    );

    test('replaces active timetable and appends bundled periods', () {
      final current = studentData(
        timetables: [timetable(id: 'active', name: 'Current')],
        activeTimetableId: 'active',
      );

      final mutation = service.applySchoolImportRequest(
        current,
        SchoolImportApplyRequest(
          response: schoolResponse(
            timetableName: 'Replacement',
            customFields: const {'source': 'replace'},
          ),
          mode: TimetableImportMode.replaceActive,
          importBundledPeriodTimeSet: true,
        ),
        localeCode: defaultLocaleCode,
      );

      expect(mutation.data.timetables, hasLength(1));
      expect(mutation.data.periodTimeSets, hasLength(2));
      expect(mutation.data.activeTimetableId, 'active');
      expect(mutation.selectedTimetable!.id, 'active');
      expect(mutation.selectedTimetable!.config.name, 'Replacement');
      expect(
        mutation.selectedTimetable!.courses.single.customFields['source'],
        'replace',
      );
    });
  });
}
