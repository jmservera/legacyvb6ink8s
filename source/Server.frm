VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Server 
   Caption         =   "Form1"
   ClientHeight    =   6525
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   7305
   LinkTopic       =   "Form1"
   ScaleHeight     =   6525
   ScaleWidth      =   7305
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin MSWinsockLib.Winsock tcpServer 
      Index           =   0
      Left            =   360
      Top             =   3360
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      LocalPort       =   9090
   End
End
Attribute VB_Name = "Server"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private intMax As Long

Public Running As Boolean

Private Sub Form_Load()
    Running = True
    
    On Error GoTo ProcError
    intMax = 0
    tcpServer(0).LocalPort = 9001
    
     Do
        If tcpServer(0).State <> sckConnected And tcpServer(0).State <> sckListening Then ' check if port is open, then open it
            tcpServer(0).Close 'All the connections are switched off
            tcpServer(0).Listen ''Listen port for incoming connections
            LogMessage "port_listen", CStr(tcpServer(0).LocalPort)
        End If
        DoEvents
    Loop
    Exit Sub
ProcError:
    Running = False
    
  LogError Err.Number, Err.Source, Err.Description
  End
End Sub

Private Sub tcpServer_Error(index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    LogError Number, Source, Description
End Sub

Private Sub tcpServer_ConnectionClose(index As Integer, ByVal requestid As Long)

End Sub


Private Sub tcpServer_DataArrival(index As Integer, ByVal bytesTotal As Long)
        Dim Data As String

        tcpServer(index).GetData Data

        LogTrace "data", Data

        If Data = "SHUTDOWN" Or Data = "SHUTDOWN" + vbCrLf Or Data = "Shutdown" + vbLf Then
            tcpServer(index).SendData ("Goodbye, server shutdown started" + vbCrLf)
            DoEvents
            LogMessage "shutdown", ""
            End
        End If
        
        If Data = vbCr Or Data = vbLf Or Data = vbCrLf Then
           tcpServer(index).SendData ("OK" + vbCrLf) ' RETURN VALUE WHEN RECEIVED END OF LINE
        End If
End Sub

Private Sub tcpServer_ConnectionRequest(index As Integer, ByVal requestid As Long)
        LogMessage "connection_request", tcpServer(index).RemoteHostIP

        If index = 0 Then
            intMax = intMax + 1
            Load tcpServer(intMax)
            tcpServer(intMax).LocalPort = 0
            tcpServer(intMax).Accept requestid
            ' SEND SERVER INFO TO CLIENT
            tcpServer(intMax).SendData ("Connected to server: " + tcpServer(intMax).LocalHostName + vbCrLf)
        End If
End Sub
