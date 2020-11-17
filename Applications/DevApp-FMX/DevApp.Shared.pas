Unit DevApp.Shared;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http:www.opensource.org/licenses/mit-license.php.

  PascalCoin website http:pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https:github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  DevApp.Config.Impl;

Function Config: TDevAppConfig;

Implementation

Var
  _Config: TDevAppConfig;

Function Config: TDevAppConfig;
Begin
  If Not Assigned(_Config) Then
    _Config := TDevAppConfig.Create();
  Result := _Config;
End;

Initialization

Finalization

If Assigned(_Config) Then
  _Config.Free;

End.
