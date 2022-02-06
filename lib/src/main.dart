abstract class IRegBuild {
  String build();
  String get source;

  RegExp reg() => RegExp(source, unicode: true);

  /// Parses input and returns found capture groups or null
  List<String>? match(String str) {
    final res = reg().allMatches(str).map((r) => r.group(0)!).toList();
    if (res.isEmpty) return null;
    return res;
  }

  bool test(String str) {
    return match(str)?.isNotEmpty ?? false;
  }
}

class RegSpan extends IRegBuild {
  final String pattern;
  RegSpan(this.pattern);

  @override
  String build() => pattern;

  @override
  String get source => pattern;
}

extension RegString on String {
  IRegBuild get r => RegBuild.fromString(this);
  IRegBuild get p => RegBuild.fromPattern(this);

  List<String>? match(IRegBuild reg) => reg.match(this);
}

class RegBuild {
  RegBuild._();

  static IRegBuild fromPattern(Pattern pattern) => RegSpan(pattern.toString());
  static IRegBuild fromNumber(int number) =>
      RegSpan('\\u{${number.toRadixString(16)}}');
  static IRegBuild fromString(String source) => RegSpan(
        source.replaceAllMapped(
          RegExp(r'([.*+?^${}()|[\]\\])'),
          (match) => '\\${match.group(0)}',
        ),
      );

  static fromIter(Iterable<IRegBuild> sources) =>
      sources.map((e) => e.build()).join();

  /// Makes regexp which includes only unicode category
  // static unicode_only( ... category: $mol_unicode_category ) {
  // 	return new RegBuild(
  // 		`\\p{${ category.join( '=' ) }}`
  // 	)
  // }

  /// Makes regexp which excludes unicode category
  // static unicode_except( ... category: $mol_unicode_category ) {
  // 	return new RegBuild(
  // 		`\\P{${ category.join( '=' ) }}`
  // 	)
  // }

  // static IRegBuild char_range(
  // 	from: number,
  // 	to: number,
  // ): RegBuild<{}> {
  // 	return new RegBuild(
  // 		`${ RegBuild.from( from ).source }-${ RegBuild.from( to ).source }`
  // 	)
  // }

  // static char_only(
  // 	... allowed: readonly [ RegBuild_source, ... RegBuild_source[] ]
  // ): RegBuild<{}> {
  // 	const regexp = allowed.map( f => RegBuild.from( f ).source ).join('')
  // 	return new RegBuild( `[${ regexp }]` )
  // }

  // static char_except(
  // 	... forbidden: readonly [ RegBuild_source, ... RegBuild_source[] ]
  // ): RegBuild<{}> {
  // 	const regexp = forbidden.map( f => RegBuild.from( f ).source ).join('')
  // 	return RegSpan( `[^${ regexp }]` );
  // }

  static final decimalOnly = r'\d'.p;
  static final decimalExcept = r'\D'.p;

  static final latinOnly = r'\w'.p;
  static final latinExcept = r'\W'.p;

  static final spaceOnly = r'\s'.p;
  static final spaceExcept = r'\S'.p;

  static final wordBreakOnly = r'\b'.p;
  static final wordBreakExcept = r'\B'.p;

  static final tab = r'\t'.p;
  static final slashBack = r'\\'.p;
  static final nul = r'\0'.p;

  static final charAny = r'.'.p;
  static final begin = r'^'.p;
  static final end = r'$'.p;
  static final or = r'|'.p;

  // static lineend = RegBuild.from({
  // 	win_end: [ [ '\r' ], '\n' ],
  // 	mac_end: '\r',
  // })
}

extension RegBuildHelper on IRegBuild {
  /// Makes regexp that non-greedy repeats this pattern from min to max count
  ///
  /// [greedy] - thats gready repeats
  IRegBuild repeat({
    int min = 0,
    int? max,
    bool greedy = false,
  }) {
    final upper = (max ?? '').toString();
    final grd = greedy ? '' : '?';

    final str = '(?:${build()}){$min,$upper}$grd';

    return RegSpan(str);
  }

  IRegBuild repeatGreedy({int min = 0, int? max}) =>
      repeat(min: min, max: max, greedy: true);

  /// Makes regexp that allow absent of this pattern
  IRegBuild optional() {
    return repeatGreedy(min: 0, max: 1);
  }

  /// Makes regexp that look ahead for pattern
  IRegBuild forceAfter() {
    return RegSpan('(?=${build()})');
  }

  /// Makes regexp that look ahead for pattern
  IRegBuild forbidAfter() {
    return RegSpan('(?!${build()})');
  }
}
