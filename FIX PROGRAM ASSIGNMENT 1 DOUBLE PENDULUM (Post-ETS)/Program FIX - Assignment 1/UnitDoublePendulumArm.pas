unit UnitDoublePendulumArm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.Buttons, VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls,
  VCLTee.TeeProcs, VCLTee.Chart, opengl, math, Equation, Vcl.Imaging.jpeg;

type
  TFormDoublePendulumArm = class(TForm)
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    ChartElbow: TChart;
    SeriesElbow: TLineSeries;
    ChartShoulder: TChart;
    SeriesShoulder: TLineSeries;
    LabelInit1: TLabel;
    LabelInit2: TLabel;
    LabelPitch: TLabel;
    LabelRoll: TLabel;
    LabelYaw: TLabel;
    PanelControl: TPanel;
    LabelOut1: TLabel;
    LabelOut2: TLabel;
    LabelOut3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    rgTest: TRadioGroup;
    edOut1: TEdit;
    edOut2: TEdit;
    edOut3: TEdit;
    GroupBoxShoulder: TGroupBox;
    LabelShK1: TLabel;
    LabelShK2: TLabel;
    LabelShK3: TLabel;
    LabelShK4: TLabel;
    LabelShT1: TLabel;
    LabelShT2: TLabel;
    edShK1: TEdit;
    edShK2: TEdit;
    edShK3: TEdit;
    edShK4: TEdit;
    edShTheta1: TEdit;
    edShTheta2: TEdit;
    GroupBoxElbow: TGroupBox;
    LabelElK1: TLabel;
    LabelElK2: TLabel;
    LabelElK3: TLabel;
    LabelElK4: TLabel;
    LabelElT1: TLabel;
    LabelElT2: TLabel;
    edElK1: TEdit;
    edElK2: TEdit;
    edElK3: TEdit;
    edElK4: TEdit;
    edElTheta1: TEdit;
    edElTheta2: TEdit;
    edTheta1Init: TEdit;
    edTheta2Init: TEdit;
    BitBtnMotionEq: TBitBtn;
    btnEqFig: TButton;
    PanelGL: TPanel;
    sePitch: TSpinEdit;
    seRoll: TSpinEdit;
    seYaw: TSpinEdit;

    // --- Prosedur Event ---
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PanelGLResize(Sender: TObject);

    procedure seYawChange(Sender: TObject);
    procedure sePitchChange(Sender: TObject);
    procedure seRollChange(Sender: TObject);

    procedure rgTestClick(Sender: TObject);

    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtnMotionEqClick(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
    procedure btnEqFigClick(Sender: TObject);

  private
    { Private declarations }
    myDC : HDC;
    myRC : HGLRC;

    // Variabel Font
    fontBase: GLuint;

    procedure SetupPixelFormat;
    procedure RenderScene;
    procedure UpdateAxis;

    // Helper Drawing & Text Procedures
    procedure BuildFont;
    procedure KillFont;
    procedure glPrint(const Text: string);
    procedure DrawAxesWithLabels(Length: Single);
    procedure DrawCube(SizeX, SizeY, SizeZ: Single);

    function ReadE(const E: TEdit; const DefaultVal: Extended): Extended;

    // Perhitungan Fisika
    procedure ComputeJointParams(
      const k1,k2,k3,k4, thMin, thMax, thInit: Extended;
      out offsetDeg, ampDeg, omega, damp, phi: Extended
    );

  public
    { Public declarations }
  end;

const
  // Material Matte (Kulit)
  mat_specular : array [0..3] of GLfloat = ( 0.1, 0.1, 0.1, 1.0 );
  mat_shininess : GLfloat = 5.0;
  light_position : array [0..3] of GLfloat = ( 50.0, 50.0, 50.0, 1.0 );
  DisplayRange = 10;

var
  FormDoublePendulumArm: TFormDoublePendulumArm;

  // Kamera
  pitch,yaw,roll: real;
  xpos,ypos,zpos: real;

  // Quadrics
  Sphere,cylinder: GLUquadricObj;

  // Fisika & Waktu
  time, dt: extended;

  // Sudut (dalam Radian untuk Render)
  teta1, teta2: extended;

  // Animasi Jari
  rotangle1, rotangle2, rotangle3: real;

  // Status visual
  upperlimb: boolean;

  // Parameter Init
  theta1_init_deg, theta2_init_deg: Extended;

  // Phase Shift
  phi_shoulder, phi_elbow: Extended;

  // Antropometri
  l1, l2: Extended;

implementation

{$R *.dfm}

procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;

// --- Helper Functions ---

function TFormDoublePendulumArm.ReadE(const E: TEdit; const DefaultVal: Extended): Extended;
begin
  try
    Result := StrToFloat(StringReplace(E.Text, ',', '.', [rfReplaceAll]));
  except
    Result := DefaultVal;
  end;
end;

// --- FONT HANDLING (Safe from Overflow) ---
procedure TFormDoublePendulumArm.BuildFont;
var
  font: HFONT;
begin
  fontBase := glGenLists(96);
  font := CreateFont(-14, 0, 0, 0, FW_BOLD, 0, 0, 0, ANSI_CHARSET,
      OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY,
      FF_DONTCARE or DEFAULT_PITCH, 'Segoe UI');

  SelectObject(myDC, font);
  wglUseFontBitmaps(myDC, 32, 96, fontBase);
end;

procedure TFormDoublePendulumArm.KillFont;
begin
  glDeleteLists(fontBase, 96);
end;

procedure TFormDoublePendulumArm.glPrint(const Text: string);
begin
  if (Text = '') or (fontBase = 0) then Exit;

  glPushAttrib(GL_LIST_BIT);
  {$Q-} // Matikan overflow checking untuk pointer aritmatik
  glListBase(fontBase - 32);
  {$Q+}
  glCallLists(Length(Text), GL_UNSIGNED_BYTE, PAnsiChar(AnsiString(Text)));
  glPopAttrib;
end;

// --- DRAWING HELPERS ---

// Helper: Menggambar Kubus
procedure TFormDoublePendulumArm.DrawCube(SizeX, SizeY, SizeZ: Single);
var
  hx, hy, hz: Single;
begin
  hx := SizeX * 0.5;
  hy := SizeY * 0.5;
  hz := SizeZ * 0.5;

  glBegin(GL_QUADS);
    glNormal3f(0.0, 0.0, 1.0); glVertex3f(-hx, -hy,  hz); glVertex3f( hx, -hy,  hz); glVertex3f( hx,  hy,  hz); glVertex3f(-hx,  hy,  hz);
    glNormal3f(0.0, 0.0, -1.0); glVertex3f(-hx, -hy, -hz); glVertex3f(-hx,  hy, -hz); glVertex3f( hx,  hy, -hz); glVertex3f( hx, -hy, -hz);
    glNormal3f(0.0, 1.0, 0.0); glVertex3f(-hx,  hy, -hz); glVertex3f(-hx,  hy,  hz); glVertex3f( hx,  hy,  hz); glVertex3f( hx,  hy, -hz);
    glNormal3f(0.0, -1.0, 0.0); glVertex3f(-hx, -hy, -hz); glVertex3f( hx, -hy, -hz); glVertex3f( hx, -hy,  hz); glVertex3f(-hx, -hy,  hz);
    glNormal3f(1.0, 0.0, 0.0); glVertex3f( hx, -hy, -hz); glVertex3f( hx,  hy, -hz); glVertex3f( hx,  hy,  hz); glVertex3f( hx, -hy,  hz);
    glNormal3f(-1.0, 0.0, 0.0); glVertex3f(-hx, -hy, -hz); glVertex3f(-hx, -hy,  hz); glVertex3f(-hx,  hy,  hz); glVertex3f(-hx,  hy, -hz);
  glEnd;
end;

// Helper: Menggambar Sumbu XYZ + Label
{procedure TFormDoublePendulumArm.DrawAxesWithLabels(Length: Single);
begin
  glDisable(GL_LIGHTING);
  glLineWidth(2.0);

  glBegin(GL_LINES);
    // Pitch (X) - Red
    glColor3f(1.0, 0.0, 0.0); glVertex3f(0.0, 0.0, 0.0); glVertex3f(Length, 0.0, 0.0);
    // Yaw (Y) - Green
    glColor3f(0.0, 1.0, 0.0); glVertex3f(0.0, 0.0, 0.0); glVertex3f(0.0, Length, 0.0);
    // Roll (Z) - Blue
    glColor3f(0.0, 0.0, 1.0); glVertex3f(0.0, 0.0, 0.0); glVertex3f(0.0, 0.0, Length);
  glEnd;

  glColor3f(1.0, 1.0, 1.0);

  glColor3f(1.0, 0.5, 0.5); glRasterPos3f(Length + 1.0, 0.0, 0.0); glPrint('Pitch (X)');
  glColor3f(0.5, 1.0, 0.5); glRasterPos3f(0.0, Length + 1.0, 0.0); glPrint('Yaw (Y)');
  glColor3f(0.5, 0.5, 1.0); glRasterPos3f(0.0, 0.0, Length + 1.0); glPrint('Roll (Z)');

  glEnable(GL_LIGHTING);
  glLineWidth(1.0);
end;}

// Helper: Menggambar Sumbu XYZ + Label Sesuai PDF (Body Planes)
procedure TFormDoublePendulumArm.DrawAxesWithLabels(Length: Single);
begin
  // Nonaktifkan lighting agar garis sumbu terlihat terang dan warnanya solid
  glDisable(GL_LIGHTING);
  glLineWidth(2.0);

  glBegin(GL_LINES);
    // 1. Sumbu X (Merah) -> Pitch Axis
    // Sesuai PDF: Axis untuk gerakan pada Sagittal Plane (Flexion/Extension)
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(Length, 0.0, 0.0);

    // 2. Sumbu Y (Hijau) -> Yaw Axis
    // Sesuai PDF: Axis Vertikal untuk gerakan rotasi kiri-kanan (Transverse Plane)
    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, Length, 0.0);

    // 3. Sumbu Z (Biru) -> Roll Axis
    // Sesuai PDF: Axis Depan-Belakang untuk gerakan Coronal Plane (Abduction/Adduction)
    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, Length);
  glEnd;

  // --- Render Label Teks pada Ujung Sumbu ---

  // Label Sumbu X (Pitch)
  glColor3f(1.0, 0.5, 0.5); // Warna Merah Muda Terang
  glRasterPos3f(Length + 1.0, 0.0, 0.0);
  glPrint('Pitch (X) - Sagittal Axis');

  // Label Sumbu Y (Yaw)
  glColor3f(0.5, 1.0, 0.5); // Warna Hijau Muda Terang
  glRasterPos3f(0.0, Length + 1.0, 0.0);
  glPrint('Yaw (Y) - Vertical Axis');

  // Label Sumbu Z (Roll)
  glColor3f(0.5, 0.5, 1.0); // Warna Biru Muda Terang
  glRasterPos3f(0.0, 0.0, Length + 1.0);
  glPrint('Roll (Z) - Coronal Axis');

  // Aktifkan kembali lighting untuk rendering objek 3D selanjutnya
  glEnable(GL_LIGHTING);
  glLineWidth(1.0);
