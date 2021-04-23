Unit FMX.PlatformUtils;

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
  FMX.Platform,
  FMX.Types,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
{$IF Defined(IOS)}
  macapi.helpers,
  iOSapi.Foundation,
  FMX.helpers.iOS;
{$ELSEIF Defined(ANDROID)}
Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.App,
  Androidapi.helpers;
{$ELSEIF Defined(MACOS)}
Posix.Stdlib;
{$ELSEIF Defined(MSWINDOWS)}
Winapi.ShellAPI, Winapi.Windows;
{$ENDIF}

Type

  ISMXCursorService = Interface
    ['{4835594F-98A2-408A-BC31-1D8FDAB451A6}']

    Procedure ShowCursor(aCursor: SmallInt);
    Procedure ResetCursor;
  End;

  TFMXUtils = Class
  Public
    Class Function TryGetClipboardService(Out AClipboard: IFMXClipboardService): boolean; Static;
    Class Function CopyToClipboard(Const Value: String): boolean; Static;
    Class Function CopyFromClipboard(Out Value: String): boolean; Static;
    Class Procedure OpenURL(URL: String);
    Class Procedure OpenFile(Const AFileName: String);
    Class Function CursorSvc(aCursor: SmallInt): ISMXCursorService;
  End;

Implementation

Uses
  System.IOUtils;

Type

  TSMXCursorService = Class(TInterfacedObject, ISMXCursorService)
  Private
    FLastCursor: SmallInt;
    FSupported: boolean;
    FCursorService: IFMXCursorService;
  Protected
    Procedure ShowCursor(aCursor: SmallInt);
    Procedure ResetCursor;
  Public
    Constructor Create(aCursor: SmallInt);
    Destructor Destroy; Override;
  End;

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

Class Function TFMXUtils.CursorSvc(aCursor: SmallInt): ISMXCursorService;
Begin
  Result := TSMXCursorService.Create(aCursor);
End;

Class Procedure TFMXUtils.OpenFile(Const AFileName: String);
Const
  COption = 0;
Var
  Extension: String;
{$IFDEF Android}
  Intent: JIntent;
  URI: Jnet_Uri;
{$ENDIF Android}
  Result: integer;
Begin
  Extension := TPath.GetExtension(AFileName).ToLower;
{$IFDEF Android}
  URI := TJnet_Uri.JavaClass.parse(StringToJString('file:///' + AFileName));
  Intent := TJIntent.Create;
  Intent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Case COption Of
    0:
      Intent.setData(URI);
    1:
      If Extension = '.pdf' Then
        Intent.setDataAndType(URI, StringToJString('application/pdf'))
      Else If Extension = '.txt' Then
        Intent.setDataAndType(URI, StringToJString('text/*'));
  End;
  Try
    SharedActivity.startActivity(Intent);
  Except
    On E: Exception Do
    Begin
      Raise;
    End;
  End;
{$ENDIF Android}
{$IFDEF MACOS}
  _system(PAnsiChar(UTF8String('open "' + AFileName + '"')));
{$ENDIF}
{$IFDEF MSWindows}
  Result := ShellExecute(0, 'Open', PChar(AFileName), '', '', SW_SHOWNORMAL);
{$ENDIF MSWindows}
End;

Class Procedure TFMXUtils.OpenURL(URL: String);
{$IF Defined(ANDROID)}
Var
  Intent: JIntent;
{$ENDIF}
Begin
{$IF Defined(ANDROID)}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(URL));
  tandroidhelper.Activity.startActivity(Intent);
  // SharedActivity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'OPEN', PWideChar(URL), Nil, Nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl(URL));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString(URL)));
{$ENDIF}
End;

Class Function TFMXUtils.TryGetClipboardService(Out AClipboard: IFMXClipboardService): boolean;
Begin
  Result := TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService);
  If Result Then
    AClipboard := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
End;

{ TSMXCursorService }

Constructor TSMXCursorService.Create(aCursor: SmallInt);
Begin
  Inherited Create;
  If TPlatformServices.Current.SupportsPlatformService(IFMXCursorService) Then
    FCursorService := TPlatformServices.Current.GetPlatformService(IFMXCursorService) As IFMXCursorService;
  FSupported := Assigned(FCursorService);
  ShowCursor(aCursor);
End;

Destructor TSMXCursorService.Destroy;
Begin
  ResetCursor;
  Inherited;
End;

Procedure TSMXCursorService.ResetCursor;
Begin
  If Not FSupported Then
    Exit;
  FCursorService.SetCursor(FLastCursor);
End;

Procedure TSMXCursorService.ShowCursor(aCursor: SmallInt);
Begin
  If Not FSupported Then
    Exit;
  FLastCursor := FCursorService.GetCursor;
  FCursorService.SetCursor(aCursor);
End;

End.
