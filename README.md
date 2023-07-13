# solidity inconsistency I found

## context
I was working using
[solhint-community](https://github.com/solhint-community/solhint-community/)'s
new rule in [sablier/v2-periphery to search for false positives and other
issues](https://github.com/sablier-labs/v2-periphery/pull/143) 

when I found the expected name of a function parameter was different when I used
the derived type vs when I used the type of the interface.

## current behaviour
It's specified in [a small foundry test](./test/Interface.t.sol)

## why it confuses me
I expect methods of all instances implementing an interface to be callable in
the same manner, regardless of the type of the variable where the actual method
is accessed (as long as said type implements the interface, of course).

## what I believe should happen

It should not be a valid implementation of an interface's method to use different
parameter names.

## versions 

    [N] capu ~/s/interface-inconsistency (master) [1]> forge build
    [⠒] Compiling...
    [⠑] Compiling 18 files with 0.8.20
    [⠊] Solc 0.8.20 finished in 2.53s
    [N] capu ~/s/interface-inconsistency (master)> ~/.svm/0.8.20/solc-0.8.20 --version
    solc, the solidity compiler commandline interface
    Version: 0.8.20+commit.a1b79de6.Linux.g++
    [I] capu ~/s/interface-inconsistency (master)> forge -V
    forge 0.2.0 (08a629a 2023-06-03T00:04:22.625130135Z)

