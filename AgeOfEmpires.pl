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
    abs(UnRaiting - OtroRaiting) > 500.

% 2
esEfectivo(Categoria1, Categoria2) :-
    leGana(Categoria1, Categoria2).

esEfectivo(samurai, Categoria) :-
    esMilitar(Categoria, _, unica).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piqueros, caballeria).

esMilitar(Tipo, Costo, Categoria) :-
    militar(Tipo, Costo, Categoria).

% 3
alarico(Jugador) :-
    tiene(Jugador, _),
    soloTieneUnidadMilitarDe(Jugador, infanteria).

% 4
leonidas(Jugador) :-
    tiene(Jugador, _),
    soloTieneUnidadMilitarDe(Jugador, piquero).

soloTieneUnidadMilitarDe(Jugador, Categoria) :-
    forall(tiene(Jugador, unidad(Tipo, _)), esMilitar(Tipo, _, Categoria)).

% 5
nomada(Jugador) :-
    tiene(Jugador, _),
    not(tieneAlgunEfificio(Jugador, casa)).

tieneAlgunEfificio(Jugador, Tipo) :-
    tiene(Jugador, edificio(Tipo, _)).

% 6
cuantoCuesta(Tipo, Costo) :-
    esMilitar(Tipo, Costo, _).

cuantoCuesta(Tipo, Costo) :-
    esEdificio(Tipo, Costo).

cuantoCuesta(Tipo, costo(0, 50, 0)) :-
    esAldeano(Tipo, _).

cuantoCuesta(Tipo, costo(100, 0, 50)) :-
    esCarretaOUrna(Tipo).

esEdificio(Tipo, Costo) :-    
    edificio(Tipo, Costo).

esAldeano(Tipo, Produccion) :-
    aldeano(Tipo, Produccion).

esCarretaOUrna(carreta).
esCarretaOUrna(urna).

% 7
produccion(Tipo, ProduccionPorMinuto) :-
    esAldeano(Tipo, ProduccionPorMinuto).

produccion(Tipo, produccion(0, 0, 32)) :-
    esCarretaOUrna(Tipo).

produccion(Tipo, produccion(0, 0, Oro)) :-
    esMilitar(Tipo, _, _),
    evaluarOro(Tipo, Oro).

evaluarOro(keshik, 10).
evaluarOro(_, 0).

% 8
produccionTotal(Jugador, Recurso, ProduccionTotalPorMinuto) :-
    tiene(Jugador, _),
    recurso(Recurso),
    findall(Recurso, tieneYProduce(Jugador, Recurso, _), Recursos),
    sumlist(Recursos, ProduccionTotalPorMinuto).

tieneYProduce(Jugador, Recurso, Produccion) :-
    tiene(Jugador, unidad(Tipo, Cantidad)),
    produccion(Tipo, ProduccionPorMinuto),
    produccionDelRecurso(Recurso, ProduccionPorMinuto, ProduccionDelRecurso),
    Produccion is Cantidad * ProduccionDelRecurso. 

produccionDelRecurso(madera, produccion(Madera, _, _), Madera).
produccionDelRecurso(alimento, produccion(_, Alimento, _), Alimento).
produccionDelRecurso(oro, produccion(_, _, Oro), Oro).

recurso(oro).
recurso(madera).
recurso(alimento).

% 9

% 10
avanza(Jugador, Edad) :-
    jugador(Jugador, _, _),
    avanzaSegun(Jugador, Edad).

avanzaSegun(_, edadMedia).

avanzaSegun(Jugador, edadFeudal) :-
    not(nomada(Jugador)),
    cumpleAlimento(Jugador, 500).

avanzaSegun(Jugador, edadDeLosCastillos) :-
    cumpleAlimento(Jugador, 800),
    cumpleOro(Jugador, 200),
    edificioEdadDdeCastillos(edificio),
    tieneAlgunEfificio(Jugador, edificio).

avanzaSegun(Jugador, edadImperial) :-
    cumpleAlimento(Jugador, 1000),
    cumpleOro(Jugador, 800),
    edificioEdadImperial(edificio),
    tieneAlgunEfificio(Jugador, edificio).

cumpleAlimento(Jugador, Cantidad) :-
    recursosJugador(Jugador, _, Alimento, _),
    Alimento > Cantidad.

cumpleOro(Jugador, Cantidad) :-
    recursosJugador(Jugador, _, _, Oro),
    Oro > Cantidad.

recursosJugador(Jugador, Madera, Alimento, Oro) :-
    tiene(Jugador, recurso(Madera, Alimento, Oro)).

edificioEdadDdeCastillos(herreria).
edificioEdadDdeCastillos(establo).
edificioEdadDdeCastillos(galeriaDeTiro).

edificioEdadImperial(castillo).
edificioEdadImperial(universidad).