function test_suite = testCompoundBin %#ok<STOUT>
%matlab_xUnit tests excercising CompoundBin
%
% Usage:
%   runtest testCompoundBin
initTestSuite;

function dir=data_dir
% Return the directory in which this test case data is located
thisfile = mfilename('fullpath');
dir=regexprep(thisfile,'/[^/]*$','');

function testReadAll %#ok<DEFNU>
% Tests whether load_metabmap (which uses CompoundBin) reads the correct
% number of entries from a test file

map = load_metabmap(fullfile(data_dir, 'testCompoundBin.01.readall.csv'));
assertEqual(length(map),78);
assertTrue(isa(map, 'CompoundBin'));

function testReadExcelHeader %#ok<DEFNU>
% Tests whether load_metabmap (which uses CompoundBin) reads the correct
% entries from a file that is identical to the first 5 entries of
% testCompoundBin.01.readall.csv, but it puts the quotation marks in in an
% excel-like way

normal_map = load_metabmap(fullfile(data_dir, 'testCompoundBin.01.readall.csv'));
assertEqual(length(normal_map),78);
assertTrue(isa(normal_map, 'CompoundBin'));

excel_map = load_metabmap(fullfile(data_dir, 'testCompoundBin.03.excel_header.csv'));
assertEqual(length(excel_map),5);
assertTrue(isa(excel_map, 'CompoundBin'));

assertEqual(normal_map(1:5), excel_map);

function testLMMBadLoadDeleted %#ok<DEFNU>
% Tests whether load_metabmap throws an exception if it gets a bad value for load_deleted 

f=@() load_metabmap(fullfile(data_dir, 'testCompoundBin.01.readall.csv'),'snafu');
assertExceptionThrown(f, 'load_metabmap:invalid_load_deleted');


function testLMMWithLoadDeleted %#ok<DEFNU>
% Tests whether load_metabmap correctly ignores deleted bins if told to

map = load_metabmap(fullfile(data_dir, ...
    'testCompoundBin.02.deleted_test.csv'),'no_deleted_bins');
assertEqual(length(map), 1);
assertTrue(isa(map, 'CompoundBin'));
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
alpha_keto=['10,,7,"alpha-Ketoglutarate","X",2.472,2.430,"t",3,,'...
    '"g CH2/CH2",,"X","Chemonx/Lindon/Measured","1H",'];
expected_map = CompoundBin(header, alpha_keto);
assertEqual(expected_map, map);

function testLMMWithOutLoadDeleted %#ok<DEFNU>
% Tests whether load_metabmap loads deleted bins when told to

map = load_metabmap(fullfile(data_dir, ...
    'testCompoundBin.02.deleted_test.csv'));
assertEqual(length(map), 3);
assertTrue(isa(map, 'CompoundBin'));
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
alpha_keto=['10,,7,"alpha-Ketoglutarate","X",2.472,2.430,"t",3,,'...
    '"g CH2/CH2",,"X","Chemonx/Lindon/Measured","1H",'];
succ=['11,X,25,"succinate","X",2.425,2.405,"s",1,,"CH",254,"X",'...
    '"Chemonx/Lindon/Measured","1H",'];
nacet=['12,X,26,"N-Acetylglutamine","X",2.055,2.025,"s",1,,"CH3",6029,'...
    '"X","Chenomx/Lindon","1H",'];
expected_map = [CompoundBin(header, alpha_keto) ...
    CompoundBin(header, succ) ...
    CompoundBin(header, nacet) ...
    ];
assertEqual(expected_map, map);

function testRemoveDeletedWithDeletedPresent %#ok<DEFNU>
% Test that remove_deleted_bins_from_metabmap removes deleted bins
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
alpha_keto=['10,,7,"alpha-Ketoglutarate","X",2.472,2.430,"t",3,,'...
    '"g CH2/CH2",,"X","Chemonx/Lindon/Measured","1H",'];
