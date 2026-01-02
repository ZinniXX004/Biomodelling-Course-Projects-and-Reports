unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls,
  VCLTee.Series, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, OpenGL, Math,
  Vcl.Buttons, Vcl.ComCtrls; // Ditambahkan Vcl.ComCtrls untuk TTrackBar

type
  TForm2 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Chart2: TChart;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Chart3: TChart;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Chart4: TChart;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Chart5: TChart;
    Series9: TPointSeries;
    Series10: TPointSeries;
    Edit1: TEdit;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    BitBtn1: TBitBtn;
    PanelGL: TPanel;

    // --- KOMPONEN POV (Pastikan sudah ditaruh di Form) ---
    GroupBoxPOV: TGroupBox; // Opsional, untuk wadah
    tbPitch: TTrackBar;
    lblPitch: TLabel;
    tbYaw: TTrackBar;
    lblYaw: TLabel;
    tbRoll: TTrackBar;
    lblRoll: TLabel;
    // -----------------------------------------------------

    // --- PARAMETER CONTROLS (Adapted from Rainhard's logic) ---
    GroupBoxParams: TGroupBox;
    Label2: TLabel; edtDamping: TEdit;   // C
    Label3: TLabel; edtStiffness: TEdit; // k
    Label4: TLabel; edtKp: TEdit;
    Label5: TLabel; edtTi: TEdit;
    Label6: TLabel; edtTd: TEdit;

    // --- DEBUG LISTBOX ---
    lbDebugData: TListBox;
    Label7: TLabel;

    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure single_pend_equ(thetaa,thetadota,phia,phidota:real);
    procedure rungekutta1(thetab,thetadotb,phib,phidotb:real);
    procedure single_pend_equ2(thetaa,thetadota,phia,phidota:real);
    procedure rungekutta2(thetab,thetadotb,phib,phidotb:real);
    procedure SetupPixelFormat;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    function CheckEnergyThreshold: Boolean;

    // --- PROCEDURE BARU UNTUK POV ---
    procedure tbPitchChange(Sender: TObject);
    procedure tbYawChange(Sender: TObject);
    procedure tbRollChange(Sender: TObject);
    // --------------------------------

  private
    myDC: HDC;
    myPalette: HPALETTE;
    myRC: HGLRC;
  public
    { Public declarations }
  end;

const
  mat_specular : array [0..3] of GLfloat = ( 8.0, 8.0, 1.0, 0.0 );
  mat_shininess : GLfloat = 40.0;
  light_position : array [0..3] of GLfloat = ( 120.6, 14.0, 41.0, 10.7 );

var
  Form2: TForm2;
  rotangle,rotangle1,rotangle2,rotangle3,rotangle4,rotangle5,rotangle6,rotanglee,rotangleee:real;
  xpos,ypos,zpos:real;
  circlepoint:integer;
  angle:real;
  Sphere,cylinder,disk: GLUquadricObj;
  time,time2:real;

  thetadotdot,thetadot,theta,phidotdot,phidot,phi:real;
  thetadotdot2,thetadot2,theta2,phidotdot2,phidot2,phi2:real;
  thetadotc,thetac,phidotc,phic:real;
  torque,torque1,m,lgth,g,mint:real;
  k1,k2,k3,k4,dt,k11,k21,k31,k41:real;
  BW,BH,reald,realu,itg1,itg2,kp,ti,td,errdb,errub,errd,erru,deriv1,deriv2 : real;
  rmse,rmsee,rmseee: real;
  damping_factor, stiffness, energy_threshold: real;

  // --- VARIABEL POV ---
  view_pitch, view_yaw, view_roll: Real;

implementation

{$R *.dfm}

{procedure tform2.single_pend_equ(thetaa,thetadota,phia,phidota:real);
begin
  if radiobutton2.Checked then
  begin
  thetadotdot := phidota*phidota*sin(thetaa)*cos(thetaa)-g/lgth*sin(thetaa) - damping_factor * thetadota;
  phidotdot := -2*phidota*thetadota*cos(thetaa);
  end
  else if radiobutton1.Checked then
  begin
  thetadotdot := phidota*phidota*sin(thetaa)*cos(thetaa)-g/lgth*sin(thetaa);
  phidotdot := -2*phidota*thetadota*cos(thetaa);
  end;
end;}

procedure TForm2.single_pend_equ(thetaa, thetadota, phia, phidota: real);
begin
  if radiobutton2.Checked then
  begin
    thetadotdot := phidota*phidota*sin(thetaa)*cos(thetaa) - 1.5 * (g/lgth)*sin(thetaa) - damping_factor * thetadota - stiffness * thetaa;
    phidotdot := -2*phidota*thetadota*cos(thetaa);
  end
  else
  begin
    thetadotdot := phidota*phidota*sin(thetaa)*cos(thetaa) - 1.5 * (g/lgth)*sin(thetaa);
    phidotdot := -2*phidota*thetadota*cos(thetaa);
  end;
