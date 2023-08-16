% animal(nombre, gallinas(peso, cantidad de huevos que ponen por semana)).
% animal(nombre, gallos su profesión).
%animal(Nombre, Tipo).
animal(ginger, gallina(10, 5)).
animal(babs, gallina(15, 2)).
animal(bunty, gallina(23, 6)).
animal(mac, gallina(8, 7)).
animal(turuleca, gallina(15, 1)).
animal(rocky, gallo(animalDeCirco)).
animal(fowler, gallo(piloto)).
animal(oro, gallo(arrocero)).
animal(nick, rata).
animal(fetcher, rata).

%granja(Nombre, [NombreDeAnimales]).
granja(tweedys, [ginger, babs, bunty, mac, fowler]).
granja(delSol, [turuleca, oro, nick, fetcher]).

%  1
puedeCederle(UnaGallina, OtraGallina) :-
    animal(UnaGallina, gallina(_, 7)),
    animal(OtraGallina, gallina(_, HuevosSemanales)),
    HuevosSemanales < 3.

% 2
animalLibre(Animal) :-
    animal(Animal, _),
    not(viveEnUnaGranja(Animal)).

viveEnUnaGranja(Animal) :-
    granja(_, AnimalesDeLaGranja),
    member(Animal, AnimalesDeLaGranja).
    
% 3
valoracionDeGranja(Granja, ValoracionTotal) :-
    granja(Granja, AnimalesDeLaGranja),
    findall(Valor, valoracionAnimal(AnimalesDeLaGranja, Valor), Valoraciones),
    sumlist(Valoraciones, ValoracionTotal).
    
valoracionAnimal(AnimalesDeLaGranja, Valor) :-
    member(Nombre, AnimalesDeLaGranja),
    valoracionIndividual(Nombre, Valor).

valoracionIndividual(Nombre, 0) :-
    animal(Nombre, rata).

valoracionIndividual(Nombre, 50) :-
    animal(Nombre, gallo(Profesion)),
    sabeVolar(Profesion).

valoracionIndividual(Nombre, 25) :-
    animal(Nombre, gallo(Profesion)),
    not(sabeVolar(Profesion)).

valoracionIndividual(Nombre, Valor) :-
    animal(Nombre, gallina(Peso, HuevosSemanales)),
    Valor is Peso * HuevosSemanales.

sabeVolar(piloto).
sabeVolar(animalDeCirco).

% 4
granjaDeluxe(Granja) :-
    granja(Granja, _),
    not(tieneAlgunaRata(Granja)),
    cantidadDeAnimalesDeUnaGranja(Granja, CantidadDeAnimales),
    CantidadDeAnimales > 50.

granjaDeluxe(Granja) :-
    granja(Granja, _),
    not(tieneAlgunaRata(Granja)),
    cantidadDeAnimalesDeUnaGranja(Granja, 1000).

tieneAlgunaRata(Granja) :-
    granja(Granja, AnimalesDeLaGranja),
    animal(Nombre, rata),
    member(Nombre, AnimalesDeLaGranja).

cantidadDeAnimalesDeUnaGranja(Granja, CantidadDeAnimales) :-
    granja(Granja, AnimalesDeLaGranja),
    length(AnimalesDeLaGranja, CantidadDeAnimales).

% 5
buenaPareja(UnAnimal, OtroAnimal) :-
    vivenEnLaMismaGranja(UnAnimal, OtroAnimal),
    sonCompatibles(UnAnimal, OtroAnimal).

vivenEnLaMismaGranja(UnAnimal, OtroAnimal) :-
    granja(_, AnimalesDeLaGranja),
    member(UnAnimal, AnimalesDeLaGranja),
    member(OtroAnimal, AnimalesDeLaGranja).

sonCompatibles(UnAnimal, OtroAnimal) :-
    animal(UnAnimal, gallina(Peso, _)),
    animal(OtroAnimal, gallina(Peso, _)),
    puedeCederle(UnAnimal, OtroAnimal).

sonCompatibles(UnAnimal, OtroAnimal) :-
    animal(UnAnimal, gallo(UnaProfesion)),
    animal(OtroAnimal, gallo(OtraProfesion)),
    sabeVolar(UnaProfesion),
    not(sabeVolar(OtraProfesion)).

sonCompatibles(UnAnimal, OtroAnimal) :-
    animal(UnAnimal, rata),
    animal(OtroAnimal, rata).

% 6
escapePerfecto(Granja) :-
    granja(Granja, AnimalesDeLaGranja),
    findall(Gallina, esGallina(Gallina, AnimalesDeLaGranja), Gallinas),
    sonPonedoras(Gallinas),
    todosHacenBuenaPareja(AnimalesDeLaGranja).

esGallina(Gallina, AnimalesDeLaGranja) :-
    animal(Gallina, gallina(_, _)),
    member(Gallina, AnimalesDeLaGranja).

sonPonedoras(Gallinas) :-
    forall(member(Gallina, Gallinas), huevosSemanales(Gallina)).

huevosSemanales(Gallina) :-
    animal(Gallina, gallina(_, HuevosSemanales)),
    HuevosSemanales > 5.    

todosHacenBuenaPareja(AnimalesDeLaGranja) :-
    member(UnAnimal, AnimalesDeLaGranja),
    member(OtroAnimal, AnimalesDeLaGranja),
    buenaPareja(UnAnimal, OtroAnimal),
    UnAnimal \= OtroAnimal.




