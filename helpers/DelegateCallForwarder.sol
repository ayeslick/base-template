// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

//modify solidity by example's example

contract DelegateCallForwarder {
    error DelegatecallFailed();

    function multiDelegatecall(bytes[] memory data)
        external
        returns (bytes[] memory results)
    {
        results = new bytes[](data.length);

        for (uint256 i; i < data.length; ) {
            (bool ok, bytes memory res) = address(this).delegatecall(data[i]);

            if (!ok) revert DelegatecallFailed();
            results[i] = res;
            unchecked {
                ++i;
            }
        }
    }
}
