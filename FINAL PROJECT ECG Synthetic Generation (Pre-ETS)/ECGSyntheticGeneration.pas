unit ECGSyntheticGeneration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, Vcl.Grids, Math;

type
  TWaveIndex = 0..5; // for PQRST waves (T+ and T-)

  TForm1 = class(TForm)
    PageControl: TPageControl;
    BitBtn1: TBitBtn;
    TabStep1: TTabSheet;
    TabStep2: TTabSheet;
    TabStep3: TTabSheet;
    TabStep4: TTabSheet;
    TabStep5: TTabSheet;
    TabStep6: TTabSheet;
    TabStep7: TTabSheet;
    TabStep8: TTabSheet;
    TabStep9: TTabSheet;
    TabStep10: TTabSheet;
    btnClear: TButton;
    ChartStep1: TChart;
    Series1: TLineSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtF1: TEdit;
    edtF2: TEdit;
    edtC1: TEdit;
    edtC2: TEdit;
    edtRatio: TEdit;
    edtNumPoints: TEdit;
    edtMeanHR: TEdit;
    edtStdDevHR: TEdit;
    btnGenerateHRV: TButton;
    ChartStep2: TChart;
    Series2: TLineSeries;
    ChartStep3: TChart;
    Series3: TLineSeries;
    Series4: TLineSeries;
    ChartStep4: TChart;
    Series5: TLineSeries;
    ChartStep5: TChart;
    Series6: TLineSeries;
    Label9: TLabel;
    Label10: TLabel;
    edtRRMean: TEdit;
    edtRRScaling: TEdit;
    GridECGParams: TStringGrid;
    Label11: TLabel;
    edtSamplingFreq: TEdit;
    btnGenerateECG: TButton;
    ChartStep10: TChart;
    Series7: TLineSeries;
    ListBoxStep7: TListBox;
    ListBoxStep8: TListBox;
    ListBoxStep9: TListBox;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    pcScenarios: TPageControl;
    tsNormal: TTabSheet;
    tsStress: TTabSheet;
    tsRelaxed: TTabSheet;
    Label12: TLabel;
    edtNormalHR: TEdit;
    Label13: TLabel;
    edtNormalSTD: TEdit;
    Label14: TLabel;
    edtStressHR: TEdit;
    Label15: TLabel;
    edtStressSTD: TEdit;
    Label16: TLabel;
    edtRelaxedHR: TEdit;
    Label17: TLabel;
    edtRelaxedSTD: TEdit;
    cbAddNoise: TCheckBox;
    Label18: TLabel;
    edtNoiseAmp: TEdit;
    cbBaselineWander: TCheckBox;
    Label19: TLabel;
    edtWanderAmp: TEdit;
    Label20: TLabel;
    edtWanderFreq: TEdit;
    btnApplyScenario: TButton;
    gbHRVResults: TGroupBox;
    Label21: TLabel;
    edtSDNN: TEdit;
    Label22: TLabel;
    edtSDANN: TEdit;
    Label23: TLabel;
    edtRMSSD: TEdit;
    Label24: TLabel;
    edtNN50: TEdit;
    Label25: TLabel;
    edtpNN50: TEdit;
    cbApplyStepFunction: TCheckBox;
    Label26: TLabel;
    edtIntervalDuration: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnGenerateHRVClick(Sender: TObject);
    procedure btnGenerateECGClick(Sender: TObject);
    procedure btnApplyScenarioClick(Sender: TObject);
    procedure cbApplyStepFunctionClick(Sender: TObject);
  private
    { Private declarations }
    Nrr: Integer;
    hmean: Double;
    fecg: Double;
    current_rr_interval: Double;

    sf: array of Double;
    sw: array of Double;
    reall, imag: array of Double;
    idft_raw: array of Double;

    rr_continuous: array of Double;
    rr_final: array of Double;

    theta_i, a_i, b_i: array[TWaveIndex] of Double;

    procedure UpdateRRFinalPlot;

    function angfreq(t: Double): Double;
    function ddt(t, x, y, z: Double; trig: Integer): Double;
    function modulus(in1, in2: Double): Double;
    procedure RungeKutta4_ECG;
    procedure CalculateAndDisplayHRV;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  GridECGParams.ColCount := 4;
  GridECGParams.RowCount := 7;
  GridECGParams.Cells[1, 0] := 'Teta (degrees)';
  GridECGParams.Cells[2, 0] := 'Amplitude (a)';
  GridECGParams.Cells[3, 0] := 'Width (b)';
  GridECGParams.Cells[0, 1] := 'P';
  GridECGParams.Cells[0, 2] := 'Q';
  GridECGParams.Cells[0, 3] := 'R';
  GridECGParams.Cells[0, 4] := 'S';
  GridECGParams.Cells[0, 5] := 'T-';
  GridECGParams.Cells[0, 6] := 'T+';
  GridECGParams.Cells[1, 1] := FloatToStr(RadToDeg(-Pi / 3));
  GridECGParams.Cells[2, 1] := '0.8';
  GridECGParams.Cells[3, 1] := '0.2';
  GridECGParams.Cells[1, 2] := FloatToStr(RadToDeg(-Pi / 12));
  GridECGParams.Cells[2, 2] := '-5.0';
  GridECGParams.Cells[3, 2] := '0.1';
  GridECGParams.Cells[1, 3] := '0';
  GridECGParams.Cells[2, 3] := '30.0';
  GridECGParams.Cells[3, 3] := '0.1';
  GridECGParams.Cells[1, 4] := FloatToStr(RadToDeg(Pi / 12));
  GridECGParams.Cells[2, 4] := '-7.5';
  GridECGParams.Cells[3, 4] := '0.1';
  GridECGParams.Cells[1, 5] := FloatToStr(RadToDeg((5 * Pi / 9) - (Pi / 60)));
  GridECGParams.Cells[2, 5] := '0.5';
  GridECGParams.Cells[3, 5] := '0.4';
  GridECGParams.Cells[1, 6] := FloatToStr(RadToDeg(5 * Pi / 9));
  GridECGParams.Cells[2, 6] := '0.75';
  GridECGParams.Cells[3, 6] := '0.2';
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  ListBoxStep7.Clear;
  ListBoxStep8.Clear;
  ListBoxStep9.Clear;
  edtSDNN.Text := '';
  edtSDANN.Text := '';
  edtRMSSD.Text := '';
  edtNN50.Text := '';
  edtpNN50.Text := '';
  SetLength(sf, 0);
  SetLength(sw, 0);
  SetLength(reall, 0);
  SetLength(imag, 0);
  SetLength(idft_raw, 0);
  SetLength(rr_continuous, 0);
  SetLength(rr_final, 0);
  PageControl.ActivePageIndex := 0;
