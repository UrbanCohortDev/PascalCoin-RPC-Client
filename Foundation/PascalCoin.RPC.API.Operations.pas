Unit PascalCoin.RPC.API.Operations;

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
  System.JSON,
  System.Generics.Collections,
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base,
  HlpConverters;

Type

  TPascalCoinOperationsAPI = Class(TPascalCoinAPIBase, IPascalCoinOperationsAPI)
  Private
  Protected
    Function payloadEncryptWithPublicKey(Const APayload: String; Const AKey: String;
      Const AKeyStyle: TKeyStyle): String;

    Function executeoperation(Const RawOperation: String): IPascalCoinOperation;
    function executeoperations(const RawOperationsArray: String):
        IPascalCoinOperations;

  Public
    Constructor Create(AClient: IPascalCoinRPCClient);
  End;

Implementation

Uses
  Rest.JSON,
  PascalCoin.RPC.Operation, PascalCoin.KeyUtils;

{ TPascalCoinOperationsAPI }

Constructor TPascalCoinOperationsAPI.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create(AClient);
End;

function TPascalCoinOperationsAPI.executeoperation(Const RawOperation: String):
    IPascalCoinOperation;
var lOperations: String;
  lRetval: IPascalCoinOperations;
Begin
  lOperations := TKeyUtils.AsHex(TConverters.ReadUInt32AsBytesLE(1)) + RawOperation;
  lRetval := executeoperations(lOperations);
  Result := lRetval.Operation[0];
End;

function TPascalCoinOperationsAPI.executeoperations(const RawOperationsArray: String): IPascalCoinOperations;
begin
  If FClient.RPCCall('executeoperations', [TParamPair.Create('rawoperations', RawOperationsArray)]) Then
  Begin
    Result := TPascalCoinOperations.FromJSONValue(ResultAsArray);
  End;
end;

Function TPascalCoinOperationsAPI.payloadEncryptWithPublicKey(Const APayload, AKey: String;
  Const AKeyStyle: TKeyStyle): String;
Begin
  If FClient.RPCCall('payloadencrypt', [TParamPair.Create('payload', APayload), TParamPair.Create('payload_method',
    'pubkey'), PublicKeyParam(AKey, AKeyStyle)]) Then
    result := GetJSONResult.AsType<String>;
End;

End.
