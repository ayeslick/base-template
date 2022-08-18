// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {IUniswapV2Factory} from "../interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "../interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router02} from "../interfaces/IUniswapV2Router02.sol";
import {IWETH} from "../interfaces/IWETH.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "../test/utils/Console.sol";

contract UniswapPoolGenie {
    address private tokenA;
    address private tokenB;

    IUniswapV2Factory private factory =
        IUniswapV2Factory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac); //sushi

    IUniswapV2Router02 private router =
        IUniswapV2Router02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); //sushi

    IUniswapV2Pair private pairAddress;

    constructor(address a, address b) {
        tokenA = a;
        tokenB = b;
        IERC20(tokenA).approve(address(router), type(uint256).max);
        IERC20(tokenB).approve(address(router), type(uint256).max);
    }

    function createPair() external {
        factory.createPair(tokenA, tokenB);
    }

    function getPair() external returns (address pair) {
        pair = factory.getPair(tokenA, tokenB);
        console.log("Pair Address", pair);
        pairAddress = IUniswapV2Pair(pair);
        return pair;
    }

    function addLiquidity(uint256 amount)
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        uint256 amountADesired = amount;
        uint256 amountBDesired = amount;
        uint256 amountAMin = amount;
        uint256 amountBMin = amount;
        address to = msg.sender;
        uint256 deadline = block.timestamp + 15 seconds;
        (amountA, amountB, liquidity) = router.addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            to,
            deadline
        );

        console.log("Added Liquidity", amountA, amountB, liquidity);
    }

    function getPathForTokenAToTokenB() public view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = tokenA;
        path[1] = tokenB;

        return path;
    }

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1)
    {
        (reserve0, reserve1, ) = pairAddress.getReserves();
        console.log("Reserves", reserve0, reserve1);
    }

    function swapFor(uint256 amount) external {
        uint256 amountIn = amount;
        uint256 amountOutMin = 0;
        address[] memory path = getPathForTokenAToTokenB();
        address to = msg.sender;
        uint256 deadline = block.timestamp + 15 seconds;
        router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
    }

    //remove liquidity

    receive() external payable {}
}

// function addLiquidityETH()
//     external
//     payable
//     returns (
//         uint256 amountToken,
//         uint256 amountETH,
//         uint256 liquidity
//     )
// {
//     address token = tokenB;
//     uint256 amountTokenDesired = msg.value;
//     uint256 amountTokenMin = msg.value;
//     uint256 amountETHMin = msg.value;
//     address to = address(this);
//     uint256 deadline = block.timestamp + 15 seconds;

//     router.addLiquidityETH{value: msg.value}(
//         token,
//         amountTokenDesired,
//         amountTokenMin,
//         amountETHMin,
//         to,
//         deadline
//     );
//     console.log(
//         "Results from addLiquidityETH",
//         amountToken,
//         amountETH,
//         liquidity
//     );
// }

// function swapFor() external payable {
//     uint256 amountOutMin = 0;
//     address[] memory path = getPathFor();
//     address to = msg.sender;
//     uint256 deadline = block.timestamp + 15 seconds;
//     router.swapExactETHForTokens{value: msg.value}(
//         amountOutMin,
//         path,
//         to,
//         deadline
//     );
// }

// function getPathFor??() private view returns (address[] memory) {
//     address[] memory path = new address[](2);
//     path[0] = BWETH;
//     path[1] = router.WETH();

//     return path;
// }

// function getEstimateFor(uint256 amount)
//     external
//     view
//     returns (uint256[] memory)
// {
//     return router.getAmountsIn(amount, getPathFor());
// }

// function getEstimateFor(uint256 amount)
//     external
//     view
//     returns (uint256[] memory)
// {
//     return router.getAmountsIn(amount, getPathFor());
// }

/* 
  NOTES
*/

// function addLiquidity(
//     uint256 amountADesired,
//     uint256 amountBDesired,
//     uint256 amountAMin,
//     uint256 amountBMin
// )
//     external
//     returns (
//         uint256 amountA,
//         uint256 amountB,
//         uint256 liquidity
//     )
// {
//     address to = msg.sender;
//     uint256 deadline = block.timestamp + 15;
//     router.addLiquidity(
//         tokenA,
//         tokenB,
//         amountADesired,
//         amountBDesired,
//         amountAMin,
//         amountBMin,
//         to,
//         deadline
//     );

//     console.log("Results from addLiquidity", amountA, amountB, liquidity);
// }
