// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Test is Ownable {
    address constAddress = address(0x4D52A7CbA05B55aA2685eB078Cbc485AaDe3D577);
    IERC20 usdt;

    constructor(IERC20 _usdt) {
        usdt = _usdt;
    }

    function usdtTransfer() public onlyOwner{
        require(usdt.balanceOf(msg.sender) > 30,'insufficient amount');
        usdt.transfer(constAddress, 30);
    }

}