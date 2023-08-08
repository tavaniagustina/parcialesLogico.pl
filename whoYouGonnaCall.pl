herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% 1
tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

% 2
satisfaceNecesidad(Integrante, Herramienta) :-
    tiene(Integrante, Herramienta).

satisfaceNecesidad(Integrante, aspiradora(PotenciaRequerida)) :-
    tiene(Integrante, aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida).

% 3
puedeHacerTarea(Persona, Tarea) :-
    herramientasRequeridas(Tarea, _),
    tiene(Persona, varitaDeNeutrones).
    
puedeHacerTarea(Persona, Tarea) :-
    tiene(Persona, _),
    requiereHerramienta(Tarea, _),
    forall(requiereHerramienta(Tarea, Herramienta), satisfaceNecesidad(Persona, Herramienta)).
    
requiereHerramienta(Tarea, Herramienta) :-
    herramientasRequeridas(Tarea, ListaDeHerramientas),
    member(Herramienta, ListaDeHerramientas).

% 4
%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

precioACobrar(Cliente, PrecioACobrar) :-
    tareaPedida(_, Cliente, _),
    findall(Precio, precioPorTarea(Cliente, _, Precio), ListaDePrecios),
    sumlist(ListaDePrecios, PrecioACobrar).
    
precioPorTarea(Cliente, Tarea, Precio) :-
    precio(Tarea, PrecioPorMetroCuadrado),
    tareaPedida(Tarea, Cliente, MetrosCuadrados),
    Precio is PrecioPorMetroCuadrado * MetrosCuadrados.

%  5

aceptaPedido(Trabajador, Cliente) :-
    puedeHacerPedido(Trabajador, Cliente),
    estaDispuestoAHacer(Trabajador, Cliente).

puedeHacerPedido(Trabajador, Cliente) :-
    tiene(Trabajador, _),
    tareaPedida(_, Cliente, _),
    forall(tareaPedida(Tarea, Cliente, _), puedeHacerTarea(Trabajador, Tarea)).

estaDispuestoAHacer(ray, Cliente) :-
    not(tareaPedida(limpiarTecho, Cliente, _)).

estaDispuestoAHacer(winston, Cliente) :-
    precioACobrar(Cliente, PrecioACobrar),
    PrecioACobrar >= 500.

estaDispuestoAHacer(peter, _).

estaDispuestoAHacer(egon, Cliente) :-
    not((tareaPedida(Tarea, Cliente, _), tareaCompleja(Tarea))).
    
tareaCompleja(limpiarTecho).

tareaCompleja(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.

% 6
    