succ=['11,X,25,"succinate","X",2.425,2.405,"s",1,,"CH",254,"X",'...
    '"Chemonx/Lindon/Measured","1H",'];
nacet=['12,X,26,"N-Acetylglutamine","X",2.055,2.025,"s",1,,"CH3",6029,'...
    '"X","Chenomx/Lindon","1H",'];

starting_map = [CompoundBin(header, nacet) ...
    CompoundBin(header, succ) ...
    CompoundBin(header, alpha_keto) ...
    ];

expected_map = CompoundBin(header, alpha_keto);

map = remove_deleted_bins_from_metabmap(starting_map);
assertEqual(expected_map, map);

function testRemoveDeletedPreservesOrder %#ok<DEFNU>
% Test that remove_deleted_bins_from_metabmap preserves the order for elements not deleted
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
alpha_keto=['10,,7,"alpha-Ketoglutarate","X",2.472,2.430,"t",3,,'...
    '"g CH2/CH2",,"X","Chemonx/Lindon/Measured","1H",'];
succ=['11,X,25,"succinate","X",2.425,2.405,"s",1,,"CH",254,"X",'...
    '"Chemonx/Lindon/Measured","1H",'];
nacet=['12,,26,"N-Acetylglutamine","X",2.055,2.025,"s",1,,"CH3",6029,'...
    '"X","Chenomx/Lindon","1H",'];

starting_map = [CompoundBin(header, nacet) ...
    CompoundBin(header, succ) ...
    CompoundBin(header, alpha_keto) ...
    ];

expected_map = [CompoundBin(header, nacet) ...
    CompoundBin(header, alpha_keto) ...
    ];

map = remove_deleted_bins_from_metabmap(starting_map);
assertEqual(expected_map, map);

function testRemoveDeletedWithNoDeletedPresent %#ok<DEFNU>
% Test that remove_deleted_bins_from_metabmap removes deleted bins when none are marked deleted
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
alpha_keto=['10,,7,"alpha-Ketoglutarate","X",2.472,2.430,"t",3,,'...
    '"g CH2/CH2",,"X","Chemonx/Lindon/Measured","1H",'];
succ=['11,,25,"succinate","X",2.425,2.405,"s",1,,"CH",254,"X",'...
    '"Chemonx/Lindon/Measured","1H",'];
nacet=['12,,26,"N-Acetylglutamine","X",2.055,2.025,"s",1,,"CH3",6029,'...
    '"X","Chenomx/Lindon","1H",'];

starting_map = [CompoundBin(header, nacet) ...
    CompoundBin(header, succ) ...
    CompoundBin(header, alpha_keto) ...
    ];

expected_map = starting_map;

map = remove_deleted_bins_from_metabmap(starting_map);
assertEqual(expected_map, map);


function testRemoveDeletedFromEmpty %#ok<DEFNU>
% Test that remove_deleted_bins_from_metabmap does nothing when passed an empty metabmap
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
nacet=['12,,26,"N-Acetylglutamine","X",2.055,2.025,"s",1,,"CH3",6029,'...
    '"X","Chenomx/Lindon","1H",'];

starting_map = CompoundBin(header, nacet);
starting_map(1) = [];

expected_map = starting_map;

map = remove_deleted_bins_from_metabmap(starting_map);
assertEqual(expected_map, map);



function testSaveAll %#ok<DEFNU>
% Tests whether save_metabmap works in a round-trip with load_metabmap
%
% loads from test file, saves to testCompoundBin.02.saveall.csv, then loads
% again and compares to see if the values saved are the same as those
% loaded
map1 = load_metabmap(fullfile(data_dir, 'testCompoundBin.01.readall.csv'));
save_metabmap(fullfile(data_dir, 'testCompoundBin.02.saveall.csv'),map1);
map2 = load_metabmap(fullfile(data_dir, 'testCompoundBin.02.saveall.csv'));
assertEqual(map1, map2);

    
function testParseCSVBoolX %#ok<DEFNU>
% Test if CompoundBin.parse_csv_bool parses an x input correctly