end;

procedure tform2.rungekutta1(thetab,thetadotb,phib,phidotb:real);
var
  k1,k2,k3,k4,k11,k21,k31,k41:real;
begin
  single_pend_equ(thetab,thetadotb,phib,phidotb);
  k1:=0.5*dt*thetadotdot;
  k11:=0.5*dt*phidotdot;

  single_pend_equ(thetab+0.5*dt*(thetadotb+0.5*k1),thetadotb+k1,phib+0.5*dt*(phidotb+0.5*k11),phidotb+k11);
  k2:=0.5*dt*thetadotdot;
  k21:=0.5*dt*phidotdot;

  single_pend_equ(thetab+0.5*dt*(thetadotb+0.5*k1),thetadotb+k2,phib+0.5*dt*(phidotb+0.5*k11),phidotb+k21);
  k3:=0.5*dt*thetadotdot;
  k31:=0.5*dt*phidotdot;

  single_pend_equ(thetab+dt*(thetadotb+k3),thetadotb+2*k3,phib+dt*(phidotb+k31),phidotb+2*k31);
  k4:=0.5*dt*thetadotdot;
  k41:=0.5*dt*phidotdot;

  theta:=theta+dt*(thetadot+1/3*(k1+k2+k3));
  thetadot:=thetadot+1/3*(k1+2*k2+2*k3+k4);

  phi:=phi+dt*(phidot+1/3*(k11+k21+k31));
  phidot:=phidot+1/3*(k11+2*k21+2*k31+k41);
end;

{procedure tform2.single_pend_equ2(thetaa,thetadota,phia,phidota:real);
begin
if radiobutton2.Checked then
  begin
  thetadotdot2 := phidota*phidota*sin(thetaa)*cos(thetaa)-g/lgth*sin(thetaa)- damping_factor * thetadota;;
  phidotdot2 := -2*phidota*thetadota*cos(thetaa);
  end
else if radiobutton1.Checked then
  begin
  thetadotdot2 := phidota*phidota*sin(thetaa)*cos(thetaa)-g/lgth*sin(thetaa);
  phidotdot2 := -2*phidota*thetadota*cos(thetaa);
  end;
end;}

procedure TForm2.single_pend_equ2(thetaa, thetadota, phia, phidota: real);
begin
  if radiobutton2.Checked then
  begin
    thetadotdot2 := phidota*phidota*sin(thetaa)*cos(thetaa) - 1.5 * (g/lgth)*sin(thetaa) - damping_factor * thetadota - stiffness * thetaa;
    phidotdot2 := -2*phidota*thetadota*cos(thetaa);
  end
  else
  begin
    thetadotdot2 := phidota*phidota*sin(thetaa)*cos(thetaa) - 1.5 * (g/lgth)*sin(thetaa);
    phidotdot2 := -2*phidota*thetadota*cos(thetaa);
  end;
end;

procedure Tform2.rungekutta2(thetab,thetadotb,phib,phidotb:real);
var
  k1,k2,k3,k4,k11,k21,k31,k41:real;
begin
  single_pend_equ2(thetab,thetadotb,phib,phidotb);
  k1:=0.5*dt*thetadotdot2;
  k11:=0.5*dt*phidotdot2;

  single_pend_equ2(thetab+0.5*dt*(thetadotb+0.5*k1),thetadotb+k1,phib+0.5*dt*(phidotb+0.5*k11),phidotb+k11);
  k2:=0.5*dt*thetadotdot2;
  k21:=0.5*dt*phidotdot2;

  single_pend_equ2(thetab+0.5*dt*(thetadotb+0.5*k1),thetadotb+k2,phib+0.5*dt*(phidotb+0.5*k11),phidotb+k21);
  k3:=0.5*dt*thetadotdot2;
  k31:=0.5*dt*phidotdot2;

  single_pend_equ2(thetab+dt*(thetadotb+k3),thetadotb+2*k3,phib+dt*(phidotb+k31),phidotb+2*k31);
  k4:=0.5*dt*thetadotdot2;
  k41:=0.5*dt*phidotdot2;

  theta2:=theta2+dt*(thetadot2+1/3*(k1+k2+k3));
  thetadot2:=thetadot2+1/3*(k1+2*k2+2*k3+k4);

  phi2:=phi2+dt*(phidot2+1/3*(k11+k21+k31));
  phidot2:=phidot2+1/3*(k11+2*k21+2*k31+k41);
end;

procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;

