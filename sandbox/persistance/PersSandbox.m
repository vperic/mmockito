p = Pers();
p.increment;
p.increment;

if p.a{2} == 1
    disp('First instance is ok.');
end;

p2 = Pers();
p2.increment;
p2.increment;
if p2.a{2} == 3
    disp('Second instance continued correctly.');
end;

p.increment
if p.a{3} == 4
    disp('And the count is still good.');
end;