end;

// INTI FISIKA
procedure TFormDoublePendulumArm.ComputeJointParams(
  const k1,k2,k3,k4, thMin, thMax, thInit: Extended;
  out offsetDeg, ampDeg, omega, damp, phi: Extended
);
var
  freqHz, stiffScale, ampScale, s: Extended;
begin
  offsetDeg := (thMax + thMin) / 2;
  ampDeg := Abs(thMax - thMin) / 2;
  ampScale := Max(0.0, k2 / 10.0);
  ampDeg := ampDeg * ampScale;
  stiffScale := Sqrt(Max(0.1, k4 / 10.0));
  freqHz := (k1 / 10.0) * stiffScale;

  if freqHz > 3.0 then freqHz := 3.0;
  if freqHz < 0.1 then freqHz := 0.1;

  omega := 2 * Pi * freqHz;
  damp := Max(0.0, k3 / 40.0);

  if ampDeg <= 1e-9 then
  begin
    phi := 0;
    Exit;
  end;

  s := (thInit - offsetDeg) / ampDeg;
  if s > 1.0 then s := 1.0 else if s < -1.0 then s := -1.0;
  phi := ArcSin(s);
end;

// --- OpenGL Setup ---

procedure TFormDoublePendulumArm.SetupPixelFormat;
var
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);
  pfd.nSize := sizeof(pfd);
  pfd.nVersion := 1;
  pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.iPixelType := PFD_TYPE_RGBA;
  pfd.cColorBits := 32;
  pfd.cDepthBits := 32;
  pfd.iLayerType := PFD_MAIN_PLANE;

  nPixelFormat := ChoosePixelFormat(myDC, @pfd);
  if nPixelFormat = 0 then raise Exception.Create('ChoosePixelFormat failed');
  if not SetPixelFormat(myDC, nPixelFormat, @pfd) then raise Exception.Create('SetPixelFormat failed');
