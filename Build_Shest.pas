unit Build_Shest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_TLB, StdCtrls, Math, ComObj, SwConst_TLB, Common_Unit, extctrls;

type

Rec_POINT= record
  X: double;
  Y: double;
  Z: double;
end;

MassivSheZi= array of Rec_POINT;  //ARRAY1D


  Procedure Postroenie_Shest(MD: IModelDoc2; a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr: double; z_sh:integer); safecall; overload;

  {  private
    { Private declarations
  public
    { Public declarations }

implementation

Procedure Postroenie_Shest(MD: IModelDoc2; a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr: double; z_sh:integer); safecall; overload;
var Point_Gear: array [0..30] of ISketchPoint;
  Point_Gearvyk: array [0..30] of ISketchPoint;
  MyPoints: array[0..90] of MassivSheZi;
  SW: ISldWorks;
  hr: Hresult;
  SelMgr: ISelectionMgr;                 // Менеджер выделений
  CP: ISketchPoint;              // исходная точка
  Seg_sh: array[0..29] of ISketchSegment;   // Линии профилей пластины и обмотки
  osevaya, osevaya2:  ISketchSegment;
  mk : IDispatch;                             //цилиндрическая плоскость.. // новая построенная плоскость, касательная цилиндр.поверхности
  Zub: array[0..3] of ISketchSegment;        //линий для профиля зуба
  bobzub, Bob, feat, kvadrat: IFeature;
  psi, R, P1, P2, s, e1, w1,q1,t1,o1,e2, w2,q2,t2,o2, b_sh, psi_shv, xp,yp,c1, c2, xv,osx, osy, x1, u: double;
  un, uk, psin, psik : extended;
  i, j, l, o :integer;
  x_sh: array of double;
  y_sh: array of double;
  x_shv: array of double;
  y_shv: array of double;
  MyMas: array of double;
  pd: IPartDoc;
  body: IBody2;
  face: IFace2;
  bodies: Variant;



  begin
    MD:=OpenSW;
      if MD = nil then
   begin
     Raise EOleError.Create('не создан документ!');
    end;
    SelMgr:=md.ISelectionManager;
  if SelMgr=nil then
     Raise EOleError.Create('xm!'); //Вошел в режим эскиза

   FindPlanes(MD);

 if (yzPlane as IFeature).Select(False) then
    md.InsertSketch
    else
    Raise EOleError.Create('Не выбрана плоскость!');

 if md.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
     cp:= SelMgr.IGetSelectedObject(1) as ISketchPoint
     else
    Raise EOleError.Create('Не выбрана исходная точка!');
 if cp = nil then
    Raise EOleError.Create('Не выбран указатель на исходную точку!');

  Seg_sh[0]:= md.ICreateLine2(0, 0, 0, db_sh/1000, 0, 0);
  if seg_sh[0] = nil then
    Raise EOleError.Create('Не создана осевая линия!');
  Seg_sh[0].ConstructionGeometry:=true;
  MD.SketchAddConstraints('sgHORIZONTAL');

  Seg_sh[2]:= md.ICreateLine2(-h_sh/1000, db_sh/1000, 0, 0, db_sh/1000, 0);
  if seg_sh[2] = nil then
    Raise EOleError.Create('Не создана линия 1!');
  MD.SketchAddConstraints('sgHORIZONTAL');
  Seg_sh[3]:= md.ICreateLine2(0, db_sh/1000, 0, 0, 50/2000, 0);
  if seg_sh[3] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');
  Seg_sh[4]:= md.ICreateLine2(0, 50/2000, 0, 48/1000, 50/2000, 0);
  if seg_sh[4] = nil then
    Raise EOleError.Create('Не создана  линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');
  Seg_sh[5]:= md.ICreateLine2(48/1000, 50/2000, 0, 48/1000, 45/2000, 0);
  if seg_sh[5] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');
  Seg_sh[6]:= md.ICreateLine2(48/1000, 45/2000, 0, 72/1000, 45/2000, 0);
  if seg_sh[6] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');
  Seg_sh[7]:= md.ICreateLine2(72/1000, 45/2000, 0, 72/1000, 42/2000, 0);
  if seg_sh[7] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');
  Seg_sh[8]:= md.ICreateLine2(72/1000, 42/2000, 0, 88/1000, 42/2000, 0);
  if seg_sh[8] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');
  Seg_sh[9]:= md.ICreateLine2(88/1000, 42/2000, 0, 88/1000, 0, 0);
  if seg_sh[9] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');


  Seg_sh[13]:= md.ICreateLine2(-h_sh/1000, db_sh/1000, 0, -h_sh/1000, 50/2000, 0);
  if seg_sh[13] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');

  Seg_sh[14]:= md.ICreateLine2(-h_sh/1000, 50/2000, 0, (-h_sh-48)/1000, 50/2000, 0);
  if seg_sh[14] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');

  Seg_sh[15]:= md.ICreateLine2((-h_sh-48)/1000, 50/2000, 0, (-h_sh-48)/1000, 45/2000, 0);
  if seg_sh[15] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');

  Seg_sh[16]:= md.ICreateLine2((-h_sh-48)/1000, 45/2000, 0, (-h_sh-72)/1000, 45/2000, 0);
  if seg_sh[16] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');

  Seg_sh[17]:= md.ICreateLine2((-h_sh-72)/1000, 45/2000, 0, (-h_sh-72)/1000, 42/2000, 0);
  if seg_sh[17] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');

  Seg_sh[18]:= md.ICreateLine2((-h_sh-72)/1000, 42/2000, 0, (-h_sh-88)/1000, 42/2000, 0);
  if seg_sh[18] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');

  Seg_sh[19]:= md.ICreateLine2((-h_sh-88)/1000, 42/2000, 0, (-h_sh-88)/1000, 40/2000, 0);
  if seg_sh[19] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');

  Seg_sh[20]:= md.ICreateLine2((-h_sh-88)/1000, 40/2000, 0, (-h_sh-111)/1000, 40/2000, 0);
  if seg_sh[20] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');

  Seg_sh[21]:= md.ICreateLine2((-h_sh-111)/1000, 40/2000, 0, (-h_sh-111)/1000, 38/2000, 0);
  if seg_sh[21] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');

  Seg_sh[22]:= md.ICreateLine2((-h_sh-111)/1000, 38/2000, 0, (-h_sh-209)/1000, 38/2000, 0);
  if seg_sh[22] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgHORIZONTAL');

  Seg_sh[23]:= md.ICreateLine2((-h_sh-209)/1000, 38/2000, 0,(-h_sh-209)/1000, 0, 0);
  if seg_sh[23] = nil then
    Raise EOleError.Create('Не создана линия!');
  MD.SketchAddConstraints('sgVERTICAL');

  Seg_sh[0].Select(false);
  bob:=md.FeatureManager.FeatureRevolve(2*pi,false,0,0,0,true,false,false);

 if (xyPlane as IFeature).Select(False) then
     md.InsertSketch
     else
  Raise EOleError.Create('Не выбрана плоскость!');

 if  md.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    cp:= SelMgr.IGetSelectedObject(1) as ISketchPoint
    else
    Raise EOleError.Create('Не выбрана исходная точка!');
 if cp = nil then
    Raise EOleError.Create('Не выбран указатель на исходную точку!');

    MD.ShowNamedView2('',0);

{Математика}
    u:=0;
    psin:=0;
    psik:=0;
    i:=0;
    b_sh:=pi/(2*z);
    s:=(da-da_sh)/1000;
    R:=(1-(d_sh/d));
    a_sh:=a_sh*(pi/180);
    P1:= d/1000*(sin((b_sh))-cos(b_sh)*Tan(a_sh));

    un:= (-d/1000)*sin(a_sh)*sin(b_sh - a_sh)+ (cos(a_sh)*(sqrt(sqr(db/1000)-sqr(d/1000)*sqr(sin(b_sh - a_sh)))));
    u:=(d/d_sh)*((a_sh - arccos((R/(s*cos(a_sh)))*(un+(d/1000)*sin(a_sh)*sin(b_sh - a_sh)))));

    c2:=(sqr(da_sh/1000))-(P1*P1*sqr(cos(a_sh)))-((s*s*(sqr(1-R)))/(R*R));
    xv:=(c2)/((2*s*cos(a_sh)*P1));
    psik:=(arcsin(xv)+a_sh)/(1-R);

    psi:=0;
    psin:=u;
    psi:=psin;

    SetLength(x_sh,100);
    SetLength(y_sh,100);

  while ((psi=psin) or (psi>psin)) and ((psi<pi/2) or (psi=pi/2)) do
   begin

    P2:=tan(a_sh)*sin(psi-R*psi)+cos(psi-R*psi);
    q1:=(cos((a_sh)+R*psi))*P1;
    e1:=(s/R)*(sin(a_sh+R*psi))*P2;
    w1:=cos(a_sh);
    t1:=s*sin(psi);
    x_sh[i]:=(q1+e1)*w1-t1;

    q2:=(-sin(a_sh+R*psi))*P1;
    e2:=(s/R)*(cos(a_sh+R*psi))*P2;
    w2:=cos(a_sh);
    t2:=s*cos(psi);
    y_sh[i]:=(q2+e2)*w2-t2;

    Point_Gear[i]:=md.ICreatePoint2(x_sh[i], y_sh[i], 0);
    md.SetPickMode;
    inc(i);
    psi:=psi+pi/20;
  end;

  SetLength(x_sh,i);
  SetLength(y_sh,i);
  l:=0;
  SetLength(MyMas,length(x_sh)*3);

  for o:=0 to i do
  begin
   MyMas[l]:=x_sh[o];
   inc(l);
   MyMas[l]:=y_sh[o];
   Inc(l);
   MyMas[l]:=0;
   Inc(l);
  end;
 IDispatch(zub[2]):=md.CreateSpline(MyMas);

 {выкружка}

   xp:=un*tan(a_sh)+P1;
   yp:=un-s;
   c1:=(sqr(db_sh/1000)-sqr(xp)-sqr(yp)-sqr(s))/(2*s);
   x1:= ((-2*c1*(yp+s))+(2*xp*sqrt(sqr(xp)+sqr(yp+s)-sqr(c1))))/(2*(sqr(xp)+sqr(yp+s)));
   psi_shv:= (arccos(x1))/(R-1);
   psi:=psin;

   SetLength(x_shv,100);
   SetLength(y_shv,100);
   j:=0;

   while (psi<=pi/10) and (psi>=psin) do
   begin
    x_shv[j]:= xp*cos(R*psi)+(yp+s)*sin(R*psi)-s*sin(psi);
    y_shv[j]:= -xp*sin(R*psi)+(yp+s)*cos(R*psi)-s*cos(psi);
    Point_Gearvyk[j]:=md.ICreatePoint2(x_shv[j], y_shv[j], 0);
    inc(j);
    psi:=psi+pi/20;
   end;

  SetLength(x_shv,j);
  SetLength(y_shv,j);

  l:=0;
  SetLength(MyMas,length(x_shv)*3);

  for o:=0 to j do
  begin
   MyMas[l]:=x_shv[o];
   inc(l);
   MyMas[l]:=y_shv[o];
   Inc(l);
   MyMas[l]:=0;
   Inc(l);
  end;

 IDispatch(zub[3]):=md.CreateSpline(MyMas);

  osx:=cos((pi/2)-a_sh)*da_sh;
  osy:=sin(a_sh)*da_sh;
  osevaya:=md.ICreateLine2(0,0,0,osx/500,osy/500,0);
  osevaya.ConstructionGeometry:=true;

  zub[0]:=md.ICreateArc2(0,0,0, 0, da_sh/1000, 0, da_sh/1000, 0, 0, -1);//окружность вершин
  zub[1]:=md.ICreateArc2(0,0,0, 0, db_sh/1000, 0, db_sh/1000, 0, 0, -1);//окружность впадин
  md.ClearSelection;

  zub[0].Select(False);
  cp.Select(true);
  md.SketchAddConstraints('sgCONCENTRIC');
  md.ClearSelection;

  zub[0].Select(False);
  md.AddDiameterDimension(0,0,0);
  md.ClearSelection;

  (zub[2] as ISketchSegment).Select(false);     {выбираем сплайн профиля}
  (zub[0] as ISketchArc).IGetStartPoint2.Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;

//  md.SelectAt(1,0,db_sh/1000,0);      //выбор твердотельной кромки

  (zub[3] as ISketchSegment).Select(false);   {выбираем сплайн выкружки}
  (zub[1] as ISketchArc).IGetStartPoint2.Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;

  zub[1].Select(False);
  md.AddDiameterDimension(0.02,0.05,0);
  md.ClearSelection;

  cp.Select(False);
  zub[1].Select(true);
  md.SketchAddConstraints('sgCONCENTRIC');
  md.ClearSelection;

  osevaya.Select(false);
  md.SketchAddConstraints('sgFIXED');

  (zub[0] as ISketchSegment).Select(false); //окр больш
  md.SketchTrim(1,0,da_sh/1000,0);
  (zub[1] as ISketchSegment).Select(false);  //  окр мал
  md.SketchTrim(0,0,da_sh/1000,0);
  (zub[2] as ISketchSegment).Select(false);
  md.SketchTrim(1,0,x_sh[i-1],y_sh[i-1]);
  (zub[3] as ISketchSegment).Select(false);
  md.SketchTrim(1,0,x_sh[i],y_sh[i]);
  (zub[1] as ISketchSegment).Select(false);  // окр мал
  md.SketchTrim(0,0,0,db_sh/1000);

   // отзеркалить
  zub[0].Select(false);
  zub[1].Select(true);
  (zub[2] as ISketchSegment).Select(true);
  (zub[3] as ISketchSegment).Select(true);
  osevaya.Select(true);
  MD.SketchMirror;

bobzub:=md.FeatureManager.FeatureExtrusion2(true,false,false, 0, 0, h_sh/1000,0, false,false,false,false,0.0,0.0,false,false,
                                            false,false,true,false,true,0,0, true);
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
  bobzub.SelectByMark(true, 4);
  feat:=  md.FeatureManager.FeatureCircularPattern2(z_sh, (2*pi)/z_sh, false, 'NULL', false);

  if feat=nil then
  ShowMessage('не построилось');
   {Вырез}
    (xyPlane as IFeature).Select(False);
    mk:=md.CreatePlaneAtOffset3(cap/1000,false,true);
    md.ClearSelection;
    (mk as IFeature).Select(false);
    md.InsertSketch;

    seg_sh[24]:=md.ICreateLine2(0, (cos(pi/4)* kvadr)/1000, 0, (cos(pi/4)* kvadr)/1000, 0, 0);
    seg_sh[25]:=md.ICreateLine2((cos(pi/4)* kvadr)/1000, 0, 0, 0, -(cos(pi/4)* kvadr)/1000, 0);
    seg_sh[26]:=md.ICreateLine2(-(cos(pi/4)* kvadr)/1000, 0, 0, 0, -(cos(pi/4)* kvadr)/1000, 0);
    seg_sh[27]:=md.ICreateLine2(-(cos(pi/4)* kvadr)/1000, 0, 0, 0, (cos(pi/4)* kvadr)/1000, 0);

    (seg_sh[24] as ISketchLine).IGetStartPoint2.Select(false);
    (seg_sh[27] as ISketchLine).IGetEndPoint2.Select(true);
    md.SketchAddConstraints('sgMERGEPOINTS');

    kvadrat:=md.FeatureManager.FeatureCut(True, False, True, 0, 0,(h_sh-2*cap)/1000,0, False, False, False, False,
          0,0,true,false,false,false, false, true, true);
  end;

end.

