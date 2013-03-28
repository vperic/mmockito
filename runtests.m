function r = runtests(what)
    import matlab.unittest.TestSuite;
    addpath('mmockito');

    switch what,
        case 'acceptance',
            r = run(TestSuite.fromFolder('tests\acceptance'));
        case 'unit',
            r = run(TestSuite.fromFolder('tests\unit'));
        otherwise,
            error('Do not know what to run.');
    end
    
    disp([num2str(nnz([r.Passed]) / numel(r) * 100), ' % tests passed']);
end