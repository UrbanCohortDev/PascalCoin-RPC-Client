Unit PascalCoin.RPC.Block;

(* ***********************************************************************
  copyright 2019-2021  Russell Weetch
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
  System.Generics.Collections,
  System.JSON,
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinBlock = Class(TInterfacedObject, IPascalCoinBlock)
  Private
    Fblock: Integer;
    Fenc_pubkey: String;
    Freward: Currency;
    Freward_s: String;
    Ffee: Currency;
    Ffee_s: String;
    Fver: Integer;
    Fver_a: Integer;
    Ftimestamp: Integer;
    Ftarget: Integer;
    Fnonce: Integer;
    Fpayload: String;
    Fsbh: String;
    Foph: String;
    Fpow: String;
    Foperations: Integer;
    Fhashratekhs: Integer;
    Fmaturation: Integer;
  Protected
    Function GetBlock: Integer;
    Function GetEnc_PubKey: String;
    Function GetFee: Currency;
    Function GetFee_s: String;
    Function GetHashRateKHS: Integer;
    Function GetMaturation: Integer;
    Function GetNonce: Integer;
    Function GetOperations: Integer;
    Function GetOPH: String;
    Function GetPayload: String;
    Function GetPOW: String;
    Function GetReward: Currency;
    Function GetReward_s: String;
    Function GetSBH: String;
    Function GetTarget: Integer;
    Function GetTimeStamp: Integer;
    Function GetVer: Integer;
    Function GetVer_a: Integer;

    Function GetTimeStampAsDateTime: TDateTime;
  Public
  End;

  TPascalCoinBlocks = Class(TInterfacedObject, IPascalCoinBlocks)
  Private
    { TDictionary blockNum, BlockInfo ? }
    FBlocks: TArray<IPascalCoinBlock>;
  Protected
    Function GetBlock(Const Index: Integer): IPascalCoinBlock;
    Function GetBlockNumber(Const Index: Integer): IPascalCoinBlock;
    Function Count: Integer;
  Public
    Class Function FromJsonValue(ABlocks: TJSONArray): TPascalCoinBlocks;
  End;

Implementation

Uses
  System.DateUtils,
  Rest.JSON;

{ TPascalCoinBlock }

Function TPascalCoinBlock.GetBlock: Integer;
Begin
  result := Fblock;
End;

Function TPascalCoinBlock.GetTimeStampAsDateTime: TDateTime;
Begin
  result := UnixToDateTime(Ftimestamp);
End;

Function TPascalCoinBlock.GetEnc_PubKey: String;
Begin
  result := Fenc_pubkey;
End;

Function TPascalCoinBlock.GetFee: Currency;
Begin
  result := Ffee;
End;

Function TPascalCoinBlock.GetFee_s: String;
Begin
  result := Ffee_s;
End;

Function TPascalCoinBlock.GetHashRateKHS: Integer;
Begin
  result := Fhashratekhs;
End;

Function TPascalCoinBlock.GetMaturation: Integer;
Begin
  result := Fmaturation;
End;

Function TPascalCoinBlock.GetNonce: Integer;
Begin
  result := Fnonce;
End;

Function TPascalCoinBlock.GetOperations: Integer;
Begin
  result := Foperations;
End;

Function TPascalCoinBlock.GetOPH: String;
Begin
  result := Foph;
End;

Function TPascalCoinBlock.GetPayload: String;
Begin
  result := Fpayload;
End;

Function TPascalCoinBlock.GetPOW: String;
Begin
  result := Fpow;
End;

Function TPascalCoinBlock.GetReward: Currency;
Begin
  result := Freward;
End;

Function TPascalCoinBlock.GetReward_s: String;
Begin
  result := Freward_s;
End;

Function TPascalCoinBlock.GetSBH: String;
Begin
  result := Fsbh;
End;

Function TPascalCoinBlock.GetTarget: Integer;
Begin
  result := Ftarget;
End;

Function TPascalCoinBlock.GetTimeStamp: Integer;
Begin
  result := Ftimestamp;
End;

Function TPascalCoinBlock.GetVer: Integer;
Begin
  result := Fver;
End;

Function TPascalCoinBlock.GetVer_a: Integer;
Begin
  result := Fver_a;
End;

{ TPascalCoinBlocks }

Function TPascalCoinBlocks.Count: Integer;
Begin
  result := Length(FBlocks);
End;

Class Function TPascalCoinBlocks.FromJsonValue(ABlocks: TJSONArray): TPascalCoinBlocks;
Var
  I: Integer;
Begin
  result := TPascalCoinBlocks.Create;

  SetLength(result.FBlocks, ABlocks.Count);
  For I := 0 To ABlocks.Count - 1 Do
  Begin
    result.FBlocks[I] := TJSON.JsonToObject<TPascalCoinBlock>(ABlocks[I] As TJSONObject);
  End;

End;

Function TPascalCoinBlocks.GetBlock(Const Index: Integer): IPascalCoinBlock;
Begin
  result := FBlocks[Index];
End;

Function TPascalCoinBlocks.GetBlockNumber(Const Index: Integer): IPascalCoinBlock;
Var
  lBlock: IPascalCoinBlock;
Begin
  result := Nil;
  For lBlock In FBlocks Do
  Begin
    If lBlock.Block = Index Then
      Exit(lBlock);
  End;
End;

End.
