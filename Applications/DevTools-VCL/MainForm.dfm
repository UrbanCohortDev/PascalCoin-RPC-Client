object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Development Tools'
  ClientHeight = 755
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 548
    Height = 755
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = -56
    object TabSheet1: TTabSheet
      Caption = 'Crypto Libraries'
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 534
        Height = 31
        Align = alTop
        Caption = 
          'Move Ugo'#39's Crypto Libs into single directories or map them to De' +
          'lphi'#39's Global Paths'
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 556
        Width = 534
        Height = 13
        Align = alBottom
        Caption = 'Failed To Copy'
        ExplicitTop = 464
        ExplicitWidth = 71
      end
      object Button1: TButton
        Left = 451
        Top = 0
        Width = 75
        Height = 22
        Action = SaveAction
        TabOrder = 0
      end
      object Memo1: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 416
        Width = 534
        Height = 134
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 1
        ExplicitLeft = 0
        ExplicitTop = 448
        ExplicitWidth = 537
        ExplicitHeight = 102
      end
      object Memo2: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 575
        Width = 534
        Height = 149
        Align = alBottom
        Lines.Strings = (
          'Memo2')
        TabOrder = 2
        ExplicitTop = 528
      end
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 40
        Width = 534
        Height = 177
        Align = alTop
        TabOrder = 3
        object GlobalMap: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 524
          Height = 17
          Align = alTop
          Caption = 
            'Map The Source Folders To Delphi'#39's Global Paths. Uncheck to Crea' +
            'te single folders for each library'
          TabOrder = 0
          OnClick = GlobalMapClick
          ExplicitLeft = -211
          ExplicitTop = 22
          ExplicitWidth = 433
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 41
          Width = 524
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel1'
          TabOrder = 1
          object Label2: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 6
            Width = 120
            Height = 18
            Margins.Top = 6
            Align = alLeft
            Caption = 'Master Source Directory:'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 13
          end
          object SpeedButton1: TSpeedButton
            Left = 501
            Top = 0
            Width = 23
            Height = 27
            Action = BrowseForSource
            Align = alRight
            ExplicitLeft = 189
            ExplicitTop = 19
            ExplicitHeight = 22
          end
          object SrcMasterDir: TEdit
            AlignWithMargins = True
            Left = 129
            Top = 3
            Width = 369
            Height = 21
            Align = alClient
            TabOrder = 0
            ExplicitLeft = 152
            ExplicitTop = 0
            ExplicitWidth = 349
            ExplicitHeight = 24
          end
        end
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 74
          Width = 524
          Height = 98
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          TabOrder = 2
          ExplicitLeft = 16
          ExplicitTop = 71
          ExplicitWidth = 185
          ExplicitHeight = 41
          object SpeedButton3: TSpeedButton
            Left = 464
            Top = 3
            Width = 57
            Height = 22
            Action = IgnoreFolderAction
          end
          object SrcFolders: TCheckListBox
            Left = 0
            Top = 0
            Width = 457
            Height = 98
            Align = alLeft
            ItemHeight = 13
            TabOrder = 0
            ExplicitLeft = 1
            ExplicitHeight = 60
          end
        end
      end
      object PCOptions: TPageControl
        Left = 0
        Top = 220
        Width = 540
        Height = 193
        ActivePage = TabSheet3
        Align = alTop
        TabOrder = 4
        ExplicitTop = 185
        object TabSheet2: TTabSheet
          Caption = 'TabSheet2'
          object SingleFolderGroup: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 526
            Height = 159
            Align = alClient
            Caption = 'Single Folder Option'
            TabOrder = 0
            ExplicitLeft = 21
            ExplicitTop = 80
            ExplicitWidth = 511
            ExplicitHeight = 85
            object Label3: TLabel
              Left = 8
              Top = 24
              Width = 119
              Height = 13
              Caption = 'Target Master Directory:'
            end
            object SpeedButton2: TSpeedButton
              Left = 485
              Top = 19
              Width = 23
              Height = 22
              Action = BrowseForTarget
            end
            object SpeedButton4: TSpeedButton
              Left = 433
              Top = 56
              Width = 75
              Height = 22
              Action = ExecAction
            end
            object TgtMasterDir: TEdit
              Left = 133
              Top = 20
              Width = 346
              Height = 21
              TabOrder = 0
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'TabSheet3'
          ImageIndex = 1
          object MappingOptionsGroup: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 526
            Height = 159
            Align = alClient
            Caption = 'Mapping Options'
            TabOrder = 0
            ExplicitLeft = -2
            ExplicitTop = 49
            ExplicitWidth = 534
            ExplicitHeight = 116
            object Label5: TLabel
              Left = 16
              Top = 18
              Width = 68
              Height = 13
              Caption = 'BackUp Folder'
            end
            object Platforms: TCheckListBox
              Left = 167
              Top = 64
              Width = 253
              Height = 83
              Columns = 2
              ItemHeight = 13
              TabOrder = 0
            end
            object DelphiVersion: TComboBox
              Left = 16
              Top = 66
              Width = 145
              Height = 21
              TabOrder = 1
              Text = 'DelphiVersion'
              OnChange = DelphiVersionChange
            end
            object MapPathsButton: TButton
              Left = 432
              Top = 122
              Width = 75
              Height = 25
              Caption = 'Execute'
              TabOrder = 2
              OnClick = MapPathsButtonClick
            end
            object BackUpFolder: TEdit
              Left = 90
              Top = 14
              Width = 336
              Height = 21
              TabOrder = 3
            end
            object Button2: TButton
              Left = 432
              Top = 12
              Width = 75
              Height = 25
              Action = BrowseForBackupFolder
              TabOrder = 4
            end
            object MapTest: TCheckBox
              Left = 432
              Top = 99
              Width = 97
              Height = 17
              Caption = 'Test Run Only'
              Checked = True
              State = cbChecked
              TabOrder = 5
            end
            object Button3: TButton
              Left = 432
              Top = 68
              Width = 75
              Height = 25
              Hint = 'Writes the directory mapping to first memo'
              Action = CreateMapAction
              TabOrder = 6
            end
          end
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 364
    Top = 336
    object BrowseForSource: TBrowseForFolder
      Category = 'File'
      Caption = '...'
      DialogCaption = 'Browse For Source Master'
      BrowseOptions = []
      BrowseOptionsEx = []
      OnAccept = BrowseForSourceAccept
    end
    object BrowseForTarget: TBrowseForFolder
      Category = 'File'
      Caption = '...'
      DialogCaption = 'Browse For Target Master'
      BrowseOptions = []
      BrowseOptionsEx = []
      OnAccept = BrowseForTargetAccept
    end
    object SaveAction: TAction
      Category = 'File'
      Caption = 'Save Params'
      OnExecute = SaveActionExecute
    end
    object IgnoreFolderAction: TAction
      Category = 'File'
      Caption = 'Ignore'
      OnExecute = IgnoreFolderActionExecute
    end
    object ExecAction: TAction
      Category = 'File'
      Caption = 'Execute'
      OnExecute = ExecActionExecute
    end
    object NotesAction: TAction
      Category = 'File'
      Caption = 'Notes'
    end
    object BrowseForBackupFolder: TBrowseForFolder
      Category = 'File'
      Caption = 'Browse'
      DialogCaption = 'Browse'
      BrowseOptions = []
      BrowseOptionsEx = []
      OnAccept = BrowseForBackupFolderAccept
    end
    object CreateMapAction: TAction
      Category = 'File'
      Caption = 'Create Map'
      OnExecute = CreateMapActionExecute
    end
  end
end
