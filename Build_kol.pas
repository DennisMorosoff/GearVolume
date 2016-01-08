unit Build_kol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_TLB, StdCtrls, Common_Unit, Math, ComObj, SwConst_TLB;

  procedure postroenie_kolesa (a, da, db, d, h: double; z:integer); overload;

{  private
    { Private declarations
  public
    { Public declarations }

implementation

procedure postroenie_kolesa (a, da, db, d, h: double; z:integer); overload;
var Razmer: boolean;
    MD: IModelDoc2;                         // �������� ������      !!!MD(2)!!!
    SelMgr: ISelectionMgr;                 // �������� ���������
    CP,PP1,PP2: ISketchPoint;              // �������� �����
    Seg: array[0..10] of ISketchSegment;   // ����� �������� �������� � �������
    mk : IDispatch;                             //�������������� ���������.. // ����� ����������� ���������, ����������� �������.�����������
    Zub: array[0..10] of ISketchSegment;        //����� ��� ������� ����
    os: array[0..1] of IFeature;
    virez, Bob, feat: IFeature;
    SW: ISldWorks;
    hr: Hresult;
    b, un, uk, x_n, y_n, x_k,y_k: double;
    pd: IPartDoc;
    body: IBody2;
    face: IFace2;
    bodies: Variant;

begin

  MD:=OpenSW;
    if MD = nil then
  begin
    Raise EOleError.Create('�� ������ ��������!');
  end;

    SelMgr:=md.ISelectionManager;
  if SelMgr=nil then
    Raise EOleError.Create('xm!'); //����� � ����� ������

  FindPlanes(MD);

 if (yzPlane as IFeature).Select(False) then
   md.InsertSketch
 else
    Raise EOleError.Create('�� ������� ���������!');

 if md.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
   cp:= SelMgr.IGetSelectedObject(1) as ISketchPoint
   else
    Raise EOleError.Create('�� ������� �������� �����!');
 if cp = nil then
    Raise EOleError.Create('�� ������ ��������� �� �������� �����!');

// ��� ��� ����
  if (xyPlane as IFeature).Select(false) then
    MD.InsertSketch
  else
    Raise EOleError.Create('�� ������� ���������!');

  seg[1]:= md.ICreateCircle2(0, 0, 0, (da/1000), 0, 0);  // ����������
    if seg[1] = nil then
      Raise EOleError.Create('�� ������� ���������� ������!');
  seg[2]:= md.ICreateCircle2(0, 0, 0, (db/1000), 0, 0);
   if seg[2] = nil then
      Raise EOleError.Create('�� ������� ���������� ������!');

  {����������}
try
  a:=a*(pi/180);                                          //������� � �������
  b:=pi/(2*z);
  un:= (-d/1000)*sin(a)*sin(b - a)+ (cos(a)*(sqrt(sqr(db/1000)-sqr(d/1000)*sqr(sin(b - a)))));     //��� ���������� ����� ����������� � ��������� ������
  uk:= (-d/1000)*sin(a)*sin(b - a)+ (cos(a)*(sqrt(sqr(da/1000)-sqr(d/1000)*sqr(sin(b - a)))));
  x_n:=un*tan(a)+(d/1000)*(sin(b)-cos(b)*tan(a));
  y_n:=un;
  x_k:=uk*tan(a)+(d/1000)*(sin(b)-cos(b)*tan(a));
  y_k:=uk;
except
  Raise EMathError.Create('������ ��� �������������� �����������!');
end;

  {����������}
  zub[0]:= MD.ICreateLine2(0,0.0,0,0,0.05,0);
   if zub[0] = nil then
    Raise EOleError.Create('�� ������� ������ �����!');
  zub[0].ConstructionGeometry:= true;               //����������� ������� ����� � ������
  zub[1]:=Md.ICreateLine2(x_n, y_n,0,x_k,y_k,0);    //����� ������
   if zub[1] = nil then
      Raise EOleError.Create('�� ������� �����!');
  zub[2]:=Md.ICreateLine2(-x_n, y_n,0,-x_k,y_k,0);  //�����
   if zub[2] = nil then
      Raise EOleError.Create('�� ������� �����!');

  md.ShowNamedView2('', 0);

  //  ����������� ������������
  (zub[1] as ISketchLine).IGetEndPoint2.Select(false);
  seg[1].Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;

  (zub[1] as ISketchLine).IGetStartPoint2.Select(false);
  seg[2].Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;

  (zub[2] as ISketchLine).IGetStartPoint2.Select(false);
  seg[2].Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;

  (zub[2] as ISketchLine).IGetEndPoint2.Select(false);
  seg[1].Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;

  seg[1].Select(False);
  cp.Select(True);
  md.SketchAddConstraints('sgCONCENTRIC');
  md.ClearSelection;

  seg[2].Select(False);
  cp.Select(True);
  md.SketchAddConstraints('sgCONCENTRIC');

  zub[1].Select(False);
  zub[2].Select(True);
  zub[0].Select(True);
  md.SketchAddConstraints('sgSYMMETRIC');

  zub[1].Select(False);
  zub[2].Select(True);
  md.SketchAddConstraints('sgSAMELENGTH');

  zub[0].Select(False);
  md.SketchAddConstraints('sgVERTICAL');
  {������}
  (seg[1] as ISketchSegment).Select(false);  //      ��� �������
  md.SketchTrim(0,0,da/1000,0);

  (seg[2] as ISketchSegment).Select(false);  //      ��� ���
  md.SketchTrim(0,0,db/1000,0);

// ����������� �������� � ������
  seg[1].Select(false);
  md.AddDiameterDimension(0, da/2000, 0);

  seg[2].Select(false);
  md.AddDiameterDimension ( db/2000, 0, 0);

  zub[1].Select(false);
  zub[2].Select(True);
  md.AddDimension(0, d/1000+0.01, 0);

  (zub[1] as ISketchLine).IGetEndPoint2.Select(false);
  (zub[2] as ISketchLine).IGetEndPoint2.Select(true);
  md.AddDimension(0, d/1000, 0);
  md.ClearSelection;

{�������� ���}
  virez:=md.FeatureManager.FeatureExtrusion2(true,false,false, 0, 0, h/1000,0, false,false,false,false,0.0,0.0,false,false,
                                            false,false,true,false,true,0,0, true);

//// ���������� �������� �����

 if (yzPlane as IFeature).Select(false) then
  MD.InsertSketch
 else
  Raise EOleError.Create('�� ������� ���������!');

  md.ShowNamedView2('', 0);

  Seg[0]:= md.ICreateLine2(0, 0, 0, da/1000, 0, 0);
   if seg[0] = nil then
      Raise EOleError.Create('�� ������� ������ �����!');
  Seg[0].ConstructionGeometry:=true;
  Seg[0].Select(false);
  MD.SketchAddConstraints('sgHORIZONTAL');

  seg[3]:=md.ICreateLine2(0, da/1000, 0, (h/1000)/10, da/1000, 0); //����� 1
   if seg[3] = nil then
      Raise EOleError.Create('�� ������� �����!');
  MD.SketchAddConstraints('sgHORIZONTAL');
  md.AddHorizontalDimension ((h/1000)/10/2, da/1000+0.05, 0);

  seg[4]:=md.ICreateLine2(h/1000/10, da/1000, 0, (h/1000)/10, (db-db/40)/1000, 0); //����� 2
   if seg[4] = nil then
      Raise EOleError.Create('�� ������� �����!');
  MD.SketchAddConstraints('sgVERTICAL');
  md.AddVerticalDimension (h/1000+0.05, da/1000/2, 0);

  seg[5]:=md.ICreateLine2((h/1000)/10, (db-db/40)/1000, 0, 0, (db-db/40)/1000, 0); //����� 3
   if seg[5] = nil then
      Raise EOleError.Create('�� ������� �����!');
  MD.SketchAddConstraints('sgHORIZONTAL');

  seg[6]:=md.ICreateLine2(0, (db-db/40)/1000, 0, 0, da/1000, 0); //����� 4
   if seg[6] = nil then
      Raise EOleError.Create('�� ������� �����!');
  MD.SketchAddConstraints('sgVERTICAL');

  seg[6].Select(false);
  CP.Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');

  seg[3].Select(false);
  CP.Select(true);
  md.AddVerticalDimension(0, 50/1000, -0.130);

  seg[7]:= MD.ICreateLine2(-h/1000/2, 0, 0, -h/1000/2, da/1000, 0);
   if seg[7] = nil then
      Raise EOleError.Create('�� ������� ������ �����!');
  Seg[7].ConstructionGeometry:= true;
  MD.SketchAddConstraints('sgVERTICAL');

  Seg[7].Select(false);
  CP.Select(true);
  MD.AddHorizontalDimension(0, da/1000+0.05, h/2/1000);

  Seg[3].Select(false);
  Seg[4].Select(true);
  Seg[5].Select(true);
  Seg[6].Select(true);
  Seg[7].Select(true);
  MD.SketchMirror;

  {������ ����������}
  seg[0].Select(false);
  bob:=MD.FeatureManager.FeatureRevolve(2*pi,false,0,0,0,true,false,false);

 {����� �������������� ����������� � ������  }
  pd:= md as IPartDoc;
  bodies:= pd.getbodies(swSolidBody);
  body:= IDispatch(bodies[0]) as IBody2;
  face:= body.IGetFirstFace;
  while face <> nil do
  begin
    if face.IGetSurface.IsCylinder then
    begin
      break;
    end;
    face:= face.IGetNextFace;
  end;
  (face as IEntity).SelectByMark(false, 1);
  virez.SelectByMark(true, 4);
  feat:=  md.FeatureManager.FeatureCircularPattern2(z, (2*pi)/z, false, 'NULL', false);
  if feat=nil then
    begin
      (face as IEntity).SelectByMark(false, 1); //�������� ������ �������������� �����������
      {os[0]:=}md.InsertAxis2(true);                     // ��������� ���

      {os[0].Select(False); }
      virez.SelectByMark(true, 4);
      feat:=  md.FeatureManager.FeatureCircularPattern2(z, (2*pi)/z, false, 'NULL', false);

    end

  else
    ShowMessage('����������� ');
end;
end.
