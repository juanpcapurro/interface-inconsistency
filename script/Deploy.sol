// SPDX-License-Identifier: UNLICENSED
// solhint-disable no-console
pragma solidity ^0.8.10;

import {Script} from "forge-std/Script.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

import {console} from "forge-std/console.sol";

import {Counter} from "../src/Counter.sol";

contract DeployConfig is Script {
    string internal deploymentsPath;
    string internal deployments;
    address internal deployer;

    function setUp() public {
        uint256 pvk = vm.envUint("PRIVATE_KEY");
        deployer = vm.rememberKey(pvk);

        bool redeploy = false;
        try vm.envBool("REDEPLOY") returns (bool a) {
            redeploy = a;
            // I actually want to ignore failures
        } catch {} // solhint-disable-line
        string memory depLoc = "./foundry-deployments/";
        string memory depPath = string.concat(depLoc, Strings.toString(block.chainid));
        deploymentsPath = string.concat(depPath, ".json");

        if (!redeploy) {
            try vm.readFile(deploymentsPath) returns (string memory prevDep) {
                deployments = prevDep;
            } catch {
                // create the file
                vm.writeFile(deploymentsPath, "{}");
            }
        } else {
            // create the file if it doesnt exist, overwrite it if it does
            vm.writeFile(deploymentsPath, "{}");
        }
    }

    // Prevents redeployment to a chain
    function noRedeploy(function() internal returns (address) fn, string memory contractName)
        internal
        returns (address, bool)
    {
        // check if the contract name is in deployments
        try vm.parseJson(deployments, contractName) returns (bytes memory deployedTo) {
            if (deployedTo.length > 0) {
                address someContract = abi.decode(deployedTo, (address));
                labelAndRecord(someContract, contractName);
                // some networks are ephemeral so we need to actually confirm it was deployed
                // by checking if code is nonzero
                if (someContract.code.length > 0) {
                    console.log(string.concat("skipping contract deployment for: ", contractName));
                    // we already have it deployed
                    return (someContract, false);
                }
            }
        // I actually want to ignore failures
        } catch {} // solhint-disable-line
        console.log(string.concat("deploying contract: ", contractName));
        vm.startBroadcast(deployer);
        address c = fn();
        vm.stopBroadcast();
        labelAndRecord(c, contractName);
        return (c, true);
    }

    function labelAndRecord(address c, string memory contractName) internal {
        vm.label(c, contractName);
        string memory a = vm.serializeAddress("onlyJsonInMemory", contractName, address(c));
        vm.writeFile(deploymentsPath, a);
    }
}

contract CounterDeployer is DeployConfig {
    address private counter;

    function deployCounter() internal returns (address) {
        return address(new Counter());
    }

    function run() public {
        (counter,) = noRedeploy(deployCounter, "Counter");
    }
}
