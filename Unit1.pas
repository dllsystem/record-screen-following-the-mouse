unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, TlHelp32, PsAPI,
  Vcl.AppEvnts, Vcl.ExtCtrls, VidGrab;

const
  HOTKEY_ID = 1;  // Identificador da Hotkey
  WM_HOTKEY = $0312; // Código da mensagem WM_HOTKEY


  type
  TFormPositionResult = (fpInside, fpOutsideLeft, fpOutsideRight, fpOutsideTop, fpOutsideBottom);

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    ckFollowMouse: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    VideoGrabber1: TVideoGrabber;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel4MouseEnter(Sender: TObject);
    procedure Panel3MouseEnter(Sender: TObject);
    procedure Panel2MouseEnter(Sender: TObject);
    procedure Panel5MouseEnter(Sender: TObject);
    procedure Panel6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel6MouseEnter(Sender: TObject);
    procedure Panel7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7MouseEnter(Sender: TObject);
    procedure Panel7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel8MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel8MouseEnter(Sender: TObject);
    procedure Panel8MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel9MouseEnter(Sender: TObject);
    procedure Panel9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure VideoGrabber1ResizeVideo(Sender: TObject; SourceWidth,
      SourceHeight: Integer);
    procedure VideoGrabber1RecordingStarted(Sender: TObject; FileName: string);
    procedure VideoGrabber1RecordingCompleted(Sender: TObject; FileName: string;
      Success: Boolean);
    procedure VideoGrabber1RecordingPaused(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure VideoGrabber1RecordingReadyToStart(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    // var
    // FAppEvents: TApplicationEvents;
    FFoundControl: Boolean;
    FCurrentControl: TWinControl;

    Resizing: Boolean;      // Variável para indicar se está redimensionando

    MouseIsDown: Boolean;
    InitialMousePosX, InitialMousePosY: Integer;
    isRecording: boolean;

    procedure WndProc(var Msg: TMessage); override;
    procedure HandleHotKey;
    procedure MakeFormTransparent;
    procedure MakeFormNormal;
    function IsPointInForm(Form: TForm; X, Y: Integer): Boolean;
    function CheckFormPosition(Form: TForm; X, Y: Integer): TFormPositionResult;
    procedure updateRecording();
    procedure updateCropPosition();
//    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
        MouseHook: HHOOK;

implementation


Type
  tagMSLLHOOKSTRUCT = record
    pt: TPoint;
    mouseData: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;
  TMSLLHOOKSTRUCT = tagMSLLHOOKSTRUCT;
  PMSLLHOOKSTRUCT = ^TMSLLHOOKSTRUCT;


  procedure RemoveTitleBar(Form: TForm);
var
  Style: LongInt;
begin
  // Obter o estilo atual da janela
  Style := GetWindowLong(Form.Handle, GWL_STYLE);
  // Remover o estilo WS_CAPTION (barra de título e bordas)
  Style := Style and not WS_CAPTION;
  // Aplicar o novo estilo à janela
  SetWindowLong(Form.Handle, GWL_STYLE, Style);
  // Redesenhar a janela para aplicar as mudanças
  SetWindowPos(Form.Handle, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED);
end;

procedure setLeftPos(mouseX: integer);
var
  posLeft: integer;
begin
  posLeft := mouseX;
  if (posLeft < 0) then posLeft := 0;
  if (posLeft + Form1.Width > screen.DesktopWidth ) then posLeft := screen.DesktopWidth + Form1.Width;
  Form1.Left := posLeft;
end;


procedure setRightPos(mouseX: integer);
var
  posLeft: integer;
begin
  posLeft := mouseX - Form1.Width;
  if (posLeft + Form1.Width > screen.DesktopWidth ) then posLeft := screen.DesktopWidth - Form1.Width;
  Form1.Left := posLeft;
end;

procedure setTopPos(mouseY:integer);
var
  posTop: integer;
begin
  posTop := mouseY;
  if (posTop < 0) then posTop := 0;
  Form1.Top := posTop;
end;


procedure setBottomPos(mouseY: integer);
var
  posTop: integer;
begin
  posTop := mouseY - Form1.Height;
  if (posTop + Form1.Height > screen.DesktopHeight ) then posTop := screen.DesktopTop - Form1.Height;
  Form1.Top := posTop;
end;


function LowLevelMouseProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  MouseStruct: PMSLLHOOKSTRUCT;
  posLeft: integer;
  posTop: integer;
  mouseInForm: boolean;
  PosResult: TFormPositionResult;
begin
  if (nCode = HC_ACTION) then
  begin
    MouseStruct := PMSLLHOOKSTRUCT(lParam);
    if (wParam = WM_MOUSEMOVE) then
    begin
      // Aqui, capturamos a posição global do mouse
      Form1.Caption := Format('X: %d, Y: %d', [MouseStruct^.pt.x, MouseStruct^.pt.y]);

      if Form1.ckFollowMouse.Checked then
      begin
        PosResult := Form1.CheckFormPosition(Form1, MouseStruct^.pt.x, MouseStruct^.pt.y);
        case PosResult of
          fpInside:
            begin
              // Form1.Memo1.Lines.Add('O ponto está dentro do formulário.');
            end;
          fpOutsideLeft:
            begin
              //Form1.Memo1.Lines.Add('O ponto está fora do lado esquerdo.');
              setLeftPos(MouseStruct^.pt.x);
            end;
          fpOutsideRight:
            begin
              //Form1.Memo1.Lines.Add('O ponto está fora do lado direito.');
              setRightPos(MouseStruct^.pt.x);
            end;
          fpOutsideTop:
            begin
              //Form1.Memo1.Lines.Add('O ponto está fora do lado superior.');
              setTopPos(MouseStruct^.pt.y);
            end;
          fpOutsideBottom:
            begin
              //Form1.Memo1.Lines.Add('O ponto está fora do lado inferior.');
              setBottomPos(MouseStruct^.pt.y);
            end;
        end;
        Form1.updateCropPosition()
      end;


      //mouseInForm := Form1.IsPointInForm(Form1, MouseStruct^.pt.x, MouseStruct^.pt.y);

//      if not mouseInForm then
//      begin
//        if Form1.ckFollowMouse.Checked then
//        begin
//          if Form1.rdBoth.Checked then
//          begin
//            setLeftPos(MouseStruct^.pt.x);
//            setTopPos(MouseStruct^.pt.y);
//          end
//          else if Form1.rdX.Checked then
//          begin
//            setLeftPos(MouseStruct^.pt.x);
//          end
//          else if Form1.rdY.Checked then
//          begin
//            setTopPos(MouseStruct^.pt.y);
//          end;
//        end;
//      end;


    end;
  end;
  // Passa o evento para o próximo hook da cadeia
  Result := CallNextHookEx(MouseHook, nCode, wParam, lParam);
end;
procedure SetGlobalMouseHook;
begin
  MouseHook := SetWindowsHookEx(WH_MOUSE_LL, @LowLevelMouseProc, GetModuleHandle(nil), 0);
end;
procedure UnsetGlobalMouseHook;
begin
  if MouseHook <> 0 then
  begin
    UnhookWindowsHookEx(MouseHook);
    MouseHook := 0;
  end;
end;


{$R *.dfm}


type
  TFindAppData = record
    AppName: string;
    WindowHandle: HWND;
  end;


function EnumChildren(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
const
  TextBoxClass = 'EDIT';
var
  ClassName: array[0..259] of Char;
begin
  Result := True;
  GetClassName(hwnd, ClassName, Length(ClassName));
  if ClassName = TextBoxClass then
    TStrings(lParam).Add(IntToHex(hwnd, 8));
end;

function GetWndInfo(Wnd: HWND): string;
var
  ClassName: array [0..256] of Char;
begin
  Result := '';
  if IsWindow(Wnd) then begin
    GetClassName(Wnd, ClassName, 256);
    Result := Format('Window: %x [%s]', [Wnd, ClassName]);
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD) = WS_CHILD then begin
      Wnd := GetAncestor(Wnd, GA_ROOT);
      GetClassName(Wnd, ClassName, 256);
      Result := Format(Result + sLineBreak + 'Top level: %x [%s]', [Wnd, ClassName]);
    end;
  end;
end;

function GetWindowProcessID(hWnd: HWND): DWORD;
var
  ProcessID: DWORD;
begin
  // Obtém o ID do processo da janela
  GetWindowThreadProcessId(hWnd, @ProcessID);
  Result := ProcessID;
end;
function GetProcessFileName(ProcessID: DWORD): string;
var
  hProcess: THandle;
  FileName: array[0..MAX_PATH] of Char;
begin
  Result := '';
  // Abre o processo para leitura
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ProcessID);
  if hProcess <> 0 then
  try
    // Obtém o nome do arquivo do executável associado ao processo
    if GetModuleFileNameEx(hProcess, 0, FileName, MAX_PATH) > 0 then
      Result := FileName;
  finally
    CloseHandle(hProcess);
  end;
end;

function EnumWindowsProc(hWnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  ProcessID: DWORD;
  FileName: string;
  AppData: ^TFindAppData;
  buf: array[0..255] of Char;
begin
  // Obtém a estrutura passada como parâmetro
  AppData := Pointer(lParam);
  // Obtém o ID do processo associado à janela
  ProcessID := GetWindowProcessID(hWnd);
  FileName := GetProcessFileName(ProcessID);


   // GetClassName(hWnd, @buf, Length(buf));
   // Form1.memo1.Lines.Add(buf);


  // Verifica se o nome do aplicativo corresponde (comparação case-insensitive)
  if Pos(LowerCase(AppData^.AppName), LowerCase(FileName)) > 0 then
  begin
    AppData^.WindowHandle := hWnd; // Armazena o handle da janela encontrada
    Result := False; // Parar a enumeração
  end
  else
    Result := True; // Continuar a enumeração

  // Form1.Memo1.Lines.Add(GetWndInfo(hWnd));
end;

function FindWindowByAppName(const AppName: string): HWND;
var
  AppData: TFindAppData;
begin
  // Inicializa a estrutura de dados
  AppData.AppName := AppName;
  AppData.WindowHandle := 0;
  // Enumera as janelas e procura pelo nome do aplicativo
  EnumWindows(@EnumWindowsProc, LPARAM(@AppData));
  // Retorna o identificador da janela (se encontrado)
  Result := AppData.WindowHandle;
end;

procedure MoveWindowByAppName(const AppName: string; X, Y: Integer);
var
  hWnd: integer;
begin
  // Procura a janela pelo nome do aplicativo
  hWnd := FindWindowByAppName(AppName);

  // EnumChildWindows(hWnd, @EnumChildren, UINT_PTR(Form1.Memo1.Lines));

  if hWnd <> 0 then
  begin
    // Move a janela para a nova posição (X, Y)
    SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE or SWP_NOZORDER);
  end
  else
  begin
    ShowMessage('Janela não encontrada!');
  end;
end;

procedure MoveWindowByTitle(const WindowTitle: string; X, Y: Integer);
var
  hWnd: integer;
begin
  // Procura a janela pelo título
  hWnd := FindWindow(nil, PChar(WindowTitle));
  if hWnd <> 0 then
  begin
    // Move a janela para a nova posição (X, Y)
    SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE or SWP_NOZORDER);
  end
  else
  begin
    ShowMessage('Janela não encontrada!');
  end;
