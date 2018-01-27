pragma solidity ^0.4.18;

interface IMatryxRound
{
	function isOpen() public constant returns (bool);
	function submissionIsAccessible(address _requester, uint256 _index) public constant returns (bool);
	function requesterIsEntrant(address _requester) public constant returns (bool);
	function getSubmissions() public constant returns (address[] _submissions);
	function getSubmission(uint256 _index) public constant returns (bytes32 externalAddress_Versioned);
	function getSubmissionAuthor(uint256 _index) public constant returns (address) ;
	function submissionChosen() public constant returns (bool);
	function getWinningSubmissionIndex() public constant returns (uint256);
	function numberOfSubmissions() public constant returns (uint256);
	function Start(uint256 _duration) public;
	function chooseWinningSubmission(uint256 _submissionIndex) public;
	function createSubmission(string _name, address _author, bytes32 _externalAddress, address[] _references, address[] _contributors, bool _publicallyAccessible) public returns (uint256 _submissionIndex);
	//function withdrawReward(uint256 _submissionIndex) public;
	//function withdrawReward(uint256 _submissionIndex, address _recipient) public;
}