end;

procedure TForm1.btnApplyScenarioClick(Sender: TObject);
begin
  case pcScenarios.ActivePageIndex of
    0: begin // Normal HRV
      edtMeanHR.Text := edtNormalHR.Text;
      edtStdDevHR.Text := edtNormalSTD.Text;
    end;
    1: begin // Stress (Low HRV)
      edtMeanHR.Text := edtStressHR.Text;
      edtStdDevHR.Text := edtStressSTD.Text;
    end;
    2: begin // Relaxed (High HRV)
      edtMeanHR.Text := edtRelaxedHR.Text;
      edtStdDevHR.Text := edtRelaxedSTD.Text;
    end;
  end;
  btnGenerateHRVClick(nil);
  if Length(rr_final) > 0 then
  begin
    btnGenerateECGClick(nil);
    CalculateAndDisplayHRV;
  end;
end;

procedure TForm1.cbApplyStepFunctionClick(Sender: TObject);
begin
  if Length(rr_continuous) > 0 then
  begin
    UpdateRRFinalPlot;
  end;
end;

// Sets the low state of the signal to the mean value (baseline) instead of zero
// (a stagnant signal at the average RR interval)
procedure TForm1.UpdateRRFinalPlot;
var
  i, intervalDuration: Integer;
  // Variables to calculate the baseline
  sum_rr, mean_rr: Double;
