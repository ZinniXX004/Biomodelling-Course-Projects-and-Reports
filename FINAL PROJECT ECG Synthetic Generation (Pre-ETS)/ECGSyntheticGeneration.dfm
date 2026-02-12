object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ECG Synthetic - Jemi (5023231017)'
  ClientHeight = 1067
  ClientWidth = 1484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 1484
    Height = 1067
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1478
    ExplicitHeight = 1050
    object PageControl: TPageControl
      Left = 8
      Top = 8
      Width = 1124
      Height = 633
      ActivePage = TabStep1
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
      object TabStep1: TTabSheet
        Caption = '1. Power Spectrum'
        object Label1: TLabel
          Left = 16
          Top = 416
          Width = 132
          Height = 15
          Caption = 'f1 (Mayer Frequency, Hz)'
        end
        object Label2: TLabel
          Left = 184
          Top = 416
          Width = 120
          Height = 15
          Caption = 'f2 (RSA Frequency, Hz)'
        end
        object Label3: TLabel
          Left = 384
          Top = 416
          Width = 91
          Height = 15
          Caption = 'c1 (Mayer Width)'
        end
        object Label4: TLabel
          Left = 568
          Top = 416
          Width = 79
          Height = 15
          Caption = 'c2 (RSA Width)'
        end
        object Label5: TLabel
          Left = 48
          Top = 488
          Width = 62
          Height = 15
          Caption = 'LF/HF Ratio'
        end
        object Label6: TLabel
          Left = 184
          Top = 488
          Width = 125
          Height = 15
          Caption = ' Number of Points (Nrr)'
        end
        object Label7: TLabel
          Left = 368
          Top = 488
          Width = 124
          Height = 15
          Caption = 'Mean Heart Rate (bpm)'
        end
        object Label8: TLabel
          Left = 560
          Top = 488
          Width = 98
          Height = 15
          Caption = 'Std Dev Heart Rate'
        end
        object ChartStep1: TChart
          Left = 0
          Top = 3
          Width = 825
          Height = 390
          Title.Font.Color = clYellow
          Title.Font.Name = 'Arial Black'
          Title.Text.Strings = (
            'Mayer and RSA Waves')
          BottomAxis.LabelsFormat.Font.Color = clYellow
          BottomAxis.Title.Caption = 'Frequency (Hz)'
          BottomAxis.Title.Font.Color = clYellow
          LeftAxis.LabelsFormat.Font.Color = clYellow
          LeftAxis.Title.Caption = 'Power'
          LeftAxis.Title.Font.Color = clYellow
          View3D = False
          Color = 8421440
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series1: TLineSeries
            HoverElement = [heCurrent]
            SeriesColor = 65408
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
        object edtF1: TEdit
          Left = 16
          Top = 437
          Width = 132
          Height = 23
          TabOrder = 1
          Text = '0.1'
        end
        object edtF2: TEdit
          Left = 177
          Top = 437
          Width = 132
          Height = 23
          TabOrder = 2
          Text = '0.25'
        end
        object edtC1: TEdit
          Left = 368
          Top = 437
          Width = 127
          Height = 23
          TabOrder = 3
          Text = '0.01'
        end
        object edtC2: TEdit
          Left = 544
          Top = 437
          Width = 127
          Height = 23
          TabOrder = 4
          Text = '0.01'
        end
        object edtRatio: TEdit
          Left = 16
          Top = 509
          Width = 132
          Height = 23
          TabOrder = 5
          Text = '0.5'
        end
        object edtNumPoints: TEdit
          Left = 177
          Top = 509
          Width = 132
          Height = 23
          TabOrder = 6
          Text = '2560'
        end
        object edtMeanHR: TEdit
          Left = 368
          Top = 509
          Width = 124
          Height = 23
          TabOrder = 7
          Text = '60'
        end
        object edtStdDevHR: TEdit
          Left = 544
          Top = 509
          Width = 127
          Height = 23
          TabOrder = 8
          Text = '1'
        end
        object btnGenerateHRV: TButton
          Left = 840
          Top = 3
          Width = 265
          Height = 597
          Caption = 'Generate HRV'#13#10'(Steps 1-5)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = btnGenerateHRVClick
        end
      end
      object TabStep2: TTabSheet
        Caption = '2. Power Spectrum (Mirrored)'
        ImageIndex = 1
        object ChartStep2: TChart
          Left = 16
          Top = 24
          Width = 1081
          Height = 545
          Title.Font.Name = 'Arial Black'
          Title.Text.Strings = (
            'Mirroring and Square Root (Sf(f))')
          BottomAxis.LabelsFormat.Font.Color = clBlue
          BottomAxis.Title.Caption = 'Frequency (Hz)'
          BottomAxis.Title.Font.Color = clBlue
          LeftAxis.LabelsFormat.Font.Color = clBlue
          LeftAxis.Title.Caption = 'Power'
          LeftAxis.Title.Font.Color = clBlue
          View3D = False
          Color = clYellow
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series2: TLineSeries
            HoverElement = [heCurrent]
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
      object TabStep3: TTabSheet
        Caption = '3. Complex Spectrum'
        ImageIndex = 2
        object ChartStep3: TChart
          Left = 16
          Top = 16
          Width = 1081
          Height = 569
          Legend.CheckBoxes = True
          Title.Font.Color = 8388672
          Title.Font.Name = 'Arial Black'
          Title.Text.Strings = (
            'Random Phase Distributed between 0 - 1 Hz')
          BottomAxis.LabelsFormat.Font.Color = 8388672
          BottomAxis.Title.Caption = 'Frequency (Hz)'
          BottomAxis.Title.Font.Color = 8388672
          LeftAxis.LabelsFormat.Font.Color = 8388672
          LeftAxis.Title.Caption = 'Power'
          LeftAxis.Title.Font.Color = 8388672
          View3D = False
          Color = clAqua
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series3: TLineSeries
            HoverElement = [heCurrent]
            SeriesColor = clRed
            Title = 'Real'
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
            SeriesColor = clPurple
            Title = 'Imaginary'
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
      object TabStep4: TTabSheet
        Caption = '4. Raw RR Tachogram (IDFT)'
        ImageIndex = 3
        object ChartStep4: TChart
          Left = 16
          Top = 16
          Width = 1081
          Height = 569
          Title.Font.Color = 8421440
          Title.Font.Name = 'Arial Black'
          Title.Text.Strings = (
            'RR Tachogram')
          BottomAxis.LabelsFormat.Font.Color = clTeal
          BottomAxis.Title.Caption = 'Sample (n)'
          BottomAxis.Title.Font.Color = clTeal
          LeftAxis.LabelsFormat.Font.Color = clTeal
          LeftAxis.Title.Caption = 'R-R Intervals'
          LeftAxis.Title.Font.Color = clTeal
          View3D = False
          Color = 4227327
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series5: TLineSeries
            HoverElement = [heCurrent]
            SeriesColor = clBlue
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
      object TabStep5: TTabSheet
        Caption = '5. Final RR Tachogram'
        ImageIndex = 4
        object Label9: TLabel
          Left = 960
          Top = 16
          Width = 90
          Height = 15
          Caption = 'RR Mean (Offset)'
        end
        object Label10: TLabel
          Left = 944
          Top = 88
          Width = 106
          Height = 15
          Caption = 'RR Std Dev (Scaling)'
        end
        object Label26: TLabel
          Left = 959
          Top = 248
          Width = 91
          Height = 15
          Caption = 'Interval Duration:'
        end
        object ChartStep5: TChart
          Left = 16
          Top = 16
          Width = 857
          Height = 569
          Title.Font.Color = clAqua
          Title.Font.Name = 'Arial Black'
          Title.Text.Strings = (
            'RR Tachogram (Final)')
          BottomAxis.LabelsFormat.Font.Color = clAqua
          BottomAxis.Title.Caption = 'Sample (n)'
          BottomAxis.Title.Font.Color = clAqua
          LeftAxis.LabelsFormat.Font.Color = clAqua
          LeftAxis.Title.Caption = 'R-R Interval'
          LeftAxis.Title.Font.Color = clAqua
          View3D = False
          Color = 12615808
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series6: TLineSeries
            HoverElement = [heCurrent]
            SeriesColor = clYellow
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
        object edtRRMean: TEdit
          Left = 938
          Top = 37
          Width = 127
          Height = 23
          TabOrder = 1
          Text = '1'
        end
        object edtRRScaling: TEdit
          Left = 938
          Top = 109
          Width = 127
          Height = 23
          TabOrder = 2
          Text = '2'
        end
        object cbApplyStepFunction: TCheckBox
          Left = 938
          Top = 184
          Width = 127
          Height = 17
          Caption = 'Apply Step Function'
          TabOrder = 3
          OnClick = cbApplyStepFunctionClick
        end
        object edtIntervalDuration: TEdit
          Left = 944
          Top = 269
          Width = 121
          Height = 23
          TabOrder = 4
          Text = '100'
        end
      end
      object TabStep6: TTabSheet
        Caption = '6. ECG Parameters'
        DoubleBuffered = False
        ImageIndex = 5
        ParentDoubleBuffered = False
        object Label11: TLabel
          Left = 696
          Top = 32
          Width = 162
          Height = 15
          Caption = 'Sampling Frequency (fecg, Hz)'
        end
        object GridECGParams: TStringGrid
          Left = 24
          Top = 16
          Width = 617
          Height = 561
          BevelInner = bvNone
          BevelOuter = bvNone
          BevelWidth = 4
          Color = clYellow
          ColCount = 4
          DefaultColWidth = 150
          DefaultColAlignment = taCenter
          DefaultRowHeight = 76
          DoubleBuffered = False
          FixedColor = clBlue
          RowCount = 7
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          GradientEndColor = 16777088
          GradientStartColor = clAqua
          GridLineWidth = 4
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedColClick, goFixedRowClick, goFixedRowDefAlign]
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 0
        end
        object edtSamplingFreq: TEdit
          Left = 696
          Top = 53
          Width = 162
          Height = 23
          TabOrder = 1
          Text = '256'
        end
        object btnGenerateECG: TButton
          Left = 664
          Top = 90
          Width = 409
          Height = 463
          Caption = 'Generate ECG Signal (Steps 6-10)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = '1'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btnGenerateECGClick
        end
      end
      object TabStep7: TTabSheet
        Caption = '7. Modulation'
        ImageIndex = 6
        object ListBoxStep7: TListBox
          Left = 0
          Top = 0
          Width = 1116
          Height = 603
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object TabStep8: TTabSheet
        Caption = '8. Angular Velocity'
        ImageIndex = 7
        object ListBoxStep8: TListBox
          Left = 0
          Top = 0
          Width = 1116
          Height = 603
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object TabStep9: TTabSheet
        Caption = '9. ODE System'
        ImageIndex = 8
        object ListBoxStep9: TListBox
          Left = 0
          Top = 0
          Width = 1116
          Height = 603
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object TabStep10: TTabSheet
        Caption = '10. Final ECG Result'
        ImageIndex = 9
        object ChartStep10: TChart
          Left = 24
          Top = 16
          Width = 1073
          Height = 569
          Title.Font.Color = clLime
          Title.Font.Name = 'Arial Black'
          Title.Text.Strings = (
            'Final ECG Synthetic Result')
          BottomAxis.LabelsFormat.Font.Color = clLime
          BottomAxis.Title.Caption = 'Time (s)'
          BottomAxis.Title.Font.Color = clLime
          LeftAxis.LabelsFormat.Font.Color = clLime
          LeftAxis.Title.Caption = 'Amplitude (mV)'
          LeftAxis.Title.Font.Color = clLime
          View3D = False
          Color = clPurple
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object Series7: TLineSeries
            HoverElement = [heCurrent]
            SeriesColor = clYellow
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
    end
    object GroupBox1: TGroupBox
      Left = 12
      Top = 695
      Width = 1120
      Height = 354
      Caption = 'Scenario Generation and Realism'
      TabOrder = 1
      object Label18: TLabel
        Left = 523
        Top = 115
        Width = 88
        Height = 15
        Caption = 'Noise Amp (mV)'
      end
      object Label19: TLabel
        Left = 523
        Top = 165
        Width = 99
        Height = 15
        Caption = 'Wander Amp (mV)'
      end
      object Label20: TLabel
        Left = 525
        Top = 215
        Width = 92
        Height = 15
        Caption = 'Wander Freq (Hz)'
      end
      object pcScenarios: TPageControl
        Left = 16
        Top = 24
        Width = 459
        Height = 257
        ActivePage = tsRelaxed
        TabOrder = 0
        object tsNormal: TTabSheet
          Caption = 'Normal HRV'
          object Label12: TLabel
            Left = 56
            Top = 16
            Width = 85
            Height = 15
            Caption = 'Mean HR (bpm)'
          end
          object Label13: TLabel
            Left = 280
            Top = 16
            Width = 95
            Height = 15
            Caption = 'Std Dev HR (bpm)'
          end
          object edtNormalHR: TEdit
            Left = 40
            Top = 37
            Width = 121
            Height = 23
            TabOrder = 0
            Text = '60'
          end
          object edtNormalSTD: TEdit
            Left = 264
            Top = 37
            Width = 121
            Height = 23
            TabOrder = 1
            Text = '5'
          end
        end
        object tsStress: TTabSheet
          Caption = 'Stress (Low HRV)'
          ImageIndex = 1
          object Label14: TLabel
            Left = 52
            Top = 19
            Width = 85
            Height = 15
            Caption = 'Mean HR (bpm)'
          end
          object Label15: TLabel
            Left = 272
            Top = 19
            Width = 95
            Height = 15
            Caption = 'Std Dev HR (bpm)'
          end
          object edtStressHR: TEdit
            Left = 36
            Top = 40
            Width = 121
            Height = 23
            TabOrder = 0
            Text = '80'
          end
          object edtStressSTD: TEdit
            Left = 256
            Top = 40
            Width = 121
            Height = 23
            TabOrder = 1
            Text = '2'
          end
        end
        object tsRelaxed: TTabSheet
          Caption = 'Relaxed (High HRV)'
          ImageIndex = 2
          object Label16: TLabel
            Left = 56
            Top = 16
            Width = 85
            Height = 15
            Caption = 'Mean HR (bpm)'
          end
          object Label17: TLabel
            Left = 272
            Top = 16
            Width = 95
            Height = 15
            Caption = 'Std Dev HR (bpm)'
          end
          object edtRelaxedHR: TEdit
            Left = 40
            Top = 37
            Width = 121
            Height = 23
            TabOrder = 0
            Text = '55'
          end
          object edtRelaxedSTD: TEdit
            Left = 254
            Top = 37
            Width = 121
            Height = 23
            TabOrder = 1
            Text = '8'
          end
        end
      end
      object cbAddNoise: TCheckBox
        Left = 512
        Top = 56
        Width = 97
        Height = 17
        Caption = 'Add Noise'
        TabOrder = 1
      end
      object edtNoiseAmp: TEdit
        Left = 512
        Top = 136
        Width = 121
        Height = 23
        TabOrder = 2
        Text = '0.025'
      end
      object cbBaselineWander: TCheckBox
        Left = 512
        Top = 80
        Width = 135
        Height = 17
        Caption = 'Add Baseline Wander'
        TabOrder = 3
      end
      object edtWanderAmp: TEdit
        Left = 512
        Top = 186
        Width = 121
        Height = 23
        TabOrder = 4
        Text = '0.05'
      end
      object edtWanderFreq: TEdit
        Left = 512
        Top = 236
        Width = 121
        Height = 23
        TabOrder = 5
        Text = '0.1'
      end
      object btnApplyScenario: TButton
        Left = 16
        Top = 296
        Width = 1089
        Height = 49
        Caption = 'Apply Scenario and Generate Full ECG'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = btnApplyScenarioClick
      end
      object gbHRVResults: TGroupBox
        Left = 664
        Top = 24
        Width = 441
        Height = 257
        Caption = 'HRV Time-Domain Analysis Results'
        TabOrder = 7
        object Label21: TLabel
          Left = 72
          Top = 32
          Width = 59
          Height = 15
          Caption = 'SDNN (ms)'
        end
        object Label22: TLabel
          Left = 312
          Top = 32
          Width = 67
          Height = 15
          Caption = 'SDANN (ms)'
        end
        object Label23: TLabel
          Left = 192
          Top = 99
          Width = 65
          Height = 15
          Caption = 'RMSSD (ms)'
        end
        object Label24: TLabel
          Left = 72
          Top = 171
          Width = 66
          Height = 15
          Caption = 'NN50 Count'
        end
        object Label25: TLabel
          Left = 319
          Top = 171
          Width = 58
          Height = 15
          Caption = 'pNN50 (%)'
        end
        object edtSDNN: TEdit
          Left = 40
          Top = 53
          Width = 121
          Height = 23
          ReadOnly = True
          TabOrder = 0
        end
        object edtSDANN: TEdit
          Left = 280
          Top = 53
          Width = 121
          Height = 23
          ReadOnly = True
          TabOrder = 1
        end
        object edtRMSSD: TEdit
          Left = 161
          Top = 120
          Width = 121
          Height = 23
          ReadOnly = True
          TabOrder = 2
        end
        object edtNN50: TEdit
          Left = 40
          Top = 192
          Width = 121
          Height = 23
          ReadOnly = True
          TabOrder = 3
        end
        object edtpNN50: TEdit
          Left = 280
          Top = 192
          Width = 121
          Height = 23
          ReadOnly = True
          TabOrder = 4
        end
      end
    end
    object BitBtn1: TBitBtn
      Left = 1138
      Top = 8
      Width = 119
      Height = 1041
      Caption = '&EXIT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Kind = bkClose
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object btnClear: TButton
      Left = 8
      Top = 648
      Width = 1124
      Height = 41
      Caption = 'CLEAR ALL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnClearClick
    end
  end
end
