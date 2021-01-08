object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Development Tools'
  ClientHeight = 656
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 548
    Height = 656
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Crypto Libraries'
      DesignSize = (
        540
        628)
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 534
        Height = 13
        Align = alTop
        Caption = 
          'Move Ugo'#39's Crypto Libs into single directories or map them to De' +
          'lphi'#39's Global Paths'
        ExplicitWidth = 393
      end
      object Label2: TLabel
        Left = 0
        Top = 57
        Width = 120
        Height = 13
        Caption = 'Source Master Directory:'
      end
      object SpeedButton1: TSpeedButton
        Left = 415
        Top = 53
        Width = 23
        Height = 22
        Action = BrowseForSource
      end
      object SpeedButton3: TSpeedButton
        Left = 415
        Top = 80
        Width = 57
        Height = 22
        Action = IgnoreFolderAction
      end
      object Label4: TLabel
        Left = 21
        Top = 464
        Width = 71
        Height = 13
        Caption = 'Failed To Copy'
      end
      object SrcMasterDir: TEdit
        Left = 136
        Top = 53
        Width = 273
        Height = 21
        TabOrder = 0
      end
      object Button1: TButton
        Left = 452
        Top = 3
        Width = 75
        Height = 22
        Action = SaveAction
        TabOrder = 1
      end
      object Memo1: TMemo
        Left = 3
        Top = 328
        Width = 516
        Height = 121
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          'Memo1')
        TabOrder = 2
      end
      object SrcFolders: TCheckListBox
        Left = 136
        Top = 80
        Width = 273
        Height = 97
        ItemHeight = 13
        TabOrder = 3
      end
      object Memo2: TMemo
        Left = 3
        Top = 483
        Width = 422
        Height = 126
        Lines.Strings = (
          'Memo2')
        TabOrder = 4
      end
      object SingleFolderGroup: TGroupBox
        Left = 3
        Top = 180
        Width = 511
        Height = 85
        Caption = 'Single Folder Option'
        TabOrder = 5
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
      object GlobalMap: TCheckBox
        Left = 8
        Top = 24
        Width = 153
        Height = 17
        Caption = 'Map To Global Paths'
        TabOrder = 6
        OnClick = GlobalMapClick
      end
      object MappingOptionsGroup: TGroupBox
        Left = 3
        Top = 183
        Width = 511
        Height = 139
        Caption = 'Mapping Options'
        TabOrder = 7
        Visible = False
        object Label5: TLabel
          Left = 16
          Top = 26
          Width = 68
          Height = 13
          Caption = 'BackUp Folder'
        end
        object Platforms: TCheckListBox
          Left = 167
          Top = 48
          Width = 253
          Height = 83
          Columns = 2
          ItemHeight = 13
          TabOrder = 0
        end
        object DelphiVersion: TComboBox
          Left = 16
          Top = 50
          Width = 145
          Height = 21
          TabOrder = 1
          Text = 'DelphiVersion'
          OnChange = DelphiVersionChange
        end
        object MapPathsButton: TButton
          Left = 432
          Top = 106
          Width = 75
          Height = 25
          Caption = 'Execute'
          TabOrder = 2
          OnClick = MapPathsButtonClick
        end
        object BackUpFolder: TEdit
          Left = 168
          Top = 21
          Width = 254
          Height = 21
          TabOrder = 3
        end
        object Button2: TButton
          Left = 432
          Top = 21
          Width = 75
          Height = 25
          Action = BrowseForBackupFolder
          TabOrder = 4
        end
        object MapTest: TCheckBox
          Left = 432
          Top = 88
          Width = 97
          Height = 17
          Caption = 'Test Run'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object Button3: TButton
          Left = 432
          Top = 52
          Width = 75
          Height = 25
          Action = CreateMapAction
          TabOrder = 6
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
