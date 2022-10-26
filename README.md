# learning-web3

Guidance: https://www.youtube.com/watch?v=M576WGiDBdQ

## contracts

This was an intro to solidity, and each was run on remix. These files were not meant to be run from the folder.

## demos_py

Simple way to deploy the contracts from contracts folder using a deploy script. To run: `python3 deploy.py`

## brownie

A lot of the deploy and compile scripts were not necessary, as there are frameworks like brownie that will do it for us. run:

```
brownie compile
brownie run scripts/deploy.py
```

or

```
brownie compile
brownie run scripts/deploy.py --network goerli
```

## get_nfts

https://docs.alchemy.com/docs/how-to-get-all-nfts-owned-by-an-address
small pet project to get all nfts owned by an address using Alchemy API
