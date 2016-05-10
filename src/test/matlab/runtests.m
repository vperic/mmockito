function r = runtests(what)
    import matlab.unittest.TestSuite;
    rootDir = fileparts(which('runtests.m'));
    testDir = fullfile(rootDir, 'tests');
    addpath(fullfile(rootDir, 'mmockito'));
    addpath(testDir);
    switch what,
        case 'all',
            r = run(TestSuite.fromFolder(testDir, 'IncludingSubfolders', true));
        case 'acceptance',
            r = run(TestSuite.fromFolder([testDir '\acceptance']));
        case 'unit',
            r = run(TestSuite.fromFolder([testDir '\unit']));
        otherwise,
            try
                r = run(TestSuite.fromFile([testDir '\unit' what]));
            catch ME
                error('Do not know what to run. Try "unit" or "acceptance"');
            end;
                
    end
    
    disp([num2str(nnz([r.Passed]) / numel(r) * 100), ' % tests passed']);
end