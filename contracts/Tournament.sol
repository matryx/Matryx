pragma solidity ^0.4.18;

import './Ownable.sol';
import './Submission.sol';
import './SubmissionViewer.sol';

///Creating a Tournament and the functionality
contract Tournament is Ownable {

    //Platform identification
    address public platformAddress;

    //Tournament identification
    string name;
    address public tournamentOwner;
    string public tournamentName;
    bytes32 public externalAddress;

    // Timing
    uint256 public timeCreated;
    uint256 public tournamentStartTime;
    uint256 public roundStartTime;
    uint256 public roundEndTime;
    uint256 public reviewPeriod;
    uint256 public endOfTournamentTime;
    uint public currentRound; //0
    uint public maxRounds = 1;
    bool public tournamentOpen;

    // Reward and fee
    uint public MTXReward;
    uint256 public entryFee;

    // Submission tracking
    address[] private submissionList;
    string[] private submissionNames;
    SubmissionViewer private submissionViewer;
    mapping(address => bool) private isEntrant;

    // Tournament Constructor
    function Tournament(address _tournamentOwner, string _tournamentName, bytes32 _externalAddress, uint256 _tournamentStartTime, uint256 _roundStartTime, uint256 _roundEndTime, uint256 _reviewPeriod, 
        uint256 _endOfTournamentTime, uint256 _MTXReward, uint256 _entryFee, uint _currentRound, uint _maxRounds) public {
        //Clean the inputs
        //Clean inputs
        require(_tournamentOwner != 0x0);
        require(!stringIsEmpty(_tournamentName));
        require(_tournamentStartTime >= now);
        require(_roundEndTime > now);
        require(_reviewPeriod != 0);
        require(_endOfTournamentTime >  now);
        require(_MTXReward > 0);
        require(_currentRound >= 0);
        require(_maxRounds >= 0);

        platformAddress = msg.sender;
        timeCreated = now;

        // Constructor assignments
        // Identification
        tournamentOwner = _tournamentOwner;
        tournamentName = _tournamentName;
        externalAddress = _externalAddress;
        // Timing & Rounds
        tournamentStartTime = _tournamentStartTime;
        roundStartTime = _roundStartTime;
        roundEndTime = _roundEndTime;
        reviewPeriod = _reviewPeriod;
        endOfTournamentTime = _endOfTournamentTime;
        currentRound = _currentRound;
        maxRounds = _maxRounds;
        // Reward and fee
        MTXReward = _MTXReward;
        entryFee = _entryFee;
        // Submission viewing
        submissionViewer = new SubmissionViewer();
    }

    // ----------------- Modifiers -----------------

    // Modifier requiring function caller to be the platform 
    modifier onlyPlatform()
    {
        require(platformAddress == msg.sender);
        _;
    }

    // Modifier requiring function caller to be an entrant
    modifier onlyEntrant()
    {
        bool senderIsEntrant = isEntrant[msg.sender];
        require(senderIsEntrant);
        _;
    }

    // Modifier requiring the round to be open
    modifier whileRoundOpen()
    {
        // TODO: Implement me!
        require(true);
        _;
    }

    // Modifier requiring the tournament to be open
    modifier whileTournamentOpen()
    {
        // TODO: Implement me!
        require(true);

        /* Sam's logic
        * Logic for active vs. inactive tournaments
        * tournamentOpen = true;
        * if(endOfTournamentTime <= now){
        *     tournamentOpen = false;
        * }

            if(tournamentOpen == true){
        */

        /*
         *   Max's logic: 
         *   if(maxRounds > 0)
         *   {
         *
         *   }
         *   else if(roundEndTime < now)
         *   {
         *       require(tournamentOpen);
         *   }
         */

         _;
    }

    // ----------------- Accessor Methods -----------------

    // Returns true if a given address is the owner (an owner...?) of this tournament
    function isOwner(address _sender) public view returns (bool)
    {
        bool senderIsOwner = _sender == owner;
        return senderIsOwner;
    }

    // Returns true if the tournament is open
    function tournamentOpen() public view returns (bool)
    {
        return tournamentOpen;
    }

    // Returns the external address of the tournament
    function getExternalAddress() public view returns (bytes32)
    {
        return externalAddress;
    }

    // ----------------- Tournament Administration Methods -----------------

    // TODO: Refactor so that the owner is actually the owner and not the platform.

    // Called by the owner to start the tournament
    function StartTournament() public onlyOwner
    {
        // TODO: Implement me!
        tournamentOpen = true;
    }

    // Updates the submissions visible via the SubmissionViewer
    function updatePublicSubmissions() public pure
    {
        // TODO: Implement me!
        // Foreach submission made in a previous round,
        // send an event from 
    }

    // To be called by the tournament owner to choose a tournament winner
    function ChooseWinner() public onlyOwner
    {
        // TODO: Implement me!
        tournamentOpen = false;
        // Tell each submission that the tournament is over?
        // (See Submission::whenAccessible)
    }

    // ----------------- Tournament Entry Methods -----------------

    // Enters the user into the tournament and returns to them
    // the address of the submissionViewer, which generates events
    // for submissions made during previous rounds of the tournament.
    function enterUserInTournament(address _entrantAddress) public onlyPlatform returns (address _submissionViewer)
    {
        isEntrant[_entrantAddress] = true;
        return address(submissionViewer);
    }

    // Returns the fee in MTX to be payed by a prospective entrant
    // to the tournament
    function getEntryFee() public view returns (uint256)
    {
        return entryFee;
    }

    // ----------------- Submission Methods -----------------

    // Creates a submission under this tournament
    function createSubmission(string _name, bytes32 _externalAddress, address[] _references, address[] _contributors) public onlyEntrant whileRoundOpen whileTournamentOpen returns (address _submissionAddress) {

        uint256 timeSubmitted = now;
        address newSubmission = new Submission(this, tournamentOwner, msg.sender, _name, _externalAddress, _references, _contributors, timeSubmitted, roundEndTime);

        name = _name;

        // TODO: Remove this event call and place all calls to it in updatePublicSubmissions.
        // Do this after the round logic has been ironed out.
        submissionViewer.CallSubmissionCreatedEvent(_name, externalAddress, _references, _contributors, timeSubmitted, msg.sender);

        return address(newSubmission);
    }

    // Helper function.
    // TODO: Move to library.
    function stringIsEmpty(string _string) public pure returns (bool)
    {
        bytes memory bytesString = bytes(_string); // Uses memory
        if (bytesString.length == 0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    

} // end of Tournament contract