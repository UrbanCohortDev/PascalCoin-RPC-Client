Unit UC.Delphi.Versions;

Interface

Uses
  System.Classes,
  System.Win.Registry;

Type

  TDelphiVersion = (Seattle, Berlin, Tokyo, Rio, Sydney);

  TDelphiVersions = Class
  Private
    FVersionList: TStrings;
    FCurrentPaths: TStrings;
    FRegistry: TRegistry;
    Procedure LoadAvailableVersions;
    Function LookUpVersionName(Const Value: String): String;
    Function LibraryKey(AVersion: String): String;
    Function GetVersion(Const AName: String): Integer;
    Function GetAvailableVersionName(Const Index: Integer): String;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function AvailableCount: Integer;
    function OpenLibrary(AVersion, APlatform, ABackUpFolder: String): boolean;
    Procedure SaveAndCloseLibrary;
    Procedure CloseLibrary;
    Function AddToLibrary(APath: String): boolean;
    Procedure SupportedPlatformsToStrings(const AVersion: String; Strings: TStrings);
    Procedure AppendPaths(Strings: TStrings);

    Property Version[Const AName: String]: Integer Read GetVersion;
    Property AvailableVersionName[Const Index: Integer]: String Read GetAvailableVersionName;
  End;

const
DELPHI_BDS_VERSION: Array[TDelphiVersion] of Integer = (
17 //Seattle = 17
,18 //Berlin = 18
,19 //Tokyo = 19
,20 //Rio = 20,
,21 //Sydney = 21
);

BASE_VERSION_NUM = 17;

Implementation

Uses
  WinAPI.Windows,
  System.Rtti,
  System.IOUtils,
  System.SysUtils;

ResourceString
  SRootPath = '\Software\Embarcadero\BDS\';
  SSearchPath = 'Search Path';

  { TDelphiVersions }

Function TDelphiVersions.AddToLibrary(APath: String): boolean;
Begin
  Result := FCurrentPaths.IndexOf(APath) < 0;
  If Result Then
    FCurrentPaths.Add(APath);
End;

Function TDelphiVersions.AvailableCount: Integer;
Begin
  Result := FVersionList.Count;
End;

Procedure TDelphiVersions.CloseLibrary;
Begin
  FCurrentPaths.Free;
  FCurrentPaths := Nil;
  FRegistry.Free;
  FRegistry := Nil;
End;

procedure TDelphiVersions.AppendPaths(Strings: TStrings);
begin
  Strings.AddStrings(FCurrentPaths);
end;

Constructor TDelphiVersions.Create;
Begin
  Inherited Create;
  FVersionList := TStringList.Create;
  LoadAvailableVersions;
End;

Destructor TDelphiVersions.Destroy;
Begin
  FVersionList.Free;
  If FCurrentPaths <> Nil Then
    FCurrentPaths.Free;
  If FRegistry <> Nil Then
    FRegistry.Free;
  Inherited;
End;

Function TDelphiVersions.GetVersion(Const AName: String): Integer;
Begin
  Result := DELPHI_BDS_VERSION[TRttiEnumerationType.GetValue<TDelphiVersion>(AName)];
End;

Function TDelphiVersions.GetAvailableVersionName(Const Index: Integer): String;
Begin
  Result := FVersionList.Names[Index];
End;

Function TDelphiVersions.LibraryKey(AVersion: String): String;
Var
  lVersion: Integer;
Begin
  lVersion := Version[AVersion];
  Result := SRootPath + lVersion.ToString + '.0\Library'
End;

Procedure TDelphiVersions.LoadAvailableVersions;
Var
  Registry: TRegistry;
  I: Integer;
  lName: String;
Begin

  Registry := TRegistry.Create;
  Try
    Registry.RootKey := HKEY_CURRENT_USER;
    If Registry.OpenKey(SRootPath, False) Then
    Begin
      Registry.GetKeyNames(FVersionList);
    End;
  Finally
    Registry.Free;
  End;

  TStringList(FVersionList).Sort;

  For I := 0 To FVersionList.Count - 1 Do
  Begin
    lName := LookUpVersionName(FVersionList[I]);
    If lName = '' Then
      Continue;

    FVersionList[I] := lName + '=' + FVersionList[I];
  End;

End;

Function TDelphiVersions.LookUpVersionName(Const Value: String): String;
Var
  lValue: Integer;
  lHigh, lLow: SmallInt;
  lVersion: TDelphiVersion;
  lVal: String;
Begin

  Result := '';
  lVal := Value.Substring(0, Value.IndexOf('.'));
  lValue := StrToIntDef(lVal, 0) - BASE_VERSION_NUM;

  lHigh := Ord(High(TDelphiVersion));
  lLow := Ord(Low(TDelphiVersion));
  If ((lValue > lHigh) Or (lValue < lLow)) Then
    Exit;

  lVersion := TDelphiVersion(lValue);

  Result := TRttiEnumerationType.GetName<TDelphiVersion>(lVersion);
End;

Function TDelphiVersions.OpenLibrary(AVersion, APlatform, ABackUpFolder: String): boolean;
var lSearchPath: String;
Begin
  If FRegistry <> Nil Then
    FRegistry.Free;
  If FCurrentPaths <> Nil Then
  Begin
    FCurrentPaths.Free;
    FCurrentPaths := Nil;
  End;

  FRegistry := TRegistry.Create;
  FRegistry.RootKey := HKEY_CURRENT_USER;
  Result := FRegistry.OpenKey(LibraryKey(AVersion) + '\' + APlatform, False);

  If Not Result Then
    Exit;

  lSearchPath := FRegistry.ReadString(SSearchPath);
  if ABackUpFolder <> '' then
     TFile.WriteAllText(TPath.Combine(ABackupFolder, AVersion + '_' + APlatform + '_SearchPath.bak'), lSearchPath);
  FCurrentPaths := TStringList.Create;
  FCurrentPaths.Delimiter := ';';
  FCurrentPaths.StrictDelimiter := True;

  FCurrentPaths.DelimitedText := lSearchPath;



End;

Procedure TDelphiVersions.SaveAndCloseLibrary;
Begin
  FRegistry.WriteString(SSearchPath, FCurrentPaths.DelimitedText);
  FCurrentPaths.Free;
  FCurrentPaths := Nil;
  FRegistry.Free;
  FRegistry := Nil;
End;

procedure TDelphiVersions.SupportedPlatformsToStrings(const AVersion: String; Strings: TStrings);
Var
  Registry: TRegistry;
  I: Integer;
  lName: String;
Begin

  Registry := TRegistry.Create;
  Try
    Registry.RootKey := HKEY_CURRENT_USER;
    If Registry.OpenKey(LibraryKey(AVersion), False) Then
    Begin
      Registry.GetKeyNames(Strings);
    End;
  Finally
    Registry.Free;
  End;



end;

End.