begin
  if Length(rr_continuous) = 0 then Exit;

  SetLength(rr_final, Length(rr_continuous));

  // Read and validate the interval duration from the UI
  try
    intervalDuration := StrToInt(edtIntervalDuration.Text);
    if intervalDuration <= 0 then
      intervalDuration := High(Integer);
  except
    intervalDuration := High(Integer);
  end;

  // Pre-calculate the signal mean to use as baseline
  sum_rr := 0;
  for i := 0 to Length(rr_continuous) - 1 do
  begin
    sum_rr := sum_rr + rr_continuous[i];
  end;
  if Length(rr_continuous) > 0 then
    mean_rr := sum_rr / Length(rr_continuous)
  else
    mean_rr := 0;

  // Plotting Logic
  Series6.Clear;
  Series6.BeginUpdate;
  try
    for i := 0 to Length(rr_continuous) - 1 do
    begin
      var current_rr := rr_continuous[i];

      // If the checkbox is checked, apply the alternating block logic
      if cbApplyStepFunction.Checked then
      begin
        // Check if the current index falls into a "low" block (odd-numbered blocks)
        if (i div intervalDuration) mod 2 = 1 then
        begin
          // Set the value to the calculated mean (baseline)
          current_rr := mean_rr;
        end;
        // If it's an even block, 'current_rr' retains its original value.
      end;

      rr_final[i] := current_rr;
      Series6.AddXY(i, rr_final[i]);
    end;
  finally
    Series6.EndUpdate;
  end;
end;

procedure TForm1.btnGenerateHRVClick(Sender: TObject);
var
  i, k, n: Integer;
  f1, f2, c1, c2, ratio, hstd, magSf, f, rr_mean, rr_scaling: Double;
  tempReal, tempImag, angle: Double;
  sf1, sf2, random_phase: Double;
  target_std_dev_sec, raw_mean, raw_sum_sq_diff, raw_std_dev, scale_factor: Double;
