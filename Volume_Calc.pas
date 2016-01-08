unit Volume_Calc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_TLB, StdCtrls, Math, ComObj, SwConst_TLB, Common_Unit, extctrls;

type

TRec_POINT= record   // Точка сплайна хранится в виде записи координат
  X: double;
  Y: double;
  Z: double;
end;

MassivSheZi=array of TRec_POINT;  // Массив точек сплайна,
                                  // использовать можно только динамический массив,
                                  // статический не примет команда построения CreateSpline


Procedure VolumeCalc(MD: IModelDoc2; a, h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr,ugol: double; z_sh:integer); safecall; overload;
Procedure VolumeCalc2(MD: IModelDoc2; a, h,a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr,ugol: double; z_sh:integer); safecall; overload;

implementation

Procedure VolumeCalc(MD: IModelDoc2;a, h, a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr,ugol: double; z_sh:integer); safecall; overload;
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

  bobzub, Bob, feat, kvadrat: IFeature;
  psi, R, P1, P2, s, e1,rr, w1,q1,t1,o1,e2, w2,q2,t2,o2, b_sh, psi_shv, xp,yp,c1, c2, xv,osx, osy, x1, u: double;
  un, uk, psin,ss,cc,aa, psik, x0, y0, alfa, alfak,alfak2,cutx,cuty : extended;
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
Razmer: boolean;
PP1,PP2: ISketchPoint;              // исходная точка
    Seg: array[0..10] of ISketchSegment;   // Линии профилей пластины и обмотки
                       //цилиндрическая плоскость.. // новая построенная плоскость, касательная цилиндр.поверхности
    Zub: array[0..10] of ISketchSegment;        //линий для профиля зуба
    os: array[0..1] of IFeature;
    virez: IFeature;

    b, x_n1, y_n1, x_k1,y_k1,x_n2, y_n2, x_k2,y_k2,x_n, y_n, x_k,y_k: double;

  begin


  if MD = nil then
    MD:=OpenSW;
      if MD = nil then
   begin
     Raise EOleError.Create('не создан документ!');
    end;
    SelMgr:=md.ISelectionManager;
  if SelMgr=nil then
     Raise EOleError.Create('xm!'); //Вошел в режим эскиза

    x0:=0;
    y0:=(da-da_sh)/1000;
    alfa:=2*ugol;
    alfak:=ugol-pi/4;      // отнимая двигаем по часовой, прибавляя против


//
//
//   ЭТАП ПЕРВЫЙ
//   СОЗДАЕМ ТО, ИЗ ЧЕГО БУДЕМ ВЫРЕЗАТЬ
//
//
//

   alfak2:=alfak+pi/4; // не трогать

