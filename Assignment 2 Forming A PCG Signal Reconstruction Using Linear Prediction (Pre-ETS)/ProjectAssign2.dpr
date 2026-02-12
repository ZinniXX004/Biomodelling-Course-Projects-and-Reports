program ProjectAssign2;

uses
  Vcl.Forms,
  UnitAssign2 in 'UnitAssign2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
