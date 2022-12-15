// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "../src/IERC20.sol";

interface iPool {
    function addLiquidity(uint256[] calldata, uint256, uint256) external returns (uint256);
}

contract Broken {

    error INVALID_ADDRESS(address addr);
    error NOT_AUTHORIZED(address _addr);
    error INVALID_SIZES();
    error FAIL_WITHDRAW(address ercAddr, uint256 amount);

    event BalanceWithdraw(address ercAddr, uint256 amount);
    event DONE(address addr);

    address public owner;

    constructor(address _owner) payable{
        owner = _owner;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NOT_AUTHORIZED(msg.sender);
        _;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function execute(
        uint256[] memory _amounts,
        address _pool_address,
        address[] memory _tokens) external onlyOwner
    {
        // Check if pool and lp_token is valid
        if (_pool_address == address(0)) revert INVALID_ADDRESS(_pool_address);
        if (_tokens.length != _amounts.length) revert INVALID_SIZES();


        // Approve tokens to pool
        for (uint i = 0; i < _tokens.length; i++) {
            IERC20 token = IERC20(_tokens[i]);
            if (_amounts[i] > 0) {
                token.approve(_pool_address, _amounts[i]);
            }
        }

        iPool poolContract = iPool(_pool_address);

        uint256 new_lp = poolContract.addLiquidity(_amounts, 0, 0);

        emit DONE(_pool_address);
    }

    function self_destroy() external onlyOwner
    {
        selfdestruct(payable(owner));
    }

    function withdrawToken(address _token_address) external onlyOwner
    {
        IERC20 token = IERC20(_token_address);
        uint256 balance = token.balanceOf(address(this));
        bool success = token.transfer(owner, balance);
        if (!success) revert FAIL_WITHDRAW(_token_address, balance);
        emit BalanceWithdraw(_token_address, balance);
    }

    receive() external payable {}

    fallback() external payable {}
}
