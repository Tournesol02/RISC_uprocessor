MICROPROCESSEUR RISC

L'automne 2025
COURS : VHDL & CIRCUITS NUMERIQUES PROGRAMMABLES
Professeure : Mme. D. Dragomirescu
Étudiants : TABAN, Aleksander & JOHNSEN, Brage

Voici notre README pour le projet µprocesseur RISC. 

Pendant les TPs et notre temps libre nous avons realisé un microprocesseur qui contient ; une unité arithmétique et logique, un banc de registres, une mémoire de données, une mémoire des instructions et le chemin de données.

INFORMATION GENERALE :
Taille de la puce sur FPGA après synthèse : 
- 17% est utilisé par Input/Output
- 6% par Flip-Flop
- 5% par Look-Up-Table

Notre carte n'a pas de contraintes d'horloge. Trouvé après synthèse et implementation sous: Timing->Design Timing Summary

Fréquence de fonctionnement : 
- Pour déterminer la fréquence maximale de fonctionnement, nous avons consulté le rapport Reports → Timing Summary. Le WNS (Worst Negative Slack) est égal à inf, ce qui indique que le design n’est pas contraint par une horloge.
- Afin d’obtenir une estimation, nous avons analysé le chemin de données le plus long entre deux flip-flops. Le pire Data Path Delay est 20,659 ns, dont 10,5 % de logique et 89,5 % de routage.
- La fréquence maximale estimée est donc : 1/T = 48,4MHz
 
UNITÉ ARITHMÉTHIQUE ET LOGIQUE : 
Fonctionne comme décrit dans le sujet.

BANC DE REGISTRES :
Répond au cahier des charges du sujet. On a implementé la fonctionnement de détournement : dès qu'on ecrit dans une adresse en retour et en même temps veut lire dans cette adresse. On fait alors l'opération : 
QA ou QB <- DATA si ADDR_Ecriture == ADDR_Lecture;

MEMOIRE DE DONNEES : 
Focctionne comme le BDR, mais est plus grosse (256x8bits).

MEMOIRE D'INSTRUCTION : 
64 lignes de 32 bits. Elle est prédifinie stockée avec des chaines d'instruction (MSB), on trouve OP(2bits), A(2bits), B(2bits), C(2bits). Alors MEMI_S(31 downto 0) = [OP A B C]

CHEMIN DE DONNEES :
	Explication générale du chemin de données. Nous avons divisé le chemin de données dans une partie asynchrone et une partie synchrone.
	- L'adresse de la memoire d'instruction est toujours donné par le PC (Program Counter), on le declare en concurrentiel.
	- On synchronise tous les horloges dans la partie asynchrone. 
	- On synchronise tous les mise à zero dans la partie asynchrone.
	- La sortie du pipeline est donnée par QA et QB, et ils vont toujours lire la valeur de A et B en étage 4(Re-écriture).
	
	Etage 1 / Lecture des instructions :
		- On lit ce qu'il y a dans l'adresse numèro PC dans la memoire d'instruction.
	Etage 2 / Decodage d'instructions :
		- On propage les signaux au prochain étage. 
		- Au cas d'affectation dans un registre, on met la valeur dans le registre voulu.
	Etage 3 / Execution :
		- L'UAL prend les valeurs de A et B dans les cas: ADD, MUL, NON, OR, XOR, AND et SUB. 
		- On renvoie la sortie dans le multiplexeur, qui encore est récuperée par le prochain étage.
	Etage 4 / Memoire de données : 
		- Nous stockons les valeurs dans la memoire de données dans quand le code d'opération vaut SRD (Sauvegarde) et nous lisons de la memoire de données dès que l'OPCODE vaut
		CRD (Chargement). 
	Etage 5 / Retour d'écriture :
		- Nous renvoyons puis le signal A, B et leur adresses voulu été stocké dans la BDR. 
		
GESTION DES ALEAS :
	- Nous mettons le programme en halte au cas où on veut affecter puis de suite faire une opération avec cette valeur.
	- Par exemple:
		- Si on veut affecter x06 dans R1 et puis copie la valeur dans R1 en R2, il faut attendre jusqu'au R1 contient x06 dans le BDR.
	- On verifie donc que l'instruction qui modifie d'un régistre n'existe plus dans le chemin de données, en arretant le compteur pour attendre que le microprocesseur est prêt, mais en continuant les opérations qui sont déja dans le chemin de données.

	
FIGURES :

Figure 1 et 2: Gestion d'aléas. Nous mettons 03 dans le registre R2, qui contient déjà AA, puis on copie direct dans R1. On peut voir que le programme se met en halte (Incrementation du PC s'arrête temporairement) pendant au moins 5 cycles d'horloge.

Figure 3: L'escalier du programme, on voit bien que les instructions sont enchainés aux differents étages.

Figure 4 et 5: Chargement et sauvegarde entre le banc de registres et la memoire des données.

Figure 6 et 7: Partie arithmétique. On fait ADD, MUL, SOU, ET, OU, OUX, NON.
