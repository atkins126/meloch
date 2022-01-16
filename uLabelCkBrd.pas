unit uLabelCkBrd;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,Vcl.StdCtrls,Vcl.ComCtrls,Vcl.ExtCtrls;
  type
  TLabelPanelHint = class (TLabel)
   private
     FPanelHint:TPanel;
     FPanelHintMouseButton:TMouseButton;
     FTimer:TTimer;
   protected
     procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);override;
     procedure PanelHintShow;virtual;
     procedure PanelHintTimer(S:TObject);virtual;
     procedure SetName(const NewName: TComponentName);override;
     procedure SetParent(AParent: TWinControl);override;
   public
     constructor Create(AOwner:TComponent); override;
   published
    property PanelHint: TPanel read FPanelHint write FPanelHint;
    property Timer: TTimer read FTimer write FTimer;
    property PanelHintMouseButton: TMouseButton read FPanelHintMouseButton write FPanelHintMouseButton default TMouseButton.mbLeft;

  end;

  procedure Register;
implementation

procedure Register;
begin
  RegisterComponents('LabelPanelHint', [TLabelPanelHint]);
end;

type
TLocComponent= class(TComponent);

constructor TLabelPanelHint.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FPanelHint:= TPanel.Create(self);
  FPanelHint.BevelOuter:=bvnone;
  FPanelHint.ParentBackground:=false;
  FPanelHint.Caption:='Cкопировано';
  FPanelHint.Font.Color:=clwhite;
  FPanelHint.Font.Size:=12;
  FPanelHint.Width:=180;
  FPanelHint.Height:=50;
  FPanelHint.Color:=clgreen;
  FTimer:=TTimer.Create(self);
  FTimer.Interval:=2000;
  FTimer.Enabled:=false;
  FTimer.OnTimer:= PanelHintTimer;

  Include(TLocComponent(FTimer).FComponentStyle, csSubComponent);
  Include(TLocComponent(FPanelHint).FComponentStyle, csSubComponent);
end;
procedure TLabelPanelHint.SetName(const NewName: TComponentName);
begin
   inherited;
   FPanelHint.name:= 'PanelHint';
   FTimer.name:= 'Timer';
end;
procedure TLabelPanelHint.SetParent(AParent: TWinControl);
begin
  inherited;
end;
procedure TLabelPanelHint.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Button=FPanelHintMouseButton)then
  PanelHintShow;
end;
procedure TLabelPanelHint.PanelHintShow;
var PointMouse: TPoint;
begin
   if  Assigned(Parent) and Parent.CanFocus  then
   begin

          { если хотим чтобы парентом была форма
       if Assigned(Parent) and not (Parent is TCustomForm) then
            FPanelHint.Parent:=GetParentForm(TControl(Owner))
       else
        if not Assigned(Parent) and (Owner is TControl)  then
         FPanelHint.Parent:=GetParentForm(TControl(Owner));

       if not Assigned(FPanelHint.Parent) then  exit;
         }

        //я поставлю тот контрол что является парентом label

        FPanelHint.Parent:=Parent;
        Winapi.Windows.GetCursorPos(PointMouse);
        Winapi.Windows.ScreenToClient(FPanelHint.Parent.Handle, PointMouse );
       //вот сдесь можно изменять где панель будет отображена если не устраивает ее положение
       FPanelHint.Top:= PointMouse.Y-10 - FPanelHint.Height;
       FPanelHint.Left:= PointMouse.X-10;
       ////////////////////////////////////////////////////////////////////////////////////

       FPanelHint.Visible:=true;
       FPanelHint.BringToFront;
       FTimer.Enabled:=true;
   end;
end;
procedure TLabelPanelHint.PanelHintTimer;
begin
    FTimer.Enabled:=false;
    if FPanelHint.Visible then
    begin
    FPanelHint.Visible:=false;
    FPanelHint.Parent:= nil;
    end;
end;

end.
