Unit MainForm;

Interface

Uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  System.Actions,
  Vcl.ActnList,
  Vcl.StdActns,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Grids,
  Vcl.ValEdit,
  Vcl.CheckLst,
  UC.Delphi.Versions, Vcl.ExtCtrls;

Type

  TForm1 = Class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    SrcMasterDir: TEdit;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ActionList1: TActionList;
    BrowseForSource: TBrowseForFolder;
    BrowseForTarget: TBrowseForFolder;
    SaveAction: TAction;
    Button1: TButton;
    SpeedButton3: TSpeedButton;
    IgnoreFolderAction: TAction;
    Memo1: TMemo;
    ExecAction: TAction;
    SrcFolders: TCheckListBox;
    Memo2: TMemo;
    Label4: TLabel;
    NotesAction: TAction;
    SingleFolderGroup: TGroupBox;
    Label3: TLabel;
    TgtMasterDir: TEdit;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    GlobalMap: TCheckBox;
    MappingOptionsGroup: TGroupBox;
    Platforms: TCheckListBox;
    DelphiVersion: TComboBox;
    MapPathsButton: TButton;
    BackUpFolder: TEdit;
    Label5: TLabel;
    BrowseForBackupFolder: TBrowseForFolder;
    Button2: TButton;
    MapTest: TCheckBox;
    Button3: TButton;
    CreateMapAction: TAction;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Panel2: TPanel;
    PCOptions: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Procedure BrowseForBackupFolderAccept(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure BrowseForSourceAccept(Sender: TObject);
    Procedure BrowseForTargetAccept(Sender: TObject);
    Procedure CreateMapActionExecute(Sender: TObject);
    Procedure DelphiVersionChange(Sender: TObject);
    Procedure GlobalMapClick(Sender: TObject);
    Procedure ExecActionExecute(Sender: TObject);
    Procedure IgnoreFolderActionExecute(Sender: TObject);
    Procedure MapPathsButtonClick(Sender: TObject);
    Procedure SaveActionExecute(Sender: TObject);
  Private
    { Private declarations }
    FIgnoreFolders: TStringList;
    FDelphiVersions: TDelphiVersions;
    FMapPaths: TStrings;
    Procedure LoadDelphiVersions;
    Procedure LoadSubFolders;
    Procedure ProcessTopFolder(AFolder: String);
    Procedure Log(Const Value: String);
    Procedure MapTopFolder(AFolder: String);
    Procedure ProcessSourceFolder(SourceFolder, TargetFolder: String);
    Procedure CreatePathMap;
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

{$R *.dfm}

Uses
  System.IOUtils,
  System.Types,
  System.IniFiles,
  System.StrUtils,
  System.Win.Registry;

Procedure TForm1.BrowseForBackupFolderAccept(Sender: TObject);
Begin
  BackUpFolder.Text := BrowseForBackupFolder.Folder;
End;

Procedure TForm1.FormDestroy(Sender: TObject);
Begin
  FDelphiVersions.Free;
  FIgnoreFolders.Free;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Var
  lIni: TIniFile;
Begin
  PCOptions.Pages[0].TabVisible := False;
  PCOptions.Pages[1].TabVisible := False;
  FDelphiVersions := TDelphiVersions.Create;
  LoadDelphiVersions;
  FIgnoreFolders := TStringList.Create;
  FIgnoreFolders.Sorted := True;
  FIgnoreFolders.Duplicates := dupIgnore;
  FIgnoreFolders.Delimiter := ';';
  lIni := TIniFile.Create(TPath.ChangeExtension(Application.ExeName, '.ini'));
  Try
    FIgnoreFolders.DelimitedText := lIni.ReadString('Folders', 'Ignore', '');
    SrcMasterDir.Text := lIni.ReadString('Folders', 'MasterSource', '');
    TgtMasterDir.Text := lIni.ReadString('Folders', 'MasterTarget', '');
    GlobalMap.Checked := lIni.ReadBool('Settings', 'GlobalMap', False);
    BackUpFolder.Text := lIni.ReadString('Mapping', 'BackUpFolder', '');
  Finally
    lIni.Free;
  End;

  LoadSubFolders;
End;

Procedure TForm1.BrowseForSourceAccept(Sender: TObject);
Begin
  SrcMasterDir.Text := BrowseForSource.Folder;
  LoadSubFolders;
End;

Procedure TForm1.BrowseForTargetAccept(Sender: TObject);
Begin
  TgtMasterDir.Text := BrowseForTarget.Folder;
End;

Procedure TForm1.CreateMapActionExecute(Sender: TObject);
Begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  CreatePathMap;
  Memo2.Lines.AddStrings(FMapPaths);
  FMapPaths.Free;
  FMapPaths := Nil;
End;

Procedure TForm1.CreatePathMap;
Var
  J: Integer;
Begin
  Log('Creating Paths List');
  FMapPaths := TStringList.Create;
  For J := 0 To SrcFolders.Count - 1 Do
  Begin

    If SrcFolders.Checked[J] Then
      MapTopFolder(SrcFolders.Items[J]);
  End;

End;

Procedure TForm1.DelphiVersionChange(Sender: TObject);
Begin
  Platforms.Items.Clear;
  FDelphiVersions.SupportedPlatformsToStrings(DelphiVersion.Text, Platforms.Items);
End;

Procedure TForm1.GlobalMapClick(Sender: TObject);
Begin
  if GlobalMap.Checked then
  begin
    PCOptions.ActivePageIndex := 1;
    Label4.Caption := 'Test Output';
  end
  else
  begin
    PCOptions.ActivePageIndex := 0;
    Label4.Caption := 'Files that failed to copy to target folder';
  end;
End;

Procedure TForm1.ExecActionExecute(Sender: TObject);
Var
  I: Integer;
Begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  For I := 0 To SrcFolders.Count - 1 Do
  Begin
    If SrcFolders.Checked[I] Then
      ProcessTopFolder(SrcFolders.Items[I]);
  End;
  ShowMessage('Complete');
End;

Procedure TForm1.IgnoreFolderActionExecute(Sender: TObject);
Var
  I: Integer;
  lDir: String;
Begin
  I := SrcFolders.ItemIndex;
  If I < 0 Then
    Exit;
  lDir := TPath.GetFileName(SrcFolders.Items[I]);
  FIgnoreFolders.Add(lDir);
  SrcFolders.Items.Delete(I);
End;

Procedure TForm1.LoadDelphiVersions;
Var
  I: Integer;
Begin
  For I := 0 To FDelphiVersions.AvailableCount - 1 Do
  Begin
    DelphiVersion.Items.Add(FDelphiVersions.AvailableVersionName[I]);
  End;
End;

Procedure TForm1.LoadSubFolders;
Var
  lDirs: TStringDynArray;
  I, X: Integer;
  lDir: String;
Begin
  SrcFolders.Items.Clear;
  lDirs := TDirectory.GetDirectories(SrcMasterDir.Text);

  For I := 0 To Length(lDirs) - 1 Do
  Begin
    lDir := TPath.GetFileName(lDirs[I]);
    X := SrcFolders.Items.Add(lDirs[I]);
    If FIgnoreFolders.IndexOf(lDir) < 0 Then
      SrcFolders.Checked[X] := True;
  End;

  SrcFolders.ItemIndex := 0;
End;

Procedure TForm1.Log(Const Value: String);
Begin
  Memo1.Lines.Add(Value);
  Application.ProcessMessages;
End;

Procedure TForm1.MapPathsButtonClick(Sender: TObject);
Var
  J, I: Integer;
Begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  CreatePathMap;
  Try
    For I := 0 To Platforms.Count - 1 Do
    Begin
      If Platforms.Checked[I] Then
      Begin
        Log('Mapping for ' + Platforms.Items[I] + '; Paths Count: ' + FMapPaths.Count.ToString);
        FDelphiVersions.OpenLibrary(DelphiVersion.Text, Platforms.Items[I], BackUpFolder.Text);

        For J := 0 To FMapPaths.Count - 1 Do
        Begin

          if FDelphiVersions.AddToLibrary(FMapPaths[J]) then
             Log('Mapped ' + FMapPaths[J])
          else
             Log('Already Exists: ' + FMapPaths[J]);

        End;
        If MapTest.Checked Then
        Begin
          Memo2.Lines.Add(FMapPaths[I]);
          Memo2.Lines.Add(StringOfChar('-', FMapPaths[I].Length));
          FDelphiVersions.AppendPaths(Memo2.Lines);
          Memo2.Lines.Add(' ');
        End
        Else
          FDelphiVersions.SaveAndCloseLibrary;
      End;
    End;
  Finally
    FMapPaths.Free;
  End;

  if  MapTest.Checked then
      ShowMessage('Complete. Paths are shown in the second memo box. Delphi Paths have not been updated')
  else
      ShowMessage('Complete. Paths have been added to the Delphi Global Paths');
End;

Procedure TForm1.MapTopFolder(AFolder: String);

  Procedure MapSourceFolder(BFolder: String);
  Var
    BFolders: TStringDynArray;
    I: Integer;
  Begin

    FMapPaths.Add(BFolder);
    Log('Added: ' + BFolder);
    BFolders := TDirectory.GetDirectories(BFolder);
    For I := 0 To Length(BFolders) - 1 Do
      MapSourceFolder(BFolders[I]);

  End;

Var
  lFolders: TStringDynArray;
  I: Integer;
  SFolder: String;
Begin
  Log('Processing: ' + AFolder);
  lFolders := TDirectory.GetDirectories(AFolder);
  For I := 0 To Length(lFolders) - 1 Do
  Begin
    If lFolders[I].Contains('.') Then
      Continue;
    SFolder := TPath.Combine(lFolders[I], 'Src');
    If TDirectory.Exists(SFolder) Then
      Break
    Else
      SFolder := '';
  End;

  If SFolder <> '' Then
    MapSourceFolder(SFolder)
  else
    Log('Source Folder not Found');
End;

Procedure TForm1.ProcessSourceFolder(SourceFolder, TargetFolder: String);

  Procedure ProcessThisFolder(Const AFolder: String; Const ALevel: Integer);
  Var
    lFiles, lFolders: TStringDynArray;
    S, lName, lTargetName, fileContents, lInc: String;
  Begin
    Log(' ' + StringOfChar('-', ALevel * 2) + ' Processing ' + AFolder);

    lFolders := TDirectory.GetDirectories(AFolder);
    lFiles := TDirectory.GetFiles(AFolder);
    For S In lFiles Do
    Begin
      lName := TPath.GetFileName(S);
      lTargetName := TPath.Combine(TargetFolder, lName);
      If TPath.GetExtension(S).ToLower = '.pas' Then
      Begin
        fileContents := TFile.ReadAllText(S);
        lInc := '{$I ' + DupeString('..\', ALevel) + 'Include\';
        fileContents := fileContents.Replace(lInc, '{$I ', [rfReplaceAll]);
        TFile.WriteAllText(lTargetName, fileContents);
        If Not TFile.Exists(lTargetName) Then
          Memo2.Lines.Add(S)
      End
      Else
      Begin
        TFile.Copy(S, lTargetName);
        If Not TFile.Exists(lTargetName) Then
          Memo2.Lines.Add(S)
      End;
    End;

    For S In lFolders Do
      ProcessThisFolder(S, ALevel + 1);

  End;

Var
  lFolders: TStringDynArray;
  I: Integer;
Begin

  lFolders := TDirectory.GetDirectories(SourceFolder);
  For I := 0 To Length(lFolders) - 1 Do
    ProcessThisFolder(lFolders[I], 1);
End;

Procedure TForm1.ProcessTopFolder(AFolder: String);
  Procedure EmptyFolder(Const XFolder: String);
  Var
    uFiles: TStringDynArray;
    S: String;
  Begin
    uFiles := TDirectory.GetFiles(XFolder);
    For S In uFiles Do
      TFile.Delete(S);
  End;

Var
  TargetFolder, SFolder, lPath, S: String;
  lFiles, lFolders, lSFolders: TStringDynArray;
  I, J: Integer;
Begin
  Log('Starting ' + AFolder);
  TargetFolder := TPath.Combine(TgtMasterDir.Text, TPath.GetFileName(AFolder));
  If TDirectory.Exists(TargetFolder) Then
    EmptyFolder(TargetFolder)
  Else
    TDirectory.CreateDirectory(TargetFolder);
  lFiles := TDirectory.GetFiles(AFolder);
  For I := 0 To Length(lFiles) - 1 Do
  Begin
    If SameText(TPath.GetFileName(lFiles[I]), 'README.md') Then
      TFile.Copy(lFiles[I], TPath.Combine(TargetFolder, 'README.md'))
    Else If SameText(TPath.GetFileName(lFiles[I]), 'LICENSE') Then
    Begin
      lPath := TPath.Combine(TargetFolder, 'LICENSE') + '.txt';
      TFile.Copy(lFiles[I], lPath);
    End;
  End;

  lFolders := TDirectory.GetDirectories(AFolder);
  For I := 0 To Length(lFolders) - 1 Do
  Begin
    If lFolders[I].Contains('.') Then
      Continue;
    SFolder := TPath.Combine(lFolders[I], 'Src');
    If TDirectory.Exists(SFolder) Then
      Break
    Else
      SFolder := '';
  End;

  If SFolder <> '' Then
    ProcessSourceFolder(SFolder, TargetFolder);

End;

Procedure TForm1.SaveActionExecute(Sender: TObject);
Var
  lIni: TIniFile;
Begin
  lIni := TIniFile.Create(TPath.ChangeExtension(Application.ExeName, '.ini'));
  Try
    lIni.WriteString('Folders', 'Ignore', FIgnoreFolders.DelimitedText);
    lIni.WriteString('Folders', 'MasterSource', SrcMasterDir.Text);
    lIni.WriteString('Folders', 'MasterTarget', TgtMasterDir.Text);
    lIni.WriteBool('Settings', 'GlobalMap', GlobalMap.Checked);
    lIni.WriteString('Mapping', 'BackUpFolder', BackUpFolder.Text);
  Finally
    lIni.Free;
  End;
End;

End.