end;


procedure DragForm(Handle, StartX, StartY, EndX, EndY: Integer);
var
  LParamStart, LParamEnd: LPARAM;
begin
  // Calcula os parâmetros LParam para o ponto inicial e final
  LParamStart := MakeLParam(StartX, StartY);
  LParamEnd := MakeLParam(EndX, EndY);
  // Envia a mensagem de clique do botão esquerdo do mouse no ponto inicial
  SendMessage(Handle, WM_LBUTTONDOWN, MK_LBUTTON, LParamStart);
  // Envia a mensagem de movimento do mouse para o ponto final
  SendMessage(Handle, WM_MOUSEMOVE, MK_LBUTTON, LParamEnd);
  // Envia a mensagem de soltar o botão esquerdo do mouse no ponto final
  SendMessage(Handle, WM_LBUTTONUP, 0, LParamEnd);
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
var
  Control: TWinControl;
begin
  if (Msg.message = WM_MOUSEMOVE) and not FFoundControl then
  begin
    Control:= FindControl(Msg.hwnd);
    if Assigned(Control) then
    begin
      FCurrentControl:= Control;
      FFoundControl:= True;
    end;
  end else
  if (Msg.message = WM_MOUSELEAVE) then
    FFoundControl:= False;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  MoveWindowByTitle('Untitled - Paint', 100, 100);

    MoveWindowByAppName('FSRecorder.exe', 100, 100);

    SetWindowPos($241620, 0, 100, 100, 0, 0, SWP_NOSIZE or SWP_NOZORDER);
    SetWindowPos($241620, 0, 0, 0, 300, 400, SWP_NOMOVE or SWP_NOZORDER);

    sleep(1000);
