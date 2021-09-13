// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract FairPlay {

    mapping (uint => string) public Int_Team;

    struct Match {
        uint team1;
        uint team2;
        uint id;
        string desc;
    }
    Match[] matches;
    uint private matchID;

    address public admin;
    
    mapping (uint => address[]) match_user;
    mapping (address => uint[]) user_match;

    constructor() {
        admin = msg.sender;
        matchID = 0;
        Int_Team[0] = "IND";
        Int_Team[1] = "ENG";
        Int_Team[2] = "AUS";
        Int_Team[3] = "PAK";
        Int_Team[4] = "RSA";
        Int_Team[5] = "SRI";
        Int_Team[6] = "WI";
        Int_Team[7] = "NZ";
    }

    function addMatch(uint t1, uint t2) external {
        require(msg.sender == admin, "Only admin is allowed to add match!");
        matches.push(Match(t1, t2, matchID, "None"));
        matchID++;
    }

    function addMatch(uint t1, uint t2, string calldata desc) external {
        require(msg.sender == admin, "Only admin is allowed to add match!");
        matches.push(Match(t1, t2, matchID, desc));
        matchID++;
    }

    function getTotalMatches() external view returns (uint) {
        return matches.length;
    }
    
    function viewMatchDetails(uint idx) external view returns (uint, uint, uint, string memory) {
        require(idx >= 0 && idx < matchID, "Invalid index");
        return (matches[idx].team1, matches[idx].team2, matches[idx].id, matches[idx].desc);
    }
    
    function enterMatch(uint match_id) external payable {
        require(match_id < matchID, "Invalid match_id");
        require(msg.value > 0, "Please transfer money");
        match_user[match_id].push(msg.sender);
        user_match[msg.sender].push(match_id);
    }
    
    function getUsers(uint match_id) external view returns (address[] memory) {
        return match_user[match_id];
    }
    
    function pay(uint match_id, uint[] calldata amounts) external {
        require(msg.sender == admin, "Only admin is allowed to make payments");
        require(amounts.length == match_user[match_id].length, "Please pass payable amount for all user!");
        for (uint i = 0; i < match_user[match_id].length; i++) {
            if (amounts[i] != 0) {
                payable(match_user[match_id][i]).transfer(amounts[i]);
            }
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

}