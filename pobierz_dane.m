clear all;
%%pobranie danych o punktach
ilosc_pktow=0;
ilosc_cial=0;
dane=fopen('dane.txt','r');
ilosc_pktow=str2num(fgetl(dane));
punkty=zeros(ilosc_pktow,2);
ktore_cialo=zeros(ilosc_pktow,1);
for i=1:ilosc_pktow
    temp=str2num(fgetl(dane));
    ktore_cialo(i)=temp(1);
    punkty(i,:)=temp(2:3);
end
ilosc_cial=str2num(fgetl(dane));
srodki_ciezkosci=zeros(ilosc_cial,2);
for i=1:ilosc_cial
   srodki_ciezkosci(i,:)=str2num(fgetl(dane));
end
fclose(dane);
%% Więzy
wiezy=fopen('wiezy.txt','r');
ilosc_obr=0;
ilosc_post=0;
ilosc_obr=str2num(fgetl(wiezy));
obrotowe=zeros(ilosc_obr,3);
for i=1:ilosc_obr
    obrotowe(i,:)=str2num(fgetl(wiezy));
end
ilosc_post=str2num(fgetl(wiezy));
postepowe=zeros(ilosc_post,5);
for i=1:ilosc_post
    postepowe(i,:)=str2num(fgetl(wiezy));
end
fclose(wiezy);
%% Wymuszenia
wymuszenie=fopen('wymuszenie.txt','r');
for i=1:8
   eval(fgetl(wymuszenie)); 
end

ilosc_wym_obr=0;
ilosc_wym_post=0;
ilosc_wym_obr=str2num(fgetl(wymuszenie));
for i=1:ilosc_wym_obr
    wym_obr(i,:)=textscan(wymuszenie,'%d %s %s %s\n');
end
ilosc_wym_post=textscan(wymuszenie,'%d\n');
for i=1:ilosc_wym_post{1}
    wym_post(i,:)=textscan(wymuszenie,'%d %s %s %s\n');
end
fclose(wymuszenie);
%% przypisanie do struktury Wiezy
Wiezy = struct('typ',{},...
    'klasa',{},... % jak to para? para postepowa czy obrotowa 
    'bodyi',{},... %  nr pierwszego ciala
    'bodyj',{},... % nr drugiego ciala
    'sA',{},... % wektor sA w i-tym ukladzie (cialo i)
    'sB',{},... % wektor sB w j-tym ukladzie (cialo j)
    'phi0',{},... % kat phi0 (gdy pary postepowa)
    'perp',{},... % wersor prostopadly do osi ruchu w ukladzie j-tym (gdy pary postepowa)
    'fodt',{},... % funkcja od czasu dla wiezow dopisanych
    'dotfodt',{},... % pochodna funkcji od czasu dla wiezow dopisanych
    'ddotfodt',{}); % druga pochodna funkcji od czasu dla wiezow dopisanych
wszystkie_wiezy=ilosc_obr+ilosc_post+ilosc_wym_obr+ilosc_wym_post{1};
for i=1:ilosc_obr
        if (obrotowe(i,2)~=0 && obrotowe(i,3)~=0)
        Wiezy(i)=cell2struct({'kinematyczny','obrotowy',obrotowe(i,2),obrotowe(i,3),(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,2),:))',(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,3),:))',[],[],[],[],[]}',fieldnames(Wiezy));
        elseif (obrotowe(i,2)==0)
            Wiezy(i)=cell2struct({'kinematyczny','obrotowy',obrotowe(i,2),obrotowe(i,3),(punkty(obrotowe(i,1),:))',(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,3),:))',[],[],[],[],[]}',fieldnames(Wiezy));
        elseif (obrotowe(i,3)==0)
            Wiezy(i)=cell2struct({'kinematyczny','obrotowy',obrotowe(i,2),obrotowe(i,3),(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,2),:))',(punkty(obrotowe(i,1),:))',[],[],[],[],[]}',fieldnames(Wiezy));
        end
end
for i=1:ilosc_post
    if ( i<=ilosc_post)
        pom=punkty(postepowe(i,2),:)-punkty(postepowe(i,1),:);
        pom=[-pom(2) pom(1)];
        Wiezy(i+ilosc_obr)=cell2struct({'kinematyczny','postepowy',postepowe(i,3),postepowe(i,4),(punkty(postepowe(i,1),:)-srodki_ciezkosci(postepowe(i,3),:))',(punkty(postepowe(i,2),:)-srodki_ciezkosci(postepowe(i,4),:))',0,pom'/norm(pom),[],[],[]}',fieldnames(Wiezy));
    end
end

for i=1:ilosc_wym_post{1}
    pom=punkty(postepowe(i,2),:)-punkty(postepowe(i,1),:);
    Wiezy(i+ilosc_obr+ilosc_post)=cell2struct({'dopisany','postepowy',postepowe(i,3),postepowe(i,4),(punkty(postepowe(i,1),:)-srodki_ciezkosci(postepowe(i,3),:))',(punkty(postepowe(i,2),:)-srodki_ciezkosci(postepowe(i,4),:))',0,pom'/norm(pom),string(wym_post(i,2)),string(wym_post(i,3)),string(wym_post(i,4))}',fieldnames(Wiezy));
end

for i=1:ilosc_wym_obr
    Wiezy(i+ilosc_obr+ilosc_post+ilosc_wym_post{1})=cell2struct({'dopisany','obrotowy',obrotowe(i,2),obrotowe(i,3),punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,2),:),punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,3),:),[],[],string(wym_obr(i,2)),string(wym_obr(i,3)),string(wym_obr(i,4))}',fieldnames(Wiezy));
end