procedure TForm2.SetupPixelFormat;
var
  hHeap: THandle;
  nColors, i: Integer;
  lpPalette : PLogPalette;
  byRedMask, byGreenMask, byBlueMask: Byte;
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);
  with pfd do
  begin
    nSize     := sizeof(pfd);               // Länge der pfd-Struktur
    nVersion  := 1;                         // Version
    dwFlags   := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;          // Flags
    iPixelType:= PFD_TYPE_RGBA;             // RGBA Pixel Type
    cColorBits:= 32;                        // 24-bit color
    cDepthBits:= 32;                        // 32-bit depth buffer
    iLayerType:= PFD_MAIN_PLANE;            // Layer Type
  end;
  nPixelFormat:= ChoosePixelFormat(myDC, @pfd);
  SetPixelFormat(myDC, nPixelFormat, @pfd);
  DescribePixelFormat(myDC, nPixelFormat,
  sizeof(TPixelFormatDescriptor),pfd);

  if ((pfd.dwFlags and PFD_NEED_PALETTE) <> 0) then
  begin
    nColors  := 1 shl pfd.cColorBits;
    hHeap    := GetProcessHeap;
    lpPalette:= HeapAlloc
       (hHeap,0,sizeof(TLogPalette)+(nColors*sizeof(TPaletteEntry)));
    lpPalette^.palVersion := $300;
    lpPalette^.palNumEntries := nColors;
    byRedMask  := (1 shl pfd.cRedBits) - 1;
    byGreenMask:= (1 shl pfd.cGreenBits) - 1;
    byBlueMask := (1 shl pfd.cBlueBits) - 1;
    for i := 0 to nColors - 1 do
    begin
      lpPalette^.palPalEntry[i].peRed  :=
        (((i shr pfd.cRedShift)  and byRedMask)  *255)DIV byRedMask;
      lpPalette^.palPalEntry[i].peGreen:=
        (((i shr pfd.cGreenShift)and byGreenMask)*255)DIV byGreenMask;
      lpPalette^.palPalEntry[i].peBlue :=
        (((i shr pfd.cBlueShift) and byBlueMask) *255)DIV byBlueMask;
      lpPalette^.palPalEntry[i].peFlags:= 0;
    end;
    myPalette:= CreatePalette(lpPalette^);
    HeapFree(hHeap, 0, lpPalette);
    if (myPalette <> 0) then
    begin
      SelectPalette(myDC, myPalette, False);
      RealizePalette(myDC);
    end;
  end;
end;

procedure lowerarm (panjang:real);
begin
  glrotate(90,1,0,0);
  glpushmatrix();
  gluSphere(sphere,0.75,32 ,32 ); //Sendi Siku
  gluCylinder(cylinder, 0.65, 0.35, panjang, 32, 10); //Lengan
  gltranslate(0,0,panjang);   //translate to end segment
  gludisk(disk,0,0.35,32,32); //Joint tutup silinder lengan
  gluSphere(sphere,0.3,32 ,32 );  //Sendi pergelangan tangan
end;

procedure hand (tl, tt, tp : real);
begin
  glcolor3f(1/3,1/3,1/3);
  glbegin(gl_polygon);
  glvertex3f(-tl,tt,0); //(x y z)  +tt
  glvertex3f(tl,tt,0);
  glvertex3f(tl,tt,tp);
  glvertex3f(-tl,tt,tp);
  glend;

  glbegin(gl_polygon);     //dasar -tt
  glvertex3f(-tl,-tt,0);
  glvertex3f(tl,-tt,0);
  glvertex3f(tl,-tt,tp);
  glvertex3f(-tl,-tt,tp);
  glend;

  glbegin(gl_polygon);   //samping kiri -t1
  glvertex3f(-tl,tt,0);
  glvertex3f(-tl,-tt,0);
  glvertex3f(-tl,-tt,tp);
  glvertex3f(-tl,tt,tp);
  glend;

  glbegin(gl_polygon);   //samping kanan +tl
  glvertex3f(tl,tt,0);
  glvertex3f(tl,-tt,0);
  glvertex3f(tl,-tt,tp);
  glvertex3f(tl,tt,tp);
  glend;

  glbegin(gl_polygon);    //depan sumbu z +tp
  glvertex3f(tl,tt,tp);
  glvertex3f(-tl,tt,tp);
  glvertex3f(-tl,-tt,tp);
  glvertex3f(tl,-tt,tp);
  glend;

  glbegin(gl_polygon);   //belakang sumbu z 0
  glvertex3f(-tl,tt,0);
  glvertex3f(-tl,-tt,0);
  glvertex3f(tl,-tt,0);
  glvertex3f(-tl,-tt,0);
  glend;
end;

procedure jari;
var
  jarip,jarip1,jarip2,jarispace:real;
