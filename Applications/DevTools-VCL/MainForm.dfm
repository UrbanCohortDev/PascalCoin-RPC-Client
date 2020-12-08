object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Development Tools'
  ClientHeight = 581
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 548
    Height = 581
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Crypto Libraries'
      DesignSize = (
        540
        553)
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 534
        Height = 13
        Align = alTop
        Caption = 'Move Ugo'#39's Crypto Libs into single directories'
        ExplicitWidth = 216
      end
      object Label2: TLabel
        Left = 8
        Top = 26
        Width = 120
        Height = 13
        Caption = 'Source Master Directory:'
      end
      object SpeedButton1: TSpeedButton
        Left = 415
        Top = 22
        Width = 23
        Height = 22
        Action = BrowseForSource
      end
      object Label3: TLabel
        Left = 8
        Top = 174
        Width = 119
        Height = 13
        Caption = 'Target Master Directory:'
      end
      object SpeedButton2: TSpeedButton
        Left = 415
        Top = 170
        Width = 23
        Height = 22
        Action = BrowseForTarget
      end
      object SpeedButton3: TSpeedButton
        Left = 415
        Top = 80
        Width = 57
        Height = 22
        Action = IgnoreFolderAction
      end
      object SpeedButton4: TSpeedButton
        Left = 457
        Top = 170
        Width = 75
        Height = 22
        Action = ExecAction
      end
      object Label4: TLabel
        Left = 16
        Top = 400
        Width = 71
        Height = 13
        Caption = 'Failed To Copy'
      end
      object SrcMasterDir: TEdit
        Left = 144
        Top = 22
        Width = 265
        Height = 21
        TabOrder = 0
      end
      object TgtMasterDir: TEdit
        Left = 144
        Top = 170
        Width = 265
        Height = 21
        TabOrder = 1
      end
      object Button1: TButton
        Left = 457
        Top = 139
        Width = 75
        Height = 22
        Action = SaveAction
        TabOrder = 2
      end
      object Memo1: TMemo
        Left = 16
        Top = 208
        Width = 516
        Height = 177
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          'Memo1')
        TabOrder = 3
      end
      object SrcFolders: TCheckListBox
        Left = 144
        Top = 56
        Width = 265
        Height = 97
        ItemHeight = 13
        TabOrder = 4
      end
      object Memo2: TMemo
        Left = 16
        Top = 416
        Width = 422
        Height = 126
        Lines.Strings = (
          'Memo2')
        TabOrder = 5
      end
    end
  end
  object ActionList1: TActionList
    Left = 420
    Top = 128
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
  end
end
