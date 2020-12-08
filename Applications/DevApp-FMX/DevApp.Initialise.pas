Unit DevApp.Initialise;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.

  PascalCoin website http://pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https://github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  System.SysUtils,
  DevApp.Config.Impl;

Procedure InitialiseApp(AConfig: TDevAppConfig);

Implementation

Uses
  UC.Net.Interfaces,
  UC.HTTPClient.Delphi,
  PascalCoin.RPC.Client,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Node,
  PascalCoin.RPC.API.Explorer,
  PascalCoin.RPC.API.Wallet;

Procedure InitialiseApp(AConfig: TDevAppConfig);
Begin
  // dropped Spring4d for the moment
  FormatSettings.CurrencyString := 'Ƿ'; // U+01F7 &#503;
  FormatSettings.CurrencyFormat := 0;
  FormatSettings.CurrencyDecimals := 4;

End;

End.