//    PostMessageA($2218D0, WM_LBUTTONDOWN, MK_LBUTTON, MakeLParam(100, 100));

    DragForm($241620, 101,101, 110, 110);

//        MoveWindowByAppName('FSCapture.exe', 100, 100);

end;



var
  WindowList: TList;




function GetHandle (windowtitle: string): HWND;
var
  h, TopWindow: HWND;
  Dest: array[0..80] of char;
  i: integer;
  s: string;

  function getWindows(Handle: HWND; Info: Pointer): BOOL; stdcall;
    begin
      Result:= True;
      WindowList.Add(Pointer(Handle));
    end;

begin
  result:= 0;

  try
    WindowList:= TList.Create;
    TopWindow:= Application.Handle;
    EnumWindows(@getWindows, Longint(@TopWindow));
    i:= 0;
    while (i < WindowList.Count) and (result = 0) do
      begin
        GetWindowText(HWND(WindowList[i]), Dest, sizeof(Dest) - 1);
        s:= dest;
        if length(s) > 0 then
          begin
            if (Pos(UpperCase(Windowtitle), UpperCase(s)) >= 1) then
              begin
                h:= HWND(WindowList[i]);
                if IsWindow(h) then
                  result:= h;
             end;

            Form1.Memo1.Lines.Add(GetWndInfo(h));

             // Form1.Memo1.Lines.Add(Windowtitle);
           end;
        inc(i)
      end
    finally
      WindowList.Free;
    end;
