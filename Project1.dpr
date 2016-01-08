program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Common_Unit in 'Common_Unit.pas',
  Build_kol in 'Build_kol.pas',
  Build_Shest in 'Build_Shest.pas',
  Build_Sketch in 'Build_Sketch.pas',
  Volume_Calc in 'Volume_Calc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
