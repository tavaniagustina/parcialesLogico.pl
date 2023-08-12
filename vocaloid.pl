% cantante(nombre, canta(nombreCancion, duracion)).
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

% 1
masNovedoso(Cantante) :-
    sabaAlMenosDosCanciones(Cantante),
    timpoTotalCanciones(Cantante, Tiempo),
    Tiempo < 15.

sabaAlMenosDosCanciones(Cantante) :-
    canta(Cantante, canta(UnaCancion, _)),
    canta(Cantante, canta(OtraCancion, _)),
    UnaCancion \= OtraCancion.

timpoTotalCanciones(Cantante, TiempoCanciones) :-
    findall(Tiempo, tiempoCanciones(Cantante, Tiempo), Tiempos),
    sumlist(Tiempos, TiempoCanciones).

tiempoCanciones(Cantante, Tiempo) :-
    canta(Cantante, Cancion),
    tiempo(Cancion, Tiempo).

tiempo(canta(_, Tiempo), Tiempo).

% 2
esAcelerado(Cantante) :-
    canta(Cantante, _),
    not((tiempoCanciones(Cantante, Tiempo), Tiempo > 15)).

% 3
% 1.
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% 2.
puedeParticipar(hatsuneMiku, Concierto) :-
    concierto(Concierto, _, _, _).

puedeParticipar(Cantante, Concierto) :-
    canta(Cantante, _),
    concierto(Concierto, _, _, Tipo),
    cumpleRequisitos(Cantante, Tipo).

cumpleRequisitos(Cantante, gigante(CantidadMinimaDeCanciones, DuracionTotalMinima)) :-
    cancionesQueSabe(Cantante, CantidadDeCanciones),
    CantidadDeCanciones >= CantidadMinimaDeCanciones,
    timpoTotalCanciones(Cantante, TiempoCanciones),
    TiempoCanciones > DuracionTotalMinima.

cumpleRequisitos(Cantante, mediano(MaximaDuracionTotalMinutos)) :-
    timpoTotalCanciones(Cantante, TiempoCanciones),
    TiempoCanciones < MaximaDuracionTotalMinutos.

cumpleRequisitos(Cantante, pequenio(AlgunaCancionConMasDuracion)) :-
    canta(Cantante, Cancion),
    tiempo(Cancion, Tiempo),
    Tiempo > AlgunaCancionConMasDuracion.

cancionesQueSabe(Cantante, CantidadDeCanciones) :-
    findall(Cancion, canta(Cantante, Cancion), Canciones),
    length(Canciones, CantidadDeCanciones).

% 3.
masFamoso(Cantante) :-
    nivelDeFama(Cantante, MayorFama),
    forall(nivelDeFama(_, Fama), MayorFama >= Fama). 

nivelDeFama(Cantante, Fama) :-
    nivelDeFamaConciertos(Cantante, FamaConciertos),
    cancionesQueSabe(Cantante, CantidadDeCanciones),
    Fama is FamaConciertos * CantidadDeCanciones.

nivelDeFamaConciertos(Cantante, FamaConciertos) :-
    canta(Cantante, _),
    findall(Fama, famaConciertos(Cantante, Fama), Famas),
    sumlist(Famas, FamaConciertos).

famaConciertos(Cantante, Fama) :-
    puedeParticipar(Cantante, Concierto),
    concierto(Concierto, _, Fama, _).

% 4.
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoEnParticipar(Cantante) :-
    puedeParticipar(Cantante, Concierto),
    not((conocido(Cantante, OtroCantante), puedeParticipar(OtroCantante, Concierto))).

conocido(Cantante, OtroCantante) :-
    conoce(Cantante, OtroCantante).

conocido(Cantante, OtroCantante) :-
    conoce(Cantante, UnCantante),
    conoce(UnCantante, OtroCantante).