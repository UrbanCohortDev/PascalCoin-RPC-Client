Unit UC.Internet.Support;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http:www.opensource.org/licenses/mit-license.php.

  PascalCoin website http:pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https:github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  System.Classes;

Type

  TInternetSupport = Class
  Public
    Class Function GetLocalIP: String; Static;
    Class Function GetPublicIp: String; Static;
    Class Function GetLocalIPs(Const ADelimiter: Char; Const UsePercentEncoding: boolean;
      Const PrivateOnly: boolean): String;
    Class Function IsPrivateIP(Const Value: String): boolean;
    Class Function IsPrivateV6IP(Const Value: String): boolean;
  End;

Implementation

Uses
  idIPWatch,
  idStack,
  idGlobal,
  System.NetEncoding,
  System.SysUtils,
  UC.Net.Interfaces,
  UC.HTTPClient.Delphi,
  REST.Utils;

{ TInternetSupport }

Class Function TInternetSupport.GetLocalIP: String;
Var
  IPW: TIdIPWatch;
Begin
  result := '';
  IPW := TIdIPWatch.Create(Nil);
  Try
    IPW.HistoryEnabled := False;
    If IPW.LocalIP <> '' Then
      result := IPW.LocalIP;
  Finally
    IPW.Free;
  End;
End;

Class Function TInternetSupport.GetLocalIPs(Const ADelimiter: Char; Const UsePercentEncoding: boolean;
  Const PrivateOnly: boolean): String;
Var
  LList: TIdStackLocalAddressList;
  I: Integer;
Begin

  TIdStack.IncUsage;
  Try
    LList := TIdStackLocalAddressList.Create;
    Try
      GStack.GetLocalAddressList(LList);

      For I := 0 To LList.Count - 1 Do
      Begin
        Case LList[I].IPVersion Of
          Id_IPv4:
            Begin
              If PrivateOnly And (Not TInternetSupport.IsPrivateIP(LList[I].IPAddress)) Then
                continue;
              If UsePercentEncoding Then
                result := result + URIEncode(LList[I].IPAddress) + ADelimiter
              Else
                result := result + LList[I].IPAddress + ADelimiter;
            End;
          Id_IPv6:
            Begin
              If PrivateOnly And (Not TInternetSupport.IsPrivateV6IP(LList[I].IPAddress)) Then
                continue;
              If UsePercentEncoding Then
                result := result + URIEncode(LList[I].IPAddress) + ADelimiter
              Else
                result := result + LList[I].IPAddress + ADelimiter;
            End;
        End;
      End;
    Finally
      LList.Free;
    End;

  Finally
    TIdStack.DecUsage;
  End;

  result := result.Trim([ADelimiter]);
End;

Class Function TInternetSupport.GetPublicIp: String;
Var
  HTTP: IucHTTPRequest;
Begin
  HTTP := TDelphiHTTP.Create;
  result := HTTP.Get('https://api.ipify.org');
End;

Class Function TInternetSupport.IsPrivateIP(Const Value: String): boolean;
Var
  IP: TArray<String>;
Begin
  If Value.StartsWith('10.') Then
    result := True
  Else If Value.StartsWith('192.168.') Then
    result := True
  Else If Value.StartsWith('172.') Then // 172.16.0.0 – 172.31.255.255
  Begin
    IP := Value.Split(['.']);
    result := (IP[1].ToInteger >= 16) AND (IP[1].ToInteger <= 31);
  End
  Else
  Begin
    result := False;
  End;
End;

Class Function TInternetSupport.IsPrivateV6IP(Const Value: String): boolean;
Begin
  result := Value.ToLower.StartsWith('FE80');
End;

End.
