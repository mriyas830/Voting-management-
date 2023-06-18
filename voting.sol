// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract VotingSystem {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) private  candidates;
    mapping(address => bool) public voters;
    uint256 private totalVotes;
    uint256 private candidateno;
    bool public votingOpen;
    address public owner;

    event VoteCasted(address indexed voter, uint256 candidateId);
    event VotingClosed();

    constructor() {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
        votingOpen = true;
        owner = msg.sender;
    }

    function addCandidate(string memory _name) private {
        candidateno += 1;
        candidates[candidateno] = Candidate(candidateno, _name, 0);
    }

    function vote(uint256 _candidateId) public {
        require(votingOpen, "Voting is closed");
        require(!voters[msg.sender], "Already voted");
        require(_candidateId <= candidateno && _candidateId > 0, "Invalid candidate");

        candidates[_candidateId].voteCount++;
        voters[msg.sender] = true;
        totalVotes++;

        emit VoteCasted(msg.sender, _candidateId);
    }
    modifier onlyOwner() {
    require(msg.sender == owner, "Only the contract owner can perform this operation");
    _;
    }

    function closeVoting() public onlyOwner {
        require(votingOpen, "Voting is already closed");

        votingOpen = false;

        emit VotingClosed();
    }

    function getCandidate(uint256 _candidateId) public view returns (string memory, uint256) {
        require(_candidateId <= candidateno && _candidateId > 0, "Invalid candidate");

        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }
}
