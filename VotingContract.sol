// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract VotingContract {
    // Struct to represent a voting event
    struct VotingEvent {
        string question;
        bool isOpen;
        address creator;
        address[] voters;
        mapping(address => bool) votes;
        mapping(address => bool) hasVoted;
    }

    // Array to store all voting events
    VotingEvent[] private votingEvents;

    // Function to create a new voting event
    function createVoting(string calldata _question) public {
        VotingEvent storage newVoting = votingEvents.push();
        newVoting.creator = msg.sender;
        newVoting.question = _question;
        newVoting.isOpen = true;
    }

    // Function to vote a specific voting event
    function vote(uint256 _index, bool _vote) public {
        // Check if the voting index is valid
        require(_index < votingEvents.length, "Invalid voting index");
        // Check if the voting event is open
        require(votingEvents[_index].isOpen, "Voting is closed");
        
        VotingEvent storage voting = votingEvents[_index];

        // Check if the voter has already voted
        if (!voting.hasVoted[msg.sender]) {
            voting.voters.push(msg.sender);
            voting.hasVoted[msg.sender] = true;
        }
        
        voting.votes[msg.sender] = _vote;
    }

    // Function to close a voting event
    function closeVoting(uint256 _index) public {
        // Check if the voting index is valid
        require(_index < votingEvents.length, "Invalid voting index");
        // Check if the caller is the creator of the voting event
        require(votingEvents[_index].creator == msg.sender, "You are not the creator of this voting");
        // Check if the voting event is open
        require(votingEvents[_index].isOpen, "Voting is already closed");

        votingEvents[_index].isOpen = false;
    }

    // Function to get the votes of a specific voting event
    function getVotes(uint256 _index) public view returns (address[] memory, bool[] memory) {
        // Check if the voting index is valid
        require(_index < votingEvents.length, "Invalid voting index");

        VotingEvent storage voting = votingEvents[_index];

        address[] memory voters = voting.voters;
        bool[] memory votes = new bool[](voters.length);

        // Iterate through the voters to get their votes
        for (uint256 i = 0; i < voters.length; i++) {
            votes[i] = voting.votes[voters[i]];
        }

        return (voters, votes);
    }

}