end;


function TForm1.IsPointInForm(Form: TForm; X, Y: Integer): Boolean;
var
  FormRect: TRect;
begin
  // Obter as dimensões do formulário na tela (em coordenadas da tela)
  FormRect := Rect(Form.Left, Form.Top, Form.Left + Form.Width, Form.Top + Form.Height);
  // Verificar se o ponto (X, Y) está dentro do retângulo do formulário
  Result := PtInRect(FormRect, Point(X, Y));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
getHandle('Screen Recorder');
end;

procedure TForm1.Button3Click(Sender: TObject);
var i: integer;
begin

    VideoGrabber1.StoragePath := ExtractFilePath(Application.ExeName);
    VideoGrabber1.VideoSource := vs_ScreenRecording;

    VideoGrabber1.RecordingMethod := rm_ASF;
    VideoGrabber1.ASFProfileVersion := apv_ProfileVersion_9;

    VideoGrabber1.ScreenRecordingLayeredWindows := true;
    VideoGrabber1.ScreenRecordingWithCursor := true;
    VideoGrabber1.ScreenRecordingMonitor := 1;

    VideoGrabber1.Cropping_Enabled := true;
    VideoGrabber1.Cropping_Zoom := 1;
    VideoGrabber1.Cropping_Outbounds:= false;
    updateCropPosition();

    VideoGrabber1.AudioDevice := 0;
    VideoGrabber1.AudioInputLevel := 65535;
    VideoGrabber1.AudioRecording := true;

    VideoGrabber1.RecordingCanPause := true;

    VideoGrabber1.StartRecording();

//Memo1.Lines.Add(Screen.DesktopWidth.ToString);
//Memo1.Lines.Add(VideoGrabber1.GetVideoWidthFromIndex(0).ToString);
//Memo1.Lines.Add(VideoGrabber1.GetVideoHeightFromIndex(0).ToString);


end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  VideoGrabber1.StopRecording;
  //Close;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  //memo1.Lines.Add('VideoGrabber1.IsRecordingPaused: '+ VideoGrabber1.IsRecordingPaused.ToString() );
  if VideoGrabber1.IsRecordingPaused then
  begin
    VideoGrabber1.ResumeRecording;
    isRecording := true;
    updateRecording();
  end
  else
    begin
      VideoGrabber1.PauseRecording;
      isRecording := false;
      updateRecording();
    end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Button1.Visible := false;
Button2.Visible := false;
Memo1.Visible := false;
VideoGrabber1.Visible := false;

if not RegisterHotKey(Handle, HOTKEY_ID, 0, VK_F5) then
  begin
    ShowMessage('Não foi possível registrar a hotkey Ctrl+F12');
  end;

  SetGlobalMouseHook();

  RemoveTitleBar(Form1);


  ComboBox1.Items.Text := VideoGrabber1.AudioDevices;
  if ComboBox1.Items.Count > 0 then
    ComboBox1.ItemIndex := 0;