end;

procedure TFormDoublePendulumArm.FormCreate(Sender: TObject);
begin
  yaw := 30;
  pitch := 0;
  roll := 0;
  xpos := 0; ypos := -2; zpos := -35;
  time := 0; dt := 0.01;
  l1 := 0.5; l2 := 0.45;

  theta1_init_deg := ReadE(edTheta1Init, 30);
  theta2_init_deg := ReadE(edTheta2Init, 60);

  myDC := GetDC(PanelGL.Handle);
  SetupPixelFormat;

  myRC := wglCreateContext(myDC);
  if myRC = 0 then raise Exception.Create('wglCreateContext failed');
  if not wglMakeCurrent(myDC, myRC) then raise Exception.Create('wglMakeCurrent failed');

  BuildFont;

  glEnable(GL_DEPTH_TEST);
  glClearColor(0.1, 0.1, 0.1, 1.0);
  glShadeModel(GL_SMOOTH);

  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);

  glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular);
  glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess);
  glLightfv(GL_LIGHT0, GL_POSITION, @light_position);

  Sphere := gluNewQuadric();
  cylinder := gluNewQuadric();
  gluQuadricNormals(Sphere, GLU_SMOOTH);
  gluQuadricNormals(cylinder, GLU_SMOOTH);

  upperlimb := True;
  teta1 := theta1_init_deg * Pi / 180;
  teta2 := theta2_init_deg * Pi / 180;

  FormResize(nil);
