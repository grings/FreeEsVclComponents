{******************************************************************************}
{                       EsVclComponents/EsVclCore v3.0                         }
{                           errorsoft(c) 2009-2018                             }
{                                                                              }
{                     More beautiful things: errorsoft.org                     }
{                                                                              }
{           errorsoft@mail.ru | vk.com/errorsoft | github.com/errorcalc        }
{              errorsoft@protonmail.ch | habrahabr.ru/user/error1024           }
{                                                                              }
{         Open this on github: github.com/errorcalc/FreeEsVclComponents        }
{                                                                              }
{ You can order developing vcl/fmx components, please submit requests to mail. }
{ �� ������ �������� ���������� VCL/FMX ���������� �� �����.                   }
{******************************************************************************}
unit ES.VclFix;

interface

{$I EsDefines.inc}
{$SCOPEDENUMS ON}

uses
  Vcl.ComCtrls, WinApi.Messages, WinApi.CommCtrl;

type
  TCustomListView = class(Vcl.ComCtrls.TCustomListView)
    // Fix D1: Selection blinking if used LVM_SETEXTENDEDLISTVIEWSTYLE (blue transparent selection rect)
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    // Fix U2: Used style selection rectangle in Win3.1: inverted pixels, expected: blue transparent selection rect
    procedure LVMSetExtendedListViewStyle(var Message: TMessage); message LVM_SETEXTENDEDLISTVIEWSTYLE;
  end;

  TListView = class(Vcl.ComCtrls.TListView)
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure LVMSetExtendedListViewStyle(var Message: TMessage); message LVM_SETEXTENDEDLISTVIEWSTYLE;
  end;

implementation

uses
  Vcl.Themes, Vcl.Controls, ES.StyleHooks;

{ TCustomListView }

procedure TCustomListView.LVMSetExtendedListViewStyle(var Message: TMessage);
begin
  if (GetComCtlVersion >= ComCtlVersionIE6) and ThemeControl(Self) and
    (StyleServices.IsSystemStyle {$IFDEF VER240UP}or not(seClient in Self.StyleElements){$ENDIF}) then
  begin
    Message.LParam := Message.LParam or LVS_EX_DOUBLEBUFFER;
    DefaultHandler(Message);
  end else
    Inherited;
end;

procedure TCustomListView.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  DefaultHandler(Message);
end;

{ TListView }

procedure TListView.LVMSetExtendedListViewStyle(var Message: TMessage);
begin
  if (GetComCtlVersion >= ComCtlVersionIE6) and ThemeControl(Self) and
    (StyleServices.IsSystemStyle {$IFDEF VER240UP}or not(seClient in Self.StyleElements){$ENDIF}) then
  begin
    Message.LParam := Message.LParam or LVS_EX_DOUBLEBUFFER;
    DefaultHandler(Message);
  end else
    Inherited;
end;

procedure TListView.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  DefaultHandler(Message);
end;

end.
