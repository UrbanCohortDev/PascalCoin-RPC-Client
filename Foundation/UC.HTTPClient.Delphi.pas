Unit UC.HTTPClient.Delphi;

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
  System.Classes,
  System.Net.HTTPClient,
  UC.Net.Interfaces;

Type

  TDelphiHTTP = Class(TInterfacedObject, IucHTTPRequest)
  Private
    FHTTP: THTTPClient;
    FResponse: IHTTPResponse;
    FStatusCode: Integer;
    FStatusText: String;
    FStatusType: THTTPStatusType;
  Protected
    Function GetResponseStr: String;
    Function GetStatusCode: Integer;
    Function GetStatusText: String;
    Function GetStatusType: THTTPStatusType;

    Procedure Clear;
    Function Post(AURL: String; AData: String): boolean;
    Function Get(AURL: String): String;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

Implementation

Uses
  System.SysUtils;

{ TDelphiHTTP }

Procedure TDelphiHTTP.Clear;
Begin
  FResponse := Nil;
  FStatusCode := -1;
  FStatusText := '';
End;

Constructor TDelphiHTTP.Create;
Begin
  Inherited Create;
  FHTTP := THTTPClient.Create;
End;

Destructor TDelphiHTTP.Destroy;
Begin
  FHTTP.Free;
  Inherited;
End;

Function TDelphiHTTP.Get(AURL: String): String;
Begin
  FResponse := FHTTP.Get(AURL);
  result := FResponse.ContentAsString;
End;

Function TDelphiHTTP.GetResponseStr: String;
Begin
  result := FResponse.ContentAsString;
End;

Function TDelphiHTTP.GetStatusCode: Integer;
Begin
  result := FStatusCode;
End;

Function TDelphiHTTP.GetStatusText: String;
Begin
  result := FStatusText;
End;

Function TDelphiHTTP.GetStatusType: THTTPStatusType;
Begin
  result := FStatusType;
End;

Function TDelphiHTTP.Post(AURL, AData: String): boolean;
Var
  lStream: TStringStream;
Begin
  FStatusText := '';
  lStream := TStringStream.Create(AData);
  Try
    lStream.Position := 0;
    Try
      FResponse := FHTTP.Post(AURL, lStream);
      FStatusCode := FResponse.StatusCode;

      result := (FResponse.StatusCode >= 200) AND (FResponse.StatusCode <= 299);
      If result Then
        FStatusType := THTTPStatusType.OK
      Else
      Begin
        FStatusType := THTTPStatusType.Fail;
        Try
          FStatusText := FResponse.StatusText;
        Except
        End;
      End;
    Except
      On E: Exception Do
      Begin
        FStatusType := THTTPStatusType.Exception;
        FStatusText := E.ClassName + ':' + E.Message;
        result := False;
      End;
    End;
  Finally
    lStream.Free;
  End;
End;

End.