end;

procedure TFormDoublePendulumArm.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
  KillFont;
  if myRC <> 0 then begin wglMakeCurrent(0,0); wglDeleteContext(myRC); myRC := 0; end;
  if myDC <> 0 then begin ReleaseDC(PanelGL.Handle, myDC); myDC := 0; end;
end;

procedure TFormDoublePendulumArm.FormResize(Sender: TObject);
var
  w, h: Integer;
begin
  if (myDC = 0) or (myRC = 0) then Exit;
  w := PanelGL.Width; h := PanelGL.Height; if h = 0 then h := 1;
  wglMakeCurrent(myDC, myRC);
  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION); glLoadIdentity();
  gluPerspective(45.0, w / h, 1, 200.0);
  glMatrixMode(GL_MODELVIEW); glLoadIdentity();
end;

procedure TFormDoublePendulumArm.PanelGLResize(Sender: TObject);
begin FormResize(Sender); end;

procedure TFormDoublePendulumArm.seYawChange(Sender: TObject);
begin yaw := seYaw.Value; if not Timer1.Enabled then RenderScene; end;

procedure TFormDoublePendulumArm.sePitchChange(Sender: TObject);
begin pitch := sePitch.Value; if not Timer1.Enabled then RenderScene; end;

procedure TFormDoublePendulumArm.seRollChange(Sender: TObject);
begin roll := seRoll.Value; if not Timer1.Enabled then RenderScene; end;

procedure TFormDoublePendulumArm.rgTestClick(Sender: TObject);
begin
  SeriesShoulder.Clear; SeriesElbow.Clear; time := 0;
  theta1_init_deg := ReadE(edTheta1Init, 30);
  theta2_init_deg := ReadE(edTheta2Init, 60);
  teta1 := theta1_init_deg * Pi / 180;
  teta2 := theta2_init_deg * Pi / 180;
  RenderScene;
