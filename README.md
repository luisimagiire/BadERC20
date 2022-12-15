# Broken ERC20 Withdrawal

The objective is to withdraw the USDT from the core contract to the owner's wallet.
- Main contract is at `contracts/Broken.sol`.
- Test to reproduce the bug is at `test/Broken.s.sol`.

## Usage
- Change RPC_URL in `test/Broken.s.sol` to the RPC endpoint of your desire (it just needs to fork ETH Mainnet).
- Run `forge test` to reproduce the bug