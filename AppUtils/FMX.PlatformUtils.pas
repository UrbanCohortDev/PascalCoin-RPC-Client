Unit FMX.PlatformUtils;

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
  FMX.Platform;

Type

  TFMXUtils = Class
  Public
    Class Function TryGetClipboardService(Out AClipboard: IFMXClipboardService): boolean; Static;
    Class Function CopyToClipboard(Const Value: String): boolean; Static;
    Class Function CopyFromClipboard(Out Value: String): boolean; Static;
  End;

Implementation

Uses
  System.Rtti;

{ TFMXUtils }

Class Function TFMXUtils.CopyFromClipboard(Out Value: String): boolean;
Var
  lClipboard: IFMXClipboardService;
  lValue: TValue;
Begin
  Result := TryGetClipboardService(lClipboard);
  If Result Then
  Begin
    lValue := lClipboard.GetClipboard;
    If Not lValue.TryAsType(Value) Then
      Value := '';
  End;
End;

Class Function TFMXUtils.CopyToClipboard(Const Value: String): boolean;
Var
  lClipboard: IFMXClipboardService;
Begin
  Result := TryGetClipboardService(lClipboard);
  If Result Then
    lClipboard.SetClipboard(Value);
End;

Class Function TFMXUtils.TryGetClipboardService(Out AClipboard: IFMXClipboardService): boolean;
Begin
  Result := TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService);
  If Result Then
    AClipboard := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
End;

End.
