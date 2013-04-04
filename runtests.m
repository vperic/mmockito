function r = runtests(what)
    import matlab.unittest.TestSuite;
    addpath('mmockito');

    switch what,
        case 'all',
            r = run(TestSuite.fromFolder('tests', 'IncludingSubfolders', true));
        case 'acceptance',
            r = run(TestSuite.fromFolder('tests\acceptance'));
        case 'unit',
            r = run(TestSuite.fromFolder('tests\unit'));
        otherwise,
            try
                r = run(TestSuite.fromFile(strcat('tests/unit/', what)));
            catch ME
                error('Do not know what to run. Try "unit" or "acceptance"');
            end;
                
    end
    
    disp([num2str(nnz([r.Passed]) / numel(r) * 100), ' % tests passed']);
end