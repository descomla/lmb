module ViewHelp exposing (viewHelp)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewHelp: Model -> Html Msg
viewHelp model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Aide utilisateur" ]
    , div [ class "soustitre" ] [ text "Se connecter au site" ]
    , div [ class "paragraphe" ]
      [ text "Afin d'effectuer des saisies d'informations dans le site, il est nécessaire d'être connecté. Pour obtenir des identifiant de connexion, contacter l'administrateur du site."
      , br [] [], text "Sur l'ensemble des pages du site se trouve une barre de connexion, en haut de la page. Saisir dans cette barre l'identifiant et le mot de passe fourni, puis cliquer sur \"Se connecter\"."
      , br [] [], text "Une fois cette opération réalisée, la page courante est recharger, et le bandeau de connexion indique simplement \"Connecté en tant que <Nom d'utilisateur>\". Il n'est pas nécessaire de se déconnecter à la fin de chaque utilisation : La déconnexion est automatique au bout d'un certain temps d'inactivité."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Généralités" ]
    , div [ class "paragraphe" ]
      [ text "Sur la plupart des formulaires proposés :"
      , br [] [], text "  - Le bouton en forme de virgule verte permet d'accéder au détail de l'élément en cours"
      , br [] [], text "  - Le bouton en forme de stylo jaune et noir permet de modifier l'élément en cours"
      , br [] [], text "  - Le bouton en forme de croix rouge permet de supprimer l'élément en cours"
      , br [] [], text "  - En cliquant sur le nom d'une équipe, on ouvre une nouvelle page concernant cette équipe (statistiques)"
      , br [] [], text "  - Le numéro des matchs dans une phase n'est donné qu'à titre indicatif et ne correspond pas forcément à l'ordre temporel décidé par l'organisateur du tournoi"
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Créer un joueur" ]
    , div [ class "paragraphe" ]
      [ text "La création d'un joueur se fait sur la page \"Joueurs\", via le bouton \"Ajout d'un nouveau joueur\" en bas de page"
      , br [] [], text "Seuls les 3 premiers champs (Pseudo, Nom et prénom) sont obligatoires. Par habitude, si on ne connait aucun surnom pour le joueur, on met son prénom dans \"Pseudo\""
      , br [] [], text "Merci de ne pas créer de nom d'utilisateur aux joueurs !!!"
      , br [] [], text "La validation se fait par \"Créer le joueur\", et ramène à la même page (afin de rapidement créer plusieurs joueurs)"
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Créer une équipe" ]
    , div [ class "paragraphe" ]
      [ text "La création d'une équipe se fait sur la page \"Equipe\", via le bouton \"Création d'une nouvelle équipe\" en bas de page"
      , br [] [], text "Seuls le nom de l'équipe est obligatoire. La couleur de base permet de facilement repérer l'équipe sur la feuille de match imprimée"
      , br [] [], text "La validation se fait par \"Créer l'équipe\"."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Créer un nouveau tournoi" ]
    , div [ class "paragraphe" ]
      [ text "La création d'un tournoi se fait en accédant à la page de la ligue souhaitée."
      , br [] [], text "Cliquer sur \"Création d'un nouveau tournoi pour cette ligue\"."
      , br [] [], text "Saisir les infos du tournoi et \"Créer le tournoi\""
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Affecter des équipes aux tournois" ]
    , div [ class "paragraphe" ]
      [ text "Les équipes participantes doivent être affectées au tournoi."
      , br [] [], text "En bas de la page du tournoi, utiliser l'outil de recherche pour trouver l'équipe souhaitée, et cliquer sur \"Ajouter au tournoi\"."
      , br [] [], text "Si une équipe est ajoutée par erreur, il est possible de l'ôter du tournoi en cliquant sur la croix rouge à côté de son nom dans la partie \"Equipe(s) inscrite(s) au tournoi\""
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Création des phases d'un tournoi" ]
    , div [ class "paragraphe" ]
      [ text "Du point de vue du logiciel, un tournoi est divisé en phases (poules, tableaux, round-robin, etc...)"
      , br [] [], text "Il est donc nécessaire de créer les différentes phases, et leur enchainement."
      , br [] [], text "Sur la page du tournoi cliquer sur \"Création d'une nouvelle phase pour ce tournoi\""
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Phase de type poule" ]
    , div [ class "paragraphe" ]
      [ text "C'est ce genre de phase que l'on utilise lorsqu'on souhaite faire des poules au sein desquelles chaque équipe rencontre toute les autres."
      , br [] [], text "Les informations à spécifier à la création dans ce cas sont le nombre de poules à créer, mais également la durée des matchs sur l'ensemble de cette phase. Attention, si les durées des matchs ne sont pas les mêmes d'une poule à l'autre, il est nécessaire de créer plusieurs phases différentes pour se faciliter le travail, quitte à n'avoir qu'une seule poule dans chaque phase."
      , br [] [], text "Une fois la phase créée, on peut modifier les poules pour en changer le nom (en utilisant le bouton en forme de stylo), affecter des équipes définies à la poule (en choisissant les équipes dans la liste déroulante), ou encore lorsqu'il ne s'agit pas de la première phase du tournoi, choisir une règle qui désignera une équipe en fonction des résultats d’une précédente phase."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Phase de type tableau" ]
    , div [ class "paragraphe" ]
      [ text "C'est ce genre de phase que l'on utilise lorsqu'on souhaite faire un système de tableau avec montée des vainqueurs et éventuellement descente des perdants."
      , br [] [], text "Pour la partie \"Matchs joués\" :"
      , br [] [], text "  - Victoire signifie que seuls les gagnants passent au niveau suivant (les perdants sont directement éliminés de la phase)"
      , br [] [], text "  - Victoires + Petite finale est identique sauf que les perdants des demi-finales se rencontreront lors d'un match de petite finale"
      , br [] [], text "  - Tous indique que tous les matchs seront joués (gagnants contre gagnants et perdants contre perdants) jusqu'à obtention d'un classement complet des équipes"
      , br [] [], text "Dans tous les cas, il est possible ensuite de supprimer les matchs en trop (il vaut donc mieux voir large au départ)."
      , br [] [], text "Le nombre d'équipe dans le tableau permettra la préparation du bon nombre de matchs."
      , br [] [], text "Les durée de chaque phase du tableau sont fixées ensuite (attention dans le cadre d'un tableau complet, les finales gagnantes et perdantes auront la même durée. Une fonctionnalité qui arrivera plus tard permettra de combler cette limitation."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Règles et enchainement" ]
    , div [ class "paragraphe" ]
      [ text "Une fois les phases créées, les enchainements peuvent être définis à partir de règles spécifiques."
      , br [] [], text "Les menus déroulants dans chaque poule ou match permettent de faire automatiquement des liens."
      , br [] [], text "Par défaut les phases de type \"tableau\" possède déjà la structure d'enchainement à l'exception faite des points d'entrée qu'il faut saisir à la main."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Création des places de classement" ]
    , div [ class "paragraphe" ]
      [ text "Une fois les phases et les enchainements créés, il ne manque plus qu'à établir la méthode de résolution du classement."
      , br [] [], text "Cela se fait de la même manière que l'attribution des règles d'enchainement, via le bouton \"Création d'une place au classement\" en attribuant à une place une règle (le nombre de point est automatiquement choisi via le règlement de la ligue, mais il est possible de le modifier par la suite)."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Démarrer une phase" ]
    , div [ class "paragraphe" ]
      [ text "On peut démarrer une phase lorsque la précédente est terminée (dans le cas de la première phase, on peut la démarrer juste après sa création, pour préparer le début du tournoi)."
      , br [] [], text "Pour se faire, plusieurs étapes :"
      , br [] [], text "  - Si des règles ont été définies pour cette phase, cliquer sur \"XXXXXXX\" afin d'attribuer les équipes correspondant à ces règles. Dans le cas d'une phase de type \"tableau\", il faudra réaliser cette opération plusieurs fois, afin de faire évoluer le tableau au fur et à mesure que les matchs se terminent et que l'on connait les vainqueurs."
      , br [] [], text "  - Dans le cadre d'une phase de type \"poules\", une fois toutes les équipes de la poule connues et attribuées, il faut aller créer l'ensemble des matchs pour chaque poule, en se rendant sur la poule (bouton vert au niveau de la poule), puis en cliquant sur \"XXXXXXXXXXXX\". Cette opération peut être longue si le nombre de matchs est important. Bien laisser l'outil travailler jusqu'à ce que la page se recharge."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Affectation des joueurs aux équipes" ]
    , div [ class "paragraphe" ]
      [ text "C'est la partie un peu contraignante. Comme les effectif d'une équipe peuvent avoir tendance à changer entre les tournois / les phases / voir les matchs (blessures, joueurs présents que certains jours, etc...), la composition de l'équipe est uniquement liée à un match. Heureusement le système est fait pour faciliter la vie de l'utilisateur :"
      , br [] [], text "  - Par défaut, la composition de l'équipe à la création d'un match est reprise à l'identique du dernier match joué par celle-ci"
      , br [] [], text "  - Il est également possible de dupliquer une composition d'équipe vers tous les matchs qui ne sont pas encore joués pour cette équipe."
      , br [] [], text "En début de tournoi il est donc nécessaire pour chaque équipe inscrite de trouver son premier match, et d'éditer la composition."
      , br [] [], text "  - Aller dans la poule correspondante"
      , br [] [], text "  - Choisir un des matchs auquel l'équipe participe et cliquer sur le match (cela ouvre la page du match)"
      , br [] [], text "  - Utiliser les outils pour valider la composition de l'équipe en question : La liste des joueur déjà présent se trouve sur la partie droite ou gauche de l'écran, il est possible de changer un numéro de maillot en cliquant sur le bouton en forme de crayon, de supprimer un joueur de la liste, ou d'utiliser l'outil de recherche en dessous pour en ajouter un. Si un joueur n'existe pas en base (aucune participation à un tournoi), il faut le créer préalablement"
      , br [] [], text "  - Une fois la composition finalisée, le bouton \"Dupliquer la formation\" permet d'affecter la même formation à tous les matchs à venir pour l'équipe."
      , br [] [], text "  - Cette opération est donc à réaliser pour chacune des équipes participant au tournoi, ou à chaque fois qu'une modification d'effectif intervient dans l'équipe, par exemple en cours de tournoi."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Imprimer les feuilles de match" ]
    , div [ class "paragraphe" ]
      [ text "Il est possible d'imprimer les feuilles de chaque match, peu importe l'état dans lequel celui-ci se trouve. En fonction des informations entrées dans le système, la feuille sera automatiquement complétée."
      , br [] [], text "Pour imprimer une feuille de match, sur la page du match, il suffit de cliquer sur le bouton \"Imprimer la feuille de match\"."
      , br [] [], text "Cette opération générée un fichier PDF. Suivant la configuration de l'ordinateur, soit la feuille est directement ouverte dans le navigateur, soit celle-ci est ouverte dans un logiciel \"lourd\" (adobe Reader par exemple), soit celle-ci est simplement téléchargée (elle pourra ensuite être ouverte dans le logiciel adéquat)."
      , br [] [], text "Normalement tous les logiciels ouvrant ce type de fichier propose une fonctionnalité d'impression."
      , br [] [], text "Pour une phase de type \"Poules\", il est également possible d'imprimer en une seule fois toutes les feuilles de match de la poule. Cette opération est donc à réaliser une fois tous les matchs créés et les compositions d'équipe saisies. Pour cela, se rendre sur la page de la poule, puis \"Imprimer les feuilles de match\"."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Saisir les résultats d'un match" ]
    , div [ class "paragraphe" ]
      [ text "Les résultats peuvent être saisis de 3 manières :"
      , br [] [], text "  - Soit uniquement le résultat final : A utiliser lorsque le tournoi bat son plein et qu'on souhaite seulement alimenter les résultats des tournois pour calculer les classements des poules, et les enchainements entre les matchs."
      , br [] [], text "  - Soit une saisie à partir des feuilles de matchs : A utiliser après coup en complément de la saisie précédente (au calme à la fin du tournoi par exemple), pour indiquer les joueurs ayant marqué les paniers et les fautes. Cela permet entre autre de générer les feuilles de matchs finales pour archivage/information, mais également de réaliser une statistique partielle."
      , br [] [], text "  - Soit une saisie complète des statistiques, à faire en direct. Cela nécessite un ordinateur dédié à un terrain, et 2 personnes affectées à cette tâche. L'ensemble des actions des joueurs sont saisies (paniers réussis ou ratés, fautes, rebonds, passe décisives, interceptions et contres), ce qui permet de réaliser des statistiques complètes sur la performance de l'équipe et des joueurs. Cette saisie nous affranchis des autres types de saisies puisqu'elle permet de déduire la feuille de match et le résultat."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Saisie unique du résultat final" ]
    , div [ class "paragraphe" ]
      [ text "Pour saisir uniquement le résultat, se rendre sur la page du match."
      , br [] [], text "Cliquer sur \"Valider le match\""
      , br [] [], text "Indiquer le score de chacune des équipes (dans le bon ordre), et désigner le vainqueur"
      , br [] [], text "Cliquer sur OK"
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Saisie des résultats à partir de la feuille de match" ]
    , div [ class "paragraphe" ]
      [ text "Sur la page du match, choisir \"Saisie rapide des résultats\""
      , br [] [], text "Un formulaire à 8 cases apparait : Pour chacune des cases saisir dans l'ordre de la feuille de match les joueurs concernés, séparés par des virgules, sans espaces. Par défaut les paniers valent 2 points. Pour les lancés francs et les paniers à trois points, utiliser un format J-1 (pour le lancer franc) ou J-3 (pour le 3 points), en remplaçant J par le numéro du joueur."
      , br [] [], text "Par exemple, si pour l'équipe A, dans la 1ere période : Le numéro 12 a marqué un panier, puis le numéro 5, puis un lancer franc réussi du 5 et enfin un 3 points du 00, on notera dans la case : 12,5,5-1,00-3"
      , br [] [], text "Même chose pour les fautes."
      , br [] [], text "Cliquer ensuite sur \"Valider\". Si une ou plusieurs erreurs sont indiquées : Repérer les numéros problématiques. Identifier l'erreur (peut être une erreur de numéro de joueur par exemple). Vider toutes les cases, puis saisir à nouveau uniquement les corrections (si seul le panier à trois point du joueur 00 n'étais pas bon car en réalité c'était le joueur 99, indiquer uniquement 99-3 dans la case, et vider toutes les autres cases)."
      , br [] [], text "Si aucune erreur n'est rencontrée, le système revient à la page du match."
      , br [] [], text "Si le match n'avait pas encore été validé, il est temps de le faire (suivre les étapes de \"Saisie unique du résultat final\")."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Saisie complètes des statistiques" ]
    , div [ class "paragraphe" ]
      [ text "Pour effectuer cette saisie, il est quasiment indispensable d'être 2 : Une personne qui réalise la saisie sur l'outil tandis que le deuxième regarde le match et lui \"dicte\" les actions"
      , br [] [], text "Pour saisir :"
      , br [] [], text "  - Choisir la bonne période"
      , br [] [], text "  - Démarrer le chronomètre quand le jeu débute (Bouton \"GO\")"
      , br [] [], text "  - Lorsqu'une action remarquable a lieu, choisir l'action correspondante dans la partie centrale, puis le joueur responsable de l'action, puis éventuellement un complément d'information (nombre de point d'un panier par exemple, ou joueur cible de l'action)."
      , br [] [], text "  - Pour certaines actions récurrentes, des boutons de raccourcis permettent de de faire un ajour en un seul clic : Il s'agit de la liste de boutons à côté de chaque nom de joueur :"
      , br [] [], text "    * Le \"2\" vert permet de rajouter un panier réussi au joueur"
      , br [] [], text "    * Le \"2\" rouge permet de rajouter un tir raté au joueur"
      , br [] [], text "    * Le \"F\" rouge permet de rajouter une faute personnelle au joueur"
      , br [] [], text "    * Le \"O\" vert permet de rajouter un rebond offensif au joueur"
      , br [] [], text "    * Le \"D\" vert permet de rajouter un rebond défensif au joueur"
      , br [] [], text "  - Ne pas oublier à la fin de la période de changer de période en cours."
      , br [] [], text "Quelques indications pour bien saisir les statistiques"
      , br [] [], text "  - On considère que le joueur ayant réalisé le rebond est celui qui le premier à la maitrise de la balle (et pas le premier à la toucher), même si celle-ci touche d'abord le sol, même plusieurs fois, ou d'autres joueurs. Le seul cas où il n'y a pas de rebond est si la balle sors directement en touche ou si une faute ou violation est commise (jeu à terre, retour en zone, etc...)"
      , br [] [], text "  - On considère qu'une passe est décisive lorsqu'un panier est marqué par le joueur qui reçoit la passe, sans que celui-ci n'aie dribblé"
      , br [] [], text "  - Si un joueur se fait contrer lors d'un shoot, on note un contre pour le l'adversaire + un shoot raté pour le joueur"
      , br [] [], text "  - Si un joueur subit une faute lors d'un shoot réussi, on compte un shoot réussi pour le joueur et une faute pour l'adversaire. En revanche si le shoot est raté et que la faute est sifflée, on ne compte pas de shoot raté pour le joueur, mais toujours une faute pour l'adversaire."
      , br [] [], text "  - Une interception revient à un joueur qui intercepte la balle volontairement : Si celui-ci reçoit délibérément la balle de l'adversaire car celui-ci fait une erreur (passe à l'adversaire, ballon perdu lors d'une perte d'équilibre)"
      , br [] [], text "Une fois le match terminé, il faut le valider (suivre les étapes de \"Saisie unique du résultat final\")."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Résultats d'une poule" ]
    , div [ class "paragraphe" ]
      [ text "Les résultats d'une poule sont directement visibles sur la page de celle-ci sous la forme d'un tableau de points."
      , br [] [], text "Par défaut, le classement est fait de la manière officielle de la ligue (seules les victoires comptent, sauf en cas d'égalité ou l'on prend en compte les matchs nuls), mais il est possible de changer cette méthode en modifiant les paramètres de la poule pour attribuer un nombre de point pour une victoire, un nombre de points pour un match nul et un nombre de points pour une défaite."
      , br [] [], text "En cas d'égalité dans une poule, un départage manuel peut être effectué via le formulaire sous le tableau \"Ajouter ou modifier un départage\". On ajoute alors des points de départage à l'équipe à mettre en avant (par exemple si 3 équipes sont égalité et se départage par des lancers francs, on attribuera 3 points de départage à la 1ere, 2 à la seconde, et un à la troisième)"
      , br [] [], text "Il est important qu'il n'y ait pas d'égalité dans le tableau à la fin d'une phase car cela poserais problème pour la résolution des règles."
      , br [] [], text "Une fois les résultats corrects, on peut cliquer sur \"Terminer cette poule\" pour bloquer les modifications."
      , br [] [], text ""
      , br [] [], text ""
      ]
    , div [ class "soustitre" ] [ text "Enchainement des phases" ]
    , div [ class "paragraphe" ]
      [ text "Une fois une phase terminée, le bouton \"Résolution des règles\" juste en dessous de cette phase permet de résoudre les règles d'enchainement et de remplir les données pour la phase suivante"
      , br [] [], text "Il en va de même pour le classement final qui sera automatiquement établis en cliquant sur le même bouton, en dessous du tableau de classement."
      , br [] [], text "En cas d'erreur lors de la résolution des règles, vérifier les phases précédentes, il y a un surement un problème (match non validé, égalité au sein d'une poule, etc...)"
      , br [] [], text ""
      , br [] [], text ""
      ]
    ]
