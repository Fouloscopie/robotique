# LES PARTICIPATIONS SONT CLOSES ! MERCI POUR VOS PROGRAMMES ! 
## Et rendez-vous très bientot pour les résultats en vidéo

<p align="center">
  <img src="robotsTournois.gif" alt="animated" /><br/>
	<i>Mes robots en pleine action ! <br/> Le but du jeu est de programmer les robots pour qu'ils découvrent et détruisent une cible cachée dans l'environnement.<br/>  </i>
	<br/>
</p>

<p align="center">
<b>Pour participer au tournois, vous devez avoir accès à Matlab</b>. 
	</p>
Ce n'est pas idéal, je sais, mais la plateforme de programmation des robots n'est disponible que dans ce langage. Si vous n'avez pas de license, vous pouvez essayer de télécharger une version d'essai de Matlab (gratuite et valide pendant 30 jours) :

<p align="center">
https://fr.mathworks.com/products/get-matlab.html
</p>

Une fois que vous avez un accès à Matlab, vous pouvez commencer à vous amuser et m’envoyer votre code. Je mettrai toutes les stratégies que vous m’envoyez en compétition (y compris la mienne) pour voir laquelle sera la meilleure.

Le niveau de programation est facile. Pas besoin d'être un pro en Matlab ! Il faut seulement modifier la classe ```Robot.m``` à votre convenance. 

<p align="center">
	<br/> <b>Merci de m'envoyer vos contributions avant le lundi 3 Mai</b><br/>
</p>


# Introduction
J’ai à ma disposition un groupe de 12 petits robots. Ils peuvent se déplacer et communiquer les uns avec les autres dans un certain rayon de perception.
<p align="center">
  <img src="http://fouloscopie.com/E3/Robot1.jpeg" width="200" alt="un robot"><br/>
  <i>Voici un robot.<br/> Il mesure environ 10 cm x 10 cm.</i><br/>
</p>

<p align="center">
  <img src="http://fouloscopie.com/E3/robot2.png" width="600" alt="rayon de perception"><br/>
  <i>Voici cinq robots. <br/>
Le cercle rouge correspond au rayon de perception du robot R1 : le robot R1 peut voir et communiquer avec R2 et R3, mais pas avec R4 ni R5. 
Le rayon de perception fait environ 30 cm. </i><br/><br/>
</p>


Ces robots ne sont *pas télécommandés*. Ils sont autonomes. Cela signifie qu’ils doivent être programmés à l’avance avec des règles comportementales simples.

# Scénario
Voici le scénario de l’exercice. Les 12 robots sont placés au milieu d’une arène de 3,2 x 2 mètres. Une cible de 5 cm est cachée quelque part dans l’arène. Les robots doivent la trouver et la détruire le plus rapidement possible. 
<p align="center">
  <img src="http://fouloscopie.com/E3/Robots3.png" width="600" alt="scenario"><br/>
<i>Voici les 12 robots dans leur position de départ au milieu de l’arène. 
Le point rouge est la cible. Elle peut se situer n’importe où dans l’arène. 
Les robots ne connaissent pas son emplacement.</i><br/>
</p>

<p align="center">


## Comment trouver la cible ? 
Un robot peut trouver la cible de deux façons différentes :
- Soit il touche la cible en se déplaçant dessus,
- Soit un autre robot qui connaît l’emplacement de la cible lui communique l’information (mais pour cela il doit être dans son rayon de perception). 

Lorsqu'un robot decouvre l'emplacement de la cible, il allume sa diode verte. 

## Comment détruire la cible ?
La cible a initialement une énergie de **100 points**. Si l'énergie de la cible est réduite à 0, la mission est accomplie. 
Pour attaquer la cible, un robot doit : 
1. connaître l’emplacement de la cible, 
2. avoir la cible dans son rayon de perception. 

Si ces deux conditions sont réunies, le robot attaque la cible **automatiquement**. Lorsqu’un robot attaque la cible, celle-ci perd 0,3 point d'énergie par seconde. C’est peu mais les attaques des robots se cumulent. Par exemple, si 10 robots attaquent en même temps, la cible perd 10 fois 0,3 point d'énergie par seconde – soit 3 points/seconde. Une attaque groupée est donc plus efficace qu’une attaque isolée. 

Lorsqu'un robot est en train d'attaquer la cible, il allume sa diode rouge. 

# Stratégie
Comment programmer les robots pour que la cible soit détruite le plus rapidement possible ? 

Idéalement, il faudrait ramener tous les robots en même temps sur la cible pour cumuler leurs attaques. Mais pour découvrir la cible, il vaut mieux que les robots se dispersent pour optimiser l’exploration, et en s’éloignant ils ne seront plus à portée de communication. Comment faire alors ?

Il existe de nombreuses solutions pour résoudre ce problème. Voici un exemple de programme assez simple mais peu performant.

### Exemple de stratégie : recherche aléatoire
(Notez que le *même* programme est exécuté sur chacun des 12 robots. On ne peut pas programmer les robots séparément: ils exécutent tous le même code).

```
Si l’emplacement de la cible n’est pas connu : 

	-> Déplacement aléatoirement

Si l’emplacement de la cible est connu :

	Envoyer l’emplacement de la cible à tous mes voisins

	-> Si la cible n’est pas à portée
		Déplacement vers la cible 

	-> Si la cible est à portée 
		Arrêter le mouvement (le robot va alors attaquer la cible)
```

Avec cette stratégie, les robots mettent en moyenne **142 secondes** pour détruire la cible. Il y a moyen de faire beaucoup mieux !


# Programmation


L’interface de programmation possède un **simulateur**. Cela signifie que vous pouvez tester votre code et visualiser le résultat en simulation avant de me l’envoyer. 
<p align="center">
  <img src="http://fouloscopie.com/E3/simulateur.png" width="600" alt="simulateur"><br/>
  <i>Le simulateur de robots sur Matlab. <br/>Le point rouge (en haut à droite) indique l'emplacement de la cible</i> <br/>
</p>

La programmation des robots est assez simple et intuitive. Vous devez seulement modifier le script Robot.m (les commentaires vous aideront à écrire votre code). Par ailleurs, le programme correspondant à la stratégie “Recherche aléatoire” décrite ci-dessus est fourni en exemple pour vous aider à démarrer. 

Pour lancer le simulateur, il suffit de taper ‘Main’ dans Matlab. 

LES PARTICIPATIONS SONT CLOSES ! NE M'ENVOYEZ PLUS DE PROGRAMMES, J'AI DÉjÀ LANCÉ LE TOURNOIS !





Amusez-vous bien ! 
