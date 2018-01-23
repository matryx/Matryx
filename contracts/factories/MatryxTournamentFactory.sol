pragma solidity ^0.4.18;

import '../MatryxTournament.sol';

contract MatryxTournamentFactory {
	address public matryxRoundFactoryAddress;

	function MatryxTournamentFactory(address _matryxRoundFactoryAddress) public {
		matryxRoundFactoryAddress = _matryxRoundFactoryAddress;
	}

	function createTournament(address _owner, string _tournamentName, bytes32 _externalAddress, uint256 _BountyMTX, uint256 _entryFee) public returns (address _roundAddress) {
		MatryxTournament newTournament = new MatryxTournament(this, _owner, _tournamentName, _externalAddress, _BountyMTX, _entryFee);
		return newTournament;
	}
}