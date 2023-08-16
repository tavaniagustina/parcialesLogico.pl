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
esUnAfano(Jugador1, Jugador2) :-
    jugador(Jugador1, Raiting1, _),
    jugador(Jugador2, Raiting2, _),
    Diferencia is Raiting1 - Raiting2,
    Diferencia > 500.

% 2
esEfectivo(Tipo1, Tipo2) :-
    militar(Tipo1, costo(0, 60, 20), Categoria1),
    militar(Tipo2, costo(0, 60, 20), Categoria2),
    leGana(Categoria1, Categoria2).

esEfectivo(sumarai, Tipo) :-
    militar(Tipo, _, unica).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).

% 3
alarico(Jugador) :-
    soloTiene(Jugador, infanteria).

% 4
leonidas(Jugador) :-
    soloTiene(Jugador, piquero).

soloTiene(Jugador, Categoria) :-
    tiene(Jugador, _),
    forall(tiene(Jugador, unidad(Tipo, _)), militar(Tipo, _, Categoria)).

% 5
nomada(Jugador) :-
    tiene(Jugador, _),
    not(tieneEdificio(Jugador, casa)).

tieneEdificio(Jugador, Tipo) :-
    tiene(Jugador, edificio(Tipo, _)).

% 6
cuantoCuesta(Unidad, Costo) :-
    militar(Unidad, Costo, _).

cuantoCuesta(Unidad, Costo) :-
    edificio(Unidad, Costo).

cuantoCuesta(Unidad, costo(0, 50, 0)) :-
    aldeano(Unidad, _).

cuantoCuesta(Unidad, costo(100, 0, 50)) :-
    carretaOUrna(Unidad).

carretaOUrna(carreta).
carretaOUrna(urna).

% 7
produccion(Tipo, ProduccionPorMinuto) :-
    aldeano(Tipo, ProduccionPorMinuto).

produccion(Tipo, produce(0, 0, 32)) :-
    carretaOUrna(Tipo).

produccion(Tipo, produce(0, 0, Oro)) :-
    militar(Tipo, _, _),
    esDeTipo(Tipo, Oro).

esDeTipo(keshik, 10).
esDeTipo(_, 0).

% 8
produccionTotal(Jugador, ProduccionTotal, Recurso) :-
    jugador(Jugador, _, _),
    recurso(Recurso),
    findall(Produccion, produccionDe(Jugador, Recurso, Produccion), Producciones),
    sumlist(Producciones, ProduccionTotal).

produccionDe(Jugador, Recurso, ProduccionTotal) :-
    tiene(Jugador, unidad(Tipo, Cantidad)),
    produccion(Tipo, ProduccionPorMinuto),
    produccionPorRecurso(Recurso, ProduccionPorMinuto, ProduccionRecurso),
    ProduccionTotal is Cantidad * ProduccionRecurso.

produccionPorRecurso(madera, produce(Madera, _, _), Madera).
produccionPorRecurso(alimento, produce(_, Alimento, _), Alimento).
produccionPorRecurso(oro, produce(_, _, Oro), Oro).

recurso(Recurso) :-
    produccionPorRecurso(Recurso, _, _).

% 9
estaPeleado(Jugador1, Jugador2) :-
    produccionTotalDeRecursosParecida(Jugador1, Jugador2),
    cantidadDeUnidades(Jugador1, Cantidad),
    cantidadDeUnidades(Jugador2, Cantidad),
    not(esUnAfano(Jugador1, Jugador2)),
    not(esUnAfano(Jugador2, Jugador1)).

produccionTotalDeRecursosParecida(Jugador1, Jugador2) :-
    produccionTotalRecursos(Jugador1, Produccion1),
    produccionTotalRecursos(Jugador2, Produccion2),
    Diferencia is abs(Produccion1 - Produccion2),
    Diferencia < 100.

produccionTotalRecursos(Jugador, Cantidad) :-
    produccionTotal(Jugador, ProduccionOro, oro),
    produccionTotal(Jugador, ProduccionMadera, madera),
    produccionTotal(Jugador, ProduccionAlimento, alimento),
    Cantidad is 5 * ProduccionOro + 3 * ProduccionMadera + 2 * ProduccionAlimento.

cantidadDeUnidades(Jugador, Cantidad) :-
    findall(Cantidad, tiene(Jugador, unidad(_, Cantidad)), Cantidades),
    sumlist(Cantidades, Cantidad).

% 10
avanzaA(Jugador, edadMedia) :-
    jugador(Jugador, _, _).

avanzaA(Jugador, edadFeudal) :-
    tieneAlMenos(Jugador, produce(_, 500, _)),
    tieneEdificio(Jugador, casa).

avanzaA(Jugador, edadDeLosCastillos) :-
    tieneAlMenos(Jugador, produce(_, 800, 200)),
    tieneAlgunEdificio(Jugador, [herreria, establo, galeriaDeTiro]).

avanzaA(Jugador, edadImperial) :-
    tieneAlMenos(Jugador, produce(_, 1000, 800)),
    tieneEdificio(Jugador, castillo),
    tieneEdificio(Jugador, universidad).

tieneAlMenos(Jugador, produce(MaderaMinima, AlimentoMinimo, OroMinimo)) :-
    tiene(Jugador, recurso(Madera, Alimento, Oro)),
    Madera >= MaderaMinima,
    Alimento >= AlimentoMinimo,
    Oro >= OroMinimo.

tieneAlgunEdificio(Jugador, Edificios) :-
    tieneEdificio(Jugador, Tipo),
    member(Tipo, Edificios).
