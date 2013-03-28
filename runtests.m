function runtests(what)
    import matlab.unittest.TestSuite;
    addpath('mmockito');

    switch what,
        case 'acceptance',
            run(TestSuite.fromFolder('tests\acceptance'))
        case 'unit',
            run(TestSuite.fromFolder('tests\unit'))
        otherwise,
            error('Do not know what to run.');
    end
end