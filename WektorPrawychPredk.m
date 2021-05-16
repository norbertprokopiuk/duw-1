% funkcja, ktora wyznacza prawe stron w rownaniach  
function [ Prawe ] = WektorPrawychPredk( q, t, Wiezy, rows )

wymuszenie=fopen('wymuszenie.txt','r');
for i=1:8
   eval(fgetl(wymuszenie)); 
end
fclose(wymuszenie);
% wype³nienie macierzy samymi zerami
Prawe = zeros(rows, 1);

% aktualny numer wiersza macierzy
m=1;

% wype³nienie macierzy niezerowymi elementami
for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ(1)) == 'd')
        if(lower(Wiezy(l).klasa(1)) == 'o')
            Prawe(m) = eval(Wiezy(l).dotfodt);
            m=m+1;
        elseif(lower(Wiezy(l).klasa(1)) == 'p')
            Prawe(m) = eval(Wiezy(l).dotfodt);
            m=m+1;
        end
    end
    if(lower(Wiezy(l).typ(1)) == 'k')
        if(lower(Wiezy(l).klasa(1)) == 'o')
            m=m+2;
        elseif(lower(Wiezy(l).klasa(1)) == 'p')
            m=m+2;
        end
    end
end

end

