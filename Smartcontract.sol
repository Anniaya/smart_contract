// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 
 contract GestionnaireRisqueContrepartie {
  struct Contrepartie {
  address portefeuille;
  uint256 scoreCredit;
  uint256 limiteExposition;
  uint256 expositionCourante;
  bool estActif;
  }
 
 // Variables d'état
  mapping(address => Contrepartie) public contreparties;
  mapping(address => mapping(address => uint256))
  public expositions;
 
 // Événements
 event ContrepartieAjoutee(
  address indexed contrepartie,
  uint256 limiteExposition
 );
  event ExpositionMiseAJour(
  address indexed contrepartie,
  uint256 nouvelleExposition
  );
  event LimiteDepassee(
  address indexed contrepartie,
  uint256 exposition
  );
 
 // Fonctions principales à implémenter

 function ajouterContrepartie(address _portefeuille, uint256 _scoreCredit, uint256 _limiteExposition) public {
    // Vérifier si la contrepartie existe déjà
    require(contreparties[_portefeuille].portefeuille == address(0), "Contrepartie existe deja");

    // Créer une nouvelle contrepartie
    contreparties[_portefeuille] = Contrepartie({
        portefeuille: _portefeuille,
        scoreCredit: _scoreCredit,
        limiteExposition: _limiteExposition,
        expositionCourante: 0,
        estActif: true
    });

    // Émettre un événement
    emit ContrepartieAjoutee(_portefeuille, _limiteExposition);
}

 function mettreAJourExposition(address _portefeuille, uint256 _nouvelleExposition) public {
    // Vérifier si la contrepartie est active
    require(contreparties[_portefeuille].estActif, "Contrepartie inactive ou inexistante");

    // Mettre à jour l'exposition
    contreparties[_portefeuille].expositionCourante += _nouvelleExposition;

    // Vérifier si la limite est dépassée
    if (contreparties[_portefeuille].expositionCourante > contreparties[_portefeuille].limiteExposition) {
        emit LimiteDepassee(_portefeuille, contreparties[_portefeuille].expositionCourante);
    }

    // Émettre un événement pour la mise à jour
    emit ExpositionMiseAJour(_portefeuille, contreparties[_portefeuille].expositionCourante);
}

 
 function calculerRisque(address _portefeuille) public view returns (uint256) {
    // Vérifier si la contrepartie existe
    require(contreparties[_portefeuille].portefeuille != address(0), "Contrepartie inexistante");

    // Calculer le score de risque
    uint256 risque = (contreparties[_portefeuille].expositionCourante * 100) / contreparties[_portefeuille].limiteExposition;

    return risque;
}
 }