//  Form1.TransparentColor := True;
//  Form1.TransparentColorValue := clFuchsia; // Escolha uma cor que represente a transparência
//  Form1.BorderStyle := bsNone;  // Remova a borda do formulário

//  AlphaBlend := True;       // Ativar blend (transparência)
//  AlphaBlendValue := 200;   // Definir o nível de transparência (0-255)

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnsetGlobalMouseHook;
  UnregisterHotKey(Handle, HOTKEY_ID);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//if (Button = mbLeft) then
//    ReleaseCapture;
//    Perform(WM_SYSCOMMAND, $F008, 0); // Redimensionar o formulário manualmente
end;

procedure TForm1.WndProc(var Msg: TMessage);
begin
  inherited WndProc(Msg);
  // Interceptar a mensagem WM_HOTKEY
  if Msg.Msg = WM_HOTKEY then
  begin
    if Msg.WParam = HOTKEY_ID then
    begin
      // Executa a função quando Ctrl+F12 é pressionado
      HandleHotKey;
    end;
  end;
end;

procedure TForm1.MakeFormNormal;
var
  Style: LongInt;
begin
  // Desativar a transparência e restaurar o comportamento normal
  //AlphaBlend := False;  // Desativa a transparência
  // BorderStyle := bsSizeable;  // Restaurar borda redimensionável (ou o estilo que você preferir)
  // Remover as flags WS_EX_LAYERED e WS_EX_TRANSPARENT para restaurar eventos de mouse
  //    TransparentColor := false;
  Style := GetWindowLong(Handle, GWL_EXSTYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, Style and not (WS_EX_LAYERED or WS_EX_TRANSPARENT));
end;

procedure TForm1.MakeFormTransparent;
var
  Style: LongInt;
begin
  // Definir a transparência do formulário
//  FormStyle := fsStayOnTop; // Opcional: manter o formulário sempre no topo
  //BorderStyle := bsNone;    // Remover bordas
  // BorderStyle := bsSizeable;
  //AlphaBlend := True;       // Ativar blend (transparência)
  //AlphaBlendValue := 200;   // Definir o nível de transparência (0-255)
  // Tornar o formulário transparente para eventos de mouse

//  TransparentColor := true;
  Style := GetWindowLong(Handle, GWL_EXSTYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, Style or WS_EX_LAYERED or WS_EX_TRANSPARENT);

  // Definir transparência da janela
  // SetLayeredWindowAttributes(Handle, 0, 150, LWA_ALPHA);
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    MouseIsDown := True;
    // Captura a posição inicial do mouse quando o botão esquerdo é pressionado
    InitialMousePosX := X;
    InitialMousePosY := Y;
  end;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewLeft, NewTop: Integer;
  DesktopWorkArea: TRect;
begin
  if MouseIsDown then
  begin
    // Obtém o retângulo que representa a área total do desktop (todos os monitores)
    DesktopWorkArea := Screen.DesktopRect;
    // Inicia as novas posições com base no movimento do mouse
    NewLeft := Form1.Left;
    NewTop := Form1.Top;
    // Verifica se as teclas Shift, Ctrl ou Alt estão pressionadas
    if ssShift in Shift then
    begin
      // Movimento apenas no eixo X (horizontal) com Shift pressionado
      NewLeft := Form1.Left + (X - InitialMousePosX);
    end
    else if ssCtrl in Shift then
    begin
      // Movimento apenas no eixo Y (vertical) com Ctrl pressionado
      NewTop := Form1.Top + (Y - InitialMousePosY);
    end
    else
    begin
      // Movimento livre quando Alt ou Ctrl está pressionado
      NewLeft := Form1.Left + (X - InitialMousePosX);
      NewTop := Form1.Top + (Y - InitialMousePosY);
    end;
    // Impede que o formulário se mova para fora do limite esquerdo do desktop
    if NewLeft < DesktopWorkArea.Left then
      NewLeft := DesktopWorkArea.Left;
    // Impede que o formulário se mova para fora do limite direito do desktop
    if NewLeft + Form1.Width > DesktopWorkArea.Right then
      NewLeft := DesktopWorkArea.Right - Form1.Width;
    // Impede que o formulário se mova para fora do limite superior do desktop
    if NewTop < DesktopWorkArea.Top then
      NewTop := DesktopWorkArea.Top;
    // Impede que o formulário se mova para fora do limite inferior do desktop
    if NewTop + Form1.Height > DesktopWorkArea.Bottom then
      NewTop := DesktopWorkArea.Bottom - Form1.Height;
    // Atualiza a posição do formulário
    Form1.Left := NewLeft;
    Form1.Top := NewTop;

    updateCropPosition();

