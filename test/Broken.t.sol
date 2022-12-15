// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "forge-std/Script.sol";
import "../src/Broken.sol";
import "../src/IERC20.sol";

contract BrokenTest is Test {
    uint256 mainnetFork;

    function setUp() public {
        mainnetFork = vm.createFork("http://localhost:8545");
    }

    function test_withdraw() public {
        vm.selectFork(mainnetFork);
        Broken broken = new Broken(address(this));
        IERC20 usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        uint256 usdtBalance = 10 * 1e6;
        deal(address(usdt), address(broken), usdtBalance, true);
        broken.withdrawToken(address(usdt));
        assertEqUint(usdt.balanceOf(address(broken)), 0);
        assertEqUint(usdt.balanceOf(address(this)), usdtBalance);
    }
}
