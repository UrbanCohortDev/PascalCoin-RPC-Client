Unit PascalCoin.RPC.Client;

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

Interface

Uses
  System.JSON,
  UC.Net.Interfaces,
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinRPCClient = Class(TInterfacedObject, IPascalCoinRPCClient)
  Private
    FNodeURI: String;

    FHTTPClient: IucHTTPRequest;
    FResultStr: String;
    FResultObj: TJSONObject;
    FCallId: String;
    FNextId: Integer;
    Function NextId: String;
  Protected
    Function GetResponseObject: TJSONObject;
    Function GetResponseStr: String;
    Function RPCCall(Const AMethod: String; Const AParams: Array Of TParamPair): boolean;
    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

  Public
    Constructor Create(AHTTPClient: IucHTTPRequest);
  End;

Implementation

Uses
  System.SysUtils,
  System.IOUtils,
  PascalCoin.RPC.Exceptions, PascalCoin.RPC.Consts;

{ TPascalCoinRPCClient }

Constructor TPascalCoinRPCClient.Create(AHTTPClient: IucHTTPRequest);
Begin
  Inherited Create;
  FHTTPClient := AHTTPClient;
End;

Function TPascalCoinRPCClient.GetNodeURI: String;
Begin
  result := FNodeURI;
End;

Function TPascalCoinRPCClient.GetResponseObject: TJSONObject;
Begin
  result := TJSONObject.ParseJSONValue(FResultStr) As TJSONObject
End;

Function TPascalCoinRPCClient.GetResponseStr: String;
Begin
  result := FResultStr
End;

Function TPascalCoinRPCClient.NextId: String;
Begin
  Inc(FNextId);
  result := FNextId.ToString;
End;

// {"jsonrpc": "2.0", "method": "XXX", "id": NNN, "params":{"p1":" ","p2":" "}}
Function TPascalCoinRPCClient.RPCCall(Const AMethod: String; Const AParams: Array Of TParamPair): boolean;
Var
  lObj, lErrObj, lParams: TJSONObject;
  lParam: TParamPair;
  lValue: TJSONValue;
  lStatusCode: Integer;
Begin
  FCallId := NextId;
  lObj := TJSONObject.Create;
  Try
    lObj.AddPair('jsonrpc', '2.0');
    lObj.AddPair('id', FCallId);
    lObj.AddPair('method', AMethod);

    lParams := TJSONObject.Create;
    For lParam In AParams Do
    Begin
      lParams.AddPair(lParam.Key, lParam.Value);
    End;

    lObj.AddPair('params', lParams);

    result := FHTTPClient.Post(FNodeURI, lObj.ToJSON);

    If Not result Then
    Begin
      lObj.Free;
      If FHTTPClient.StatusText.Contains('not allowed') Then
        Raise ENotAllowedException.Create(RPC_ERRNUM_NOTALLOWEDCALL, FHTTPClient.ResponseStr) //FHTTPClient.StatusText)
      Else
        Raise EHTTPException.Create(FHTTPClient.StatusCode, FHTTPClient.StatusText);
    End
    { TODO : Test that return Id matches call id }
    Else
    Begin
      FResultStr := FHTTPClient.ResponseStr;
      FResultObj := (TJSONObject.ParseJSONValue(FResultStr) As TJSONObject);
      lValue := FResultObj.FindValue('error');

      If lValue <> Nil Then
      Begin

        FResultStr := '';

        lErrObj := lValue As TJSONObject;
        lStatusCode := lErrObj.Values['code'].AsType<Integer>;

        Raise GetRPCExceptionClass(lStatusCode).Create(lStatusCode, lErrObj.Values['message'].AsType<String>);

      End
      Else
      Begin
        result := True;
      End;

    End;

  Finally
    // if Assigned(lObj) then
    // lObj.Free;
  End;
End;

Procedure TPascalCoinRPCClient.SetNodeURI(Const Value: String);
Begin
  FNodeURI := Value;

End;

End.
