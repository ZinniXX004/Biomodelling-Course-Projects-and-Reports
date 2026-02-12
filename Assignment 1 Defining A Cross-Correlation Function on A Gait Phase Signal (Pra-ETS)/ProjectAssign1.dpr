program ProjectAssign1;

uses
  Vcl.Forms,
  UnitAssign1 in 'UnitAssign1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