end;

procedure TFormDoublePendulumArm.BitBtn1Click(Sender: TObject);
var
  sh_k1,sh_k2,sh_k3,sh_k4, shMin,shMax: Extended;
  el_k1,el_k2,el_k3,el_k4, elMin,elMax: Extended;
  off,amp,omega,damp,phi: Extended;
begin
  SeriesShoulder.Clear; SeriesElbow.Clear;
  time := 0; dt := 0.03; Timer1.Interval := 10;

  theta1_init_deg := ReadE(edTheta1Init, 30);
  theta2_init_deg := ReadE(edTheta2Init, 60);

  sh_k1 := ReadE(edShK1, 10); sh_k2 := ReadE(edShK2, 10);
  sh_k3 := ReadE(edShK3, 10); sh_k4 := ReadE(edShK4, 10);
  shMin := ReadE(edShTheta1, -20); shMax := ReadE(edShTheta2, 40);

  ComputeJointParams(sh_k1,sh_k2,sh_k3,sh_k4, shMin,shMax, theta1_init_deg, off,amp,omega,damp,phi);
  phi_shoulder := phi;

  el_k1 := ReadE(edElK1, 10); el_k2 := ReadE(edElK2, 10);
  el_k3 := ReadE(edElK3, 10); el_k4 := ReadE(edElK4, 10);
  elMin := ReadE(edElTheta1, 0); elMax := ReadE(edElTheta2, 90);

  ComputeJointParams(el_k1,el_k2,el_k3,el_k4, elMin,elMax, theta2_init_deg, off,amp,omega,damp,phi);
  phi_elbow := phi;

  teta1 := DegToRad(theta1_init_deg);
  teta2 := DegToRad(theta2_init_deg);
  Timer1.Enabled := True;
end;

procedure TFormDoublePendulumArm.BitBtn2Click(Sender: TObject);
begin Timer1.Enabled := False; end;

procedure TFormDoublePendulumArm.BitBtn3Click(Sender: TObject);
begin Close; end;

