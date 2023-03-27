# PascalCoin-RPC-Client
A framework and set of applications that utilise the Pascal (PascalCoin) RPC functionality.

Copyright (c) 2016-2020 PascalCoin developers based on original Albert Molina source code.

This version is copyright (c) 2019-2020 Russell Weetch, subject to the above copyright.
    
Distributed under the MIT software license, see the accompanying file LICENSE or visit http://www.opensource.org/licenses/mit-license.php.  

## Framework
This is a reworking of the Pascal Firemonkey Wallet I published under my TCardinal Github account. I have decided to rework it so that there is a standalone framework which can be used for anything that accesses the Pascal RPC. I'm also using the process to update the RPC documentation.

This has all been developed in Delphi 10.4 (Sydney) but I have tried to avoid many of the new features (such as in-line variables) so that earlier versions of Delphi (and Lazarus? no idea) can use it.

Within the framework I have tried to avoid using third party libraries, even using the built in Delphi JSON library. The exception is for libraries written specifically to support of the PascalCoin project. In particular the libraries by Ugo. Unlike the original development, I have included the needed files under the libraries sub folder, although please feel free to use the full repositories:

SimplebaseLib4Pascal: https://github.com/Xor-el/SimpleBaseLib4Pascal
HashLib4Pascal: https://github.com/Xor-el/HashLib4Pascal
CryptoLib4Pascal: https://github.com/xor-el/cryptoLib4Pascal/

## What's where

The Framework (see the sub directory `Foundation`) is defined as a set of interfaces which are all defined in `PascalCoin-RPC-Interfaces.pas`. The implementation of these is then in individual files. The `PascalCoin.RPC.API.XXX.pas` files are the implementation of the RPC calls, while most of the others are the implementation of thre response objects. I'll add an index here (eventually).

## Applications
The development has been done using FireMonkey (FMX) and I have included some FMX Utilities to aid with that. There is no reason why the framework will not work with a VCL app, and I might create one to check this - but feel free to have a go yourself.

The applications do use some third part libraries:

FrameStand/FormStand: available via GetIt package manager or at https://github.com/andrea-magni/TFrameStand

The DevApp-FMX is the application used to develop the framework, it's a bit rough and ready but shows the use of the library.

### How far have we got

I have broken the RPC down into 4 areas:

1. Node - needs your IP in `WHITELIST` and `RPC_ALLOWUSEPRIVATEKEYS=1` in the `pascalcoin_daemon.ini` config file.
2. Explorer - Block, Operation and Account queries
3. Wallet - as for 1. Node and access to the private keys
4. Operations - processing Raw Operations and others

The current framework covers 1 (partially) and 2. I'm leaving 3 for the moment (some of this has been done though) as the aim is to provide a functional framework to work with remote RPC Nodes. So 4. is now in play.

## Donations always welcome

if you like this development and want to support it by making a donation then please feel free :-)

PASC donations: PASA/Account Number 1922/23


Thank you
