object FormWristJoint: TFormWristJoint
  Left = 0
  Top = 0
  Caption = 'Final Project Wrist Joint - 5023231017 - Jeremia Manalu'
  ClientHeight = 768
  ClientWidth = 1280
  Color = 8388672
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 401
    Top = 0
    Height = 768
    ExplicitLeft = 328
    ExplicitTop = 328
    ExplicitHeight = 100
  end
  object PanelLeft: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 768
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 751
    object PanelControls: TPanel
      Left = 0
      Top = 0
      Width = 401
      Height = 240
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object GrpSimulation: TGroupBox
        Left = 10
        Top = 5
        Width = 380
        Height = 132
        Caption = ' Simulation Control '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LblRMSE: TLabel
          Left = 250
          Top = 100
          Width = 35
          Height = 15
          Caption = 'RMSE:'
        end
        object BtnFrontal: TButton
          Left = 16
          Top = 24
          Width = 80
          Height = 35
          Caption = 'Frontal'
          TabOrder = 0
          OnClick = BtnFrontalClick
        end
        object BtnSagital: TButton
          Left = 102
          Top = 24
          Width = 80
          Height = 35
          Caption = 'Sagital'
          TabOrder = 1
          OnClick = BtnSagitalClick
        end
        object BtnBoth: TButton
          Left = 188
          Top = 24
          Width = 80
          Height = 35
          Caption = 'Combined'
          TabOrder = 2
          OnClick = BtnBothClick
        end
        object BtnReset: TButton
          Left = 16
          Top = 65
          Width = 80
          Height = 30
          Caption = 'Reset'
          TabOrder = 3
          OnClick = BtnResetClick
        end
        object BtnSave: TButton
          Left = 102
          Top = 65
          Width = 80
          Height = 30
          Caption = 'Save'
          TabOrder = 4
          OnClick = BtnSaveClick
        end
        object RadioActive: TRadioButton
          Left = 16
          Top = 101
          Width = 70
          Height = 17
          Caption = 'Active'
          TabOrder = 5
        end
        object RadioPassive: TRadioButton
          Left = 86
          Top = 101
          Width = 70
          Height = 17
          Caption = 'Passive'
          Checked = True
          TabOrder = 6
          TabStop = True
        end
        object EditRMSE: TEdit
          Left = 290
          Top = 97
          Width = 60
          Height = 23
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 7
          Text = '0.00'
        end
        object btnEqFig: TButton
          Left = 188
          Top = 65
          Width = 80
          Height = 30
          Caption = 'Eq. Figure'
          TabOrder = 8
          OnClick = btnEqFigClick
        end
        object BitBtn1: TBitBtn
          Left = 274
          Top = 24
          Width = 97
          Height = 70
          Caption = '&EXIT'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Kind = bkClose
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 9
        end
      end
      object GrpPID: TGroupBox
        Left = 10
        Top = 143
        Width = 380
        Height = 82
        Caption = ' PID Parameters '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LabelKp: TLabel
          Left = 20
          Top = 25
          Width = 15
          Height = 15
          Caption = 'Kp'
        end
        object LabelTi: TLabel
          Left = 130
          Top = 25
          Width = 10
          Height = 15
          Caption = 'Ti'
        end
        object LabelTd: TLabel
          Left = 240
          Top = 25
          Width = 13
          Height = 15
          Caption = 'Td'
        end
        object EdKp: TEdit
          Left = 16
          Top = 46
          Width = 80
          Height = 23
          Color = clBlue
          TabOrder = 0
          Text = '0.6'
        end
        object EdTi: TEdit
          Left = 130
          Top = 46
          Width = 80
          Height = 23
          Color = clBlue
          TabOrder = 1
          Text = '30'
        end
        object EdTd: TEdit
          Left = 240
          Top = 46
          Width = 80
          Height = 23
          Color = clBlue
          TabOrder = 2
          Text = '0.005'
        end
      end
    end
    object ScrollBoxCharts: TScrollBox
      Left = 0
      Top = 240
      Width = 401
      Height = 528
      VertScrollBar.Position = 6
      Align = alClient
      TabOrder = 1
      ExplicitHeight = 511
      object Chart1: TChart
        Left = 0
        Top = -6
        Width = 371
        Height = 180
        Legend.Alignment = laTop
        Legend.CheckBoxes = True
        Title.Font.Color = clGreen
        Title.Text.Strings = (
          'Frontal (Dorsal/Palmar)')
        View3D = False
        Align = alTop
        Color = clYellow
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object Series1: TLineSeries
          HoverElement = [heCurrent]
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
        Left = 0
        Top = 174
        Width = 371
        Height = 180
        Legend.Alignment = laTop
        Legend.CheckBoxes = True
        Title.Text.Strings = (
          'Sagittal (Radial/Ulnar)')
        View3D = False
        Align = alTop
        Color = 8454016
        TabOrder = 1
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object Series3: TLineSeries
          HoverElement = [heCurrent]
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
        Left = 0
        Top = 354
        Width = 371
        Height = 180
        Legend.Alignment = laTop
        Legend.CheckBoxes = True
        Title.Text.Strings = (
          'Torque')
        View3D = False
        Align = alTop
        Color = 16744703
        TabOrder = 2
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object Series5: TLineSeries
          HoverElement = [heCurrent]
          Title = 'Tau Sag.'
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
          Title = 'Tau Front.'
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
        Left = 0
        Top = 534
        Width = 371
        Height = 180
        Legend.Alignment = laTop
        Legend.CheckBoxes = True
        Title.Text.Strings = (
          'Position Error')
        View3D = False
        Align = alTop
        Color = 16777088
        TabOrder = 3
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object Series7: TLineSeries
          HoverElement = [heCurrent]
          Title = 'Err Sag.'
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
          Title = 'Err Front.'
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
        Left = 0
        Top = 714
        Width = 371
        Height = 180
        Legend.Alignment = laTop
        Title.Text.Strings = (
          'Joint Angle')
        View3D = False
        Align = alTop
        Color = 12615808
        TabOrder = 4
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object Series9: TPointSeries
          HoverElement = [heCurrent]
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
    end
  end
  object PanelRight: TPanel
    Left = 404
    Top = 0
    Width = 876
    Height = 768
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 870
    ExplicitHeight = 751
    object PanelGL: TPanel
      Left = 0
      Top = 0
      Width = 876
      Height = 668
      Align = alClient
      Color = clBlack
      ParentBackground = False
      TabOrder = 0
      ExplicitWidth = 870
      ExplicitHeight = 651
    end
    object GrpCamera: TGroupBox
      Left = 0
      Top = 668
      Width = 876
      Height = 100
      Align = alBottom
      Caption = ' Camera Controls '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      ExplicitTop = 651
      ExplicitWidth = 870
      object LabelYaw: TLabel
        Left = 24
        Top = 32
        Width = 22
        Height = 15
        Caption = 'Yaw'
      end
      object LabelPitch: TLabel
        Left = 144
        Top = 32
        Width = 28
        Height = 15
        Caption = 'Pitch'
      end
      object LabelRoll: TLabel
        Left = 270
        Top = 32
        Width = 21
        Height = 15
        Caption = 'Roll'
      end
      object Label1: TLabel
        Left = 544
        Top = 22
        Width = 181
        Height = 15
        Caption = 'Blue: X-Axis (Anterior/Posterior)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 544
        Top = 43
        Width = 154
        Height = 15
        Caption = 'Red: Y-Axis (Lateral/Medial)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 544
        Top = 64
        Width = 183
        Height = 15
        Caption = 'Green: Z-Axis (Superior/Inferior)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object seYaw: TSpinEdit
        Left = 24
        Top = 53
        Width = 80
        Height = 24
        Color = clBlue
        MaxValue = 360
        MinValue = -360
        TabOrder = 0
        Value = 0
        OnChange = seYawChange
      end
      object sePitch: TSpinEdit
        Left = 144
        Top = 53
        Width = 80
        Height = 24
        Color = clBlue
        MaxValue = 360
        MinValue = -360
        TabOrder = 1
        Value = 0
        OnChange = sePitchChange
      end
      object seRoll: TSpinEdit
        Left = 270
        Top = 53
        Width = 80
        Height = 24
        Color = clBlue
        MaxValue = 360
        MinValue = -360
        TabOrder = 2
        Value = 0
        OnChange = seRollChange
      end
      object BtnResetCamera: TButton
        Left = 384
        Top = 32
        Width = 97
        Height = 45
        Caption = 'Reset Camera'
        TabOrder = 3
        OnClick = BtnResetCameraClick
      end
    end
  end
  object TimerRender: TTimer
    Interval = 30
    OnTimer = TimerRenderTimer
    Left = 464
    Top = 24
  end
  object TimerPhysics: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerPhysicsTimer
    Left = 544
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*'
    Left = 632
    Top = 24
  end
end
