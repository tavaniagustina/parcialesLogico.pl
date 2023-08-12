% animal(nombre, gallinas(peso, cantidad de huevos que ponen por semana)).
% animal(nombre, gallos su profesión).
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

granja(tweedys, [ginger, babs, bunty, mac, fowler]).
granja(delSol, [turuleca, oro, nick, fetcher]).

%  1
puedeCederle(UnaGallina, OtraGallina) :-
    animal(UnaGallina, gallina(_, 7)),
    animal(OtraGallina, gallina(_, Huevos)),
    Huevos < 3.

% 2
animalLibre(Nombre) :-
    animal(Nombre, _),
    not(viveEnGranja(Nombre)).

viveEnGranja(Nombre) :-
    granja(_, AnimalesGranja),
    member(Nombre, AnimalesGranja).
    
% 3
valoracionDeGranja(Granja, Valoracion) :-
    granja(Granja, AnimalesDeLaGranja),
    valoracionGallos(AnimalesDeLaGranja, ValoracionGallos),
    valoracionGallinas(AnimalesDeLaGranja, ValoracionGallinas),
    Valoracion is ValoracionGallos + ValoracionGallinas.
    
valoracionGallos(AnimalesDeLaGranja, ValoracionGallos) :-
    findall(Gallo, member(Gallo, AnimalesDeLaGranja), Gallos),
    length(Gallos, CantidadDeGallos),
    valoracionAnimal(Gallo, Valoracion),
    ValoracionGallos is Valoracion * CantidadDeGallos.

valoracionGallinas(AnimalesDeLaGranja, ValoracionGallos) :-
    findall(Gallina, member(Gallina, AnimalesDeLaGranja), Gallinas),
    length(Gallinas, CantidadDeGallinas),
    valoracionAnimal(Gallina, Valoracion),
    ValoracionGallos is Valoracion * CantidadDeGallinas.

valoracionAnimal(rata, 0).

valoracionAnimal(gallo(Profesion), 50) :-
    pilotoOAnimalDeCirco(Profesion).

valoracionAnimal(gallo(Profesion), 25) :-
    not(pilotoOAnimalDeCirco(Profesion)).
    
valoracionAnimal(gallinas(Peso, Huevos), Valoracion) :-
    Valoracion is Peso * Huevos.

pilotoOAnimalDeCirco(piloto).
pilotoOAnimalDeCirco(animalDeCirco).

% 4
granjaDeluxe(Granja) :-
    viveEnGranja(rata),
    granja(Granja, AnimalesGranja),
    length(AnimalesGranja, Cuantos),
    Cuantos > 50.
   
granjaDeluxe(Granja) :-
    viveEnGranja(rata),
    valoracionDeGranja(Granja, 100).

% 5
buenaPareja(UnAnimal, OtroAnimal) :-
    puedeCederle(UnAnimal, OtroAnimal),
    animal(UnAnimal, gallina(Peso, _)),
    animal(OtroAnimal, gallina(Peso, _)).

buenaPareja(UnAnimal, OtroAnimal) :-
    UnAnimal \= OtroAnimal,
    animal(UnAnimal, gallo(UnaProfesion)),
    animal(OtroAnimal, gallo(OtraProfesion)),
    pilotoOAnimalDeCirco(UnaProfesion),
    not(pilotoOAnimalDeCirco(OtraProfesion)).

buenaPareja(UnAnimal, OtroAnimal) :-
    UnAnimal \= OtroAnimal,
    animal(UnAnimal, rata),
    animal(OtroAnimal, rata).

% 6
escapePerfecto(Granja) :-
    granja(Granja, AnimalesDeLaGranja),
    forall((member(Animal, AnimalesDeLaGranja), animal(Animal, gallina(_, Huevos))), Huevos > 5),
    forall((member(UnAnimal, AnimalesDeLaGranja), member(AnimalesDeLaGranja, OtroAnimal)), buenaPareja(UnAnimal, OtroAnimal)).
