var MatryxPlatform = artifacts.require("MatryxPlatform");
var Tournament = artifacts.require("Tournament");
var Submission = artifacts.require("Submission");

contract('MatryxPlatform', function(accounts){
  it("The owner of the platform should be the creator of the platform", async function() {
      let platform = await MatryxPlatform.deployed();
      // create a tournament
      createTournamentTransaction = await platform.createTournament("tournament", "external address", 100, 2);
      // get the tournament address
      tournamentAddress = createTournamentTransaction.logs[0].args._tournamentAddress;
      // create tournament from address
      let tournament = await Tournament.at(tournamentAddress);

      let creatorIsOwner = await tournament.isOwner.call(accounts[0]);
      assert(creatorIsOwner.valueOf(), true, "The owner and creator of the tournament should be the same"); 
  });
});

contract('MatryxPlatform', function(accounts)
{
	it("The number of tournaments should be 0.", function() {
    return MatryxPlatform.deployed().then(function(instance) {
      return instance.tournamentCount();
    }).then(function(count) {
    	assert.equal(count.valueOf(), 0, "The tournament count was non-zero to begin with.");
    });
  });
});

contract('MatryxPlatform', function(accounts) {
	let platform;
	var createTournamentTransaction;

  it("The number of tournaments should be 1", async function() {
    platform = await MatryxPlatform.new();
    createTournamentTransaction = await platform.createTournament("tournament", "external address", 100, 2);
    let tournamentCount = await platform.tournamentCount();
    // assert there should be one tournament
    assert.equal(tournamentCount.valueOf(), 1, "The number of tournaments should be 1.");
  })

  it("The number of tournaments should be 2", async function() {
    createTournamentTransaction = await platform.createTournament("tournament 2", "external address", 100, 2);
    let tournamentCount = await platform.tournamentCount.call();

    assert.equal(tournamentCount.valueOf(), 2, "The number of tournaments should be 2.");
  })
});

contract('MatryxPlatform', function(accounts)
{
	var tournamentAddress;
	it("The created tournament should be addressable from the platform", function() {
		return MatryxPlatform.deployed().then(function(instance) {
        return instance.createTournament("tournament", "external address", 100, 2);
    }).then(function(result)
    {
      return result.logs[0].args._externalAddress;
    }).then(function(externalAddress){
      return assert.equal(web3.toAscii(externalAddress).replace(/\u0000/g, ""), "external address");
    });
	})
});

contract('MatryxPlatform', async function(accounts)
{
  let platform;
  let createTournamentTransaction;
  let tournamentAddress;
  let tournament;

  it("One person becomes an entrant in a tournament", async function()
  {
    platform = await MatryxPlatform.deployed();
    // create a tournament.
    createTournamentTransaction = await platform.createTournament("tournament", "external address", 100, 2);
    // get the tournament address
    tournamentAddress = createTournamentTransaction.logs[0].args._tournamentAddress;
    // create tournament from address
    tournament = await Tournament.at(tournamentAddress);


    // become entrant in tournament
    await platform.enterTournament(tournamentAddress);
    let isEntrant = await tournament.isEntrant.call(accounts[0]);
    assert.equal(isEntrant.valueOf(), true, "The first account should be entered into the tournament.")
  })

  it("Another person becomes an entrant in the tournament", async function()
  {
    // become entrant in tournament
    await platform.enterTournament(tournamentAddress, {from: accounts[1]});
    let isEntrant = await tournament.isEntrant.call(accounts[1]);
    assert.equal(isEntrant.valueOf(), true, "The second account should be entered into the tournament.")
  })

  it("The third account was not entered into the tournament", async function()
  {
    let isEntrant = await tournament.isEntrant.call(accounts[2]);
    assert.equal(isEntrant.valueOf(), false, "The third account should not be entered into the tournament");
  })
});