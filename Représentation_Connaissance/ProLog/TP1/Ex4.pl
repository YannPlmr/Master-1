byCar(auckland,hamilton).
byCar(hamilton,raglan).
byCar(valmont,saarbruecken).
byCar(valmont,metz).


byTrain(metz,frankfurt).
byTrain(saarbruecken,frankfurt).
byTrain(metz,paris).
byTrain(saarbruecken,paris).

byPlane(frankfurt,bangkok). 
byPlane(frankfurt,singapore).
byPlane(paris,losAngeles).
byPlane(bangkok,auckland).
byPlane(singapore,auckland).
byPlane(losAngeles,auckland).

voyage(X,Y):- byCar(X,Y).
voyage(X,Y):- byTrain(X,Y).
voyage(X,Y):- byPlane(X,Y).
voyage(X,Y):- byCar(X,P), voyage(P,Y).
voyage(X,Y):- byTrain(X,P), voyage(P,Y).
voyage(X,Y):- byPlane(X,P), voyage(P,Y).

voyage(X,Y,go(byCar(X,Y))):- byCar(X,Y).
voyage(X,Y,go(byTrain(X,Y))):- byTrain(X,Y).
voyage(X,Y,go(byPlane(X,Y))):- byPlane(X,Y).
voyage(X,Y,go(byCar(X,P),W)):- byCar(X,P), voyage(P,Y,W).
voyage(X,Y,go(byTrain(X,P),W)):- byTrain(X,P), voyage(P,Y,W).
voyage(X,Y,go(byPlane(X,P),W)):- byPlane(X,P), voyage(P,Y,W).