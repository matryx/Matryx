pragma solidity ^0.4.18;

interface IMatryxRoundFactory
{
	function createRound(uint256 _bountyMTX) public returns (address _roundAddress);
}