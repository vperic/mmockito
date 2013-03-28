function runtests(what)
    import matlab.unittest.TestSuite;

    switch what,
        case 'acctests',
            run(TestSuite.fromFolder('acctests'))
        otherwise,
            error('Do not know what to run.');
    end
end