assertTrue(CompoundBin.parse_csv_bool('X',''));
assertTrue(CompoundBin.parse_csv_bool('x',''));

function testParseCSVBoolNull %#ok<DEFNU>
% Test if CompoundBin.parse_csv_bool parses an "" input correctly

assertFalse(CompoundBin.parse_csv_bool('',''));

function testParseCSVBoolBlank %#ok<DEFNU>
% Test if CompoundBin.parse_csv_bool parses an " " input correctly

assertFalse(CompoundBin.parse_csv_bool(' ',''));

function testParseCSVBoolGarbage %#ok<DEFNU>
% Test if CompoundBin.parse_csv_bool parses an "garbage" input correctly

f=@() CompoundBin.parse_csv_bool('bad','some input var');
assertExceptionThrown(f,'CompoundBin:bad_bool');

function testValidMultABDoubletNoConcat %#ok<DEFNU>
% Test that 'half of AB d' concatenated with something is not valid

assertFalse(CompoundBin.is_valid_multiplicity_string('half of AB ds'));

function testValidMultLotsOfTests %#ok<DEFNU>
% Implements the tests from the original "Examples" section of the comments
% for is_valid_multiplicity_string

% Good strings
assertTrue(CompoundBin.is_valid_multiplicity_string('d'));
assertTrue(CompoundBin.is_valid_multiplicity_string('t'));
assertTrue(CompoundBin.is_valid_multiplicity_string('half of AB d'));
assertTrue(CompoundBin.is_valid_multiplicity_string('m'));
assertTrue(CompoundBin.is_valid_multiplicity_string('m,d'));
assertTrue(CompoundBin.is_valid_multiplicity_string('s,s'));
assertTrue(CompoundBin.is_valid_multiplicity_string('dt'));
assertTrue(CompoundBin.is_valid_multiplicity_string('half of AB d,s'));


% Bad strings
assertFalse(CompoundBin.is_valid_multiplicity_string('xl'));
assertFalse(CompoundBin.is_valid_multiplicity_string('t,'));
assertFalse(CompoundBin.is_valid_multiplicity_string(',t'));
assertFalse(CompoundBin.is_valid_multiplicity_string('rv'));
assertFalse(CompoundBin.is_valid_multiplicity_string('ds'));
assertFalse(CompoundBin.is_valid_multiplicity_string('half of AB ds'));
assertFalse(CompoundBin.is_valid_multiplicity_string(''));


function testHumReadMult %#ok<DEFNU>
% Tests CompoundBin.human_readable_multiplicity
assertEqual(CompoundBin.human_readable_multiplicity('s'),'singlet');
assertEqual(CompoundBin.human_readable_multiplicity('d'),'doublet');
assertEqual(CompoundBin.human_readable_multiplicity('t'),'triplet');
assertEqual(CompoundBin.human_readable_multiplicity('q'),'quartet');
assertEqual(CompoundBin.human_readable_multiplicity('m'), ...
    'multiplet');
assertEqual(CompoundBin.human_readable_multiplicity('half of AB d'), ...
    'half of AB doublet');
assertEqual(CompoundBin.human_readable_multiplicity('m,d'), ...
    'multiplet, doublet');
assertEqual(CompoundBin.human_readable_multiplicity('s,s'), ...
    'singlet, singlet');
assertEqual(CompoundBin.human_readable_multiplicity('dt'), ... 
    'doublet of triplets');
assertEqual(CompoundBin.human_readable_multiplicity('dtq'), ... 
    'doublet of triplet of quartets');
assertEqual(CompoundBin.human_readable_multiplicity('half of AB d,s'), ... 
    'half of AB doublet, singlet');



function testCompoundBinConstructor %#ok<DEFNU>
% Test that the constructor constructs what we'd expect

in = ['1,"",101,"Unobtanium","X",'...
    '101.1,100.0,'...
	'"t",2,"50","CH5",,"X","Some refs",'...
	'"1H","Here are some notes to read"'];

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

