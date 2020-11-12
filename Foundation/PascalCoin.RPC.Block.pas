unit PascalCoin.RPC.Block;

//************************************************************************//
//                copyright 2019-2020  Russell Weetch                     //
// Distributed under the MIT software license, see the accompanying file  //
//  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.  //
//                                                                        //
//               PascalCoin website http://pascalcoin.org                 //
//                                                                        //
//                 PascalCoin Delphi RPC Client Repository                //
//        https://github.com/UrbanCohortDev/PascalCoin-RPC-Client         //
//                                                                        //
//             PASC Donations welcome: Account (PASA) 1922-23             //
//                                                                        //
//                THIS LICENSE HEADER MUST NOT BE REMOVED.                //
//                                                                        //
//************************************************************************//

interface

uses System.Generics.Collections, System.JSON, PascalCoin.RPC.Interfaces;

type

  TPascalCoinBlock = class(TInterfacedObject, IPascalCoinBlock)
  private
    Fblock: Integer;
    Fenc_pubkey: String;
    Freward: Currency;
    Freward_s: string;
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
  protected
    function GetBlock: Integer;
    function GetEnc_PubKey: String;
    function GetFee: Currency;
    function GetFee_s: String;
    function GetHashRateKHS: Integer;
    function GetMaturation: Integer;
    function GetNonce: Integer;
    function GetOperations: Integer;
    function GetOPH: String;
    function GetPayload: String;
    function GetPOW: String;
    function GetReward: Currency;
    function GetReward_s: String;
    function GetSBH: String;
    function GetTarget: Integer;
    function GetTimeStamp: Integer;
    function GetVer: Integer;
    function GetVer_a: Integer;

    function GetTimeStampAsDateTime: TDateTime;
  public
  end;

  TPascalCoinBlocks = Class(TInterfacedObject, IPascalCoinBlocks)
  private
     {TDictionary blockNum, BlockInfo ?}
     FBlocks: TArray<IPascalCoinBlock>;
  protected
      Function GetBlock(Const Index: integer): IPascalCoinBlock;
    Function GetBlockNumber(Const Index: integer): IPascalCoinBlock;
    Function Count: integer;
  public
  class function FromJsonValue(ABlocks: TJSONArray): TPascalCoinBlocks;
  End;

implementation

uses System.DateUtils, Rest.Json;

{ TPascalCoinBlock }

function TPascalCoinBlock.GetBlock: Integer;
begin
  result := Fblock;
end;

function TPascalCoinBlock.GetTimeStampAsDateTime: TDateTime;
begin
  result := UnixToDateTime(Ftimestamp);
end;

function TPascalCoinBlock.GetEnc_PubKey: String;
begin
  result := Fenc_pubkey;
end;

function TPascalCoinBlock.GetFee: Currency;
begin
  result := Ffee;
end;

function TPascalCoinBlock.GetFee_s: String;
begin
  result := FFee_s;
end;

function TPascalCoinBlock.GetHashRateKHS: Integer;
begin
  result := Fhashratekhs;
end;

function TPascalCoinBlock.GetMaturation: Integer;
begin
  result := Fmaturation;
end;

function TPascalCoinBlock.GetNonce: Integer;
begin
  result := Fnonce;
end;

function TPascalCoinBlock.GetOperations: Integer;
begin
  result := Foperations;
end;

function TPascalCoinBlock.GetOPH: String;
begin
  result := Foph;
end;

function TPascalCoinBlock.GetPayload: String;
begin
  result := Fpayload;
end;

function TPascalCoinBlock.GetPOW: String;
begin
  result := Fpow;
end;

function TPascalCoinBlock.GetReward: Currency;
begin
  result := Freward;
end;

function TPascalCoinBlock.GetReward_s: String;
begin
  result := FReward_s;
end;

function TPascalCoinBlock.GetSBH: String;
begin
  result := Fsbh;
end;

function TPascalCoinBlock.GetTarget: Integer;
begin
  result := Ftarget;
end;

function TPascalCoinBlock.GetTimeStamp: Integer;
begin
  result := Ftimestamp;
end;

function TPascalCoinBlock.GetVer: Integer;
begin
  result := Fver;
end;

function TPascalCoinBlock.GetVer_a: Integer;
begin
  result := Fver_a;
end;


{ TPascalCoinBlocks }

function TPascalCoinBlocks.Count: integer;
begin
  Result := Length(FBlocks);
end;

class function TPascalCoinBlocks.FromJsonValue(ABlocks: TJSONArray): TPascalCoinBlocks;
var
  I: Integer;
begin
  Result := TPascalCoinBlocks.Create;

  SetLength(Result.FBlocks, ABlocks.Count);
  for I := 0 to ABlocks.Count - 1 do
    begin
      Result.FBlocks[I] := TJSON.JsonToObject<TPascalCoinBlock>(ABlocks[I] As TJSONObject);
    end;

end;

function TPascalCoinBlocks.GetBlock(const Index: integer): IPascalCoinBlock;
begin
  Result := FBlocks[Index];
end;

function TPascalCoinBlocks.GetBlockNumber(const Index: integer): IPascalCoinBlock;
var lBlock: IPascalCoinBlock;
begin
  Result := Nil;
  for lBlock in FBlocks do
  begin
    if lBlock.block = Index then
       Exit(lBlock);
  end;
end;

end.