begin
  {first segment}
  {centre fingers}
  jarip:=0.25;
  jarip1:=0.23;
  jarip2:=0.27;
  gltranslate(0,0,1.25); //ref
  glrotate(rotangle1,1,0,0);   //rotation1
  glenable(gl_lighting);
  glpushmatrix();
  gluCylinder(cylinder, 0.075, 0.075,jarip, 32, 10);    //jari tengan dengan panjang jarip
  gluSphere(sphere,0.077,32 ,32 ); //sendi

  {pointer finger}
  glpushmatrix();
  jarispace:=0.2;
  gltranslate(jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.075, 0.075,jarip, 32, 10);
  gluSphere(sphere,0.077,32 ,32 );

  {tumb}
  gltranslate(jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.095, 0.095,jarip, 32, 10);
  gluSphere(sphere,0.097,32 ,32 );

  {jari manis}
  gltranslate(-3*jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.07, 0.07,jarip, 32, 10);
  gluSphere(sphere,0.072,32 ,32 );

  {kelingking}
  gltranslate(-jarispace,0,0); {ref}
  gluSphere(sphere,0.072,32 ,32 );
  gluCylinder(cylinder, 0.07, 0.07,jarip, 32, 10);

  {second segment}
  {kelingking}
  gltranslate(0,0,jarip); {ref}
  glrotate(rotangle2,1,0,0);   {rotation1}
  glpushmatrix();
  gluCylinder(cylinder, 0.07, 0.07,jarip1, 32, 10);
  gluSphere(sphere,0.072,32 ,32 );
  gltranslate(0,0,jarip1); {ref}
  gluSphere(sphere,0.072,32 ,32 );
  gltranslate(0,0,-jarip1); {ref}

  {jari manis}
  gltranslate(jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.07, 0.07,jarip1, 32, 32);
  gluSphere(sphere,0.072,32 ,32 );

  {jari tengah}
  gltranslate(jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.07, 0.07,jarip1, 32, 10);
  gluSphere(sphere,0.072,32 ,32 );

  {jari telunjuk}
  gltranslate(jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.075, 0.075,jarip1, 32, 10);
  gluSphere(sphere,0.077,32 ,32 );

  {tumb}
  gltranslate(jarispace,0,0); {ref}
  gluCylinder(cylinder, 0.095, 0.095,jarip1, 32, 10);
  gluSphere(sphere,0.097,32 ,32 );
  gltranslate(0,0,jarip1); {ref}
  gluSphere(sphere,0.097,32 ,32 );

  {third segment}

  {telunjuk}
  gltranslate(-jarispace,0,0); {ref}
  glrotate(rotangle3,1,0,0);   {rotation1}
  glpushmatrix();
  gluCylinder(cylinder, 0.075, 0.065,jarip2, 32, 10);
  gluSphere(sphere,0.077,32 ,32 );
  gltranslate(0,0,jarip2); {ref}
  gluSphere(sphere,0.067,32 ,32 );

  {jaritengah}
  gltranslate(-jarispace,0,-jarip2); {ref}
  glpushmatrix();
  gluCylinder(cylinder, 0.075, 0.065,jarip2, 32, 10);
  gluSphere(sphere,0.077,32 ,32 );
  gltranslate(0,0,jarip2); {ref}
  gluSphere(sphere,0.067,32 ,32 );

  {jari manis}
  gltranslate(-jarispace,0,-jarip2); {ref}
  glpushmatrix();
  gluCylinder(cylinder, 0.075, 0.065,jarip2, 32, 10);
  gluSphere(sphere,0.077,32 ,32 );
  gltranslate(0,0,jarip2); {ref}
  gluSphere(sphere,0.067,32 ,32 );

  glPopMatrix();
  glend;
end;

procedure render;
var
  panjang,tp,tl,tt :real;
begin
  glClearColor(0.0, 0.0, 0.5, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); //Farb und Tiefenpuffer löschen
  glLoadIdentity;

  // 1. Posisikan Kamera/Objek Menjauh
  gltranslate(xpos, ypos, zpos);

  // ---------------------------------------------
  // 2. APPLY POV ROTATION (FITUR POV BARU)
  // ---------------------------------------------
  glRotate(view_pitch, 1, 0, 0); // Putar sumbu X
  glRotate(view_yaw,   0, 1, 0); // Putar sumbu Y
  glRotate(view_roll,  0, 0, 1); // Putar sumbu Z
  // ---------------------------------------------

  glenable(gl_lighting);

  panjang:=5;//panjang silinder lengan
  tp:=1.25;  //panjang tangan
  tl:=0.5;   //lebar tangan
  tt:=0.152; //tebal tangan
  lowerarm (panjang);
  glrotate(0,0,0,1);
  glrotate(rotanglee,1,0,0);
  hand(tl, tt, tp);
  jari;
  swapBuffers(form2.myDC);