c = CompoundBin(header,in);

assertEqual(uint64(c.id),uint64(1));
assertFalse(c.was_deleted);
assertEqual(uint64(c.compound_id), uint64(101));
assertEqual(c.compound_name, 'Unobtanium');
assertTrue(c.is_known_compound);
assertEqual(c.bin.left,101.1);
assertEqual(c.bin.right,100.0);
assertEqual(c.multiplicity, 't');
assertEqual(uint64(c.num_peaks), uint64(2));
assertEqual(c.j_values, 50);
assertEqual(c.nucleus_assignment, 'CH5');
assertTrue(isnan(c.hmdb_id));
assertTrue(c.chenomix_was_used);
assertEqual(c.literature, 'Some refs');
assertEqual(c.nmr_isotope, '1H');
assertEqual(c.notes, 'Here are some notes to read');

function testCompoundBinConstructorRevTruth %#ok<DEFNU>
% Test that the constructor constructs what we'd expect when the truth
% values of the booleans are reversed

in = ['1,"X",101,"Unobtanium"," ",'...
    '101.1,100.0,'...
	'"t",2,"50","CH5",," ","Some refs",'...
	'"1H","Here are some notes to read"'];

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

c = CompoundBin(header,in);

assertEqual(uint64(c.id),uint64(1));
assertTrue(c.was_deleted);
assertEqual(uint64(c.compound_id), uint64(101));
assertEqual(c.compound_name, 'Unobtanium');
assertFalse(c.is_known_compound);
assertEqual(c.bin.left,101.1);
assertEqual(c.bin.right,100.0);
assertEqual(c.multiplicity, 't');
assertEqual(uint64(c.num_peaks), uint64(2));
assertEqual(c.j_values, 50);
assertEqual(c.nucleus_assignment, 'CH5');
assertTrue(isnan(c.hmdb_id));
assertFalse(c.chenomix_was_used);
assertEqual(c.literature, 'Some refs');
assertEqual(c.nmr_isotope, '1H');
assertEqual(c.notes, 'Here are some notes to read');

function testCompoundBinConstructorMethylnicotinamide %#ok<DEFNU>
% Test that the constructor constructs what we'd expect for 1-
% methlynicotinamide

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

in = '1,,1,"1-Methylnicotinamide","X",9.297,9.265,"s",1,,"CH2, H2",699,"X","Lindon, year?","1H",';
c = CompoundBin(header,in);

assertEqual(uint64(c.id),uint64(1));
assertFalse(c.was_deleted);
assertEqual(uint64(c.compound_id), uint64(1));
assertEqual(c.compound_name, '1-Methylnicotinamide');
assertTrue(c.is_known_compound);
assertEqual(c.bin.left,9.297);
assertEqual(c.bin.right,9.265);
assertEqual(c.multiplicity, 's');
assertEqual(uint64(c.num_peaks), uint64(1));
assertTrue(isempty(c.j_values));
assertEqual(c.nucleus_assignment, 'CH2, H2');
assertEqual(uint64(c.hmdb_id),uint64(699));
assertTrue(c.chenomix_was_used);
assertEqual(c.literature, 'Lindon, year?');
assertEqual(c.nmr_isotope, '1H');
assertEqual(c.notes, '');

function testGetAsCsvStringHippurate %#ok<DEFNU>
% Test that when an object for bin 3 (hippurate) is converted to csv, the result is the same as the input 
%
% Hippurate 3 has no listed j-value

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

in ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"liver, serum, urine","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
c = CompoundBin(header,in);
out = c.as_csv_string;

assertEqual(in, out);


function testGetAsCsvStringMalate %#ok<DEFNU>
% Test that when an object for bin 6 (malate) is converted to csv, the result is the same as the input 
%
% Malate has two known j-values
header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

in = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"serum, urine","","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';
c = CompoundBin(header,in);
out = c.as_csv_string;

assertEqual(in, out);


