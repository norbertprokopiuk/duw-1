% funckja rozwiazuje uk�adu r�wna� metod� Newtona-Raphsona
% q0 to przybli�enie startowe  
% t to chwila, dla kt�rej poszukiwane jest rozwi�zanie 
% q to uzyskane rozwi�zanie
function q=NewtonRaphson(q0,t, Wiezy, rows)

q=q0;

F=WektorPhi(q,t, Wiezy, rows);
iter=1;  
while ( (norm(F)>1e-10) && (iter < 200) )
    F=WektorPhi(q,t, Wiezy, rows);
    Fq=Jakobian(q,t,Wiezy,rows);
    q=q-Fq\F; 
    iter=iter+1;
end
if iter >= 250
    disp('BLAD: Po 250 iteracjach nie ma zbie�no�ci');
    norm(F)
    q=q0;
end

