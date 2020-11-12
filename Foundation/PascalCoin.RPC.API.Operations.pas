unit PascalCoin.RPC.API.Operations;

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

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base;

Type

  TPascalCoinOperationsAPI = Class(TPascalCoinAPIBase, IPascalCoinOperationsAPI)
  Private
  Protected
       Function payloadEncryptWithPublicKey(Const APayload: String; Const AKey: String;
      Const AKeyStyle: TKeyStyle): String;

    Function executeoperation(Const RawOperation: String): IPascalCoinOperation;
  Public
  Constructor Create(AClient: IPascalCoinRPCClient);
  End;

implementation

uses Rest.JSON, PascalCoin.RPC.Operation;

{ TPascalCoinOperationsAPI }

constructor TPascalCoinOperationsAPI.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create(AClient);
end;

function TPascalCoinOperationsAPI.executeoperation(const RawOperation: String): IPascalCoinOperation;
begin
  If FClient.RPCCall('executeoperations', [TParamPair.Create('rawoperations', RawOperation)]) Then
  Begin
    result := TJSON.JsonToObject<TPascalCoinOperation>((GetJSONResult As TJSONObject));
  End;
end;

function TPascalCoinOperationsAPI.payloadEncryptWithPublicKey(const APayload, AKey: String;
  const AKeyStyle: TKeyStyle): String;
begin
  If FClient.RPCCall('payloadencrypt', [TParamPair.Create('payload', APayload), TParamPair.Create('payload_method',
    'pubkey'), PublicKeyParam(AKey, AKeyStyle)]) Then
    result := GetJSONResult.AsType<String>;
End;


end.
