%funcion que retorna al precisi?n alcanzada por la SVM
function fit = supportVector(data,class,sigma,c)

%Se transforman las clases que est?n como string a int cuando sea necesario
%utiliza cuando la clase este dada como string
%en el caso de ionosfera 'g'
%en el caso de breast cancer 'M'
%species = cellstr(class);
%groups = ismember(species,'M');

%% Randomly select training and test sets.
%cuando la clase es numerica utilizar estas lineas
[train, test] = crossvalind('holdOut',class);
cp = classperf(class);
%cuando la clase es string utilizar estas lineas
%[train, test] = crossvalind('holdOut',groups);
%cp = classperf(groups);

%% Use the svmtrain function to train an SVM classifier using a radial basis function and plot the grouped data.
%svmStruct = svmtrain(data(train,:),groups(train),'showplot',true);

%svmStruct = svmtrain(data(train,:),class(train),'showplot',true,'kernel_function','rbf','rbf_sigma',sigma,'AUTOSCALE',true,'BoxConstraint',c);

%se a?ade una maxima cantidad de iteraciones para que la SVM pueda converger
%se aumenta la tolerancia en caso que la cantidad de iteraciones no sea
%suficiente, esto se se aplica para casos en que los par?metros calculados
%por el GA sean demasiado grandes
options = optimset('maxiter',10000,'largescale','off','TolX',5e-4,'TolFun',5e-4);

%se entrena la SVM utilizando un kernel da base radial y escalando los
%ejemplos de entrada para ayudar en la convergencia del algoritmo.
svmStruct = svmtrain(data(train,:),class(train),'showplot',false,'kernel_function','rbf','AUTOSCALE',true,'rbf_sigma',sigma,'BoxConstraint',c,'Method','QP','quadprog_opts',options);
%svmStruct = svmtrain(data(train,:),groups(train),'showplot',false,'kernel_function','rbf','AUTOSCALE',true,'rbf_sigma',sigma,'BoxConstraint',c,'Method','QP','quadprog_opts',options);
%svmStruct = svmtrain(data(train,:),groups(train),'showplot',true,'kernel_function','polynomial');

%Se clasifica el conjunto de test en base al modelo obtenido
classes = svmclassify(svmStruct,data(test,:),'showplot',false);

%se evalua el performance del modelo
classperf(cp,classes,test);
fit = cp.CorrectRate;
%fit = get(cp)

end
