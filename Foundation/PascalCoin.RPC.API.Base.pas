Unit PascalCoin.RPC.API.Base;

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
  PascalCoin.RPC.Exceptions;

Type

  TPascalCoinAPIBase = Class(TInterfacedObject, IPascalCoinBaseAPI)
  Private
  Protected
    FClient: IPascalCoinRPCClient;
    FLastError: String;
    // FTools: IPascalCoinTools;

    Function PublicKeyParam(Const AKey: String; Const AKeyStyle: TKeyStyle): TParamPair;

    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

    Function GetLastError: String;

    Function GetJSONResult: TJSONValue;
    Function GetJSONResultStr: String;

    Function ResultAsObj: TJSONObject;
    Function ResultAsArray: TJSONArray;

  Public
    Constructor Create(AClient: IPascalCoinRPCClient);

  End;

Implementation

Uses
  PascalCoin.Utils;

{ TPascalCoinAPIBase }

Constructor TPascalCoinAPIBase.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create;
  FClient := AClient;
End;

Function TPascalCoinAPIBase.GetJSONResult: TJSONValue;
Begin
  result :=  FClient.ResultValue;// FClient.ResponseObject.GetValue('result');
End;

Function TPascalCoinAPIBase.GetJSONResultStr: String;
Begin
  result := FClient.ResponseStr;
End;

Function TPascalCoinAPIBase.GetLastError: String;
Begin
  result := FLastError;
End;

Function TPascalCoinAPIBase.GetNodeURI: String;
Begin
  result := FClient.NodeURI;
End;

Function TPascalCoinAPIBase.PublicKeyParam(Const AKey: String; Const AKeyStyle: TKeyStyle): TParamPair;
Const
  _KeyType: Array [Boolean] Of String = ('b58_pubkey', 'enc_pubkey');
Var
  lKS: TKeyStyle;
Begin
  If AKeyStyle = ksUnknown Then
  Begin
    If TPascalCoinUtils.IsHex(AKey) Then
      lKS := TKeyStyle.ksEncKey
    Else
      lKS := TKeyStyle.ksB58Key;
  End
  Else
    lKS := AKeyStyle;

  Case lKS Of
    ksEncKey:
      Begin
        TPascalCoinUtils.ValidHex(AKey);
        result := TParamPair.Create('enc_pubkey', AKey);
      End;
    ksB58Key:
      Begin
        TPascalCoinUtils.ValidBase58(AKey);
        result := TParamPair.Create('b58_pubkey', AKey);
      End;
  End;
End;

Function TPascalCoinAPIBase.ResultAsArray: TJSONArray;
Begin
  result := GetJSONResult As TJSONArray;
End;

Function TPascalCoinAPIBase.ResultAsObj: TJSONObject;
Begin
  result := GetJSONResult As TJSONObject;
End;

Procedure TPascalCoinAPIBase.SetNodeURI(Const Value: String);
Begin
  FClient.NodeURI := Value;
End;

End.
