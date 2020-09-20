int nV = ...; // Número de vértices

range A = 1..nV;
range V = 1..nV;

// Parâmetros

float c[A][A] = ...; // Custo de viajar entre os arcos i e j

// Variáveis 

dvar float x[V][V]; // Se o arco i e j faz parte da solução

dvar float z1[V][V][V][V]; // Se o arco (i,j) é o h-ésimo, h=1,..., n-1, arco e está no caminho de 1 até k, isto é, primeiro layer
dvar float z2[V][V][V][V]; // Se o arco (i,j) é o h-ésimo, h=2,..., n, arco e está no caminho de k até 1, isto é, segundo layer

dvar float z[A][A][V]; // Se o arco (i,j) é o h-ésimo no tour

minimize sum(i in A, j in A)(c[i][j]*x[i][j]);

subject to {
	// 8
	forall(j in V){
		sum(i in V: i != j)(x[i][j]) == 1;
	}
	// 9
	forall(i in V){
		sum(j in V: i != j)(x[i][j]) == 1;	
	}
	// 10
	forall(k in V: k != 1){
		sum(j in V: j != 1)(z1[1][j][1][k]) == 1;	
	}
	// 11
	forall(k in V, i in V, h in V: k != 1 && i != 1 && i != k && h <= (nV-2)){
		sum(j in V: j != i && j != 1)(z1[i][j][h+1][k]) - sum(j in V: j != i && j != k)(z1[j][i][h][k]) == 0;
	}
	// 12
	forall(k in V, h in V: k != 1 && h <= (nV-1)){
		sum(j in V: j != k)(z2[k][j][h+1][k]) - sum(j in V: j != k)(z1[j][k][h][k]) == 0;
	}
	// 13
	forall(k in V, i in V, h in V: k != 1 && i != 1 && i != k && h <= (nV-1) && h >= 2){
		sum(j in V: j != i && j != k)(z2[i][j][h+1][k]) - sum(j in V: j != i && j != 1)(z2[j][i][h][k]) == 0;
	}
	// 14
	forall(k in V, i in A, j in A, h in V: k != 1){
		z1[i][j][h][k] + z2[i][j][h][k] == z[i][j][h];
	}
	// 15
	forall(i in A, j in A){
		sum(h in V)(z[i][j][h]) == x[i][j];	
	}
	// 16
	// 17
	/*forall(k in V, i in A, j in A, h in V: k != 1 && i != k && j != 1 && h <= (nV-1)){
		z1[i][j][h][k] + (1 - z1[i][j][h][k]) == 1;	
	}
	// 18
	forall(k in V, i in A, j in A, h in V: k != 1 && i != 1 && j != k && h >= 2){
		z2[i][j][h][k] + (1 - z2[i][j][h][k]) == 1;	
	}*/
	// 19
	forall(i in A, j in A, h in V){
		z[i][j][h] >= 0;
	}
	/*Restrições de relaxação linear*/
	forall(k in V, i in A, j in A, h in V){
		0 <= z1[i][j][h][k] <= 1;
		0 <= z2[i][j][h][k] <= 1;		
	}
	forall(i in A, j in A, h in V){
		0 <= z[i][j][h] <= 1;		
	}
	forall(i in A, j in A){
		0 <= x[i][j] <= 1;		
	}
	/*Restrições adicionais para modelegem*/
	forall(i in V, j in V, h in V, k in V: k == 1){
		z1[i][j][h][k] == 0;
	}
	forall(i in V, j in V, h in V, k in V: k == 1){
		z2[i][j][h][k] == 0;
	}
}

/*tuple Node 
{
	int Origem;
	int Destino;
};

{Node} Nodes = {};

execute 
{
	for(var i in A)
	{
		for(var j in A) 
		{
			if(x[i][j] > 0)
			{
				writeln("------------------------------------------------------");
				writeln("x[",i,"][",j,"] = ", x[i][j]);
				writeln("------------------------------------------------------");	
				Nodes.add(i, j);		
			}
		}
	}
	writeln("Caminho Encontrado:");
	for(var node in Nodes)
	{
		writeln("------------------------------------------------------");
		writeln("De ", node.Origem, " para ", node.Destino);
		writeln("------------------------------------------------------");	
	}
}*/