// зуб еще один
  if (xyPlane as IFeature).Select(false) then
    MD.InsertSketch
  else
    Raise EOleError.Create('Не выбрана плоскость!');

  zub[0]:=md.ICreateArc2(0,0,0,da*cos(alfak+pi/2)/1000,da*sin(alfak+pi/2)/1000,0,da*cos(alfak2+pi/2)/1000,da*sin(alfak2+pi/2)/1000,0,1);//окружность вершин
  zub[1]:=md.ICreateArc2(0,0,0,db*cos(alfak+pi/2)/1000,db*sin(alfak+pi/2)/1000,0,db*cos(alfak2+pi/2)/1000,db*sin(alfak2+pi/2)/1000,0,1);//окружность впадин

  Seg[0]:=md.ICreateLine2(da*cos(alfak+pi/2)/1000,da*sin(alfak+pi/2)/1000,0,db*cos(alfak+pi/2)/1000,db*sin(alfak+pi/2)/1000,0);//окружность вершин
  seg[1]:=md.ICreateLine2(da*cos(alfak2+pi/2)/1000,da*sin(alfak2+pi/2)/1000,0,db*cos(alfak2+pi/2)/1000,db*sin(alfak2+pi/2)/1000,0);//окружность впадин

  ((zub[0] as ISketchArc).GetStartPoint2 as ISketchPoint).Select(False);
  ((Seg[0] as ISketchLine).GetStartPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  md.ClearSelection;

  ((zub[0] as ISketchArc).GetEndPoint2 as ISketchPoint).Select(False);
  ((Seg[1] as ISketchLine).GetStartPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  md.ClearSelection;

  ((zub[1] as ISketchArc).GetStartPoint2 as ISketchPoint).Select(False);
  ((Seg[0] as ISketchLine).GetEndPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  md.ClearSelection;

  ((zub[1] as ISketchArc).GetEndPoint2 as ISketchPoint).Select(False);
  ((Seg[1] as ISketchLine).GetEndPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');

  md.FeatureManager.FeatureExtrusion2(true,false,false, 0, 0, 1/1000,0, false,false,false,false,0.0,0.0,false,false,
                                            false,false,true,false,true,0,0, true);



//
//
//   ЭТАП ВТОРОЙ
//   СОЗДАЕМ ПЕРВЫЙ ВЫРЕЗ
//
//
//









// зуб еще один
  if (xyPlane as IFeature).Select(false) then
    MD.InsertSketch
  else
    Raise EOleError.Create('Не выбрана плоскость!');

 if  md.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    cp:= SelMgr.IGetSelectedObject(1) as ISketchPoint
    else
    Raise EOleError.Create('Не выбрана исходная точка!');
 if cp = nil then
    Raise EOleError.Create('Не выбран указатель на исходную точку!');

  seg[1]:= md.ICreateCircle2(0, 0, 0, (da/1000), 0, 0);  // окружности
    if seg[1] = nil then
      Raise EOleError.Create('Не создана окружность вершин!');
  seg[2]:= md.ICreateCircle2(0, 0, 0, (db/1000), 0, 0);
   if seg[2] = nil then
      Raise EOleError.Create('Не создана окружность впадин!');

  {Математика}
try
  a:=a*(pi/180);                                          //перевод в радианы
  b:=pi/(2*z);
  un:= (-d/1000)*sin(a)*sin(b - a)+ (cos(a)*(sqrt(sqr(db/1000)-sqr(d/1000)*sqr(sin(b - a)))));     //для нахождения точки пересечения с диаметром вершин
  uk:= (-d/1000)*sin(a)*sin(b - a)+ (cos(a)*(sqrt(sqr(da/1000)-sqr(d/1000)*sqr(sin(b - a)))));
  x_n:=un*tan(a)+(d/1000)*(sin(b)-cos(b)*tan(a));
  y_n:=un;
  x_k:=uk*tan(a)+(d/1000)*(sin(b)-cos(b)*tan(a));
  y_k:=uk;
except
  Raise EMathError.Create('Ошибка при математических вычислениях!');
end;

   rr:=sqrt(sqr(x_n) + sqr(y_n));
   SinCos(alfak + arctan2((y_n), (x_n)), ss, cc);
   x_n1:={x_n+}rr*cc;
   y_n1:={y_n+}rr*ss;

   SinCos(alfak + arctan2((y_n), (-x_n)), ss, cc);
   x_n2:={-x_n+}rr*cc;
   y_n2:={y_n+}rr*ss;

   rr:=sqrt(sqr(x_k) + sqr(y_k));
   SinCos(alfak + arctan2((y_k), (x_k)), ss, cc);
   x_k1:={x_k+}rr*cc;
   y_k1:={y_k+}rr*ss;

   SinCos(alfak + arctan2((y_k), (-x_k)), ss, cc);
   x_k2:={-x_k+}rr*cc;
   y_k2:={y_k+}rr*ss;

  {Построение}
  zub[0]:= MD.ICreateLine2(0,0,0,0.05*cos(alfak+pi/2),0.05*sin(alfak+pi/2),0);
   if zub[0] = nil then
    Raise EOleError.Create('Не создана осевая линия!');
  zub[0].ConstructionGeometry:= true;               //превращение обычной линии в осевую
  zub[1]:=Md.ICreateLine2(x_n1, y_n1,0,x_k1,y_k1,0);    //линия правая
   if zub[1] = nil then
      Raise EOleError.Create('Не создана линия!');
  zub[2]:=Md.ICreateLine2(x_n2, y_n2,0,x_k2,y_k2,0);  //левая
   if zub[2] = nil then
      Raise EOleError.Create('Не создана линия!');

  //  простановка взаимосвязей
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

  {Отсечь}
  (seg[1] as ISketchSegment).Select(false);  //      окр большая
  md.SketchTrim(0,0,da/1000,0);

  (seg[2] as ISketchSegment).Select(false);  //      окр мал
  md.SketchTrim(0,0,db/1000,0);

// простановка размеров в эскизе
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

{Вытянуть зуб }
  virez:=md.FeatureManager.FeatureCut(True, False, True, 1, 0, 0.01, 0.01, False, False, False, False, 0.01745329251994, 0.01745329251994, False, False, False, False, False, False,False);

//
//
//   ЭТАП ТРЕТИЙ
//   СОЗДАЕМ ВТОРОЙ ВЫРЕЗ
//
//
//

if (xyPlane as IFeature).Select(false) then
    MD.InsertSketch
  else
    Raise EOleError.Create('Не выбрана плоскость!');

 if  md.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    cp:= SelMgr.IGetSelectedObject(1) as ISketchPoint
    else
    Raise EOleError.Create('Не выбрана исходная точка!');
 if cp = nil then
    Raise EOleError.Create('Не выбран указатель на исходную точку!');

  seg[1]:= md.ICreateCircle2(0, 0, 0, (da/1000), 0, 0);  // окружности
    if seg[1] = nil then
      Raise EOleError.Create('Не создана окружность вершин!');
  seg[2]:= md.ICreateCircle2(0, 0, 0, (db/1000), 0, 0);
   if seg[2] = nil then
      Raise EOleError.Create('Не создана окружность впадин!');



  rr:=sqrt(sqr(x_n) + sqr(y_n));
   SinCos(alfak2 + arctan2((y_n), (x_n)), ss, cc);
   x_n1:={x_n+}rr*cc;
   y_n1:={y_n+}rr*ss;

   SinCos(alfak2 + arctan2((y_n), (-x_n)), ss, cc);
   x_n2:={-x_n+}rr*cc;
   y_n2:={y_n+}rr*ss;

   rr:=sqrt(sqr(x_k) + sqr(y_k));
   SinCos(alfak2 + arctan2((y_k), (x_k)), ss, cc);
   x_k1:={x_k+}rr*cc;
   y_k1:={y_k+}rr*ss;

   SinCos(alfak2 + arctan2((y_k), (-x_k)), ss, cc);
   x_k2:={-x_k+}rr*cc;
   y_k2:={y_k+}rr*ss;

  {Построение}
  zub[0]:= MD.ICreateLine2(0,0,0,0.05*cos(alfak2+pi/2),0.05*sin(alfak2+pi/2),0);
   if zub[0] = nil then
    Raise EOleError.Create('Не создана осевая линия!');
  zub[0].ConstructionGeometry:= true;               //превращение обычной линии в осевую
  zub[1]:=Md.ICreateLine2(x_n1, y_n1,0,x_k1,y_k1,0);    //линия правая
   if zub[1] = nil then
      Raise EOleError.Create('Не создана линия!');
  zub[2]:=Md.ICreateLine2(x_n2, y_n2,0,x_k2,y_k2,0);  //левая
   if zub[2] = nil then
      Raise EOleError.Create('Не создана линия!');

  //  простановка взаимосвязей
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

  {Отсечь}
  (seg[1] as ISketchSegment).Select(false);  //      окр большая
  md.SketchTrim(0,0,da/1000,0);

  (seg[2] as ISketchSegment).Select(false);  //      окр мал
  md.SketchTrim(0,0,db/1000,0);

// простановка размеров в эскизе
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

{Вытянуть зуб }
  virez:=md.FeatureManager.FeatureCut(True, False, True, 1, 0, 0.01, 0.01, False, False, False, False, 0.01745329251994, 0.01745329251994, False, False, False, False, False, False,False);
end;


Procedure VolumeCalc2(MD: IModelDoc2;a, h, a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr,ugol: double; z_sh:integer); safecall; overload;
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

  bobzub, Bob, feat, kvadrat: IFeature;
  psi, R, P1, P2, s, e1,rr, w1,q1,t1,o1,e2, w2,q2,t2,o2, b_sh, psi_shv, xp,yp,c1, c2, xv,osx, osy, x1, u: double;
  un, uk, psin,ss,cc,aa, psik, x0, y0, alfa, alfak,alfak2,cutx,cuty : extended;
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
  Razmer: boolean;
  PP1,PP2: ISketchPoint;              // исходная точка
  Seg: array[0..10] of ISketchSegment;   // Линии профилей пластины и обмотки
                       //цилиндрическая плоскость.. // новая построенная плоскость, касательная цилиндр.поверхности
  Zub: array[0..10] of ISketchSegment;        //линий для профиля зуба
  os: array[0..1] of IFeature;
  virez: IFeature;

  b, x_n1, y_n1, x_k1,y_k1,x_n2, y_n2, x_k2,y_k2,x_n, y_n, x_k,y_k: double;

begin

    x0:=0;
    y0:=(da-da_sh)/1000;
    alfa:=2*ugol;
    alfak:=ugol-pi/4;      // отнимая двигаем по часовой, прибавляя против


    alfak2:=alfak+pi/4; // не трогать

        SelMgr:=md.ISelectionManager;
  if SelMgr=nil then
     Raise EOleError.Create('xm!'); //Вошел в режим эскиза

//
//
//   ЭТАП ЧЕТВЕРТЫЙ
//   СОЗДАЕМ ШЕСТЕРНЮ
//
//
//




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
//    psin:=0;
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

 //   psi:=0;
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
    x_sh[i]:=x0+((q1+e1)*w1-t1);

    q2:=(-sin(a_sh+R*psi))*P1;
    e2:=(s/R)*(cos(a_sh+R*psi))*P2;
    w2:=cos(a_sh);
    t2:=s*cos(psi);
    y_sh[i]:=y0+((q2+e2)*w2-t2);

//    Point_Gear[i]:=md.ICreatePoint2(x_sh[i], y_sh[i], 0);
    md.SetPickMode;
    inc(i);
    psi:=psi+pi/20;
  end;

  SetLength(x_sh,i);
  SetLength(y_sh,i);
  l:=0;
  SetLength(MyMas,length(x_sh)*3);




  for o:=0 to i-1 do
  begin
   rr:=sqrt(sqr(x_sh[o] - x0) + sqr(y_sh[o] - y0));
   SinCos(alfa + arctan2((y_sh[o]- y0), (x_sh[o] - x0)), ss, cc);
   MyMas[l]:=x0+rr*cc;
   inc(l);
   MyMas[l]:=y0+rr*ss;
   Inc(l);
   MyMas[l]:=0;
   Inc(l);
  end;




 cutx:=Mymas[l-3];
 cuty:=MyMas[l-2];



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
    x_shv[j]:= x0+xp*cos(R*psi)+(yp+s)*sin(R*psi)-s*sin(psi);
    y_shv[j]:= y0-xp*sin(R*psi)+(yp+s)*cos(R*psi)-s*cos(psi);
//    Point_Gearvyk[j]:=md.ICreatePoint2(x_shv[j], y_shv[j], 0);
    inc(j);
    psi:=psi+pi/20;
   end;

  SetLength(x_shv,j);
  SetLength(y_shv,j);

  l:=0;
  SetLength(MyMas,length(x_shv)*3);

  for o:=0 to j do
  begin
   rr:=sqrt(sqr(x_shv[o] - x0) + sqr(y_shv[o] - y0));
   SinCos(alfa + arctan2((y_shv[o]- y0), (x_shv[o] - x0)), ss, cc);
   MyMas[l]:=x0+rr*cc;
   inc(l);
   MyMas[l]:=y0+rr*ss;
   Inc(l);
   MyMas[l]:=0;
   Inc(l);
  end;

 IDispatch(zub[3]):=md.CreateSpline(MyMas);



  osx:=x0+cos((pi/2)-a_sh)*da/1000;
  osy:=y0+sin(a_sh)*da/1000;
  rr:=sqrt(sqr(osx - x0) + sqr(osy - y0));
  SinCos(alfa + arctan2((osy- y0), (osx - x0)), ss, cc);
  osx:=x0+rr*cc;
  osy:=y0+rr*ss;

  osevaya:=md.ICreateLine2(x0,y0,0,osx,osy,0);
  osevaya.ConstructionGeometry:=true;

  ((Osevaya as ISketchLine).GetStartPoint2 as ISketchPoint).Select(False);
  cp.Select(True);
  md.SketchAddConstraints('sgVERTPOINTS');

 {   ((Osevaya as ISketchLine).GetStartPoint2 as ISketchPoint).Select(False);
  cp.Select(True);
  MD.AddVerticalDimension(0.01,0.02,0);}

  (zub[3] as ISketchSegment).Select(False);
  MD.SketchAddConstraints('sgFIXED');
  (zub[2] as ISketchSegment).Select(False);
  MD.SketchAddConstraints('sgFIXED');
  (Osevaya as ISketchSegment).Select(False);
  MD.SketchAddConstraints('sgFIXED');

  zub[0]:=md.ICreateArc2(x0, y0, 0,x0-da_sh/1000,y0,0,  x0, y0-da_sh/1000, 0, -1);//окружность вершин
 // zub[1]:=md.ICreateArc2(x0, y0, 0,x0-db_sh/1000,y0,0,  x0, y0-db_sh/1000, 0, -1);//окружность впадин
  md.ClearSelection;

  ((zub[0] as ISketchArc).GetCenterPoint2 as ISketchPoint).Select(False);
  ((Osevaya as ISketchLine).GetStartPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  md.ClearSelection;

{  ((zub[1] as ISketchArc).GetCenterPoint2 as ISketchPoint).Select(False);
  ((Osevaya as ISketchLine).GetStartPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgMERGEPOINTS');
  md.ClearSelection;    }

  zub[0].Select(False);
  md.AddDiameterDimension(0,0,0);
  md.ClearSelection;

{ (zub[2] as ISketchSegment).Select(false);     //выбираем сплайн профиля
  (zub[0] as ISketchArc).IGetStartPoint2.Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;                          }

{  (zub[3] as ISketchSegment).Select(false);   //выбираем сплайн выкружки
  (zub[1] as ISketchArc).IGetStartPoint2.Select(true);
  md.SketchAddConstraints('sgCOINCIDENT');           }
{  (zub[3] as ISketchSegment).Select(false);   //выбираем сплайн выкружки
  (zub[1] as ISketchArc).IGetStartPoint2.Select(true);
  md.SketchAddConstraints('sgTANGENT');    }

 { zub[1].Select(False);
  md.AddDiameterDimension(0.02,0.05,0);   }

{  Osevaya.Select(False);
  ((zub[0] as ISketchArc).GetEndPoint2 as ISketchPoint).Select(True);
  md.SketchAddConstraints('sgCOINCIDENT');
  md.ClearSelection;     }

 // exit;

  (zub[0] as ISketchSegment).Select(false); //окр больш
  md.SketchTrim(1,0,x0-da_sh/1000,y0);
//  (zub[1] as ISketchSegment).Select(false);  //  окр мал
//  md.SketchTrim(0,0,x0-db_sh/1000,y0);
  (zub[2] as ISketchSegment).Select(false);
  md.SketchTrim(1,0,{x0+x_sh[i-1]}cutx,{y0+y_sh[i-1]}cuty);
 // (zub[3] as ISketchSegment).Select(false);
//  md.SketchTrim(1,0,x0+x_sh[i],y0+y_sh[i]);
  (zub[0] as ISketchSegment).Select(false);  // окр мал
  md.SketchTrim(1,0,x0,y0-da_sh/1000);
{  (zub[1] as ISketchSegment).Select(false);  // окр мал
  md.SketchTrim(1,0,x0,y0-db_sh/1000);  }

{  t1:=(zub[1] as ISketchArc).IGetStartPoint2.X;
  t2:=(zub[1] as ISketchArc).IGetStartPoint2.y;

  (zub[1] as ISketchSegment).Select(false);  //  окр мал
  md.SketchTrim(1,0,t1,t2);    }


   // отзеркалить
  zub[0].Select(false);
//  zub[1].Select(true);
  (zub[2] as ISketchSegment).Select(true);
  (zub[3] as ISketchSegment).Select(true);
  osevaya.Select(true);
  MD.SketchMirror;

  virez:=md.FeatureManager.FeatureCut(True, True, True, 1, 0, 0.01, 0.01, False, False, False, False, 0.01745329251994, 0.01745329251994, False, False, False, False, False, False,False);


{ bobzub:=md.FeatureManager.FeatureExtrusion2(true,false,false, 0, 0, h_sh/1000,0, false,false,false,false,0.0,0.0,false,false,
                                            false,false,true,false,true,0,0, true);
 }



 // virez:=md.FeatureManager.FeatureCut(True, False, True, 1, 0, 0.01, 0.01, False, False, False, False, 0.01745329251994, 0.01745329251994, False, False, False, False, False, False,False);
end;


end.

