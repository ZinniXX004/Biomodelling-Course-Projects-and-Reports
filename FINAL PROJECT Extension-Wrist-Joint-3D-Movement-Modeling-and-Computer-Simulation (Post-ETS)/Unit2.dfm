object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 
    '5023231017 - Jeremia Christ Immanuel Manalu - Wrist Joint Simula' +
    'tor'
  ClientHeight = 1067
  ClientWidth = 1600
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  TextHeight = 15
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 1096
    Height = 1067
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1090
    ExplicitHeight = 1050
    object Label1: TLabel
      Left = 119
      Top = 3
      Width = 54
      Height = 28
      Caption = 'RMSE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 24
      Top = 999
      Width = 36
      Height = 15
      Caption = 'Label7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Chart1: TChart
      Left = 280
      Top = 8
      Width = 393
      Height = 217
      Legend.CheckBoxes = True
      Legend.LegendStyle = lsSeries
      Title.Font.Color = clFuchsia
      Title.Font.Name = 'Arial MT Black'
      Title.Text.Strings = (
        'Radial/Ulnar Flexion')
      BottomAxis.LabelsFormat.Font.Color = clFuchsia
      BottomAxis.Title.Font.Color = clFuchsia
      LeftAxis.LabelsFormat.Font.Color = clFuchsia
      LeftAxis.Title.Font.Color = clFuchsia
      View3D = False
      Color = clGreen
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series1: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = clYellow
        Title = 'Target'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series2: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = clAqua
        Title = 'Realized'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object Chart2: TChart
      Left = 679
      Top = 8
      Width = 393
      Height = 217
      Legend.CheckBoxes = True
      Legend.LegendStyle = lsSeries
      Title.Font.Color = clYellow
      Title.Font.Name = 'Arial MT Black'
      Title.Text.Strings = (
        'Dorsal/Palmar Flexion')
      BottomAxis.LabelsFormat.Font.Color = clYellow
      LeftAxis.LabelsFormat.Font.Color = clYellow
      View3D = False
      Color = clNavy
      TabOrder = 1
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series3: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = 8388863
        Title = 'Target'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series4: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = clAqua
        Title = 'Realized'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object Chart3: TChart
      Left = 280
      Top = 231
      Width = 393
      Height = 217
      Title.Font.Color = clAqua
      Title.Font.Name = 'Arial MT Black'
      Title.Text.Strings = (
        'Active Torque')
      BottomAxis.LabelsFormat.Font.Color = clAqua
      LeftAxis.LabelsFormat.Font.Color = clAqua
      View3D = False
      Color = 8388672
      TabOrder = 2
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series5: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = clYellow
        Title = 'Tau1'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series6: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = 65408
        Title = 'Tau2'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object Chart4: TChart
      Left = 679
      Top = 231
      Width = 393
      Height = 217
      Title.Font.Name = 'Arial MT Black'
      Title.Text.Strings = (
        'Error')
      BottomAxis.LabelsFormat.Font.Color = clBlue
      LeftAxis.LabelsFormat.Font.Color = clBlue
      View3D = False
      Color = clYellow
      TabOrder = 3
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series7: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = clRed
        Title = 'Error1'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series8: TLineSeries
        HoverElement = [heCurrent]
        SeriesColor = clGreen
        Title = 'Error2'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object Chart5: TChart
      Left = 280
      Top = 454
      Width = 792
      Height = 226
      Title.Font.Color = 65408
      Title.Font.Name = 'Arial MT Black'
      Title.Text.Strings = (
        'Joint Angle')
      BottomAxis.LabelsFormat.Font.Color = 65408
      LeftAxis.LabelsFormat.Font.Color = 65408
      View3D = False
      Color = 8421440
      TabOrder = 4
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series9: TPointSeries
        HoverElement = [heCurrent]
        SeriesColor = 4194432
        Title = 'Target'
        ClickableLine = False
        Pointer.InflateMargins = True
        Pointer.Style = psTriangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series10: TPointSeries
        HoverElement = [heCurrent]
        SeriesColor = 16744576
        Title = 'Realized'
        ClickableLine = False
        Pointer.InflateMargins = True
        Pointer.Style = psDiamond
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object Edit1: TEdit
      Left = 24
      Top = 34
      Width = 242
      Height = 23
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object GroupBox1: TGroupBox
      Left = 24
      Top = 71
      Width = 242
      Height = 609
      Caption = 'Button Config'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentColor = False
      ParentFont = False
      TabOrder = 6
      object Button1: TButton
        Left = 16
        Top = 24
        Width = 106
        Height = 177
        Caption = 'Frontal'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 128
        Top = 24
        Width = 104
        Height = 177
        Caption = 'Sagital'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 16
        Top = 207
        Width = 106
        Height = 170
        Caption = 'Front + Sag'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 128
        Top = 207
        Width = 103
        Height = 170
        Caption = 'Save'
        TabOrder = 3
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 16
        Top = 383
        Width = 105
        Height = 162
        Caption = 'Reset'
        TabOrder = 4
        OnClick = Button5Click
      end
      object RadioButton1: TRadioButton
        Left = 32
        Top = 565
        Width = 65
        Height = 17
        Caption = 'Active'
        TabOrder = 5
      end
      object RadioButton2: TRadioButton
        Left = 135
        Top = 565
        Width = 74
        Height = 17
        Caption = 'Passive'
        TabOrder = 6
      end
      object BitBtn1: TBitBtn
        Left = 127
        Top = 383
        Width = 104
        Height = 162
        Caption = '&EXIT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Kind = bkClose
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 7
      end
    end
    object GroupBoxPOV: TGroupBox
      Left = 24
      Top = 686
      Width = 1056
      Height = 203
      Caption = 'POV Configuration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      object lblPitch: TLabel
        Left = 32
        Top = 15
        Width = 52
        Height = 20
        Caption = 'lblPitch'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblRoll: TLabel
        Left = 32
        Top = 159
        Width = 44
        Height = 20
        Caption = 'lblRoll'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblYaw: TLabel
        Left = 32
        Top = 87
        Width = 45
        Height = 20
        Caption = 'lblYaw'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object tbPitch: TTrackBar
        Left = 120
        Top = 14
        Width = 913
        Height = 45
        TabOrder = 0
        OnChange = tbPitchChange
      end
      object tbRoll: TTrackBar
        Left = 120
        Top = 155
        Width = 913
        Height = 45
        TabOrder = 1
        OnChange = tbRollChange
      end
      object tbYaw: TTrackBar
        Left = 120
        Top = 89
        Width = 913
        Height = 45
        TabOrder = 2
        OnChange = tbYawChange
      end
    end
    object GroupBoxParams: TGroupBox
      Left = 24
      Top = 895
      Width = 1056
      Height = 98
      Caption = 'Parameters Input'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      object Label2: TLabel
        Left = 75
        Top = 24
        Width = 7
        Height = 20
        Caption = 'c'
      end
      object Label3: TLabel
        Left = 296
        Top = 24
        Width = 8
        Height = 20
        Caption = 'k'
      end
      object Label4: TLabel
        Left = 520
        Top = 24
        Width = 19
        Height = 20
        Caption = 'Kp'
      end
      object Label5: TLabel
        Left = 736
        Top = 24
        Width = 13
        Height = 20
        Caption = 'Ti'
      end
      object Label6: TLabel
        Left = 968
        Top = 24
        Width = 17
        Height = 20
        Caption = 'Td'
      end
      object edtDamping: TEdit
        Left = 16
        Top = 50
        Width = 121
        Height = 28
        Alignment = taCenter
        Color = clBlue
        TabOrder = 0
        Text = '0.5'
      end
      object edtStiffness: TEdit
        Left = 240
        Top = 50
        Width = 121
        Height = 28
        Alignment = taCenter
        Color = clBlue
        TabOrder = 1
        Text = '2.0'
      end
      object edtKp: TEdit
        Left = 464
        Top = 50
        Width = 121
        Height = 28
        Alignment = taCenter
        Color = clBlue
        TabOrder = 2
        Text = '0.2'
      end
      object edtTi: TEdit
        Left = 680
        Top = 50
        Width = 121
        Height = 28
        Alignment = taCenter
        Color = clBlue
        TabOrder = 3
        Text = '0.01'
      end
      object edtTd: TEdit
        Left = 912
        Top = 50
        Width = 121
        Height = 28
        Alignment = taCenter
        Color = clBlue
        TabOrder = 4
        Text = '0.0025'
      end
    end
    object lbDebugData: TListBox
      Left = 64
      Top = 999
      Width = 980
      Height = 97
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 9
    end
  end
  object PanelGL: TPanel
    Left = 1096
    Top = 0
    Width = 504
    Height = 1067
    Align = alRight
    Caption = 'PanelGL'
    TabOrder = 1
    ExplicitLeft = 1090
    ExplicitHeight = 1050
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 224
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer2Timer
    Left = 256
    Top = 16
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer3Timer
    Left = 288
    Top = 16
  end
  object Timer4: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer4Timer
    Left = 320
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    Left = 184
    Top = 16
  end
end