//
//
//
//    Memo1.Lines.Add('--');
//    Memo1.Lines.Add('Form1.Left: '+ Form1.Left.ToString);
//    Memo1.Lines.Add('VideoGrabber1.Cropping_Width: '+ VideoGrabber1.Cropping_Width.ToString);
//    Memo1.Lines.Add('Cropping_Zoom: '+ VideoGrabber1.Cropping_Zoom.ToString);
//    Memo1.Lines.Add('Cropping_XMax: '+ VideoGrabber1.Cropping_XMax.ToString);




  end;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown := False;
end;

procedure TForm1.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel2MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel2.Cursor := crSizeWE
  else
    Panel2.Cursor := crDefault
end;

procedure TForm1.Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewWidth: Integer;
begin
  if Resizing then
  begin
    NewWidth := Form1.Width + (Mouse.CursorPos.X - (Form1.Left + Form1.Width));
    if NewWidth > 200 then  // Define uma largura mínima para o formulário
      Form1.Width := NewWidth;
  end;

end;

procedure TForm1.Panel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel3MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel3.Cursor := crSizeWE
  else
    Panel3.Cursor := crDefault
end;

procedure TForm1.Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewLeft, NewWidth: Integer;
begin
  if Resizing then
  begin
    // Calcula a nova posição da borda esquerda do formulário
    NewLeft := Mouse.CursorPos.X;
    // Calcula a nova largura, mantendo a borda direita no mesmo lugar
    NewWidth := Form1.Width + (Form1.Left - NewLeft);
    // Impede que a largura do formulário seja menor que um valor mínimo
    if NewWidth > 200 then
    begin
      Form1.Left := NewLeft;  // Atualiza a posição Left do formulário
      Form1.Width := NewWidth;  // Atualiza a largura do formulário
    end;
  end;
end;

procedure TForm1.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel4MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel4.Cursor := crSizeNS
  else
  Panel4.Cursor := crDefault
end;

procedure TForm1.Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewTop, NewHeight: Integer;
begin
  if Resizing then
  begin
    // Captura a nova posição do topo do formulário
    NewTop := Mouse.CursorPos.Y;
    // Calcula a nova altura, mantendo a borda inferior fixa
    NewHeight := Form1.Height + (Form1.Top - NewTop);
    // Impede que a altura do formulário seja menor que um valor mínimo
    if NewHeight > 200 then
    begin
      Form1.Top := NewTop;    // Atualiza a posição Top do formulário
      Form1.Height := NewHeight;  // Atualiza a altura do formulário
    end;
  end;
end;

procedure TForm1.Panel4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.Panel5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;
procedure TForm1.Panel5MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel5.Cursor := crSizeNS
  else
    Panel5.Cursor := crDefault
end;

procedure TForm1.Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewHeight: Integer;
begin
  if Resizing then
  begin
    // Calcula a nova altura com base na posição do cursor no eixo Y
    NewHeight := Mouse.CursorPos.Y - Form1.Top;
    // Impede que a altura do formulário seja menor que um valor mínimo
    if NewHeight > 200 then
      Form1.Height := NewHeight;  // Atualiza a altura do formulário
  end;
end;

procedure TForm1.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;


procedure TForm1.Panel6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel6MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel5.Cursor := crSizeNESW
  else
    Panel5.Cursor := crDefault

end;

procedure TForm1.Panel6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewLeft, NewWidth, NewHeight: Integer;
begin
  if Resizing then
  begin
    // Redimensionamento do lado esquerdo
    NewLeft := Mouse.CursorPos.X;
    NewWidth := Form1.Width + (Form1.Left - NewLeft);
    // Redimensionamento do fundo
    NewHeight := Mouse.CursorPos.Y - Form1.Top;
    // Impede que a largura e a altura sejam menores que um valor mínimo
    if (NewWidth > 200) and (NewHeight > 200) then
    begin
      Form1.Left := NewLeft;     // Atualiza a posição Left do formulário
      Form1.Width := NewWidth;   // Atualiza a largura do formulário
      Form1.Height := NewHeight; // Atualiza a altura do formulário
    end;
  end;
end;

