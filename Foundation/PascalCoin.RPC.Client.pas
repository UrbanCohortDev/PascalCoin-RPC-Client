Unit PascalCoin.RPC.Client;

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
  System.JSON,
  UC.Net.Interfaces,
  PascalCoin.RPC.Interfaces,
  PascalCoin.Consts;

Type

  TPascalCoinRPCClient = Class(TInterfacedObject, IPascalCoinRPCClient)
  Private
    FNodeURI: String;

    FHTTPClient: IucHTTPRequest;
    FResponseStr: String;
    FResponseObj: TJSONObject;
    FResultValue: TJSONValue;
    FCallId: String;
    FNextId: Integer;
    Function NextId: String;
  Protected
    Function GetResponseObject: TJSONObject;
    Function GetResponseStr: String;
    Function GetResultValue: TJSONValue;

    Function RPCCall(Const AMethod: String; Const AParams: Array Of TParamPair): Boolean;
    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

  Public
    Constructor Create(AHTTPClient: IucHTTPRequest);
  End;

Implementation

Uses
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  PascalCoin.RPC.Exceptions;

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
  result := TJSONObject.ParseJSONValue(FResponseStr) As TJSONObject
End;

Function TPascalCoinRPCClient.GetResponseStr: String;
Begin
  result := FResponseStr
End;

function TPascalCoinRPCClient.GetResultValue: TJSONValue;
begin
    Result := FResultValue;
end;

Function TPascalCoinRPCClient.NextId: String;
Begin
  Inc(FNextId);
  result := FNextId.ToString;
End;

// {"jsonrpc": "2.0", "method": "XXX", "id": NNN, "params":{"p1":" ","p2":" "}}
Function TPascalCoinRPCClient.RPCCall(Const AMethod: String; Const AParams: Array Of TParamPair): Boolean;
Var
  lObj, lErrObj, lParams: TJSONObject;
  lArray: TJSONArray;
  lParam: TParamPair;
  lResponse, lValue, lStatusValue: TJSONValue;
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
        Raise ENotAllowedException.Create(RPC_ERRNUM_NOTALLOWEDCALL, FHTTPClient.ResponseStr) // FHTTPClient.StatusText)
      Else
        Raise EHTTPException.Create(FHTTPClient.StatusCode, FHTTPClient.StatusText);
    End
    { TODO : Test that return Id matches call id }
    Else
    Begin
      FResponseStr := FHTTPClient.ResponseStr;

      lResponse := TJSONObject.ParseJSONValue(FResponseStr);

      FResponseObj := (lResponse As TJSONObject);

      lValue := FResponseObj.FindValue('error');

      If lValue <> Nil Then
      Begin

        FResponseStr := '';

        lErrObj := lValue As TJSONObject;
        lStatusCode := lErrObj.Values['code'].AsType<Integer>;

        Raise GetRPCExceptionClass(lStatusCode).Create(lStatusCode, lErrObj.Values['message'].AsType<String>);

      End;

      FResultValue := FResponseObj.GetValue('result');

      If FResultValue is TJSONArray then
      begin
        lArray := FResultValue as TJSONArray;
        if lArray.Count > 0 then
        begin
          lErrObj := lArray[0] as TJSONObject;
          lStatusValue := lErrObj.FindValue('valid');
          if (lStatusValue <> nil) and (lStatusValue.AsType<boolean> = false) then
          begin
            FResponseStr := '';
            raise GetRPCExceptionByMethod(AMethod, lErrObj.Values['errors'].AsType<String>);
          end;

        end;
      end;

      Result := True;

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