function testEqualObjObj %#ok<DEFNU>
% Test that object == object works

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];
inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';
cH = CompoundBin(header,inH);
cHDel = CompoundBin(header,inHDel);
cM = CompoundBin(header,inM);

assertTrue(cH == cH,'A == A for obj-obj comparison');
assertFalse(cM == cH,'malate ~= hippurate for obj-obj comparison');
assertFalse(cH == cHDel,'== detects changes in deleted field for obj-obj comparison');

function testEqualObjObjSampleTypes %#ok<DEFNU>
% Test that object == object works with objects that have a sample_type field

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];
inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, urine, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHRev = '3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"liver, urine, serum","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, urine, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHNoUri='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"serum, urine","","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

cH = CompoundBin(header,inH);
cHRev = CompoundBin(header,inHRev);
cHDel = CompoundBin(header,inHDel);
cHNoUri = CompoundBin(header,inHNoUri);
cM = CompoundBin(header,inM);

assertTrue(cH == cHRev,'Equality is independent of input order of sample_types field');
assertTrue(cH == cH,'A == A with sample_types field for hippurate');
assertTrue(cM == cM,'A == A with sample_types field for malate');
assertFalse(cM == cH,'malate ~= hippurate with sample_types field');
assertFalse(cH == cHDel,'Equality detects changes in deletion for when_sample_types field is present');
assertFalse(cH == cHNoUri,'Equality detects changes in contents of sample_types field');

function testEqualObjArySampleTypes %#ok<DEFNU>
% Test that obj == array(obj) and array(obj)==obj works with objects that have a sample_type field

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];
inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, urine, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHRev = '3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"liver, urine, serum","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, urine, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHNoUri='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"serum, urine","","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

cH = CompoundBin(header,inH);
cHRev = CompoundBin(header,inHRev);
cHDel = CompoundBin(header,inHDel);
cHNoUri = CompoundBin(header,inHNoUri);
cM = CompoundBin(header,inM);

ary = [cH cHRev cHDel cHNoUri cM];
assertEqual(cHRev == ary, [true true false false false]);
assertEqual(ary == cHNoUri, [false false false true false]);
assertEqual(ary == cH, [true true false false false]);


function testEqualAryArySampleTypes %#ok<DEFNU>
% Test that array(obj) == array(obj) works with objects that have a sample_type field

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];
inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, urine, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHRev = '3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"liver, urine, serum","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, urine, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHNoUri='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum, liver","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"serum, urine","","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

cH = CompoundBin(header,inH);
cHRev = CompoundBin(header,inHRev);
cHDel = CompoundBin(header,inHDel);
cHNoUri = CompoundBin(header,inHNoUri);
cM = CompoundBin(header,inM);

ary1 = [cHRev cHRev   cH    cH      cH cH];
ary2 = [cH    cHNoUri cHDel cHNoUri cM cH];
assertEqual(ary1 == ary2, [true false false false false true]);

function testEqualObjAry %#ok<DEFNU>
% Test that object == array(object) works

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';
cH = CompoundBin(header,inH);
cHDel = CompoundBin(header,inHDel);
cM = CompoundBin(header,inM);

ary = [cH cHDel cM];
assertEqual(cHDel == ary, [false true false]);

function testEqualAryObj %#ok<DEFNU>
% Test that array(object) == object works

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

cH = CompoundBin(header,inH);
cHDel = CompoundBin(header,inHDel);
cM = CompoundBin(header,inM);

ary = [cH cHDel cM];
assertEqual(ary == cH, [true false false]);



function testEqualAryAry %#ok<DEFNU>
% Test that array(object) == array(object) works

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inHDel ='3,"X",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';
inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

cH = CompoundBin(header,inH);
cHDel = CompoundBin(header,inHDel);
cM = CompoundBin(header,inM);

ary1 = [cH cHDel cM];
ary2 = [cH cHDel cH];
assertEqual(ary1 == ary2, [true true false]);


function testCompoundBinConstructorSampleTypes %#ok<DEFNU>
% Test: The constructor of CompoundBin accepts sample_types field
% ("Sample-types that may contain compound") and produces an object with
% that field having the expected value

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"urine","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';

