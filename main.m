function main
close all;
clear;
clc;

global variables;
global mejorGen;
global mejorFit;
global c1;
global c2;
global c3; 
global c4;
global c5; 
global c6;
global c7;
global c8;
global clase;


[c1,c2,c3,c4,c5,c6,c7,c8,clase] = textread('pima-indians-diabetes.data.txt' ,'%d%d%d%d%d%f%f%d%d','delimiter', ',');

%German
%c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,clase] = textread('german.data-numeric.txt' ,'%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d','delimiter', ' ');

%australian
%[c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,clase] = textread('australian.dat.txt' ,'%d%f%f%d%d%d%f%d%d%d%d%d%d%d%d','delimiter', ' ');

%inosfera
%[c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,clase] = textread('ionosphere.data.txt' ,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','delimiter', ',');

%wisconsin breast cancer
%[id,class,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30] = textread('wdbc.data.txt' ,'%d%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');



variables = 8;
parametros = 2;
tamPoblacion = 20;
mejorGen = 0;
mejorFit = 0;

%Opciones para el algoritmo
options = gaoptimset;
options = gaoptimset(options, 'PopulationSize', tamPoblacion);

%Genero poblacion incicial en base al tamaño de la poblacion
pobInicial = (rand(options.PopulationSize, variables+(parametros*8))> 0.1);

%Determino el número maximo de generaciones
options = gaoptimset(options, 'Generations', 100);

%Seteo parametros iniciales del algoritmo
options = gaoptimset(options, 'InitialPopulation', pobInicial);
options = gaoptimset(options, 'PopulationType' , 'bitstring');
options = gaoptimset(options, 'SelectionFcn', {@selectionroulette});
options = gaoptimset(options, 'CrossoverFcn', {@crossoverscattered});
options = gaoptimset(options, 'CrossoverFraction', 0.8);
options = gaoptimset(options, 'MutationFcn', {@mutationuniform, 0.07});

%Grafico de puntos
options = gaoptimset(options, 'Display', 'off'); 
options = gaoptimset(options, 'PlotInterval', 1); 
options = gaoptimset(options,'PlotFcns',{@gaplotbestf});


[mejorSol,~,~,~,~,~] = ga(@fitness, variables+(parametros*8), options);

end

function res = fitness(solucion)
    global numLineasInd;
    global numLineasBCW;
    global numLineasGerman;
    global numLineasIono;
    global variables;
    global c1;
    global c2;
    global c3; 
    global c4;
    global c5; 
    global c6;
    global c7;
    global c8;
    global clase;
    global mejorGen;
    global mejorFit;
    
    numLineasInd = 768;
    numLineasBCW = 569;
    numLineasGerman = 1000;
    numLineasIono = 351;
    
    matrizCompletaDatos = [c1,c2,c3,c4,c5,c6,c7,c8];
    
if any(solucion(1:variables))
    matrizRefinada = [];
    %Calculo parte binaria (Desde 1 hasta la cantidad de variables)
    for i=1:variables
        matrizClasif = [];
        for j=(i-1)*numLineasInd+1:i*numLineasInd
            matrizClasif  = [matrizClasif matrizCompletaDatos(j)];
        end
        if(solucion(i) == 1);
            matrizRefinada = [matrizRefinada transpose(matrizClasif)];
        end
    end
    %Calculo de C y sigma
    
    parametroC = 1;
    sigma = 1;
    contadorC = 0;
    contadorS = 0;
    
    matrizC = solucion(variables+1:variables+8);
    matrizS = solucion(variables+9:variables+16);
    %Para 'c'
    for i = length(matrizC):1
        parametroC = parametroC + 2^(contadorC)*matrizC(i);
        contadorC = contadorC +1;
    end
    
    %Para sigma
    for i = length(matrizS):1
        sigma = sigma + 2^(contadorS)*matrizS(i);
        contadorS = contadorS +1;
    end
    
    res = supportVector(matrizRefinada, clase,sigma, parametroC);
    res = -res;
    if mejorFit > res
        mejorGen = solucion;
        mejorFit = res;
    
    end
else
    res = 0;
   
    
end    
end











