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
   Begin MSWinsockLib.Winsock Winsock1 
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
Private Sub Form_Load()
    Do
        If Winsock1.State <> sckConnected And Winsock1.State <> sckListening Then ' check if port is open, then open it
            Winsock1.Close 'All the connections are switched off
            Winsock1.Listen ''Listen port for incoming connections
            Log ("Listening in port: " + CStr(Winsock1.LocalPort))
        End If
        DoEvents
    Loop
End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    Log ("error number:" + CStr(Number) + " scode: " + CStr(Scode) + " desc: " + Description)
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
        Dim Data As String

        Winsock1.GetData Data

        Log ("Data Received: " + Data)

        If Data = "SHUTDOWN" Or Data = "SHUTDOWN" + vbCrLf Or Data = "ShutDown" + vbLf Then
            Winsock1.SendData ("Goodbye, server shutdown started" + vbCrLf)
            Log ("Shutting down server")
            End ' COMMAND FOR SERVER SHUTDOWN
        End If
        
        If Data = vbCr Or Data = vbLf Or Data = vbCrLf Then
           Winsock1.SendData ("OK" + vbCrLf) ' RETURN VALUE WHEN RECEIVED END OF LINE
        End If
End Sub

Private Sub Winsock1_ConnectionRequest(ByVal requestID As Long)
        Winsock1.Close ' CLOSE PRIOR CONNECTION
        Winsock1.Accept requestID
               
        Log ("Connection requested from host: " + Winsock1.RemoteHostIP + " with id: " + CStr(requestID))
        
        ' SEND SERVER INFO TO CLIENT
        Winsock1.SendData ("Connected to server: " + Winsock1.LocalHostName + vbCrLf)
End Sub
