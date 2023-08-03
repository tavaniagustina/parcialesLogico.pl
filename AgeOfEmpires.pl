% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

% 1
esUnAfano(UnJugador, OtroJugador) :-
    jugador(UnJugador, UnRaiting, _),
    jugador(OtroJugador, OtroRaiting, _),
    UnJugador \= OtroJugador,
    abs(UnRaiting - OtroRaiting) > 500.

% 2
esEfectivo(UnaUnidad, OtraUnidad) :-
    militar(UnaUnidad, _, Categoria1),
    militar(OtraUnidad, _, Categoria2),
    leGana(Categoria1, Categoria2).

esEfectivo(samurai, Tipo) :-
    militar(Tipo, _, unica).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).


% 3
alarico(Jugador) :-
    soloTieneUnidadesDe(infanteria, Jugador).

% 4
leonidas(Jugador) :-
    soloTieneUnidadesDe(piqueros, Jugador).

soloTieneUnidadesDe(Categoria, Jugador) :-
    tiene(Jugador, _),
    forall(tiene(Jugador, unidad(Tipo, _)), militar(Tipo, _, Categoria)).

% 5
nomada(Jugador) :-
    tiene(Jugador, _),
    not(tiene(Jugador, edificio(casa, _))).

% 6
cuantoCuesta(Tipo, Costo) :-
    militar(Tipo, Costo, _).

cuantoCuesta(Tipo, Costo) :-
    edificio(Tipo, Costo).

cuantoCuesta(Tipo, costo(0, 50, 0)) :-
    aldeano(Tipo, _).

cuantoCuesta(Tipo, costo(100, 0, 50)) :-
    esCarretaOUrna(Tipo).

esCarretaOUrna(carreta).
esCarretaOUrna(urna).

% 7
produccion(Tipo, ProduccionPorMinuto) :-
    aldeano(Tipo, ProduccionPorMinuto).

produccion(Tipo, produccionPorMinuto(0, 0, 32)) :-
    esCarretaOUrna(Tipo).

produccion(Tipo, produccionPorMinuto(0, 0, Oro)) :-
    militar(Tipo, _, _),
    oroPorMinuto(Tipo, Oro).

oroPorMinuto(keshiks, 10).
oroPorMinuto(_, 0).

% 8
% recursos (Madera, Alimento, Oro)

produccionTotal(Jugador, Recurso, ProduccionPorMinuto) :-
    tiene(Jugador, _),
    recursos(Recurso),
    findall(Produccion, loTieneYProduce(Jugador, Recurso, Produccion), Producciones),
    sumlist(Producciones, ProduccionPorMinuto).

loTieneYProduce(Jugador, Recurso, Produccion) :-
    tiene(Jugador, unidad(Tipo, Cuantas)),
    produccion(Tipo, ProduccionTotal),
    produccionDelRecurso(Recurso, ProduccionTotal, ProduccionRecurso),
    Produccion is ProduccionRecurso * Cuantas.

produccionDelRecurso(madera, produce(Madera, _, _), Madera).
produccionDelRecurso(alimento, produce(_, Alimento, _), Alimento).
produccionDelRecurso(oro, produce(_, _, Oro), Oro).

recursos(madera).
recursos(alimento).
recursos(oro).

% 9

% 10
avanzaA(Jugador, Edad) :-
    jugador(Jugador , _, _),
    avanzaSegun(Jugador, Edad).

avanzaSegun(_, edadMedia).

avanzaSegun(Jugador, edadFeudal) :-
    not(nomada(Jugador)),
    cumpleAlimento(Jugador, 500).
    
avanzaSegun(Jugador, edadDeLosCastillos) :-
    cumpleAlimento(Jugador, 800),
    cumpleOro(Jugador, 200),
    edificioNecesarioParaEdadDeLosCastillos(Edificio),
    tieneAlgunEdificioNecesario(Jugador, Edificio).

avanzaSegun(Jugador, edadImperial) :-
    cumpleAlimento(Jugador, 1000),
    cumpleOro(Jugador, 800),
    edificioNecesarioParaEdadImperial(Edificio),
    tieneAlgunEdificioNecesario(Jugador, Edificio).

cumpleAlimento(Jugador, Cantidad) :-
    tiene(Jugador, recurso(_, alimento, _)),
    alimento > Cantidad.

cumpleOro(Jugador, Cantidad) :-
    tiene(Jugador, recurso(_, _, oro)), 
    oro > Cantidad.

edificioNecesarioParaEdadDeLosCastillos(herreria).
edificioNecesarioParaEdadDeLosCastillos(establo).
edificioNecesarioParaEdadDeLosCastillos(galeriaDeTiro).

tieneAlgunEdificioNecesario(Jugador, Edificio) :-
    tiene(Jugador, edificio(Edificio, _)).

edificioNecesarioParaEdadImperial(castillo).
edificioNecesarioParaEdadImperial(universidad).

