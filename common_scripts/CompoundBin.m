classdef CompoundBin
    %COMPOUNDBIN A bin that should contain certain peaks from the given
    %compound(s)
    %   Both a a bin object as description of the compound(s)
    
    properties (SetAccess=private)
        % Our id of the compound/bin combination - a number
        id
        
        % True if this bin was deleted, false otherwise
        was_deleted
        
        % The BIRG id number for this metabolite (will be greater than 0)
        compound_id
        
        % String description of compound - cannot contain ""
        compound_name
        
        % True if this bin is for a known metabolite, false if for peaks
        % from an unknown metabolite
        is_known_compound
        
        % Bin object
        bin
        
        % Multiplicity of bin (as described in binmap file) - cannot
        % contain ""
        multiplicity
        
        % The number of peaks to be clicked on in this compound bin
        num_peaks
        
        % For a multiplet, this contains a list of the j values for the
        % multiplet's components if they are known.  If the bin contains a
        % singlet, then this will be empty
        j_values
        
        % The nucleus assignment - cannot contain ""
        nucleus_assignment
        
        % The HMDB acession number without the HMDB prefix.  NaN when
        % unknown or not given.
        hmdb_id
        
        % List of sample types in which the compound was found.  A cell
        % array of strings sorted in the order given by sort.  No string 
        % can contain a comma or leading or trailing white-space.
        sample_types={}
        
        
        % True if some information was verified with Chenomx
        chenomix_was_used
        
        % Source of id information - literature - cannot contain ""
        literature
        
        % The isotope to which the bin applies - 1H, 13C, 31P, 14N, 15N,
        % etc - cannot contain "", must match [\d+[A-z]+]
        nmr_isotope
        
        % Human-readable notes for the compound bin - cannot contain ""
        notes
    end
    
    properties (Dependent)
        % A nicely formatted version of the multiplicity
        readable_multiplicity
        
        % A string that represents this bin as a line in a csv file (the
        % csv header is given by csv_file_header_string)
        as_csv_string
        
        % A single string that represents this bin as newline-delimited
        % pairs of property labels (from the header file) and values
        as_long_string
        
    end
    
    methods (Static)
        function str=csv_file_header_string()
            % A string that represents the header for a csv file containing
            % CompoundBin objects
            str=['"Bin ID","Deleted","Compound ID",'...
                '"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)",'...
                '"Multiplicity","Peaks to Select","J (Hz)",'...
                '"Nucleus Assignment","HMDB ID",'...
                '"Sample-types that may contain compound",'...
                '"Chenomx","Literature","NMR Isotope","Notes"'];
        end
        
        function trueorfalse=parse_csv_bool(str, value_destination)
            % Turns str (a field from the input csv) from 'X','' to 1,0
            %
            % If str is 'X' or 'x' returns 1
            % if str is '' or white-space returns 0
            %
            % Otherwise throws an exception with the text:
            %
            % ------------
            % - Usage
            % ------------
            %
            % trueorfalse=parse_csv_bool(str, value_destination)
            %
            % ------------
            % - Input Arguments
            % ------------
            %
            % str               The string to parse
            % value_destination The destination where the value will be put --
            %                   will be used in the error message
            % ------------
            % - Output Parameters
            % ------------
            %
            % trueorfalse   the result of parsing str into a true or a false value
            %
            %
            % ------------
            % - Examples
            % ------------
            %
            % >> parse_csv_bool('X', 'foobar')
            %
            % 1
            %
            % >> parse_csv_bool('', 'foobar')
            %
            % 0
            %
            % >> parse_csv_bool(' ', 'foobar')
            %
            % 0
            %
            % >> parse_csv_bool('something', 'foobar')
            %
            % (exception thrown here)
            
            
            if     ~isempty(regexp(str, '^[Xx]$', 'once'))
                trueorfalse = 1==1;
            elseif isempty(str) || ~isempty(regexp(str, '^\s*$', 'once'))
                trueorfalse = 0==1;
            else
                error('CompoundBin:bad_bool',['The input for "%s" should have been '...
                    'an "X" for true or a blank "" for false.  Instead '...
                    '"%s" was passed.'], value_destination, str);
            end
        end
        
        
        function is_valid = is_valid_multiplicity_string(str)
            % Return true if str could represent a multiplicity, false otherwise
            %
            % ------------
            % - Usage
            % ------------
            %
            % is_valid = CompoundBin.is_valid_multiplicity_string(str)
            %
            % ------------
            % - Input Arguments
            % ------------
            %
            % str               The string to check
            %
            % ------------
            % - Output Parameters
            % ------------
            %
            % is_valid   True if str is valid, false otheriwse
            %
            %
            % ------------
            % - Examples
            % ------------
            %
            % >> CompoundBin.is_valid_multiplicity_string('')
            %
            % 0
            %
            % >> CompoundBin.is_valid_multiplicity_string('d')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('t')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('half of AB d')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('m')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('m,d')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('s,s')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('dt')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('xl')
            %
            % 0
            %
            % >> CompoundBin.is_valid_multiplicity_string('t,')
            %
            % 0
            %
            % >> CompoundBin.is_valid_multiplicity_string(',t')
            %
            % 0
            %
            % >> CompoundBin.is_valid_multiplicity_string('rv')
            %
            % 0
            %
            % >> CompoundBin.is_valid_multiplicity_string('half of AB d,s')
            %
            % 1
            %
            % >> CompoundBin.is_valid_multiplicity_string('half of AB ds')
            %
            % 0
            %
            is_valid = 1==1;
            try
                CompoundBin.human_readable_multiplicity(str);
            catch  %#ok<CTCH>
                is_valid = 1==0;
            end
            
        end
        
        
        
        function result = human_readable_multiplicity(str)
            % Takes a multiplicity string and returns a more readable version
            %
            % Throws an exception on error
            %
            % ------------
            % - Usage
            % ------------
            %
            % result = CompoundBin.human_readable_multiplicity(str)
            %
            % ------------
            % - Input Arguments
            % ------------
            %
            % str  A multiplicity string.  i.e. 'dd' or 's' or 'half of AB d'
            %
            % ------------
            % - Output Parameters
            % ------------
            %
            % result A human-readable version of str i.e dd->doublet of
            %        doublets
            %
            % ------------
            % - Examples
            % ------------
            %
            % >> CompoundBin.human_readable_multiplicity('s')
            %
            % singlet
            %
            % >> CompoundBin.human_readable_multiplicity('dt')
            %
            % doublet of triplets
            %
            % >> CompoundBin.human_readable_multiplicity('td')
            %
            % triplet of doublets
            %
            % >> CompoundBin.human_readable_multiplicity('s,s')
            %
            % singlet, singlet
            %
            %Split on commas
            str = lower(str);
            fields = regexp(str, '\s*,\s*', 'split');
            
            %Make each segment readable
            hr_fields = fields;
            for i=1:length(fields)
                hr_fields{i} = do_field(fields{i});
            end
            
            %Join with commas
            result = sprintf('%s%s',sprintf('%s, ',hr_fields{1:end-1}),hr_fields{end});
            
            function fresult = do_field(field)
                % Makes a lower-case sub-part of a multiplicity string human-readable
                %
                % Throws an exception on error
                if     isempty(field)
                    error('CompoundBin_multiplet:no_empty_field', ...
                        ['Empty fields are not allowed in multiplet ' ...
                        'descriptions. So, for example, "d,,t" is not '...
                        'legal.']);
                elseif isequal(field,'half of ab d')
                    fresult = 'half of AB doublet';
                    return;
                elseif ~isempty(strfind(field, 'half of ab d'))
                    error('CompoundBin_multiplet:no_ab_combo', ...
                        ['It is not legal to combine half of an ab ' ...
                        'doublet with other types of multiplets to ' ...
                        'make more complicated couplings.  For '...
                        'example half of AB doublet of triplets is ' ...
                        'not a legal multiplet description.  Thus "' ...
                        field '" is not a legal description.']);
                elseif isequal(field,'s')
                    fresult = 'singlet';
                    return;
                elseif ~isempty(strfind(field, 's'))
                    error('CompoundBin_multiplet:no_singlet_combo', ...
                        ['It is not legal to concatenate singlets' ...
                        'with other types of multiplets to ' ...
                        'make more complicated couplings.  For '...
                        'example singlet of triplets ("st") is ' ...
                        'not a legal multiplet description.  Thus "' ...
                        field '" is not a legal description.']);
                end
                
                %Here we have a non-empty field that does not have a 'half
                %of ab doublet string in it'
                for j = 1:length(field)
                    switch field(j)
                        case 'd'
                            toadd = 'doublet';
                        case 't'
                            toadd = 'triplet';
                        case 'q'
                            toadd = 'quartet';
                        case 'm'
                            toadd = 'multiplet';
                        otherwise
                            error('CompoundBin_multiplet:bad_char',[ ...
                                '"' field(j) '" is not a legal '...
                                'multiplet specifier character.  Legal '...
                                'values are s,d,t,q, and m']);
                    end
                    if j == 1
                        fresult = toadd;
                    elseif j > 1 && j < length(field)
                        fresult = [fresult ' of ' toadd]; %#ok<AGROW>
                    else
                        assert(j > 1 && j == length(field));
                        fresult = [fresult ' of ' toadd 's']; %#ok<AGROW>
                    end
                end
                
            end
        end
    end
    
    methods
        function obj=CompoundBin(header_line, data_line)
            % Create a CompoundBin object by parsing lines from a csv file
            %
            % Throws readable exceptions that can be used for input validation
            % if you just format user-input as the appropriate line in the csv
            % (with sprintf, for example).
            %
            % Note that the caller will need to translate checkboxes
            % into 'X' and '' for boolean true and false respectively
            %
            %
            % Known headers are:
            %  1. "Bin ID","Deleted","Compound ID","Compound Name","Known Compound","Bin (Lt)","Bin (Rt)","Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment","HMDB ID","Chenomx","Literature","NMR Isotope","Notes"
            %  2. Bin ID,Deleted,Compound ID,Compound Name,Known Compound,Bin (Lt),Bin (Rt),Multiplicity,Peaks to Select,J (Hz),Nucleus Assignment,HMDB ID,Chenomx,Literature,NMR Isotope,Notes
            %  3. "Bin ID","Deleted","Compound ID",'"Compound Name","Known Compound","Bin (Lt)","Bin (Rt)","Multiplicity","Peaks to Select","J (Hz)","Nucleus Assignment","HMDB ID","Sample-types that may contain compound","Chenomx","Literature","NMR Isotope","Notes"
            %  4. Bin ID,Deleted,Compound ID,'Compound Name,Known Compound,Bin (Lt),Bin (Rt),Multiplicity,Peaks to Select,J (Hz),Nucleus Assignment,HMDB ID,Sample-types that may contain compound,Chenomx,Literature,NMR Isotope,Notes
            % ---------
            % - Usage
            % ---------
            %
            % obj=CompoundBin(header_line, data_line)
            %
            %     Creates a CompoundBin from the data
            %
            % or
            %
            % obj=CompoundBin()
            %
            %     Creates an uninitialized CompoundBin
            %
            % ---------
            % - Input Arguments
            % ---------
            %
            % header_line is a header line from a csv file
            %
            % data_line   is a line of data from the csv file with the header
            %             contained in header line
            %
            % ---------
            % - Output Parameters
            % ---------
            %
            % obj The compound bin created from the input arguments
            
            if nargin>0 %Make a default constructor that doesn't initialize
                header_no_sample_type_field=[ ...
                    '"Bin ID","Deleted","Compound ID","Compound Name",'...
                    '"Known Compound","Bin (Lt)","Bin (Rt)",'...
                    '"Multiplicity","Peaks to Select","J (Hz)",'...
                    '"Nucleus Assignment","HMDB ID","Chenomx",'...
                    '"Literature","NMR Isotope","Notes"'];
                header_no_sample_type_field_excel=regexprep(...
                    header_no_sample_type_field, '"','');
                
                header=[ ...
                    '"Bin ID","Deleted","Compound ID","Compound Name",'...
                    '"Known Compound","Bin (Lt)","Bin (Rt)",'...
                    '"Multiplicity","Peaks to Select","J (Hz)",'...
                    '"Nucleus Assignment","HMDB ID",' ...
                    '"Sample-types that may contain compound",'...
                    '"Chenomx","Literature","NMR Isotope","Notes"'];
                    
                header_excel=regexprep(header, '"','');
                
                
                if isequal(header_line,header_no_sample_type_field) || ...
                        isequal(header_line, header_no_sample_type_field_excel) || ...
                        isequal(header_line, header) || ...
                        isequal(header_line, header_excel)
                        
                    if isequal(header_line,header_no_sample_type_field) || ...
                        isequal(header_line, header_no_sample_type_field_excel) 
                        d = textscan(data_line, ...
                            ['%d %q %d %q '... to Compound Name
                            '%q %f %f '   ... to Bin (Rt)
                            '%q %d %q '   ... to J (Hz)
                            '%q %q %q '   ... to Chenomix
                            '%q %q %q'],...
                            'Delimiter', ',');
                        
                        headers = textscan(header_line, ['%q %q %q %q '...
                            '%q %q %q %q %q %q %q %q %q %q %q %q'],...
                            'Delimiter', ',');
                        
                        expected_d_length = 16;
                    else %Standard header
                        d = textscan(data_line, ...
                            ['%d %q %d %q '... to Compound Name
                            '%q %f %f '   ... to Bin (Rt)
                            '%q %d %q '   ... to J (Hz)
                            '%q %q %q %q '   ... to Chenomix
                            '%q %q %q'],...
                            'Delimiter', ',');

                        headers = textscan(header_line, ['%q %q %q %q '...
                            '%q %q %q %q %q %q %q %q %q %q %q %q %q'],...
                            'Delimiter', ',');
                        
                        expected_d_length = 17;
                    end
                    
                    % Text scan treats %q fields not present in the 
                    % original the same as blank ones.  Blank fields are 
                    % acceptable, but missing fields indicate a problem
                    % with the file.  The number of commas that separate 
                    % data elements should be one more than the number of 
                    % data elements.  Checking this distinguishes absent
                    % fields from empty ones.
                    commas_in_data = 0;
                    for i = 1:length(d)
                        contents = d{i};
                        if iscell(contents) && length(contents)==1
                            contents = contents{1};
                        end
                        if ~isempty(contents) && ischar(contents)
                            commas_in_data = commas_in_data + ...
                                length(strfind(contents, ','));
                        end
                    end
                    commas_in_data_line = length(strfind(data_line, ','));
                    
                    number_of_fields_present = commas_in_data_line - ...
                        commas_in_data + 1;
                    if number_of_fields_present ~= expected_d_length
                        error('CompoundBin:wrong_number_of_fields', ...
                            ['The header specifies %d fields but the ' ...
                            'data contained %d fields'], ...
                            expected_d_length, number_of_fields_present);
                    end
                    
                    % Make sure the data scanned correctly.  Handle
                    % errors for fields not being integers or floating
                    % point numbers (does not take care of J or sample_types)
                    if length(d) ~= expected_d_length
                        bad_field = length(d) + 1;
                        bad_field_name = headers{bad_field};
                        if     bad_field == 1
                            error('CompoundBin:bin_id_int', ...
                                'The Bin ID field must be an integer');
                        elseif bad_field == 3
                            error('CompoundBin:compound_id_int', ...
                                'The Compound ID field must be an integer');
                        elseif bad_field == 6
                            error('CompoundBin:bin_lt_num', ...
                                'The left bin boundary must be a number');
                        elseif bad_field == 7
                            error('CompoundBin:bin_rt_num', ...
                                'The right bin boundary must be a number');
                        elseif bad_field == 9
                            error('CompoundBin:num_peaks_num', ...
                                'The number of peaks to select must be an integer');
                        else
                            error('CompoundBin:bad_data_line', ...
                                ['Could not create a compound bin from the '...
                                'data in \nData:"' data_line '"\n.' ...
                                'There is an error in the "' ...
                                bad_field_name '" field.  The header '...
                                'line given was:\n'
                                'Header:"' header_line '"\n']);
                        end
                    end
                    
                    % Add on empty sample_type field if it was missing due to
                    % old-style file
                    if isequal(header_line,header_no_sample_type_field) || ...
                        isequal(header_line, header_no_sample_type_field_excel) 
                        d={d{1:12},{''},d{13:16}};
                    end
                else
                    error('CompoundBin:unknown_header', ...
                        ['The header line passed to the CompoundBin '...
                        'constructor was not among those that the '...
                        'constructor knows how to parse.  The header '...
                        'passed was "' header_line '"']);
                end

                
                
                
                obj.id=d{1};
                if obj.id <= 0
                    error('CompoundBin:bin_id_not_pos', ...
                        ['The bin id must be an integer that is '...
                        'at least 1']);
                end

                obj.was_deleted=CompoundBin.parse_csv_bool(...
                    d{2}{1}, 'was deleted');

                obj.compound_id=d{3};
                if obj.compound_id <= 0
                    error('CompoundBin:compound_id_not_pos', ...
                        ['The compound id must be an integer that is '...
                        'at least 1']);
                end


                obj.compound_name=d{4}{1};
                if ~isempty(strfind(obj.compound_name,'"'))
                    error('CompoundBin:compound_name_has_quote', ...
                        ['The compound name cannot contain '...
                        'quotation marks (")']);
                end

                obj.is_known_compound=CompoundBin.parse_csv_bool(...
                    d{5}{1}, 'is known compound');

                obj.bin=SpectrumBin(d{6}, d{7});
                if obj.bin.left < obj.bin.right
                    error('CompoundBin:bin_bounds_reversed', ...
                        ['The left bin boundary must be at least as '...
                        'large as the right bin boundary']);
                end

                obj.multiplicity=d{8}{1};
                if ~CompoundBin.is_valid_multiplicity_string(obj.multiplicity)
                    error('CompoundBin:bad_multiplicity', ...
                        ['The string "' obj.multiplicity ...
                        '" is not a valid multiplicity string.']);
                end

                obj.num_peaks=d{9};
                if obj.compound_id <= 0
                    error('CompoundBin:compound_id_neg', ...
                        ['The number of peaks to select must not '...
                        'be a negative number.']);
                end

                jv = d{10}{1}; % j-values line
                if      isempty(jv) || ...                  %Empty
                        ~isempty(regexp(jv,'^\s*$','once')) %Spaces only
                    obj.j_values = [];
                else
                    obj.j_values=str2double(regexp(jv,'\s*,\s*','split'));
                    if any(isnan(obj.j_values))
                        error('CompoundBin:j_values_nan', ...
                            ['J values must be empty or a comma-' ...
                            'separated list of positive numbers']);
                    end
                    if any(obj.j_values <= 0)
                        error('CompoundBin:j_values_not_pos', ...
                            'J values must all be positive');
                    end
                end

                obj.nucleus_assignment=d{11}{1};
                if ~isempty(strfind(obj.nucleus_assignment,'"'))
                    error('CompoundBin:nucleus_assignment_has_quote', ...
                        ['The nucleus assignment cannot contain'...
                        ' quotation marks (")']);
                end



                hid = d{12}{1}; % HMDB id line
                if isempty(hid) || ~isempty(regexp(hid,'^\s*$','once'))
                    obj.hmdb_id = nan;
                else
                    obj.hmdb_id=str2double(hid);
                    if isnan(obj.hmdb_id)
                        error('CompoundBin:hmdb_id_not_num', ...
                            'The HMDB ID must be a number');
                    end
                end
                
                stypes = d{13}{1};
                % Remove leading and trailing spaces
                stypes = regexprep(stypes,'^\s+|\s+$','');
                if  isempty(stypes)
                    obj.sample_types = {};
                else
                    % Split on commas (eating white-space adjacent to them)
                    obj.sample_types = sort(regexp(stypes,'\s*,\s*','split'));
                end


                obj.chenomix_was_used=CompoundBin.parse_csv_bool(...
                    d{14}{1}, 'chenomix was used');


                if isempty(d{15})
                    obj.literature = '';
                else
                    obj.literature=d{15}{1};
                    if ~isempty(strfind(obj.literature,'"'))
                        error('CompoundBin:literature_has_quote', ...
                            ['The literature field cannot contain '...
                            'quotation marks (")']);
                    end
                end

                if isempty(d{16})
                    obj.nmr_isotope='';
                else
                    obj.nmr_isotope=d{16}{1};
                    if isempty(regexp(obj.nmr_isotope,'^\d{1,3}[A-Z][a-z]{0,2}$','once'))
                        error('CompoundBin:isotope_bad_format', ...
                            ['The nmr isotope be a series of 1 to 3 '...
                            'digits followed by a capital letter and '...
                            'up to 2 more lower case letters.  For '...
                            'example: "1H" and "6Li" would be valid, ' ...
                            'but "1h", "6LI", and "P" would not.']);
                    end
                end

                if isempty(d{17})
                    obj.notes = '';
                else
                    obj.notes=d{17}{1};
                    if ~isempty(strfind(obj.notes,'"'))
                        error('CompoundBin:notes_has_quote', ...
                            ['The notes field cannot contain '...
                            'quotation marks (")']);
                    end
                end
            end
        end
        
        function str=get.readable_multiplicity(obj)
            % Getter method calculating a readable version of the multiplicity
            % from the multiplicity variable
            str = CompoundBin.human_readable_multiplicity(obj.multiplicity);
        end
        
        function str=string_from_format(obj, sprintf_format, ...
                affirm, reject)
            % Common string formatting function. Will adapt booleans (AKA
            % logicals) to the string passed as the affirm parameter when
            % they are true and to the string passed as the reject
            % parameter when they are false.
            
            str = sprintf(sprintf_format, ...
                obj.id, bool2str(obj.was_deleted, affirm, reject), ...
                obj.compound_id, obj.compound_name, ...
                bool2str(obj.is_known_compound, affirm, reject), ...
                obj.bin.left, obj.bin.right, ...
                obj.multiplicity, obj.num_peaks, ...
                farray2str(obj.j_values), ...
                obj.nucleus_assignment, hmdbstr(obj.hmdb_id), ...
                stypesstr(obj.sample_types), ...
                bool2str(obj.chenomix_was_used, affirm, reject),...
                obj.literature, obj.nmr_isotope, obj.notes);
            
            function sts=stypesstr(cells)
                %Convert the cell array of strings to a comma-separated string
                if isempty(cells)
                    sts='';
                elseif length(cells) == 1
                    sts = sprintf('%s',cells{1});
                else
                    sts = sprintf('%s%s',sprintf('%s, ',cells{1:end-1}),...
                        cells{end});
                end
            end
            
            function hs=hmdbstr(h)
                %Convert the hmdb number to either an integer or a '' if nan
                if isnan(h)
                    hs = '';
                else
                    hs = sprintf('%d',h);
                end
            end
            
            function ss=farray2str(a)
                %Convert an array of floats to a comma-separated string
                if isempty(a)
                    ss = '';
                elseif length(a) == 1
                    ss = sprintf('%f',a(1));
                else
                    ss = sprintf('%s%f',sprintf('%f, ',a(1:end-1)),a(end));
                end
            end
            
            function s=bool2str(bool, affirm, reject)
                %Convert a bool to a string that is either affirm's or
                %reject's value.
                if bool
                    s = affirm;
                else
                    s = reject;
                end
            end
        end
        
        
        
        function str=get.as_csv_string(obj)
            % Getter method returning the value of as_csv_string
            
            % Fields:
            %
            %['"Bin ID","Deleted","Compound ID","Compound Name",'...
            % '"Known Compound","Bin (Lt)","Bin (Rt)",'...
            % '"Multiplicity","Peaks to Select","J (Hz)",'...
            % '"Nucleus Assignment","HMDB ID",'...
            % '"Sample-types that may contain compound",'...
            % '"Chenomx","Literature","NMR Isotope","Notes"'];
            
            format=['%d,"%s",%d,"%s",'... to Compound Name
                '"%s",%f,%f,'     ... to Bin (Rt)
                '"%s",%d,"%s",'   ... to J (Hz)
                '"%s",%s,"%s","%s",' ... to Chenomix
                '"%s","%s","%s"'];
            
            str = string_from_format(obj, format, 'X', '');
            
        end
        
        function str=get.as_long_string(obj)
            % Getter method returning the value of as_long_string
            
            % Fields:
            %
            %['"Bin ID","Deleted","Compound ID","Compound Name",'...
            % '"Known Compound","Bin (Lt)","Bin (Rt)",'...
            % '"Multiplicity","Peaks to Select","J (Hz)",'...
            % '"Nucleus Assignment","HMDB ID","Chenomx",'...
            % '"Literature","NMR Isotope","Notes"'];
            
            format=['Bin ID: %d\n' ...
                'Deleted: %s\n' ...
                'Compound ID: %d\n' ...
                'Compound Name: %s\n' ...
                'Known Compound: %s\n'...
                'Bin (Lt): %f\n'...
                'Bin (Rt): %f\n'     ...
                'Multiplicity: %s\n'...
                'Peaks to Select: %d\n'...
                'J (Hz): %s\n'   ...
                'Nucleus Assignment: %s\n'...
                'HMDB ID: %s\n'...
                'Sample-types that may contain compound: %s\n'...
                'Chenomx: %s\n' ...
                'Literature: %s\n'...
                'NMR Isotope: %s\n'...
                'Notes:\n%s\n'];
            
            str = string_from_format(obj, format, 'Yes', 'No');
            
        end
        
        
        
        function r = eq(a,b)
            % Equality testing (called by operator ==).  Not defined for
            % matrices of CompoundBin
            i = [a.id] == [b.id];
            wd = [a.was_deleted] == [b.was_deleted];
            cd = [a.compound_id] == [b.compound_id];
            cn = strcmp({a.compound_name},{b.compound_name});
            kc = [a.is_known_compound] == [b.is_known_compound];
            bn = [a.bin] == [b.bin];
            mu = strcmpi({a.multiplicity},{b.multiplicity});
            np = [a.num_peaks] == [b.num_peaks];
            
            % This if statement is to generate the jv, comparing the
            % j_values fields
            if(length(a) == length(b))
                %Element wise compare
                equal_contents = @(a,b) ...
                    (isempty(a) && isempty(b)) || ...
                    (~isempty(a) && ~isempty(b) && all(a==b));
                jv = cellfun(equal_contents, {a.j_values}, {b.j_values});
            else
                %Compare single with each element of rest
                if length(a) == 1
                    sing = a.j_values;
                    rest = b;
                elseif length(b) == 1
                    sing = b.j_values;
                    rest = a;
                else
                    error('CompoundBin_eq:size_mismatch',['When '...
                        'comparing arrays of CompoundBin objects, they '...
                        'must both have the same size, or one must have '...
                        'length==1.  Comparison of matrices is not '...
                        'supported.']);
                end
                
                equal_to_sing = @(k) ...
                    (isempty(sing) && isempty(k)) || ...
                    (~isempty(sing) && ~isempty(k) && all(sing==k));
                jv = cellfun(equal_to_sing, {rest.j_values});
            end

            % This if statement is to generate the sts, comparing the
            % sample_types fields
            if(length(a) == length(b))
                %Element wise compare
                equal_contents = @(a,b) ...
                    (isempty(a) && isempty(b)) || ...
                    (length(a) == length(b) && all(strcmp(a,b)));
                sts = cellfun(equal_contents, {a.sample_types}, {b.sample_types});
            else
                %Compare single with each element of rest
                if length(a) == 1
                    sing = a.sample_types;
                    rest = b;
                elseif length(b) == 1
                    sing = b.sample_types;
                    rest = a;
                else
                    error('CompoundBin_eq:size_mismatch',['When '...
                        'comparing arrays of CompoundBin objects, they '...
                        'must both have the same size, or one must have '...
                        'length==1.  Comparison of matrices is not '...
                        'supported.']);
                end
                
                equal_to_sing = @(k) ...
                    (isempty(sing) && isempty(k)) || ...
                    (length(sing)==length(k) && all(strcmp(sing,k)));
                sts = cellfun(equal_to_sing, {rest.sample_types});
            end
            
            na = strcmp({a.nucleus_assignment}, {b.nucleus_assignment});
            hm = (isnan([a.hmdb_id]) & isnan([b.hmdb_id])) | ...
                ([a.hmdb_id] == [b.hmdb_id]);
            cx = [a.chenomix_was_used] == [b.chenomix_was_used];
            li = strcmp({a.literature}, {b.literature});
            ni = strcmp({a.nmr_isotope}, {b.nmr_isotope});
            no = strcmp({a.notes}, {b.notes});
            
            r = i   & wd & cd & cn & kc & bn & mu & np & jv & na & hm & ...
                sts & cx & li & ni & no;
        end
    end
end