begin
  try
    f1    := StrToFloat(edtF1.Text);
    f2    := StrToFloat(edtF2.Text);
    c1    := StrToFloat(edtC1.Text);
    c2    := StrToFloat(edtC2.Text);
    ratio := StrToFloat(edtRatio.Text);
    Nrr   := StrToInt(edtNumPoints.Text);
    hmean := StrToFloat(edtMeanHR.Text);
    hstd  := StrToFloat(edtStdDevHR.Text);
  except
    on E: Exception do begin
      ShowMessage('Error: Invalid parameters in Step 1. ' + E.Message);
      Exit;
    end;
  end;
  btnClearClick(nil);
  SetLength(sf, Nrr);
  SetLength(sw, Nrr);
  SetLength(reall, Nrr);
  SetLength(imag, Nrr);
  SetLength(idft_raw, Nrr);
  SetLength(rr_continuous, Nrr);

  magSf := 1.7 / Nrr;
  for i := 0 to Nrr - 1 do
  begin
    f := i * 1.0 / Nrr;
    sf1 := ratio * magSf * Exp(-Sqr(f - f1) / (2 * Sqr(c1))) / Sqrt(2 * Pi * Sqr(c1));
    sf2 := magSf * Exp(-Sqr(f - f2) / (2 * Sqr(c2))) / Sqrt(2 * Pi * Sqr(c2));
    sf[i] := sf1 + sf2;
    Series1.AddXY(f, sf[i]);
  end;
  for i := 0 to Round(Nrr / 2) - 1 do sw[i] := Sqrt(sf[i]);
  for i := Round(Nrr / 2) to Nrr - 1 do sw[i] := Sqrt(sf[Nrr - i]);
  for i := 0 to Nrr - 1 do Series2.AddXY(i * 1.0 / Nrr, sw[i]);
  for i := 0 to Nrr - 1 do
  begin
    random_phase := Random * 2 * Pi;
    reall[i] := sw[i] * Cos(random_phase);
    imag[i]  := sw[i] * Sin(random_phase);
    Series3.AddXY(i * 1.0 / Nrr, reall[i]);
    Series4.AddXY(i * 1.0 / Nrr, imag[i]);
  end;
  for n := 0 to Nrr - 1 do
  begin
    tempReal := 0; tempImag := 0;
    for k := 0 to Nrr - 1 do
    begin
      angle := 2 * Pi * k * n / Nrr;
      tempReal := tempReal + (reall[k] * Cos(angle) - imag[k] * Sin(angle));
      tempImag := tempImag + (reall[k] * Sin(angle) + imag[k] * Cos(angle));
    end;
    idft_raw[n] := tempReal / Nrr;
    Series5.AddXY(n, idft_raw[n]);
  end;

  raw_mean := 0;
  for i := 0 to Nrr - 1 do raw_mean := raw_mean + idft_raw[i];
  raw_mean := raw_mean / Nrr;
  raw_sum_sq_diff := 0;
  for i := 0 to Nrr - 1 do raw_sum_sq_diff := raw_sum_sq_diff + Sqr(idft_raw[i] - raw_mean);
  if (Nrr > 1) then raw_std_dev := Sqrt(raw_sum_sq_diff / (Nrr - 1)) else raw_std_dev := 0;
  target_std_dev_sec := hstd / 60.0;
  if raw_std_dev > 1E-9 then scale_factor := target_std_dev_sec / raw_std_dev else scale_factor := 0;
  rr_mean := 60.0 / hmean;
  edtRRMean.Text := FloatToStrF(rr_mean, ffFixed, 8, 4);
  edtRRScaling.Text := FloatToStrF(scale_factor, ffFixed, 8, 4);

  for i := 0 to Nrr - 1 do
  begin
    rr_continuous[i] := ((idft_raw[i] - raw_mean) * scale_factor) + rr_mean;
  end;

  UpdateRRFinalPlot;

  PageControl.ActivePageIndex := 5;
end;

procedure TForm1.btnGenerateECGClick(Sender: TObject);
var
  i: TWaveIndex;
  alpha: Double;
  base_theta, base_a, base_b: array[TWaveIndex] of Double;
const
  waveNames: array[TWaveIndex] of string = ('P', 'Q', 'R', 'S', 'T-', 'T+');