procedure TForm1.Panel6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.Panel7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel7MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel5.Cursor := crSizeNWSE
  else
    Panel5.Cursor := crDefault
end;

procedure TForm1.Panel7MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewWidth, NewHeight: Integer;
begin
  if Resizing then
  begin
    // Redimensionamento do lado direito
    NewWidth := Mouse.CursorPos.X - Form1.Left;
    // Redimensionamento do fundo
    NewHeight := Mouse.CursorPos.Y - Form1.Top;
    // Impede que a largura e a altura sejam menores que um valor mínimo
    if (NewWidth > 200) and (NewHeight > 200) then
    begin
      Form1.Width := NewWidth;   // Atualiza a largura do formulário
      Form1.Height := NewHeight; // Atualiza a altura do formulário
    end;
  end;
end;

procedure TForm1.Panel7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.Panel8MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel8MouseEnter(Sender: TObject);
begin
  if not ckFollowMouse.Checked then
    Panel5.Cursor := crSizeNWSE
  else
    Panel5.Cursor := crDefault

end;
procedure TForm1.Panel8MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  if Resizing then
  begin
    // Redimensionamento do lado esquerdo
    NewLeft := Mouse.CursorPos.X;
    NewWidth := Form1.Width + (Form1.Left - NewLeft);
    // Redimensionamento do topo
    NewTop := Mouse.CursorPos.Y;
    NewHeight := Form1.Height + (Form1.Top - NewTop);
    // Impede que a largura e a altura sejam menores que um valor mínimo
    if (NewWidth > 200) and (NewHeight > 200) then
    begin
      Form1.Left := NewLeft;     // Atualiza a posição Left do formulário
      Form1.Width := NewWidth;   // Atualiza a largura do formulário
      Form1.Top := NewTop;       // Atualiza a posição Top do formulário
      Form1.Height := NewHeight; // Atualiza a altura do formulário
    end;
  end;
end;
procedure TForm1.Panel8MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.Panel9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ckFollowMouse.Checked then exit;
  if Button = mbLeft then
  begin
    Resizing := True;              // Inicia o processo de redimensionamento
    InitialMousePosX := X;         // Armazena a posição inicial do mouse
  end;
end;

procedure TForm1.Panel9MouseEnter(Sender: TObject);
begin
begin
  if not ckFollowMouse.Checked then
    Panel5.Cursor := crSizeNESW
  else
    Panel5.Cursor := crDefault

end;
end;

procedure TForm1.Panel9MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewTop, NewWidth, NewHeight: Integer;
begin
  if Resizing then
  begin
    // Redimensionamento do lado direito
    NewWidth := Mouse.CursorPos.X - Form1.Left;
    // Redimensionamento do topo
    NewTop := Mouse.CursorPos.Y;
    NewHeight := Form1.Height + (Form1.Top - NewTop);
    // Impede que a largura e a altura sejam menores que um valor mínimo
    if (NewWidth > 200) and (NewHeight > 200) then
    begin
      Form1.Width := NewWidth;   // Atualiza a largura do formulário
      Form1.Top := NewTop;       // Atualiza a posição Top do formulário
      Form1.Height := NewHeight; // Atualiza a altura do formulário
    end;
  end;
end;

procedure TForm1.Panel9MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Resizing := False;  // Finaliza o redimensionamento
end;

procedure TForm1.updateCropPosition;
begin
  VideoGrabber1.Cropping_X := Form1.Left + Panel3.Width;
  VideoGrabber1.Cropping_Width := Form1.Width - Panel3.Width - Panel2.Width;
  VideoGrabber1.Cropping_Y := Form1.Top + Panel4.Height;
  VideoGrabber1.Cropping_Height := Form1.Height - Panel4.Height - Panel5.Height - Panel1.Height;
end;

procedure TForm1.updateRecording;
begin
  if isRecording then
  begin
    Panel2.Color := clRed;
    Panel3.Color := clRed;
    Panel4.Color := clRed;
    Panel5.Color := clRed;
    Panel6.Color := clRed;
    Panel7.Color := clRed;
  end
  else
  begin
    Panel2.Color := clYellow;
    Panel3.Color := clYellow;
    Panel4.Color := clYellow;
    Panel5.Color := clYellow;
    Panel6.Color := clYellow;
    Panel7.Color := clYellow;
  end;
end;

procedure TForm1.VideoGrabber1RecordingCompleted(Sender: TObject;
  FileName: string; Success: Boolean);
