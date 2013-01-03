function run(what)
    switch what,
        case 'acctests',
            runtests('acctests');
        otherwise,
            error('Do not know what to run.');
    end
end