// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ShareCanopy
/// @notice Native BOT distributions for an explicit public recipient list and weights.
contract ShareCanopy {
    uint256 public constant MAX_RECIPIENTS = 100;
    struct Round { address creator; uint64 expiry; uint32 recipients; uint32 claims; uint256 total; uint256 claimed; string label; }
    Round[] private _rounds;
    mapping(uint256 => mapping(address => uint256)) public allocation;
    mapping(uint256 => mapping(address => bool)) public hasClaimed;
    uint256 private _locked = 1;

    event RoundOpened(uint256 indexed roundId,address indexed creator,uint256 total,uint64 expiry,string label,address[] recipients,uint256[] amounts);
    event ShareClaimed(uint256 indexed roundId,address indexed recipient,uint256 amount);
    event RemainderReclaimed(uint256 indexed roundId,uint256 amount);
    error InvalidList(); error InvalidExpiry(); error EmptyFunding(); error NothingToClaim(); error RoundMissing(); error NotCreator(); error TooEarly(); error TransferFailed();
    modifier lock(){require(_locked==1,"LOCKED");_locked=2;_;_locked=1;}

    function openRound(string calldata label,uint64 expiry,address[] calldata recipients,uint256[] calldata weights) external payable returns(uint256 roundId){
        if(msg.value==0) revert EmptyFunding();
        if(expiry<=block.timestamp) revert InvalidExpiry();
        if(recipients.length==0||recipients.length>MAX_RECIPIENTS||recipients.length!=weights.length) revert InvalidList();
        uint256 totalWeight; for(uint256 i;i<weights.length;i++){if(recipients[i]==address(0)||weights[i]==0)revert InvalidList();totalWeight+=weights[i];for(uint256 j;j<i;j++)if(recipients[j]==recipients[i])revert InvalidList();}
        roundId=_rounds.length; _rounds.push(Round(msg.sender,expiry,uint32(recipients.length),0,msg.value,0,label));
        uint256[] memory amounts=new uint256[](recipients.length); uint256 assigned;
        for(uint256 i;i<recipients.length;i++){uint256 amount=msg.value*weights[i]/totalWeight;amounts[i]=amount;allocation[roundId][recipients[i]]=amount;assigned+=amount;}
        amounts[0]+=msg.value-assigned;allocation[roundId][recipients[0]]+=msg.value-assigned;
        emit RoundOpened(roundId,msg.sender,msg.value,expiry,label,recipients,amounts);
    }
    function claim(uint256 roundId) external lock {if(roundId>=_rounds.length)revert RoundMissing();Round storage r=_rounds[roundId];if(block.timestamp>=r.expiry)revert TooEarly();uint256 amount=allocation[roundId][msg.sender];if(amount==0||hasClaimed[roundId][msg.sender])revert NothingToClaim();hasClaimed[roundId][msg.sender]=true;r.claims++;r.claimed+=amount;(bool ok,)=msg.sender.call{value:amount}("");if(!ok)revert TransferFailed();emit ShareClaimed(roundId,msg.sender,amount);}
    function reclaim(uint256 roundId) external lock {if(roundId>=_rounds.length)revert RoundMissing();Round storage r=_rounds[roundId];if(msg.sender!=r.creator)revert NotCreator();if(block.timestamp<r.expiry)revert TooEarly();uint256 amount=r.total-r.claimed;if(amount==0)revert NothingToClaim();r.claimed=r.total;(bool ok,)=msg.sender.call{value:amount}("");if(!ok)revert TransferFailed();emit RemainderReclaimed(roundId,amount);}
    function roundCount() external view returns(uint256){return _rounds.length;}
    function round(uint256 roundId) external view returns(Round memory){if(roundId>=_rounds.length)revert RoundMissing();return _rounds[roundId];}
}