begin
  if Length(rr_final) = 0 then
  begin
    ShowMessage('Please generate Heart Rate Variability (Step 1-5) first.');
    Exit;
  end;
  Series7.Clear;
  ListBoxStep7.Clear;
  ListBoxStep8.Clear;
  ListBoxStep9.Clear;

  try
    fecg := StrToFloat(edtSamplingFreq.Text);
    if fecg <= 0 then raise Exception.Create('Sampling Frequency must be positive.');

    for i := Low(TWaveIndex) to High(TWaveIndex) do
    begin
      base_theta[i] := StrToFloat(GridECGParams.Cells[1, i + 1]);
      base_a[i]     := StrToFloat(GridECGParams.Cells[2, i + 1]);
      base_b[i]     := StrToFloat(GridECGParams.Cells[3, i + 1]);
    end;
  except
    on E: Exception do begin
      ShowMessage('Error: Invalid ECG parameters in Step 6. ' + E.Message);
      Exit;
    end;
  end;

  ListBoxStep7.Items.Add('### Modulation Factor α (alpha) Calculation ###');
  alpha := Sqrt(hmean / 60.0);
  ListBoxStep7.Items.Add(Format('Mean HR (hmean) = %.2f bpm', [hmean]));
  ListBoxStep7.Items.Add(Format('Modulation Factor α = sqrt(%.2f / 60) = %.4f', [hmean, alpha]));
  ListBoxStep7.Items.Add('');
  ListBoxStep7.Items.Add('\\\ Morphological Parameter Adjustment (using Grid values) \\\');
  ListBoxStep7.Items.Add(Format('%-5s | %-15s | %-15s | %-15s', ['Wave', 'Final Teta (rad)', 'Final Amplitude (a)', 'Final Width (b)']));
  ListBoxStep7.Items.Add(StringOfChar('-', 60));

  theta_i[0] := DegToRad(base_theta[0]) * Sqrt(alpha);
  a_i[0]     := base_a[0];
  b_i[0]     := base_b[0] * alpha;
  theta_i[1] := DegToRad(base_theta[1]) * alpha;
  a_i[1]     := base_a[1];
  b_i[1]     := base_b[1] * alpha;
  theta_i[2] := 0;
  a_i[2]     := base_a[2];
  b_i[2]     := base_b[2] * alpha;
  theta_i[3] := DegToRad(base_theta[3]) * alpha;
  a_i[3]     := base_a[3];
  b_i[3]     := base_b[3] * alpha;
  theta_i[4] := (DegToRad(base_theta[5]) * Sqrt(alpha)) - (DegToRad(base_theta[0])/20 * Sqrt(alpha));
  a_i[4]     := base_a[4] * Power(alpha, 2.5);
  b_i[4]     := base_b[4] / alpha;
  theta_i[5] := DegToRad(base_theta[5]) * Sqrt(alpha);
  a_i[5]     := base_a[5] * Power(alpha, 2.5);
  b_i[5]     := base_b[5] * alpha;

  for i := Low(TWaveIndex) to High(TWaveIndex) do
  begin
    ListBoxStep7.Items.Add(Format('%-5s | %-15.4f | %-15.4f | %-15.4f',
      [waveNames[i], theta_i[i], a_i[i], b_i[i]]));
  end;

  ListBoxStep8.Items.Add('### Angular Velocity Concept (ω(t)) ###');
  ListBoxStep8.Items.Add('The model''s circular motion speed is determined by the RR interval.');
  ListBoxStep8.Items.Add('Shorter RR intervals (faster heart rate) result in higher ω(t).');
  ListBoxStep8.Items.Add('Formula: ω(t) = 2 * π / T(t), where T(t) is the RR interval at time t.');
  ListBoxStep8.Items.Add('The logic now correctly updates this value for each beat.');

  ListBoxStep9.Items.Add('### Ordinary Differential Equation (ODE) System ###');
  ListBoxStep9.Items.Add('This model uses 3 equations to describe the trajectory (x,y,z) in 3D space.');
  ListBoxStep9.Items.Add('The ECG output is the projection of this trajectory onto the z-axis.');
  ListBoxStep9.Items.Add('Equations: ẋ = α*x - ω*y, ẏ = α*y + ω*x, ż = ...');
  ListBoxStep9.Items.Add('The ż equation creates P,Q,R,S,T-,T+ peaks as the angle (θ) nears each wave''s angle (θᵢ).');

  RungeKutta4_ECG;
  PageControl.ActivePageIndex := 9;
end;

procedure TForm1.CalculateAndDisplayHRV;
var
  i, nn50_count, end_j: Integer;
  sum, mean, sum_sq_diff, sdnn, rmssd, diff, sdann: Double;
  segment_averages: array of Double;
  segment_sum: Double;
  segment_count, segment_length, j: Integer;
  total_duration: Double;
  warning_msg: string;
begin
  if Length(rr_final) < 2 then
  begin
    edtSDNN.Text  := 'N/A';
    edtSDANN.Text := 'N/A';
    edtRMSSD.Text := 'N/A';
    edtNN50.Text  := 'N/A';
    edtpNN50.Text := 'N/A';
    Exit;
  end;

  total_duration := 0;
  for i := 0 to Length(rr_final) - 1 do
    total_duration := total_duration + rr_final[i];

  if total_duration < 300 then
    warning_msg := ' (< 5 min, for reference only)'
  else
    warning_msg := '';

  sum := 0;
  for i := 0 to Length(rr_final) - 1 do
    sum := sum + rr_final[i];
  mean := sum / Length(rr_final);

  sum_sq_diff := 0;
  for i := 0 to Length(rr_final) - 1 do
    sum_sq_diff := sum_sq_diff + Sqr(rr_final[i] - mean);
  sdnn := Sqrt(sum_sq_diff / (Length(rr_final) - 1));

  sum_sq_diff := 0;
  nn50_count := 0;
  for i := 1 to Length(rr_final) - 1 do
  begin
    diff := rr_final[i] - rr_final[i-1];
    sum_sq_diff := sum_sq_diff + Sqr(diff);
    if Abs(diff) * 1000 > 50 then
      Inc(nn50_count);
  end;
  rmssd := Sqrt(sum_sq_diff / (Length(rr_final) - 1));

  if hmean > 0 then
    segment_length := Round(60 / (60 / hmean))
  else
    segment_length := 60;

  if segment_length > 0 then
    segment_count := Length(rr_final) div segment_length
  else
    segment_count := 0;

  if (segment_count > 1) then
  begin
    SetLength(segment_averages, segment_count);
    for i := 0 to segment_count - 1 do
    begin
      segment_sum := 0;
      end_j := Min(segment_length - 1, Length(rr_final) - (i * segment_length) - 1);
      for j := 0 to end_j do
        segment_sum := segment_sum + rr_final[i * segment_length + j];
      if end_j > -1 then
        segment_averages[i] := segment_sum / (end_j + 1);
    end;

    sum := 0;
    for i := 0 to segment_count - 1 do sum := sum + segment_averages[i];
    mean := sum / segment_count;
    sum_sq_diff := 0;
    for i := 0 to segment_count - 1 do sum_sq_diff := sum_sq_diff + Sqr(segment_averages[i] - mean);
    sdann := Sqrt(sum_sq_diff / (segment_count - 1));
    edtSDANN.Text := FloatToStrF(sdann * 1000, ffFixed, 8, 2) + warning_msg;
  end
  else
  begin
    edtSDANN.Text := 'N/A (not enough data)';
  end;

  edtSDNN.Text := FloatToStrF(sdnn * 1000, ffFixed, 8, 2) + warning_msg;
  edtRMSSD.Text := FloatToStrF(rmssd * 1000, ffFixed, 8, 2);
  edtNN50.Text := IntToStr(nn50_count);
  if Length(rr_final) > 1 then
    edtpNN50.Text := FloatToStrF((nn50_count / (Length(rr_final) - 1)) * 100, ffFixed, 8, 2)
  else
    edtpNN50.Text := 'N/A';
end;

function TForm1.angfreq(t: Double): Double;
begin
  if (current_rr_interval > 1E-9) then
    Result := 2.0 * Pi / current_rr_interval
  else
    Result := 2.0 * Pi / (60.0 / hmean);
end;

function TForm1.modulus(in1, in2: Double): Double;
begin
  Result := fmod(in1, in2);
  if Result < 0 then
    Result := Result + in2;
end;

function TForm1.ddt(t, x, y, z: Double; trig: Integer): Double;
var
  alpha, teta, delta_teta, z_sum, z_base: Double;
  i: TWaveIndex;
  wander_amp, wander_freq: Double;
begin
  alpha := 1.0 - Sqrt(Sqr(x) + Sqr(y));
  case trig of
    1: Result := alpha * x - angfreq(t) * y;
    2: Result := alpha * y + angfreq(t) * x;
    3: begin
      teta := ArcTan2(y, x);
      z_sum := 0;
      for i := Low(TWaveIndex) to High(TWaveIndex) do
      begin
        delta_teta := modulus(teta - theta_i[i], 2 * Pi);
        if delta_teta > Pi then
          delta_teta := delta_teta - 2 * Pi;
        z_sum := z_sum - a_i[i] * delta_teta * Exp(-0.5 * Sqr(delta_teta) / Sqr(b_i[i]));
      end;

      if cbBaselineWander.Checked then
      begin
        try
          wander_amp := StrToFloat(edtWanderAmp.Text);
          wander_freq := StrToFloat(edtWanderFreq.Text);
          z_base := wander_amp * Sin(2 * Pi * wander_freq * t);
        except
          z_base := 0.0;
        end;
      end else
        z_base := 0.0;
      Result := z_sum - (z - z_base);
    end
  else
    Result := 0;
  end;
end;

procedure TForm1.RungeKutta4_ECG;
var
  i: Integer;
  t, dt: Double;
  x, y, z: Double;
  k1x, k1y, k1z, k2x, k2y, k2z, k3x, k3y, k3z, k4x, k4y, k4z: Double;
  noise, noise_amp: Double;
  beat_index: Integer;
  time_of_next_beat: Double;
begin
  dt := 1.0 / fecg;
  x := 1.0; y := 0.0; z := 0.04;
  t := 0.0;
  beat_index := 0;
  if Length(rr_final) > 0 then
  begin
    time_of_next_beat := rr_final[0];
    current_rr_interval := rr_final[0];
  end else begin
    time_of_next_beat := 60.0 / hmean;
    current_rr_interval := 60.0 / hmean;
  end;

  if cbAddNoise.Checked then try
      noise_amp := StrToFloat(edtNoiseAmp.Text);
    except
      noise_amp := 0.0;
    end
  else
    noise_amp := 0.0;

  Series7.BeginUpdate;
  try
    for i := 0 to Round(Nrr) do
    begin
      if t >= time_of_next_beat then
      begin
        Inc(beat_index);
        if beat_index < Length(rr_final) then
        begin
          time_of_next_beat := time_of_next_beat + rr_final[beat_index];
          current_rr_interval := rr_final[beat_index];
        end
        else
        begin
          if Length(rr_final) > 0 then
            current_rr_interval := rr_final[Length(rr_final) - 1];
        end;
      end;

      k1x := ddt(t, x, y, z, 1);
      k1y := ddt(t, x, y, z, 2);
      k1z := ddt(t, x, y, z, 3);
      k2x := ddt(t + 0.5*dt, x + 0.5*k1x*dt, y + 0.5*k1y*dt, z + 0.5*k1z*dt, 1);
      k2y := ddt(t + 0.5*dt, x + 0.5*k1x*dt, y + 0.5*k1y*dt, z + 0.5*k1z*dt, 2);
      k2z := ddt(t + 0.5*dt, x + 0.5*k1x*dt, y + 0.5*k1y*dt, z + 0.5*k1z*dt, 3);
      k3x := ddt(t + 0.5*dt, x + 0.5*k2x*dt, y + 0.5*k2y*dt, z + 0.5*k2z*dt, 1);
      k3y := ddt(t + 0.5*dt, x + 0.5*k2x*dt, y + 0.5*k2y*dt, z + 0.5*k2z*dt, 2);
      k3z := ddt(t + 0.5*dt, x + 0.5*k2x*dt, y + 0.5*k2y*dt, z + 0.5*k2z*dt, 3);
      k4x := ddt(t + dt, x + k3x*dt, y + k3y*dt, z + k3z*dt, 1);
      k4y := ddt(t + dt, x + k3x*dt, y + k3y*dt, z + k3z*dt, 2);
      k4z := ddt(t + dt, x + k3x*dt, y + k3y*dt, z + k3z*dt, 3);
      x := x + (dt / 6.0) * (k1x + 2*k2x + 2*k3x + k4x);
      y := y + (dt / 6.0) * (k1y + 2*k2y + 2*k3y + k4y);
      z := z + (dt / 6.0) * (k1z + 2*k2z + 2*k3z + k4z);

      if cbAddNoise.Checked then
      begin
        noise := (Random * 2 - 1) * noise_amp;
        z := z + noise;
      end;
      Series7.AddXY(t, z);
      t := t + dt;
    end;
  finally
    Series7.EndUpdate;
  end;
end;

end.