end;

procedure render2;
var
  panjang,tp,tl,tt :real;
begin
  glClearColor(0.0, 0.0, 0.5, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); //Farb und Tiefenpuffer löschen
  glLoadIdentity;

  // 1. Posisikan Kamera/Objek Menjauh
  gltranslate(xpos, ypos, zpos);

  // ---------------------------------------------
  // 2. APPLY POV ROTATION (FITUR POV BARU)
  // ---------------------------------------------
  glRotate(view_pitch, 1, 0, 0);
  glRotate(view_yaw,   0, 1, 0);
  glRotate(view_roll,  0, 0, 1);
  // ---------------------------------------------

  glenable(gl_lighting);

  panjang:=5;//panjang silinder lengan
  tp:=1.25;  //panjang tangan
  tl:=0.5;   //lebar tangan
  tt:=0.152; //tebal tangan
  lowerarm (panjang);
  glrotate(0,0,0,1);
  glrotate(rotangleee,0,1,0);
  hand(tl, tt, tp);
  jari;
  swapBuffers(form2.myDC);
end;

procedure render3;
var
  panjang,tp,tl,tt :real;
begin
  glClearColor(0.0, 0.0, 0.5, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); //Farb und Tiefenpuffer löschen
  glLoadIdentity;

  // 1. Posisikan Kamera/Objek Menjauh
  gltranslate(xpos, ypos, zpos);

  // ---------------------------------------------
  // 2. APPLY POV ROTATION (FITUR POV BARU)
  // ---------------------------------------------
  glRotate(view_pitch, 1, 0, 0);
  glRotate(view_yaw,   0, 1, 0);
  glRotate(view_roll,  0, 0, 1);
  // ---------------------------------------------

  glenable(gl_lighting);

  panjang:=5;//panjang silinder lengan
  tp:=1.25;  //panjang tangan
  tl:=0.5;   //lebar tangan
  tt:=0.152; //tebal tangan
  lowerarm (panjang);
  glrotate(rotanglee,1,0,0);
  glrotate(rotangleee,0,1,0);
  hand(tl, tt, tp);
  jari;
  swapBuffers(form2.myDC);
end;

function TForm2.CheckEnergyThreshold: Boolean;
var
  kinetic_energy, potential_energy, total_energy: real;
