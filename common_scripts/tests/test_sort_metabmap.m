function test_suite = test_sort_metabmap%#ok<STOUT>
%matlab_xUnit tests excercising sort_metabap_by_name_then_ppm
%
% Usage:
%   runtest test_sort_metabmap
initTestSuite;

function dir=data_dir
% Return the directory in which this test case data is located
thisfile = mfilename('fullpath');
dir=regexprep(thisfile,'/[^/]*$','');

function testSort %#ok<DEFNU>
% Tests whether sort_metabmap sorts a single particular metabmap correctly

unsorted = load_metabmap(fullfile(data_dir, 'test_sort_metabmap.01.unsorted.csv'));
expected = load_metabmap(fullfile(data_dir, 'test_sort_metabmap.02.sorted.csv'));
sorted = sort_metabmap_by_name_then_ppm(unsorted);
assertEqual(length(unsorted),78);
assertEqual(length(expected), length(sorted));
assertEqual(expected, sorted);
assertTrue(isa(sorted, 'CompoundBin'));

function testSortEmpty %#ok<DEFNU>
% Tests whether sort_metabmap correctly sorts an empty list

unsorted = load_metabmap(fullfile(data_dir, 'test_sort_metabmap.01.unsorted.csv'));
unsorted = unsorted(1);
unsorted(1) = [];
expected = unsorted;

sorted = sort_metabmap_by_name_then_ppm(unsorted);

assertEqual(expected, sorted);
assertTrue(isa(sorted, 'CompoundBin'));