procedure TFormDoublePendulumArm.BitBtnMotionEqClick(Sender: TObject);
begin
  ShowMessage('Anatomical Double Pendulum Arm Model.'#13#10 + 'Corrected constraints and palm orientation.');
end;

procedure TFormDoublePendulumArm.btnEqFigClick(Sender: TObject);
begin if Assigned(FormDoublePendulumMotionEquation) then FormDoublePendulumMotionEquation.Show; end;

procedure TFormDoublePendulumArm.UpdateAxis;
begin
  if time > DisplayRange then begin
    ChartShoulder.BottomAxis.SetMinMax(time - DisplayRange, time);
    ChartElbow.BottomAxis.SetMinMax(time - DisplayRange, time);
  end else begin
    ChartShoulder.BottomAxis.SetMinMax(0, DisplayRange);
    ChartElbow.BottomAxis.SetMinMax(0, DisplayRange);
  end;
end;

// --- CORE SIMULATION LOOP ---
{procedure TFormDoublePendulumArm.Timer1Timer(Sender: TObject);
var
  sh_k1,sh_k2,sh_k3,sh_k4, shMin,shMax: Extended;
  el_k1,el_k2,el_k3,el_k4, elMin,elMax: Extended;
  offS,ampS,omegaS,dampS,phiS: Extended;
  offE,ampE,omegaE,dampE,phiE: Extended;
  shDeg, elDeg: Extended;
  PhaseLag: Extended;
begin
  sh_k1 := ReadE(edShK1, 10); sh_k2 := ReadE(edShK2, 10);
  sh_k3 := ReadE(edShK3, 10); sh_k4 := ReadE(edShK4, 10);
  shMin := ReadE(edShTheta1, -20); shMax := ReadE(edShTheta2, 40);

  el_k1 := ReadE(edElK1, 10); el_k2 := ReadE(edElK2, 10);
  el_k3 := ReadE(edElK3, 10); el_k4 := ReadE(edElK4, 10);
  elMin := ReadE(edElTheta1, 0);   elMax := ReadE(edElTheta2, 90);

  ComputeJointParams(sh_k1,sh_k2,sh_k3,sh_k4, shMin,shMax, theta1_init_deg, offS,ampS,omegaS,dampS,phiS);
  ComputeJointParams(el_k1,el_k2,el_k3,el_k4, elMin,elMax, theta2_init_deg, offE,ampE,omegaE,dampE,phiE);

  omegaE := omegaS; // Sync Frequency
  PhaseLag := 0.5;

  if rgTest.ItemIndex = 0 then begin
    shDeg := offS + ampS * sin(omegaS * time + phi_shoulder);
    elDeg := offE + ampE * sin(omegaE * time + phi_shoulder - PhaseLag);
  end else begin
    shDeg := offS + (theta1_init_deg - offS) * exp(-dampS*time) * cos(omegaS*time);
    elDeg := offE + (theta2_init_deg - offE) * exp(-dampE*1.2*time) * cos(omegaE*time - PhaseLag);
  end;

  // --- ANATOMICAL CONSTRAINTS (PENJEPIT) ---
  // Mencegah rotasi 360 derajat atau patah ke belakang

  // Bahu: Max mundur ~ -60 (ekstensi), Max maju ~ 180 (fleksi penuh)
  if shDeg < -60.0 then shDeg := -60.0;
  if shDeg > 180.0 then shDeg := 180.0;

  // Siku: Min 0 (Lurus), Max 150 (Tekuk penuh), Tidak boleh minus (hiperekstensi)
  if elDeg < 0.0 then elDeg := 0.0;
  if elDeg > 150.0 then elDeg := 150.0;

  teta1 := DegToRad(shDeg);
  teta2 := DegToRad(elDeg);

  UpdateAxis;
  SeriesShoulder.AddXY(time, shDeg);
  SeriesElbow.AddXY(time, elDeg);

  edOut1.Text := FormatFloat('0.0', shDeg);
  edOut2.Text := FormatFloat('0.0', elDeg);
  edOut3.Text := FormatFloat('0.00', time);

  rotangle1 := 45 + 15 * sin(3 * time);
  rotangle2 := 30 + 10 * sin(3 * time + 0.5);
  rotangle3 := 10 + 5 * sin(3 * time + 1.0);

  if upperlimb then RenderScene;
  time := time + dt;
end;}

procedure TFormDoublePendulumArm.Timer1Timer(Sender: TObject);
var
  sh_k1, sh_k2, sh_k3, sh_k4, shMin, shMax: Extended;
  el_k1, el_k2, el_k3, el_k4, elMin, elMax: Extended;

  // Variabel internal perhitungan
  offS, ampS, omegaS, dampS, phiS: Extended;
  offE, ampE, omegaE, dampE, phiE: Extended;

  // Hasil Sudut
  shDeg, elDeg: Extended;
  PhaseLag: Extended;
begin
  // 1. BACA PARAMETER DARI GUI
  sh_k1 := ReadE(edShK1, 10); sh_k2 := ReadE(edShK2, 10);
  sh_k3 := ReadE(edShK3, 10); sh_k4 := ReadE(edShK4, 10);
  shMin := ReadE(edShTheta1, -20); shMax := ReadE(edShTheta2, 40);

  el_k1 := ReadE(edElK1, 10); el_k2 := ReadE(edElK2, 10);
  el_k3 := ReadE(edElK3, 10); el_k4 := ReadE(edElK4, 10);
  elMin := ReadE(edElTheta1, 0);   elMax := ReadE(edElTheta2, 90);

  // 2. HITUNG JOINT PARAMETERS (Frequency, Damping, dll)
  ComputeJointParams(sh_k1,sh_k2,sh_k3,sh_k4, shMin,shMax, theta1_init_deg, offS,ampS,omegaS,dampS,phiS);
  ComputeJointParams(el_k1,el_k2,el_k3,el_k4, elMin,elMax, theta2_init_deg, offE,ampE,omegaE,dampE,phiE);

  // Sinkronisasi Frekuensi (Biar siku tidak mengayun terlalu cepat sendirian)
  omegaE := omegaS;
  PhaseLag := 0.5;

  // 3. PILIH MODE SIMULASI
  if rgTest.ItemIndex = 0 then
  begin
    // === ACTIVE MODE (Gerakan Sinusoidal Terus Menerus) ===
    // Menggunakan offset dari Input Min/Max
    shDeg := offS + ampS * sin(omegaS * time + phi_shoulder);

    // Siku mengikuti bahu dengan sedikit keterlambatan (PhaseLag)
    elDeg := offE + (ampE * 0.7) * sin(omegaE * time + phi_shoulder - PhaseLag);
  end
  else
  begin
    // === PASSIVE DECAY MODE (Gerakan Meluruh / Jatuh Bebas) ===
    // MODIFIKASI KHUSUS DI SINI:
    // Kita PAKSA titik tengah (equilibrium) menjadi 0.0 derajat (Sejajar badan).
    // Rumus: TitikSetimbang + (PosisiAwal - TitikSetimbang) * Peluruhan * Osilasi

    // Bahu: Meluruh dari posisi awal menuju 0
    shDeg := 0.0 + (theta1_init_deg - 0.0) * exp(-dampS * time) * cos(omegaS * time);

    // Siku: Meluruh dari posisi awal menuju 0
    // Saya hilangkan PhaseLag di sini agar saat jatuh pasif, gerakannya lebih natural mengikuti gravitasi
    elDeg := 0.0 + (theta2_init_deg - 0.0) * exp(-dampE * time) * cos(omegaE * time);
  end;

  // 4. CONSTRAINT ANATOMI (PEMBATASAN SUDUT)
  // Mencegah tangan tembus badan atau patah ke belakang

  // Bahu: Dibatasi max mundur -5 (sedikit ekstensi) dan max maju 180
  if shDeg < -30.0 then shDeg := -30.0;
  if shDeg > 180.0 then shDeg := 180.0;

  // Siku: Tidak boleh minus (hiperekstensi) dan max 150 (tekuk penuh)
  if elDeg < 0.0 then elDeg := 0.0;
  if elDeg > 150.0 then elDeg := 150.0;

  // 5. UPDATE VARIABEL GLOBAL UNTUK RENDER
  teta1 := DegToRad(shDeg);
  teta2 := DegToRad(elDeg);

  // Update Grafik
  UpdateAxis;
  SeriesShoulder.AddXY(time, shDeg);
  SeriesElbow.AddXY(time, elDeg);

  // Update Angka di Panel
  edOut1.Text := FormatFloat('0.0', shDeg);
  edOut2.Text := FormatFloat('0.0', elDeg);
  edOut3.Text := FormatFloat('0.00', time);

  // Animasi Jari (Hanya visual pemanis)
  rotangle1 := 45 + 15 * sin(3 * time);
  rotangle2 := 30 + 10 * sin(3 * time + 0.5);
  rotangle3 := 10 + 5 * sin(3 * time + 1.0);

  // Render Ulang jika mode upperlimb aktif
  if upperlimb then RenderScene;

  // Increment Waktu
  time := time + dt;
end;

// --- RENDER VISUALISASI ---
procedure TFormDoublePendulumArm.RenderScene;
var
  radShoulder, radElbow, radWrist: Double;
  jarispace: Double;
  i: Integer;
  vL1, vL2: Double;
  elbowRelAngle: Double;
begin
  if (myDC = 0) or (myRC = 0) then Exit;
  wglMakeCurrent(myDC, myRC);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;

  glTranslate(xpos, ypos, zpos);
  glRotate(pitch, 1, 0, 0);
  glRotate(yaw, 0, 1, 0);
  glRotate(roll, 0, 0, 1);

  DrawAxesWithLabels(15.0);

  vL1 := l1 * 10;
  vL2 := l2 * 10;
  radShoulder := 0.75;
  radElbow := 0.55;
  radWrist := 0.40;


  glColor3f(0.75, 0.75, 0.75); // Warna Perak/Silver
  //glColor3f(0.85, 0.65, 0.55); // Warna Kulit

  // --- BAHU & LENGAN ATAS ---
  glPushMatrix();
    gluSphere(Sphere, radShoulder * 1.1, 32, 32);
    glRotate(RadToDeg(teta1), 1, 0, 0); // Rotasi Bahu (Pitch/X)
    gluCylinder(cylinder, radShoulder, radElbow, vL1, 32, 32);

    // --- SIKU & LENGAN BAWAH ---
    glTranslate(0, 0, vL1);
    gluSphere(Sphere, radElbow * 1.1, 32, 32);

    elbowRelAngle := RadToDeg(teta2 - teta1);
    if elbowRelAngle < 0 then elbowRelAngle := 0; // Visual clamp
    glRotate(elbowRelAngle, 1, 0, 0); // Rotasi Siku (Pitch/X)

    gluCylinder(cylinder, radElbow, radWrist, vL2, 32, 32);

    // --- PERGELANGAN (WRIST) & TANGAN (HAND) ---
    glTranslate(0, 0, vL2);
    gluSphere(Sphere, radWrist * 1.1, 32, 32);

    // 1. TELAPAK TANGAN (PALM)
    // Orientasi: Bidang Sagital (Gepeng kiri-kanan, lebar atas-bawah relatif lengan)
    glPushMatrix();
      glTranslate(0, 0, 0.7); // Geser pusat kubus ke tengah telapak
      // SizeX=0.3 (Tipis/Tebal tangan), SizeY=1.2 (Lebar tangan), SizeZ=1.4 (Panjang tangan)
      DrawCube(0.3, 1.2, 1.4);
    glPopMatrix();

    // 2. EMPAT JARI (FINGERS)
    glTranslate(0, 0, 1.4); // Pindah ke ujung telapak
    jarispace := 0.25;

    for i := -1 to 2 do // 4 Jari
    begin
      glPushMatrix();
        // Geser vertikal (Y) karena tangan posisi sagital (pisau)
        glTranslate(0, (i - 0.5) * jarispace, 0);

        glRotate(rotangle1, 1, 0, 0); // Tekuk Jari (X axis)
        gluCylinder(cylinder, 0.09, 0.08, 0.4, 16, 8);
        glTranslate(0, 0, 0.4);
        gluSphere(Sphere, 0.08, 16, 16);

        glRotate(rotangle2, 1, 0, 0);
        gluCylinder(cylinder, 0.08, 0.06, 0.35, 16, 8);
        glTranslate(0, 0, 0.35);
        gluSphere(Sphere, 0.06, 16, 16);

        glRotate(rotangle3, 1, 0, 0);
        gluCylinder(cylinder, 0.06, 0.04, 0.3, 16, 8);
        glTranslate(0, 0, 0.3);
        gluSphere(Sphere, 0.04, 16, 16);
      glPopMatrix();
    end;

    // 3. IBU JARI (THUMB)
    // Posisi: Di sisi ATAS (+Y) telapak tangan (agar sesuai anatomi saat siku menekuk)
    glPushMatrix();
      glTranslate(0, 0, -1.4); // Reset ke pangkal pergelangan

      // Geser ke Sisi Atas (+Y) dan Sedikit Depan (+Z)
      // Koordinat Lokal: Y=Atas, Z=Depan, X=Samping
      glTranslate(0.1, -0.5, 0.3);

      // Orientasi Jempol: Keluar sedikit (-X) dan Menghadap depan
      glRotate(-45, 0, 1, 0); // Abduction (Jauh dari telapak)
      glRotate(30, 1, 0, 0);  // Flexion awal

      // Ruas 1 (Metacarpal)
      gluCylinder(cylinder, 0.12, 0.10, 0.35, 16, 8);
      glTranslate(0, 0, 0.35);
      gluSphere(Sphere, 0.10, 16, 16);

      // Ruas 2 (Phalange) - Ikut animasi tekuk
      glRotate(rotangle2, 1, 0, 0); // Tekuk jempol
      gluCylinder(cylinder, 0.10, 0.08, 0.35, 16, 8);
      glTranslate(0, 0, 0.35);
      gluSphere(Sphere, 0.08, 16, 16);

    glPopMatrix(); // End Thumb

  glPopMatrix(); // End Shoulder

  SwapBuffers(myDC);
end;

end.
