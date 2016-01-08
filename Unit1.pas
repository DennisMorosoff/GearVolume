unit Unit1;

interface

uses
  {Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_TLB, StdCtrls, UnitPloskostiKolesa, Math, ComObj, Build}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Build_kol, StdCtrls, SwConst_TLB, Math, ExtCtrls,SldWorks_TLB, Volume_calc, Build_Sketch, Build_shest, Common_Unit;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    GroupBox2: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    SD1: TSaveDialog;
    Button1: TButton;
    Button2: TButton;
    GroupBox3: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox4: TGroupBox;
    LabeledEdit9: TLabeledEdit;
    Button4: TButton;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    Button3: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    a, da, db, d, h, un: double;
    z:integer;
begin
  //OpenSW;

  try
  da:= StrToFloat(Edit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit1.SetFocus;
    exit;
  end;

  try
  d:= StrToFloat(Edit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit2.SetFocus;
    exit;
  end;

  try
  db:= StrToFloat(Edit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit3.SetFocus;
    exit;
  end;

  try
  a:= StrToFloat(Edit4.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit4.SetFocus;
    exit;
  end;

  try
  h:= StrToFloat(Edit5.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit5.SetFocus;
    exit;
  end;

  try
  z:= StrToInt(Edit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit6.SetFocus;
    exit;
  end;

  if da <= db then
    begin
      ShowMessage('Диаметр вершины должен быть больше диаметра впадины');
      Edit1.SetFocus;
      exit;
    end;

  if (da<=0) or (db<=0) or (d<=0) or (a<=0) or (h<=0) then
    begin
      ShowMessage('Все значения параметров должны быть больше нуля');
      Edit1.SetFocus;
      exit;
    end;

   Postroenie_kolesa (a, da, db, d, h, z);

  if RadioButton1.Checked=true then
    closeSWSave;
  if RadioButton2.Checked=true then
    closeSWShow;
end;

procedure TForm1.Button2Click(Sender: TObject);
var a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, cap: double;
    z: integer;
    z_sh:integer;
    kvadr : double;
begin
  try
  da_sh:= StrToFloat(LabeledEdit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit1.SetFocus;
    exit;
  end;

  try
  d_sh:= StrToFloat(LabeledEdit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit2.SetFocus;
    exit;
  end;

  try
  db_sh:= StrToFloat(LabeledEdit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit3.SetFocus;
    exit;
  end;

  try
  a_sh:= StrToFloat(LabeledEdit4.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit4.SetFocus;
    exit;
  end;

  try
  h_sh:= StrToFloat(LabeledEdit5.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit5.SetFocus;
    exit;
  end;

  try
  z_sh:= StrToInt(LabeledEdit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit6.SetFocus;
    exit;
  end;

  try
  da:= 0;
  da:= StrToFloat(Edit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit1.SetFocus;
    exit;
  end;

  try
  d:=0;
  d:= StrToFloat(Edit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit2.SetFocus;
    exit;
  end;

  try
  db:= 0;
  db:= StrToFloat(Edit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit3.SetFocus;
    exit;
  end;

  try
  z:= StrToInt(Edit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit6.SetFocus;
    exit;
  end;


  try
  z:= StrToInt(Edit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit6.SetFocus;
    exit;
  end;

  try
    cap:= StrToInt(LabeledEdit7.Text);
 except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit7.SetFocus;
    exit;
  end;

  try
    kvadr:= StrToInt(LabeledEdit8.Text);
 except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit8.SetFocus;
    exit;
  end;

  if da = da_sh then
    begin
      ShowMessage('Значения диаметров вершин колеса и шестерни не должны быть равны!');
      Edit1.SetFocus;
      exit;
    end;

  if (kvadr = da_sh) or (kvadr > da_sh) then
    begin
      ShowMessage('Значение длины стороны квадрата не должно превышать диаметр вершины шестерни!');
      Edit1.SetFocus;
      exit;
    end;

  Postroenie_Shest (OpenSW, a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr, z_sh);

  if RadioButton1.Checked=true then
    closeSWSave;
  if RadioButton2.Checked=true then
    closeSWShow;
end;

procedure TForm1.Button3Click(Sender: TObject);
var a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, cap: double;
    z: integer;
    z_sh:integer;
    kvadr : double;
begin
  try
  da_sh:= StrToFloat(LabeledEdit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit1.SetFocus;
    exit;
  end;

  try
  d_sh:= StrToFloat(LabeledEdit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit2.SetFocus;
    exit;
  end;

  try
  db_sh:= StrToFloat(LabeledEdit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit3.SetFocus;
    exit;
  end;

  try
  a_sh:= StrToFloat(LabeledEdit4.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit4.SetFocus;
    exit;
  end;

  try
  h_sh:= StrToFloat(LabeledEdit5.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit5.SetFocus;
    exit;
  end;

  try
  z_sh:= StrToInt(LabeledEdit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit6.SetFocus;
    exit;
  end;

  try
  da:= 0;
  da:= StrToFloat(Edit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit1.SetFocus;
    exit;
  end;

  try
  d:=0;
  d:= StrToFloat(Edit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit2.SetFocus;
    exit;
  end;

  try
  db:= 0;
  db:= StrToFloat(Edit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit3.SetFocus;
    exit;
  end;

  try
  z:= StrToInt(Edit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit6.SetFocus;
    exit;
  end;


  try
  z:= StrToInt(Edit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit6.SetFocus;
    exit;
  end;

  try
    cap:= StrToInt(LabeledEdit7.Text);
 except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit7.SetFocus;
    exit;
  end;

  try
    kvadr:= StrToInt(LabeledEdit8.Text);
 except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit8.SetFocus;
    exit;
  end;

  if da = da_sh then
    begin
      ShowMessage('Значения диаметров вершин колеса и шестерни не должны быть равны!');
      Edit1.SetFocus;
      exit;
    end;

  if (kvadr = da_sh) or (kvadr > da_sh) then
    begin
      ShowMessage('Значение длины стороны квадрата не должно превышать диаметр вершины шестерни!');
      Edit1.SetFocus;
      exit;
    end;

  Postroenie_Sketch (OpenSW, a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr, z_sh);

  if RadioButton1.Checked=true then
    closeSWSave;
  if RadioButton2.Checked=true then
    closeSWShow;
end;

procedure TForm1.Button4Click(Sender: TObject);
var a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, cap,a,h,ugol,cug1,cug2: double;
    z,i: integer;
    z_sh:integer;
    kvadr : double;
    F:textfile;
    ModD:IModelDoc2;
begin
  try
  ugol:= StrToFloat(LabeledEdit9.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit9.SetFocus;
    exit;
  end;

  try
  a:= StrToFloat(Edit4.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit4.SetFocus;
    exit;
  end;

  try
  h:= StrToFloat(Edit5.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit5.SetFocus;
    exit;
  end;


  try
  da_sh:= StrToFloat(LabeledEdit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit1.SetFocus;
    exit;
  end;

  try
  d_sh:= StrToFloat(LabeledEdit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit2.SetFocus;
    exit;
  end;

  try
  db_sh:= StrToFloat(LabeledEdit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit3.SetFocus;
    exit;
  end;

  try
  a_sh:= StrToFloat(LabeledEdit4.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit4.SetFocus;
    exit;
  end;

  try
  h_sh:= StrToFloat(LabeledEdit5.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit5.SetFocus;
    exit;
  end;

  try
  z_sh:= StrToInt(LabeledEdit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit6.SetFocus;
    exit;
  end;

  try
  da:= 0;
  da:= StrToFloat(Edit1.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit1.SetFocus;
    exit;
  end;

  try
  d:=0;
  d:= StrToFloat(Edit2.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit2.SetFocus;
    exit;
  end;

  try
  db:= 0;
  db:= StrToFloat(Edit3.Text)/2;
  except
    ShowMessage('Некорректный ввод параметра');
    Edit3.SetFocus;
    exit;
  end;

  try
  z:= StrToInt(Edit6.Text);
  except
    ShowMessage('Некорректный ввод параметра');
    Edit6.SetFocus;
    exit;
  end;

  try
    cap:= StrToInt(LabeledEdit7.Text);
 except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit7.SetFocus;
    exit;
  end;

  try
    kvadr:= StrToInt(LabeledEdit8.Text);
 except
    ShowMessage('Некорректный ввод параметра');
    LabeledEdit8.SetFocus;
    exit;
  end;

  if da = da_sh then
    begin
      ShowMessage('Значения диаметров вершин колеса и шестерни не должны быть равны!');
      Edit1.SetFocus;
      exit;
    end;

  if kvadr >= da_sh then
    begin
      ShowMessage('Значение длины стороны квадрата не должно превышать диаметр вершины шестерни!');
      Edit1.SetFocus;
      exit;
    end;

{    AssignFile(F,'D:\Doc.txt');
   Rewrite(F);

 for I := 0 to 9 do
  begin
   VolumeCalc(OpenSW, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol+i*0.1, z_sh);
   md.SaveAs('d:\doc'+IntToStr(i)+'.sldprt');
   SW.Visible:=False;
   Writeln(F,'doc'+IntToStr(i)+#9+FloatTostr(Ugol+i*0.1)+#9+FloatToStr(md.Extension.CreateMassProperty.Volume));
  end;
  SW.Visible:=True;
    CloseFile(F); }

   ModD:=OpenSW;

   FindPlanes(MD);

  (xyPlane as IFeature).Select(false);
    MD.InsertSketch;
  MD.ICreateCircle2(0, 0, 0, (db/1000), 0, 0);

  md.FeatureManager.FeatureExtrusion2(true,false,false, 0, 0, 1/1000,0, false,false,false,false,0.0,0.0,false,false,
                                            false,false,true,false,true,0,0, true);


    i:=0;
//  for i := 0 to 7 do

  VolumeCalc(ModD, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol+i*pi/4, z_sh);
  VolumeCalc(ModD, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol+pi/4, z_sh);

 (xyPlane as IFeature).Select(false);
    MD.InsertSketch;
   MD.ICreateCircle2(0, (da-da_sh)/1000, 0,(db_sh/1000)+0.002, (da-da_sh)/1000, 0);

  md.FeatureManager.FeatureCut(True, False, True, 1, 0, 0.01, 0.01, False, False, False, False, 0.01745329251994, 0.01745329251994, False, False, False, False, False, False,False);



  VolumeCalc2(ModD, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol, z_sh);
  VolumeCalc2(ModD, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol+pi/4, z_sh);
//  VolumeCalc2(ModD, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol+pi/2, z_sh);
//  VolumeCalc2(ModD, a,h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db , z, cap, kvadr,ugol+3*pi/4, z_sh);

 cug1:=0.4;
 cug2:=1.8;

 (xyPlane as IFeature).Select(false);
 MD.InsertSketch;
 MD.ICreateLine2(0,0,0,(da/1000+0.005)*cos(cug1),(da/1000+0.005)*sin(cug1),0);
 MD.ICreateLine2(0,0,0,(da/1000+0.005)*cos(cug2),(da/1000+0.005)*sin(cug2),0);
 MD.ICreateArc2(0,0,0,(da/1000+0.005)*cos(cug1),(da/1000+0.005)*sin(cug1),0,(da/1000+0.005)*cos(cug2),(da/1000+0.005)*sin(cug2),0,-1);


 md.SetInferenceMode(True);

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
var i:byte;
begin
  if not (key in ['0'..'9', #8, DecimalSeparator]) then
    key:=#0;
end;
end.


