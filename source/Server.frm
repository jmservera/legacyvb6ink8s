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
    
    Running = True
    
    'On Error GoTo ProcError
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
    Loop
    Exit Sub
ProcError:
    Running = False
    
  LogError Err.Number, Err.Source, Err.Description
  End
End Sub

Private Sub reviewTimer()
    Dim i As Long
    Dim count As Long
    
    If intMax > 0 Then
        For i = 1 To tcpServer.UBound
            If tcpServer(i).State = sckConnected Then
                count = count + 1
            End If
            DoEvents
        Next
    End If
    LogTrace "CONNECTED", CStr(count)
End Sub

Private Sub tcpServer_Error(index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    removeServer (index)
    LogError Number, Source, Description
End Sub

Private Sub tcpServer_ConnectionClose(index As Integer, ByVal requestid As Long)
    removeServer (index)
    LogTrace "CLOSE", CStr(index) & " " & CStr(requestid)
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
           tcpServer(index).SendData ("OK" + vbCrLf) ' RETURN VALUE WHEN END OF LINE IS RECEIVED
        End If
End Sub

Private Sub tcpServer_ConnectionRequest(index As Integer, ByVal requestid As Long)
        Dim i As Long
        
        LogMessage "connection_request", tcpServer(index).RemoteHostIP

        If index = 0 Then
            intMax = intMax + 1
            If intMax = MAXCONNS Then
                LogTrace "MAXCONNS", "Reached maximum number of connections, restarting to reuse them"
                intMax = 1 'ugly counter restart, should use an availability matrix
            End If

            If tcpServer.UBound < intMax Then
                Load tcpServer(intMax)
            Else
                ' find a free one
                For i = intMax To tcpServer.UBound
                    If tcpServer(i).State <> sckConnected Then
                        tcpServer(intMax).Close
                        intMax = i
                        GoTo subConnect
                    Else
                        If i = tcpServer.UBound Then
                            LogError "-1", "tcpServer_ConnectionRequest", "Not available connections"
                            GoTo subEnd
                        End If
                    End If
                Next
                
                DoEvents
            End If
subConnect:
            tcpServer(intMax).LocalPort = 0
            tcpServer(intMax).Accept requestid
            ' SEND SERVER INFO TO CLIENT
            tcpServer(intMax).SendData ("Connected to server: " + tcpServer(intMax).LocalHostName + vbCrLf)
        Else
            LogError "-1", "tcpServer_ConnectionRequest", "Invalid connection request to index: " & CStr(index) & ". This should never happen"
        End If
subEnd:

End Sub

Private Sub removeServer(index As Long)
    If index <= tcpServer.UBound Then
        If Not tcpServer(index) Is Nothing Then
            tcpServer(index).Close
            DoEvents
        End If
    End If
    DoEvents
End Sub