begin
  // Hitung energi kinetik (1/2 * m * v^2)
  kinetic_energy := 0.5 * m * (thetadot*thetadot + phidot*phidot);
  // Hitung energi potensial (m * g * h)
  potential_energy := m * g * lgth * (1 - cos(theta));
  total_energy := kinetic_energy + potential_energy;
  // Periksa apakah energi di bawah ambang batas
  Result := total_energy < energy_threshold;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  damping_factor := 0.5; // Sesuaikan nilai ini untuk efek redaman yang diinginkan
  energy_threshold := 0.01; // Ambang energi untuk menghentikan gerakan

  theta:=30*pi/180;
  phi:=30*pi/180;
  thetadot:=0;
  phidot:=0;

  theta2:=0;
  phi2:=0;
  thetadot2:=2.25;
  phidot2:=0;

  BW:=50;
  BH:=160;
  g:=9.8;
  lgth:=0.517;          //Dempster
  m := 0.006*BW+0.054;

  dt := 0.01;
  reald := 0;
  realu := 0;
  itg1 := 0;
  itg2 := 0;
  kp:=0.01/0.9/0.05;
  //kp:=0.1;
  Ti := 0.01;
  Td := 0.5*0.005;
  //Td := 0.0005;
  errdb:= 0;
  errub := 0;
  stiffness := 2.0;
  damping_factor := 0.5;

  // --- POV INIT ---
  view_pitch := 0;
  view_yaw   := 0;
  view_roll  := 0;

  // Pastikan TrackBar properti tersetting (jika belum di design time)
  if Assigned(tbPitch) then begin tbPitch.Min:=-180; tbPitch.Max:=180; tbPitch.Position:=0; end;
  if Assigned(tbYaw) then begin tbYaw.Min:=-180; tbYaw.Max:=180; tbYaw.Position:=0; end;
  if Assigned(tbRoll) then begin tbRoll.Min:=-180; tbRoll.Max:=180; tbRoll.Position:=0; end;
  // ----------------

  //form2.myDC:= GetDC(Handle);
  form2.myDC:= GetDC(PanelGL.Handle);
  SetupPixelFormat;
  myRC:= wglCreateContext(myDC);
  wglMakeCurrent(myDC, myRC);
  glEnable(GL_DEPTH_TEST);
  glLoadIdentity;

  glClearColor(1.0, 1.0, 1.0, 0.0); 	  // White Background
  glShadeModel(GL_SMOOTH);              // Enables Smooth Color Shading
  glClearDepth(1.0);                    // Depth Buffer Setup
  glEnable(GL_DEPTH_TEST);              // Enable Depth Buffer
  glDepthFunc(GL_LESS);		              // The Type Of Depth Test To Do

  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

  glEnable(GL_TEXTURE_2D);

  Sphere := gluNewQuadric();
  cylinder:= gluNewQuadric();
  disk:=glunewquadric();
  gluQuadricNormals(Sphere, GLU_SMOOTH);      // Create Smooth Normals
  gluQuadricNormals(cylinder, GLU_SMOOTH);    // Create Smooth Normals
  gluQuadricNormals(disk, GLU_SMOOTH);        // Create Smooth Normals

  glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular);
  glMaterialfv(GL_BACK, GL_SPECULAR, @mat_specular);
  glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess);
  glMaterialfv(GL_BACK, GL_SHININESS, @mat_shininess);
  glLightfv(GL_LIGHT0, GL_POSITION, @light_position);
  glLightfv(GL_LIGHT3, GL_SPECULAR, @mat_specular);
  glLightfv(GL_LIGHT1, GL_POSITION, @light_position);
  glLightfv(GL_LIGHT2, GL_POSITION, @light_position);

  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHT1);
  glEnable(GL_LIGHT2);
  glEnable(GL_LIGHT3);
  glDepthFunc(GL_LEQUAL);

  rotangle:=0;
  rotangle1:=30;
  rotangle2:=30;
  rotangle3:=30;
  rotangle4:=90;

  xpos:=0;
  ypos:=2;
  zpos:=-15;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  wglmakecurrent(0,0);
  wgldeletecontext(mydc);
  releasedc(handle,mydc);
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  // Pastikan PanelGL sudah dibuat untuk menghindari error saat startup
  if Assigned(PanelGL) then
  begin
    // Gunakan Lebar dan Tinggi PanelGL, BUKAN Width/Height Form
    glViewport(0, 0, PanelGL.Width, PanelGL.Height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    // Aspek rasio juga menggunakan dimensi PanelGL
    if PanelGL.Height = 0 then
       gluPerspective(45.0, PanelGL.Width / 1, 1, 100.0)
    else
       gluPerspective(45.0, PanelGL.Width / PanelGL.Height, 1, 100.0);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
  end;
end;

// --- EVENT HANDLERS POV (DITAMBAHKAN) ---
procedure TForm2.tbPitchChange(Sender: TObject);
begin
  view_pitch := tbPitch.Position;
  if Assigned(lblPitch) then lblPitch.Caption := 'Pitch: ' + IntToStr(tbPitch.Position);
  // Paksa render saat timer mati agar preview terlihat
  if not (Timer1.Enabled or Timer3.Enabled or Timer4.Enabled) then render;
end;

procedure TForm2.tbYawChange(Sender: TObject);
begin
  view_yaw := tbYaw.Position;
  if Assigned(lblYaw) then lblYaw.Caption := 'Yaw: ' + IntToStr(tbYaw.Position);
  if not (Timer1.Enabled or Timer3.Enabled or Timer4.Enabled) then render;
end;

procedure TForm2.tbRollChange(Sender: TObject);
begin
  view_roll := tbRoll.Position;
  if Assigned(lblRoll) then lblRoll.Caption := 'Roll: ' + IntToStr(tbRoll.Position);
  if not (Timer1.Enabled or Timer3.Enabled or Timer4.Enabled) then render;
end;
// ----------------------------------------

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  render;
  time:=time+dt;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
  // --- KONDISI 1: FRONTAL ONLY (Button 1 / Timer 1 Aktif) ---
  if Timer1.Enabled then
  begin
    // 1. Hitung Fisika Frontal (Theta)
    rungekutta1(theta,thetadot,phi,phidot);
    rotanglee := theta * 180 / pi;  // Konversi ke derajat

    // 2. PID Control Frontal (Ulnar/Radial - Realu)
    erru   := rotanglee - realu;
    Itg2   := Itg2 + erru * dt;
    deriv2 := (erru - errub) / dt;
    // Output PID (Torsi/Posisi baru)
    realu  := realu + Kp*erru + Ti*Itg2 + Td*deriv2;
    errub  := erru;

    // 3. MATIKAN/NOL-KAN BAGIAN SAGITAL
    theta2      := 0;
    thetadot2   := 0;
    rotangleee  := 0;
    reald       := 0;
    errd        := 0;
    deriv1      := 0; // Tau1 jadi 0
    itg1        := 0;
    errdb       := 0;
  end

  // --- KONDISI 2: SAGITAL ONLY (Button 2 / Timer 3 Aktif) ---
  else if Timer3.Enabled then
  begin
    // 1. Hitung Fisika Sagital (Theta2)
    rungekutta2(theta2,thetadot2,phi2,phidot2);
    rotangleee := theta2 * 180 / pi; // Konversi ke derajat

    // 2. PID Control Sagital (Dorsal/Palmar - Reald)
    errd   := rotangleee - reald;
    Itg1   := Itg1 + errd * dt;
    deriv1 := (errd - errdb) / dt;
    // Output PID
    reald  := reald + Kp*errd + Ti*Itg1 + Td*deriv1;
    errdb  := errd;

    // 3. MATIKAN/NOL-KAN BAGIAN FRONTAL
    theta       := 0;
    thetadot    := 0;
    rotanglee   := 0;
    realu       := 0;
    erru        := 0;
    deriv2      := 0; // Tau2 jadi 0
    itg2        := 0;
    errub       := 0;
  end

  // --- KONDISI 3: GABUNGAN (Button 3 / Timer 4 Aktif) ---
  else if Timer4.Enabled then
  begin
    // Hitung Keduanya
    rungekutta1(theta,thetadot,phi,phidot);
    rungekutta2(theta2,thetadot2,phi2,phidot2);

    rotanglee  := theta * 180 / pi;
    rotangleee := theta2 * 180 / pi;

    // PID Frontal
    erru   := rotanglee - realu;
    Itg2   := Itg2 + erru * dt;
    deriv2 := (erru - errub) / dt;
    realu  := realu + Kp*erru + Ti*Itg2 + Td*deriv2;
    errub  := erru;

    // PID Sagital
    errd   := rotangleee - reald;
    Itg1   := Itg1 + errd * dt;
    deriv1 := (errd - errdb) / dt;
    reald  := reald + Kp*errd + Ti*Itg1 + Td*deriv1;
    errdb  := errd;
  end;

  // --- PLOTTING DATA KE GRAFIK ---
  // Karena variabel yang tidak aktif sudah di-nol-kan di atas,
  // grafik otomatis akan menggambar garis lurus di angka 0 untuk bagian yang tidak aktif.

  // Grafik Frontal (Target vs Realized)
  Series1.AddXY(time/60, rotangleee);
  Series2.AddXY(time/60, reald);

  // Grafik Sagital (Target vs Realized)
  Series3.AddXY(time/60, rotanglee);
  Series4.AddXY(time/60, realu);

  // Grafik Joint Angle (Phase Plane) - Point Series
  // Jika Frontal Only -> X=0. Jika Sagital Only ->Y=0.
  Series9.AddXY(rotangleee, rotanglee); // Target Joint Path
  Series10.AddXY(reald, realu);         // Realized Joint Path

  // Grafik Active Torque (Diwakili oleh Derivatif/Output PID)
  Series5.AddXY(time/60, deriv2); // Tau Sagital
  Series6.AddXY(time/60, deriv1); // Tau Frontal

  // Grafik Error
  Series7.AddXY(time/60, erru);   // Error Sagital
  Series8.AddXY(time/60, errd);   // Error Frontal

  // Hitung RMSE (Hanya untuk yang aktif agar akurat)
  if Timer1.Enabled then
     rmse := rmse + sqr(erru)
  else if Timer3.Enabled then
     rmse := rmse + sqr(errd)
  else
     rmse := rmse + sqr((erru+errd)/2);

  rmseee := rmse / (time + 0.0001); // Hindari pembagian nol
  rmsee  := sqrt(rmseee);

  Edit1.Text := FloatToStr(rmsee);
end;

procedure TForm2.Timer3Timer(Sender: TObject);
begin
  render2;
  time:=time+dt;
end;

procedure TForm2.Timer4Timer(Sender: TObject);
begin
  render3;
  time:=time+dt;
end;

procedure TForm2.Button1Click(Sender: TObject); // FRONTAL BUTTON
begin
  if (not Timer1.Enabled) then
  begin
    // Reset Data Dulu
    time := 0; rmse := 0;
    theta := 30*pi/180; thetadot:=0; // Reset Posisi Awal Frontal
    reald := 0; realu := 0;          // Reset Realized
    Series1.Clear; Series2.Clear; Series3.Clear; Series4.Clear;
    Series5.Clear; Series6.Clear; Series7.Clear; Series8.Clear;
    Series9.Clear; Series10.Clear;

    // Aktifkan Timer yang Benar
    Timer1.Enabled := True;  // Render Frontal
    Timer2.Enabled := True;  // Math Loop
    Timer3.Enabled := False;
    Timer4.Enabled := False;

    Button1.Caption := 'Stop';
    damping_factor := 0.5; // Atau 0 tergantung mode Active/Passive
  end
  else
  begin
    Timer1.Enabled := False;
    Timer2.Enabled := False;
    Button1.Caption := 'Start';
  end;
end;

procedure TForm2.Button2Click(Sender: TObject); // SAGITAL BUTTON
begin
  if (not Timer3.Enabled) then
  begin
    // Reset Data
    time := 0; rmse := 0;
    theta2 := 0; thetadot2 := 2.25; // Reset Posisi Awal Sagital
    reald := 0; realu := 0;
    Series1.Clear; Series2.Clear; Series3.Clear; Series4.Clear;
    Series5.Clear; Series6.Clear; Series7.Clear; Series8.Clear;
    Series9.Clear; Series10.Clear;

    // Aktifkan Timer yang Benar
    Timer3.Enabled := True;  // Render Sagital
    Timer2.Enabled := True;  // Math Loop
    Timer1.Enabled := False;
    Timer4.Enabled := False;

    Button2.Caption := 'Stop';
    damping_factor := 0.7;
  end
  else
  begin
    Timer3.Enabled := False;
    Timer2.Enabled := False;
    Button2.Caption := 'Start';
  end;
end;

procedure TForm2.Button3Click(Sender: TObject); // COMBINED BUTTON
begin
  if (not Timer4.Enabled) then
  begin
    // Reset Data
    time := 0; rmse := 0;
    theta := 30*pi/180; theta2 := 0; // Reset Keduanya
    reald := 0; realu := 0;
    Series1.Clear; Series2.Clear; Series3.Clear; Series4.Clear;
    Series5.Clear; Series6.Clear; Series7.Clear; Series8.Clear;
    Series9.Clear; Series10.Clear;

    // Aktifkan Timer yang Benar
    Timer4.Enabled := True;  // Render Combined
    Timer2.Enabled := True;  // Math Loop
    Timer1.Enabled := False;
    Timer3.Enabled := False;

    Button3.Caption := 'Stop';
    damping_factor := 0.6;
  end
  else
  begin
    Timer4.Enabled := False;
    Timer2.Enabled := False;
    Button3.Caption := 'Start';
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  i, j: Integer;
  SaveFile: TextFile;
  FileName: string;
  SeriesData: array[1..10] of TChartSeries;
begin
  // Tentukan serial yang akan disimpan
  SeriesData[1] := Series1;
  SeriesData[2] := Series2;
  SeriesData[3] := Series3;
  SeriesData[4] := Series4;
  SeriesData[5] := Series5;
  SeriesData[6] := Series6;
  SeriesData[7] := Series7;
  SeriesData[8] := Series8;
  SeriesData[9] := Series9;
  SeriesData[10] := Series10;

  // Tampilkan SaveDialog untuk memilih lokasi dan nama file
  if SaveDialog1.Execute then
  begin
    // Ambil nama file dari SaveDialog
    FileName := SaveDialog1.FileName;

    // Coba membuka file untuk menulis
    AssignFile(SaveFile, FileName);
    try
      Rewrite(SaveFile); // Membuka file untuk ditulis

      // Menulis header untuk kolom data
      WriteLn(SaveFile, 'Time (min)|Target Frontal|Realized Frontal|Target Sagital|Realized Sagital|Tau1|Tau2|Error1|Error2|Joint Target|Joint Realized');

      // Menulis data dari setiap seri
      for i := 0 to SeriesData[1].Count - 1 do
      begin
        // Menulis waktu (dalam menit) untuk setiap baris
        Write(SaveFile, Format('%.6f', [SeriesData[1].XValue[i] / 60]));

        // Loop untuk setiap seri dan menulis nilai Y untuk setiap seri
        for j := 2 to 10 do
        begin
          Write(SaveFile, Format('|%.6f', [SeriesData[j].YValue[i]]));
        end;

        // Pindah ke baris berikutnya setelah menulis semua data dalam satu baris
        WriteLn(SaveFile);
      end;

      // Berhasil menyimpan file
      ShowMessage('Berhasil menyimpan file!');
    except
      on E: Exception do
        ShowMessage('Error saving file: ' + E.Message);
    end;

    // Menutup file setelah selesai
    CloseFile(SaveFile);
  end;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  time:=0;
  theta:=30*pi/180;
  phi:=30*pi/180;
  thetadot:=0;
  phidot:=0;

  theta2:=0;
  phi2:=0;
  thetadot2:=2.31;
  phidot2:=0;

  reald := 0;
  realu := 0;
  itg1 := 0;
  itg2 := 0;
  errdb:= 0;
  errub := 0;

  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  Series8.clear;
  Series9.Clear;
  Series10.Clear;
  button1.caption:='Frontal';
  button2.caption:='Sagital';
  button3.caption:='Frontal+Sagital';

  Series1.Active := True;
  Series2.Active := True;
  Series3.Active := True;
  Series4.Active := True;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  Close;
end;

end.
