unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.StdActns, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.CheckLst;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    SrcMasterDir: TEdit;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ActionList1: TActionList;
    BrowseForSource: TBrowseForFolder;
    Label3: TLabel;
    TgtMasterDir: TEdit;
    SpeedButton2: TSpeedButton;
    BrowseForTarget: TBrowseForFolder;
    SaveAction: TAction;
    Button1: TButton;
    SpeedButton3: TSpeedButton;
    IgnoreFolderAction: TAction;
    Memo1: TMemo;
    SpeedButton4: TSpeedButton;
    ExecAction: TAction;
    SrcFolders: TCheckListBox;
    Memo2: TMemo;
    Label4: TLabel;
    NotesAction: TAction;
    procedure FormCreate(Sender: TObject);
    procedure BrowseForSourceAccept(Sender: TObject);
    procedure BrowseForTargetAccept(Sender: TObject);
    procedure ExecActionExecute(Sender: TObject);
    procedure IgnoreFolderActionExecute(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
  private
    { Private declarations }
    FIgnoreFolders: TStringList;
    procedure LoadSubFolders;
    procedure ProcessTopFolder(AFolder: string);
    procedure Log(const Value: string);
    procedure ProcessSourceFolder(SourceFolder, TargetFolder: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses System.IOUtils, System.Types, System.IniFiles, System.StrUtils;

procedure TForm1.FormCreate(Sender: TObject);
var lIni:TIniFile;
begin
  FIgnoreFolders := TStringList.Create;
  FIgnoreFolders.Sorted := True;
  FignoreFolders.Duplicates := dupIgnore;
  FIgnoreFolders.Delimiter := ';';
  lIni := TIniFile.Create(TPath.ChangeExtension(Application.ExeName, '.ini'));
  try
    FIgnoreFolders.DelimitedText := lIni.ReadString('Folders', 'Ignore', '');
    SrcMasterDir.Text := lIni.ReadString('Folders', 'MasterSource', '');
    TgtMasterDir.Text := lIni.ReadString('Folders', 'MasterTarget', '');

  finally
    lIni.Free;
  end;

  LoadSubFolders;
end;

procedure TForm1.BrowseForSourceAccept(Sender: TObject);
begin
  SrcMasterDir.Text := BrowseForSource.Folder;
  LoadSubFolders;
end;

procedure TForm1.BrowseForTargetAccept(Sender: TObject);
begin
  TgtMasterDir.Text := BrowseForTarget.Folder;
end;

procedure TForm1.ExecActionExecute(Sender: TObject);
var
  I: Integer;
begin
   Memo1.Lines.Clear;
   Memo2.Lines.Clear;
   for I := 0 to SrcFolders.Count - 1 do
   begin
     if SrcFolders.Checked[I] then
        ProcessTopFolder(SrcFolders.Items[I]);
   end;
   ShowMessage('Complete');
end;

procedure TForm1.IgnoreFolderActionExecute(Sender: TObject);
var I: Integer;
    lDir: String;
begin
   I := SrcFolders.ItemIndex;
   if I < 0 then
      Exit;
   lDir := TPath.GetFileName(SrcFolders.Items[I]);
   FIgnoreFolders.Add(lDir);
   SrcFolders.Items.Delete(I);
end;

procedure TForm1.LoadSubFolders;
var lDirs: TStringDynArray;
  I, X: Integer;
  lDir: String;
begin
  SrcFolders.Items.Clear;
  lDirs := TDirectory.GetDirectories(SrcMasterDir.Text);

  for I := 0 to Length(lDirs) - 1 do
  begin
    lDir := TPath.GetFileName(lDirs[I]);
    X := SrcFolders.Items.Add(lDirs[I]);
    if FIgnoreFolders.IndexOf(lDir) < 0 then
       SrcFolders.Checked[X] := True;
  end;

  SrcFolders.ItemIndex := 0;
end;

procedure TForm1.Log(const Value: string);
begin
  Memo1.Lines.Add(Value);
  Application.ProcessMessages;
end;

procedure TForm1.ProcessSourceFolder(SourceFolder, TargetFolder: string);

   procedure ProcessThisFolder(Const AFolder: String; const ALevel: Integer);
   var lFiles, lFolders: TStringDynarray;
       S, lName, lTargetName, fileContents, lInc: String;
   begin
     Log(' ' + StringOfChar('-', ALevel * 2) +   ' Processing ' + AFolder);

     lFolders := TDirectory.GetDirectories(AFolder);
     lFiles := TDirectory.GetFiles(AFolder);
     for S In lFiles do
     begin
       lName := TPath.GetFileName(S);
       lTargetName := TPath.Combine(TargetFolder, lName);
       if TPath.GetExtension(S).ToLower = '.pas' then
       begin
         fileContents := TFile.ReadAllText(S);
         lInc := '{$I ' + DupeString('..\', ALevel) + 'Include\';
         fileContents := fileContents.Replace(lInc, '{$I ', [rfReplaceAll]);
         TFile.WriteAllText(lTargetName, fileContents);
         if not TFile.Exists(lTargetName) then
            Memo2.Lines.Add(S)
       end
       else
       begin
         TFile.Copy(S, lTargetName);
         if not TFile.Exists(lTargetName) then
            Memo2.Lines.Add(S)
       end;
     end;

     for S in lFolders do
        ProcessThisFolder(S, ALevel + 1);

   end;

var lFolders: TStringDynarray;
  I: Integer;
begin

  lFolders := TDirectory.GetDirectories(SourceFolder);
  for I := 0 to Length(lFolders) - 1 do
      ProcessThisFolder(lFolders[I], 1);
end;

procedure TForm1.ProcessTopFolder(AFolder: string);
  procedure EmptyFolder(const XFolder: String);
  var uFiles: TStringDynArray;
  S: String;
  begin
    uFiles := TDirectory.GetFiles(XFolder);
    for S in uFiles do
        TFile.Delete(S);
  end;
var
 TargetFolder, SFolder, lPath, S: String;
 lFiles, lFolders, lSFolders: TStringDynarray;
  I, J: Integer;
begin
  Log('Starting ' + AFolder);
  TargetFolder := TPath.Combine(TgtMasterDir.Text, TPath.GetFileName(AFolder));
  if TDirectory.Exists(TargetFolder) then
     EmptyFolder(TargetFolder)
  else
     TDirectory.CreateDirectory(TargetFolder);
  lFiles := TDirectory.GetFiles(AFolder);
  for I := 0 to Length(lFiles) - 1 do
  begin
    if SameText(TPath.GetFileName(lFiles[I]), 'README.md') then
       TFile.Copy(lFiles[I], TPath.Combine(TargetFolder, 'README.md'))
    else if SameText(TPath.GetFileName(lFiles[I]), 'LICENSE') then
    begin
       lPath := TPath.Combine(TargetFolder, 'LICENSE') + '.txt';
       TFile.Copy(lFiles[I], lPath);
    end;
  end;

  lFolders := TDirectory.GetDirectories(AFolder);
  for I := 0 to Length(lFolders) - 1 do
  begin
    if lFolders[I].Contains('.') then
       Continue;
    SFolder := TPath.Combine( lFolders[I], 'Src');
    if TDirectory.Exists(sFolder) then
       Break
    else
      SFolder := '';
  end;

  if SFolder <> '' then
     ProcessSourceFolder(SFolder, TargetFolder);

end;

procedure TForm1.SaveActionExecute(Sender: TObject);
var lIni:TIniFile;
begin
  lIni := TIniFile.Create(TPath.ChangeExtension(Application.ExeName, '.ini'));
  try
    lIni.WriteString('Folders', 'Ignore', FIgnoreFolders.DelimitedText);
    lIni.WriteString('Folders', 'MasterSource', SrcMasterDir.Text);
    lIni.WriteString('Folders', 'MasterTarget', TgtMasterDir.Text);
  finally
    lIni.Free;
  end;
end;

end.