cH = CompoundBin(header, inH);

assertEqual(cH.sample_types,{'urine'});

function testCompoundBinConstructorSampleTypesNoTypes %#ok<DEFNU>
% Test: The constructor of CompoundBin gives empty cell array for sample_types field if no sample types listed

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';

cH = CompoundBin(header, inH);

assertTrue(isempty(cH.sample_types));
assertTrue(iscell(cH.sample_types));

function testCompoundBinConstructorSampleTypesTwoTypes %#ok<DEFNU>
% Test: The constructor of CompoundBin gives expected values if two types
% are listed for sample types field

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"serum,brain","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';

cH = CompoundBin(header, inH);

assertEqual(cH.sample_types,{'brain','serum'});

function testCompoundBinConstructorSampleTypesFiveTypes %#ok<DEFNU>
% Test: CompoundBin constructor gives expected sample_types field when the 5 needed types are listed: urine, serum, brain, liver, fecal

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714," fecal,   liver, brain, serum, urine","X","Chemonx/Lindon/Measured","1H","Multiplicity is different in HMDB"';

cH = CompoundBin(header, inH);

assertEqual(cH.sample_types,{'brain', 'fecal', 'liver', 'serum', 'urine'});


function testCompoundBinConstructorSampleTypesExcel %#ok<DEFNU>
% Test: The constructor of CompoundBin accepts sample_types field
% ("Sample-types that may contain compound") and produces an object with
% that field having the expected value when the data is given as Excel
% would give it, that is, without extra quotes

header=['Bin ID,Deleted,Compound ID,'...
    'Compound Name,Known Compound,Bin (Lt),Bin (Rt),'...
    'Multiplicity,Peaks to Select,J (Hz),Nucleus Assignment,'...
    'HMDB ID,Sample-types that may contain compound,'...
    'Chenomx,Literature,NMR Isotope,Notes'];

inH ='3,,4,hippurate,X,7.857000,7.815000,d,2,,"CH2, CH6",714,urine,X,Chemonx/Lindon/Measured,1H,Multiplicity is different in HMDB';

cH = CompoundBin(header, inH);

assertEqual(cH.sample_types,{'urine'});


function testCompoundBinSampleTypesBackwardCompat %#ok<DEFNU>
% CompoundBin sample_types field is empty for objects created with the old header

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

cM = CompoundBin(header,inM);

assertTrue(isempty(cM.sample_types));
assertTrue(iscell(cM.sample_types));


function testCompoundBinSampleTypesLoadMatBackwardCompat %#ok<DEFNU>
% CompoundBin coorectly loads old .mat file from before SampleTypes

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Chenomx","Literature","NMR Isotope","Notes"'];

inM = '6,"",42,"Malate","X",4.335000,4.300000,"dd",4,"10.230000, 2.980000","CH",156,"","","1H","HMDB puts this dd at 4.29 and the range as 4.27-4.32. Needs checking - Eric adapted from old bin-map"';

expected_metab = CompoundBin(header,inM);

s=load('testCompoundBin.04.mat_before_sample_types.mat');

assertTrue(isempty(s.metab.sample_types));
assertTrue(iscell(s.metab.sample_types));
assertEqual(s.metab, expected_metab);

function testCompoundBinLengthMismatch %#ok<DEFNU>
% CompoundBin correctly identifies when the input line is too short for the
% given header

header=['"Bin ID","Deleted","Compound ID",'...
    '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
    '"Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment",'...
    '"HMDB ID","Sample-types that may contain compound",'...
    '"Chenomx","Literature","NMR Isotope","Notes"'];

inH ='3,"",4,"hippurate","X",7.857000,7.815000,"d",2,"","CH2, CH6",714,"X","","1H","Multiplicity is different in HMDB"';

f=@() CompoundBin(header, inH);
assertExceptionThrown(f, 'CompoundBin:wrong_number_of_fields');
