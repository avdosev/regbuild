import 'package:regbuild/regbuild.dart';
import 'package:test/test.dart';

void main() {
  group('small exp', () {
    test('escape', () {
      final specials = '.*+?^\${}()|[]\\'.r;
      expect(specials.source, '\\.\\*\\+\\?\\^\\\$\\{\\}\\(\\)\\|\\[\\]\\\\');
    });
    test('char code', () {
      final space = RegBuild.fromNumber(32);
      expect(space.match(' '), [' ']);
    });

    test('repeat fixed', () {
      final year = RegBuild.decimalOnly.repeat(min: 4, max: 4);
      expect(year.match('#2020#3210*abdc#'), ['2020', '3210']);
    });

    // test('greedy repeat', () {

    // 	final { repeat , repeat_greedy , latin_only: letter } = $mol_regexp

    // 	expect( 'abc'.match( repeat( letter, 1, 2 ) ) , [ 'a', 'b', 'c' ] )
    // 	expect( 'abc'.match( repeat_greedy( letter, 1, 2 ) ) , [ 'ab', 'c' ] )

    // });

    test('repeat range', () {
      final year = RegBuild.decimalOnly.repeatGreedy(min: 2, max: 4);

      expect('#2#'.match(year), null);
      expect('#20#'.match(year), ['20']);
      expect('#2020#'.match(year), ['2020']);
      expect('#20201#'.match(year), ['2020']);
    });

    test('repeat from', () {
    	final name = RegBuild.latinOnly.repeatGreedy( min:  2 );

    	expect( '##'.match( name ) , null );
    	expect( '#a#'.match( name ) , null );
    	expect( '#ab#'.match( name ) , [ 'ab' ] );
    	expect( '#abc#'.match( name ) , [ 'abc' ] );

    });

    // test('from string', () {

    // 	final regexp = $mol_regexp.from( '[\\d]' )

    // 	$mol_assert_equal( regexp.source , '\\[\\\\d\\]' )
    // 	$mol_assert_equal( regexp.flags , 'gsu' )

    // });

    // test('from regexp', () {

    // 	final regexp = $mol_regexp.from( /[\d]/i )

    // 	$mol_assert_equal( regexp.source , '[\\d]' )
    // 	$mol_assert_equal( regexp.flags , 'i' )

    // });

    // test('split', () {

    // 	final regexp = $mol_regexp.from( ';' )

    // 	expect( 'aaa;bbb;ccc'.split( regexp ) , [ 'aaa', ';', 'bbb', ';', 'ccc' ] )
    // 	expect( 'aaa;;ccc'.split( regexp ) , [ 'aaa', ';', '', ';', 'ccc' ] )
    // 	expect( 'aaa'.split( regexp ) , [ 'aaa' ] )
    // 	expect( ''.split( regexp ) , [''] )

    // });

    test('test for matching', () {

    	final regexp = 'foo'.r;

    	expect( regexp.test( '' ) , false );
    	expect( regexp.test( 'fo' ) , false );
    	expect( regexp.test( 'foo' ) , true );
    	expect( regexp.test( 'foobar' ) , true );
    	expect( regexp.test( 'barfoo' ) , true );

    });

    // test('case ignoring', () {

    // 	final xxx = $mol_regexp.from( 'x' , { ignoreCase : true } )

    // 	expect( xxx.flags , 'gisu' )
    // 	expect( xxx.exec( 'xx' )![0] , 'x' )
    // 	expect( xxx.exec( 'XX' )![0] , 'X' )

    // });

    // test('multiline mode', () {

    // 	final { end , from } = $mol_regexp

    // 	final xxx = from( [ 'x' , end ] , { multiline : true } )

    // 	expect( xxx.exec( 'x\ny' )![0] , 'x' )
    // 	expect( xxx.flags , 'gmsu' )

    // });

    // test('flags override', () {

    // 	final triplet = $mol_regexp.from(
    // 		$mol_regexp.from(
    // 			/.../,
    // 			{ ignoreCase: true });
    // 		),
    // 		{ multiline: true });
    // 	)

    // 	expect( triplet.toString() , '/.../gmsu' )

    // });

    // test('sequence', () {

    // 	final { begin , end , decimal_only: digit , repeat , from } = $mol_regexp

    // 	final year = repeat( digit , 4 , 4 )
    // 	final dash = '-'
    // 	final month = repeat( digit , 2 , 2 )
    // 	final day = repeat( digit , 2 , 2 )

    // 	final date = from([ begin , year , dash , month , dash , day , end ])

    // 	expect( date.exec( '2020-01-02' )![0] , '2020-01-02' )

    // });

    // test('optional', () {

    // 	final name = $mol_regexp.from([ 'A', ['4'] ])

    // 	$mol_assert_equal( 'AB'.match( name )![0] , 'A' )
    // 	$mol_assert_equal( 'A4'.match( name )![0] , 'A4' )

    // });

    // test('only groups', () {

    // 	final regexp = $mol_regexp.from({ dog : '@' })

    // 	expect( [ ... '#'.matchAll( regexp ) ][0].groups , undefined )
    // 	expect( [ ... '@'.matchAll( regexp ) ][0].groups , { dog : '@' } )

    // });

    // test('catch skipped', () {

    // 	final regexp = $mol_regexp.from(/(@)(\d?)/g)

    // 	expect(
    // 		[ ... '[[@]]'.matchAll( regexp ) ].map( f => [ ... f ] ) ,
    // 		[
    // 			[ '[[' ],
    // 			[ '@', '@' , '' ],
    // 			[ ']]' ],
    // 		]
    // 	)

    // });

    // test('enum variants', () {

    // 	enum Sex {
    // 		male = 'male',
    // 		female = 'female',
    // 	}

    // 	final sexism = $mol_regexp.from( Sex )

    // 	expect( [ ... ''.matchAll( sexism ) ].length, 0 )
    // 	expect( [ ... 'trans'.matchAll( sexism ) ][0].groups, undefined )

    // 	expect(
    // 		[ ... 'male'.matchAll( sexism ) ][0].groups,
    // 		{ male : 'male' , female : '' });
    // 	)

    // 	expect(
    // 		[ ... 'female'.matchAll( sexism ) ][0].groups,
    // 		{ male : '' , female : 'female' });
    // 	)

    // });

    // test('recursive only groups', () {

    // 	enum Sex {
    // 		male = 'male',
    // 		female = 'female',
    // 	}

    // 	final sexism = $mol_regexp.from({ Sex })

    // 	expect( [ ... ''.matchAll( sexism ) ].length , 0 )

    // 	expect(
    // 		[ ... 'male'.matchAll( sexism ) ][0].groups,
    // 		{ Sex : 'male' , male : 'male' , female : '' });
    // 	)

    // 	expect(
    // 		[ ... 'female'.matchAll( sexism ) ][0].groups,
    // 		{ Sex : 'female' , male : '' , female : 'female' });
    // 	)

    // });

    // test('sequence with groups', () {

    // 	final { begin , end , decimal_only: digit , repeat , from } = $mol_regexp
    // 	final year = repeat( digit , 4 , 4 )
    // 	final dash = '-'
    // 	final month = repeat( digit , 2 , 2 )
    // 	final day = repeat( digit , 2 , 2 )

    // 	final regexp = from([ begin , {year} , dash , {month} , dash , {day} , end ])
    // 	final found = [ ... '2020-01-02'.matchAll( regexp ) ]

    // 	expect( found[0].groups , {
    // 		year : '2020' ,
    // 		month : '01' ,
    // 		day : '02' ,
    // 	} )

    // });

    // test('sequence with groups of mixed type', () {

    // 	final prefix = '/'
    // 	final postfix = '/'

    // 	final regexp = $mol_regexp.from([ {prefix} , /(\w+)/ , {postfix} , /([gumi]*)/ ])

    // 	expect(
    // 		[ ... '/foo/mi'.matchAll( regexp ) ],
    // 		[
    // 			Object.assign(
    // 				[ "/foo/mi", "/", "foo", "/", "mi" ],
    // 				{
    // 					groups: {
    // 						prefix : '/' ,
    // 						postfix : '/' ,
    // 					});
    // 					index: 0,
    // 					input: "/",
    // 				});
    // 			),
    // 		],
    // 	)

    // });

    // test('recursive sequence with groups', () {

    // 	final { begin , end , decimal_only: digit , repeat , from } = $mol_regexp
    // 	final year = repeat( digit , 4 , 4 )
    // 	final dash = '-'
    // 	final month = repeat( digit , 2 , 2 )
    // 	final day = repeat( digit , 2 , 2 )

    // 	final regexp = from([
    // 		begin , { date : [ {year} , dash , {month} ] } , dash , {day} , end
    // 	])

    // 	final found = [ ... '2020-01-02'.matchAll( regexp ) ]

    // 	expect( found[0].groups , {
    // 		date : '2020-01' ,
    // 		year : '2020' ,
    // 		month : '01' ,
    // 		day : '02' ,
    // 	} )

    // });

    // test('parse multiple', () {

    // 	final { decimal_only: digit , from } = $mol_regexp

    // 	final regexp = from({ digit })

    // 	expect(
    // 		[ ... '123'.matchAll( regexp ) ].map( f => f.groups ) ,
    // 		[
    // 			{ digit : '1' });
    // 			{ digit : '2' });
    // 			{ digit : '3' });
    // 		]
    // 	)

    // });

    // test('variants', () {

    // 	final { begin , or , end , from } = $mol_regexp

    // 	final sexism = from([
    // 		begin , 'sex = ' , { sex : [ 'male' , or , 'female' ] } , end
    // 	])

    // 	expect( [ ... 'sex = male'.matchAll( sexism ) ][0].groups , { sex : 'male' } )
    // 	expect( [ ... 'sex = female'.matchAll( sexism ) ][0].groups , { sex : 'female' } )
    // 	expect( [ ... 'sex = malefemale'.matchAll( sexism ) ][0].groups , undefined )

    // });

    // test('force after', () {

    // 	final { latin_only: letter , force_after , from } = $mol_regexp

    // 	final regexp = from([ letter , force_after( '.' ) ])

    // 	expect( 'x.'.match( regexp ) , [ 'x' ] )
    // 	expect( 'x,'.match( regexp ) , null )

    // });

    // test('forbid after', () {

    // 	final { latin_only: letter , forbid_after , from } = $mol_regexp

    // 	final regexp = from([ letter , forbid_after( '.' ) ])

    // 	expect( 'x.'.match( regexp ) , null )
    // 	expect( 'x,'.match( regexp ) , [ 'x' ] )

    // });

    // test('char except', () {

    // 	final { char_except, latin_only, tab } = $mol_regexp

    // 	final name = char_except( latin_only, tab )

    // 	expect( 'a'.match( name ) , null )
    // 	expect( '\t'.match( name ) , null )
    // 	expect( ', ('.match( name ) , [ ', (' ] )

    // });

    // test('unicode only', () {

    // 	final { unicode_only, from } = $mol_regexp

    // 	final name = from([
    // 		unicode_only( 'Script', 'Cyrillic' ),
    // 		unicode_only( 'Hex_Digit' ),
    // 	])

    // 	expect( 'FF'.match( name ) , null )
    // 	expect( 'ФG'.match( name ) , null )
    // 	expect( 'ФF'.match( name ) , [ 'ФF' ] )

    // });

    // test('generate by optional with inner group', () {

    // 	final { begin, end, from } = $mol_regexp

    // 	final animals = from([ begin, '#', [ '^', { dog : '@' } ], end ])

    // 	$mol_assert_equal( animals.generate({}) , '#' )

    // 	$mol_assert_equal( animals.generate({ dog: false }) , '#' )
    // 	$mol_assert_equal( animals.generate({ dog: true }) , '#^@' )

    // 	$mol_assert_fail( ()=> animals.generate({ dog: '$' }) , 'Wrong param: dog=$' )

    // });

    // test('generate by optional with inner group with variants', () {

    // 	final { begin, end, from } = $mol_regexp

    // 	final animals = from([ begin, '#', [ '^', { animal: { dog : '@', fox: '&' } } ], end ])

    // 	$mol_assert_equal( animals.generate({}) , '#' )

    // 	$mol_assert_equal( animals.generate({ dog: true }) , '#^@' )
    // 	$mol_assert_equal( animals.generate({ fox: true }) , '#^&' )

    // 	$mol_assert_fail( ()=> animals.generate({ dog: '$' }) , 'Wrong param: dog=$' )

    // });

    // test('complex example', () {

    // 	final {
    // 		begin, end,
    // 		char_only, char_range,
    // 		latin_only, slash_back,
    // 		repeat_greedy, from,
    // 	} = $mol_regexp

    // 	final atom_char = char_only( latin_only, "!#$%&'*+/=?^`{|}~-" )
    // 	final atom = repeat_greedy( atom_char, 1 )
    // 	final dot_atom = from([ atom, repeat_greedy([ '.', atom ]) ])

    // 	final name_letter = char_only(
    // 		char_range( 0x01, 0x08 ),
    // 		0x0b, 0x0c,
    // 		char_range( 0x0e, 0x1f ),
    // 		0x21,
    // 		char_range( 0x23, 0x5b ),
    // 		char_range( 0x5d, 0x7f ),
    // 	)

    // 	final quoted_pair = from([
    // 		slash_back,
    // 		char_only(
    // 			char_range( 0x01, 0x09 ),
    // 			0x0b, 0x0c,
    // 			char_range( 0x0e, 0x7f ),
    // 		)
    // 	])

    // 	final name = repeat_greedy({ name_letter, quoted_pair })
    // 	final quoted_name = from([ '"', {name}); '"' ])

    // 	final local_part = from({ dot_atom, quoted_name })
    // 	final domain = dot_atom

    // 	final mail = from([ begin, local_part, '@', {domain}); end ])

    // 	$mol_assert_equal( 'foo..bar@example.org'.match( mail ), null )
    // 	$mol_assert_equal( 'foo..bar"@example.org'.match( mail ), null )

    // 	expect(
    // 		[ ... 'foo.bar@example.org'.matchAll( mail ) ][0].groups,
    // 		{
    // 			domain: "example.org",
    // 			dot_atom: "foo.bar",
    // 			name: "",
    // 			name_letter: "",
    // 			quoted_name: "",
    // 			quoted_pair: "",
    // 		}
    // 	)

    // 	expect(
    // 		[ ... '"foo..bar"@example.org'.matchAll( mail ) ][0].groups,
    // 		{
    // 			dot_atom: "",
    // 			quoted_name: '"foo..bar"',
    // 			name: "foo..bar",
    // 			name_letter: "r",
    // 			quoted_pair: "",
    // 			domain: "example.org",
    // 		}
    // 	)

    // 	$mol_assert_equal(
    // 		mail.generate({ dot_atom: 'foo.bar', domain: 'example.org' }),
    // 		'foo.bar@example.org',
    // 	)

    // 	$mol_assert_equal(
    // 		mail.generate({ name: 'foo..bar', domain: 'example.org' }),
    // 		'"foo..bar"@example.org',
    // 	)

    // 	$mol_assert_fail(
    // 		()=> mail.generate({ dot_atom: 'foo..bar', domain: 'example.org' }),
    // 		'Wrong param: dot_atom=foo..bar',
    // 	)

    // }
  });
}
