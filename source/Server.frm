VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Server 
   Caption         =   "Form1"
   ClientHeight    =   9435
   ClientLeft      =   6810
   ClientTop       =   2490
   ClientWidth     =   13680
   LinkTopic       =   "Form1"
   ScaleHeight     =   9435
   ScaleWidth      =   13680
   Visible         =   0   'False
   Begin VB.TextBox Text1 
      Enabled         =   0   'False
      Height          =   9015
      Left            =   960
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Text            =   "Server.frx":0000
      Top             =   240
      Width           =   12495
   End
   Begin MSWinsockLib.Winsock tcpServer 
      Index           =   0
      Left            =   360
      Top             =   3360
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "Server"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private intMax As Integer
Private lastTime As Date

Const MAXCONNS As Integer = 4096

Public Running As Boolean

Private Sub Form_Load()
    Dim i As Long
    
'    Me.Show
    
    Running = True
    On Error GoTo procError
    intMax = 0
    tcpServer(0).LocalPort = 9001
    lastTime = Now
       
     Do
        If tcpServer(0).State <> sckConnected And tcpServer(0).State <> sckListening Then ' check if port is open, then open it
            tcpServer(0).Close 'All the connections are switched off
            tcpServer(0).Listen ''Listen port for incoming connections
            LogMessage "port_listen", CStr(tcpServer(0).LocalPort)
        End If
        DoEvents
        If DateDiff("s", lastTime, Now) > 5 Then
            reviewTimer
            lastTime = Now
        End If
        If Not Running Then
         Exit Sub
        End If
    Loop
    Exit Sub
procError:
  Running = False
  LogError Err.Number, Err.Source, Err.Description
End Sub

Private Sub reviewTimer()
    Dim i As Long
    Dim count As Long
    
    On Error GoTo procError
    If intMax > 0 Then
        For i = 1 To tcpServer.UBound
            If tcpServer(i).State = sckConnected Then
                count = count + 1
            End If
            DoEvents
        Next
    End If
    LogTrace "CONNECTED", CStr(count)
    Exit Sub
procError:
  LogError Err.Number, Err.Source, Err.Description
End Sub

Private Sub Form_Resize()
    Text1.Top = 10
    Text1.Left = 10
    Text1.Width = Me.ScaleWidth - 55
    Text1.Height = Me.ScaleHeight - 55
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Running = False
End Sub

Private Sub tcpServer_Error(index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    LogError Number, Source, Description
End Sub

Private Sub tcpServer_ConnectionClose(index As Integer, ByVal requestid As Long)
    LogTrace "CLOSE", CStr(index) & " " & CStr(requestid)
End Sub


Private Sub tcpServer_DataArrival(index As Integer, ByVal bytesTotal As Long)
        Dim Data As String

        On Error GoTo dataError
        If bytesTotal > 0 Then
            
            tcpServer(index).GetData Data
    
            LogTrace "data", Data
    
            If Data = "SHUTDOWN" Or Data = "SHUTDOWN" + vbCrLf Or Data = "Shutdown" + vbLf Then
                tcpServer(index).SendData ("Goodbye, server shutdown started" + vbCrLf)
                DoEvents
                LogMessage "shutdown", ""
                End
            End If
            
            If Data = vbCr Or Data = vbLf Or Data = vbCrLf Then
               tcpServer(index).SendData ("OK" + vbCrLf) ' RETURN VALUE WHEN END OF LINE IS RECEIVED
            End If
        End If
        Exit Sub
dataError:
    LogError Err.Number, Err.Source, Err.Description
        
End Sub

Private Sub tcpServer_ConnectionRequest(index As Integer, ByVal requestid As Long)
        Dim i As Long

        On Error GoTo procError
        
        LogMessage "connection_request", tcpServer(index).RemoteHostIP

        If index = 0 Then
            intMax = intMax + 1
            If intMax = MAXCONNS Then
                LogTrace "MAXCONNS", "Reached maximum number of connections, restarting to reuse them"
                intMax = 1 'ugly counter restart, should use an availability matrix
            End If

            If tcpServer.UBound < intMax Then
                Load tcpServer(intMax)
                tcpServer(intMax).LocalPort = 0
            Else
                ' find a free one
                For i = intMax To tcpServer.UBound
                    If tcpServer(i).State <> sckConnected Then
                        intMax = i
                        tcpServer(i).Close
                        GoTo subConnect
                    Else
                        If i = tcpServer.UBound Then
                            LogError "-1", "tcpServer_ConnectionRequest", "Not available connections"
                            Exit Sub
                        End If
                    End If
                Next
            End If
subConnect:
            LogTrace "INTMAX", CStr(intMax)
            tcpServer(intMax).Accept requestid
            ' SEND SERVER INFO TO CLIENT
            tcpServer(intMax).SendData ("Connected to server: " + tcpServer(intMax).LocalHostName + vbCrLf)
        Else
            LogError "-1", "tcpServer_ConnectionRequest", "Invalid connection request to index: " & CStr(index) & ". This should never happen"
        End If
        Exit Sub
procError:
    LogError Err.Number, Err.Source, Err.Description
End Sub

Private Sub Text1_Change()
    If Len(Text1.Text) > 8196 Then
        Text1.Text = Mid(Text1.Text, 4096, Len(Text1.Text) - 4096)
    End If
End Sub
