function r = runtests()
    import matlab.unittest.TestSuite;

    r = run(TestSuite.fromFile('FirstImprovementLocalSearchTest.m'));
end