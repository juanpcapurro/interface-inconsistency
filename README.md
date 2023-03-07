# Foundry boilerplate

Got tired of configuring dependencies & linting over and over again like some kind of groundhound day for every little proof of concept I come up with, so I made this, hopefully is of help to you too.

## what's in the box
- `npm install --include=dev` (tried with node 16) should get you set up with linting and dependencies (both those of npm and those of git)
- CI should work on a github repo right away
- npm scripts to lint via forge & solhint
- `forge test` tests
- bring your own foundry, though
- no scripts/deployments so far

## rationale

- npm minimalism: I really don't want to use npm. But a `package.json` is where most people look for the project's scripts, and I had to install solhint somehow. Using a makefile felt extremely overkill & misguided, and using a shell script with a `case...esac` for every possible `argv[1]` felt tempting but wrong in it's own way too. Also using the `postinstall` hook to initialize dependencies looks like will help avoid some footguns.
- submodules for dependencies: that's the foundry way to do things and I like it. Vendoring ftw.
- foundry only, to keep things simple.

## TODO
- [ ] get some way to deploy the contracts. I have like zero xp on foundry scripts.
- [ ] try to use nixOS to install things instead of having the user bring their own foundry and using npm for solhint
