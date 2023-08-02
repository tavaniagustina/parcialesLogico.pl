% Punto 1

% dodain atiende lunes, miércoles y viernes de 9 a 15.
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
% lucas atiende los martes de 10 a 20
atiende(lucas, martes, 10, 20).
% juanC atiende los sábados y domingos de 18 a 22.
atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).
% juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
% leoC atiende los lunes y los miércoles de 14 a 18.
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
% martu atiende los miércoles de 23 a 24.
atiende(martu, miercoles, 23, 24).
% vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dia, HoraDeInicio, HoraDeFinalizacion) :-
    atiende(dodain, Dia, HoraDeInicio, HoraDeFinalizacion).

atiende(vale, Dia, HoraDeInicio, HoraDeFinalizacion) :-
    atiende(juanC, Dia, HoraDeInicio, HoraDeFinalizacion).

% En caso de no ser necesario hacer nada, explique qué concepto teórico está relacionado y justifique su respuesta.

% nadie hace el mismo horario que leoC
% Por principio de universo cerrado, no agregamos a la base de conocimiento lo que no tiene sentido agregar, y 

% maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% Por principio de universo cerrado, lo desconocido se presume falso

% Punto 2
quienAtiende(Persona, Dia, HoraPuntual) :-
    atiende(Persona, Dia, HoraDeInicio, HoraDeFinalizacion),
    between(HoraDeInicio, HoraDeFinalizacion, HoraPuntual).
    
% Punto 3
foreverAlone(Persona, Dia, HoraPuntual) :-
    quienAtiende(Persona, Dia, HoraPuntual),
    not((quienAtiende(OtraPersona, Dia, HoraPuntual), Persona \= OtraPersona)).
    
% Punto 4
posibilidadesDeAtencion(Dia, Personas) :-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).

combinar([], []).

combinar([Persona|PersonasPosibles], [Persona|Personas]) :-
    combinar(PersonasPosibles, Personas).

combinar([_|PersonasPosibles], Personas) :-
    combinar(PersonasPosibles, Personas).
    
% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles

% Punto 5
% dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
venta(dodain, fecha(10, 08), [golosinas(1200), cigarrillos(jockey), golosinas(10)]).

% dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
venta(dodain, fecha(12, 08), [bebida(true, 8), bebida(false, 1), golosinas(10)]).

% martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
venta(martu, fecha(12, 08), [golosinas(100), cigarrillos([chesterfield, colorado, parisiennes])]).

% lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
venta(lucas, fecha(11, 08), [golosinas(600)]).

% lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
venta(lucas, fecha(18, 08), [bebida(false, 2), cigarrillos(derby)]).

esSuertuda(Persona) :-
    venta(Persona, _, _),
    forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).
    
ventaImportante(golosinas(Precio)) :-
    Precio > 100.

ventaImportante(cigarrillos(Marcas)) :-
    length(Marcas, Cantidad),
    Cantidad > 2.

ventaImportante(bebida(true,_)).

ventaImportante(bebida(_,Cantidad)) :-
    Cantidad > 5.