begin
  Memo1.Lines.Add('completed');
  isRecording := false;
  updateRecording();
end;

procedure TForm1.VideoGrabber1RecordingPaused(Sender: TObject);
begin
//  Memo1.Lines.Add('pause');
//  isRecording := not VideoGrabber1.IsRecordingPaused;
//  updateRecording();
end;

procedure TForm1.VideoGrabber1RecordingReadyToStart(Sender: TObject);
begin
  Memo1.Lines.Add('read');
end;

procedure TForm1.VideoGrabber1RecordingStarted(Sender: TObject;
  FileName: string);
begin
  Memo1.Lines.Add('stated');
  isRecording := true;
  updateRecording();

end;

procedure TForm1.VideoGrabber1ResizeVideo(Sender: TObject; SourceWidth,
  SourceHeight: Integer);
begin



//  VideoGrabber1.Cropping_X := Form1.Left;
//  //VideoGrabber1.Cropping_Width := Form1.Width;
//  VideoGrabber1.Cropping_Width := Form1.Left + Form1.Width;
//
//  VideoGrabber1.Cropping_Y := Form1.Top;
//  VideoGrabber1.Cropping_Height := Form1.Height;

  Memo1.Lines.Add('resize: ' + VideoGrabber1.Cropping_X.ToString);

end;

procedure TForm1.HandleHotKey;
begin
  // Coloque a função que você quer que execute aqui
  ckFollowMouse.Checked := not ckFollowMouse.Checked;
//  if ckFollowMouse.Checked then
//    MakeFormTransparent
//  else
//    MakeFormNormal;

end;

//procedure TForm1.WMNCHitTest(var Msg: TWMNCHitTest);
//begin
//  inherited;
//
//  // Verifica se o mouse está sobre as bordas do formulário
//  if (Msg.Result = HTCLIENT) then
//  begin
//    if (Msg.XPos >= Self.Left) and (Msg.XPos <= Self.Left + 5) then
//      Msg.Result := HTLEFT
//    else if (Msg.XPos >= Self.Left + Self.Width - 5) and (Msg.XPos <= Self.Left + Self.Width) then
//      Msg.Result := HTRIGHT
//    else if (Msg.YPos >= Self.Top) and (Msg.YPos <= Self.Top + 5) then
//      Msg.Result := HTTOP
//    else if (Msg.YPos >= Self.Top + Self.Height - 5) and (Msg.YPos <= Self.Top + Self.Height) then
//      Msg.Result := HTBOTTOM
//    else if (Msg.XPos >= Self.Left) and (Msg.XPos <= Self.Left + 5) and
//            (Msg.YPos >= Self.Top) and (Msg.YPos <= Self.Top + 5) then
//      Msg.Result := HTTOPLEFT
//    else if (Msg.XPos >= Self.Left + Self.Width - 5) and (Msg.XPos <= Self.Left + Self.Width) and
//            (Msg.YPos >= Self.Top) and (Msg.YPos <= Self.Top + 5) then
//      Msg.Result := HTTOPRIGHT
//    else if (Msg.XPos >= Self.Left) and (Msg.XPos <= Self.Left + 5) and
//            (Msg.YPos >= Self.Top + Self.Height - 5) and (Msg.YPos <= Self.Top + Self.Height) then
//      Msg.Result := HTBOTTOMLEFT
//    else if (Msg.XPos >= Self.Left + Self.Width - 5) and (Msg.XPos <= Self.Left + Self.Width) and
//            (Msg.YPos >= Self.Top + Self.Height - 5) and (Msg.YPos <= Self.Top + Self.Height) then
//      Msg.Result := HTBOTTOMRIGHT;
//  end;
//end;

function TForm1.CheckFormPosition(Form: TForm; X, Y: Integer): TFormPositionResult;
var
  FormRect: TRect;
begin
  // Obter as dimensões do formulário na tela (em coordenadas da tela)
  FormRect := Rect(Form.Left, Form.Top, Form.Left + Form.Width, Form.Top + Form.Height);
  // Verificar se o ponto está fora do formulário
  if (X < FormRect.Left) then
    Result := fpOutsideLeft
  else if (X > FormRect.Right) then
    Result := fpOutsideRight
  else if (Y < FormRect.Top) then
    Result := fpOutsideTop
  else if (Y > FormRect.Bottom) then
    Result := fpOutsideBottom
  else
    Result := fpInside;
end;

end.
