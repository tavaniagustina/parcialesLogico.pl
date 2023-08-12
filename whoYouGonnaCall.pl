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
satisfaceNecesidad(Persona, Herramienta) :-
    tiene(Persona, Herramienta).

satisfaceNecesidad(Persona, aspiradora(PotenciaRequerida)) :-
    tiene(Persona, aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida).

% 3
puedeHacerTarea(Persona, Tarea) :-
    tiene(Persona, varitaDeNeutrones),
    herramientasRequeridas(Tarea, _).

puedeHacerTarea(Persona, Tarea) :-
    tiene(Persona, _),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), satisfaceNecesidad(Persona, Herramienta)).

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

valorACobrar(Cliente, ValorTotal) :-
    tareaPedida(_, Cliente, _),
    findall(Precio, precioPorTarea(Cliente, _, Precio), Precios),
    sumlist(Precios, ValorTotal).    

precioPorTarea(Cliente, Tarea, Precio) :-
    tareaPedida(Tarea, Cliente, MetrosCuadrados),
    precio(Tarea, PrecioPorMetroCuadrado),
    Precio is MetrosCuadrados * PrecioPorMetroCuadrado.

% 5
esCompleja(limpiarTecho).

esCompleja(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cuantas),
    Cuantas > 2.

aceptaPedido(Persona, Cliente) :-
    puedeHacerTodasLasTareas(Persona, Cliente),
    dispuestoAHacer(Persona, Cliente).
    
puedeHacerTodasLasTareas(Persona, Cliente) :-
    tiene(Persona, _),
    tareaPedida(_, Cliente, _),
    forall(tareaPedida(Tarea, Cliente, _), puedeHacerTarea(Persona, Tarea)).

dispuestoAHacer(ray, Cliente) :-
    not(tareaPedida(limpiarTecho, Cliente, _)).

dispuestoAHacer(winston, Cliente) :-
    valorACobrar(Cliente, ValorTotal),
    ValorTotal > 500.

dispuestoAHacer(egon, Cliente) :-
    not((esCompleja(Tarea), tareaPedida(Tarea, Cliente, _))).

dispuestoAHacer(peter, _).