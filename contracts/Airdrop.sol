
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Airdrop {

    address ownerAddress;

    mapping(address => uint) claimableTokens;
    mapping(address => bool) isClaimables; //true: claimable
  
    IERC20 airdrop;

    constructor(IERC20 _airdrop) {
        airdrop = _airdrop;
        ownerAddress = msg.sender; 
    }

    function claimAssignedAmount() public {

        require(isClaimables[msg.sender] != false, "Already claim.");

        if (isClaimables[msg.sender] != true) {
            claimableTokens[msg.sender] = airdrop.balanceOf(msg.sender);
        }

        // require(airdrop.balanceOf(ownerAddress) >= claimableTokens[msg.sender], "There are't enough tokens");

        uint claimTokens = Math.min(claimableTokens[msg.sender], airdrop.balanceOf(ownerAddress));
        
        require(airdrop.transferFrom(ownerAddress, msg.sender, claimTokens), "Failed to claim");
        claimableTokens[msg.sender] = 0;
        isClaimables[msg.sender] = false;
    }

    function withdrawPortion(uint _portionTokens) public {

        require(isClaimables[msg.sender] != false, "Already claim.");

        if (isClaimables[msg.sender] != true) {
            isClaimables[msg.sender] = true;
            claimableTokens[msg.sender] = airdrop.balanceOf(msg.sender);
        }
        
        require(claimableTokens[msg.sender] >= _portionTokens, "The portion of user tokens should be equal or smaller than claimable tokens.");
        
        uint withdrawTokens = Math.min(airdrop.balanceOf(ownerAddress), _portionTokens);

        require(airdrop.transferFrom(ownerAddress, msg.sender, withdrawTokens), "Failed to withdraw");

        claimableTokens[msg.sender] = SafeMath.sub(claimableTokens[msg.sender], withdrawTokens);

        if (claimableTokens[msg.sender] == 0) {
            isClaimables[msg.sender] = false;
        }
    }
}