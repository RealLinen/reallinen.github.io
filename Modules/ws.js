
// THIS IS FOR TO IMPORT INSIDE UR HTML SCRIPT.
/* Usage:
(async()=>{
    const socket = await WS.Connect("localhost:3000/ws_port") // if you dont include "wss://" or "ws://" it will automaticallly be included
    if(typeof(socket)!=="object") return console.log("Connection Failed: "+socket) // will be a string with the reason of why the connection failed

    socket.on("disconnect", async()=>{
        console.log("Websocket Server Disconnected :(")
    })
    socket.on("test", async(data)=>{
        console.log(data)
    })
    
    socket.emit("message", "From client to server!")
    
    // to disconnect/close the websocket connection:
    // socket.disconnect( <(optional) reason> ) // The reason will be sent before disconnecting
})()
*/
const socketConnections = {};
this.WS = {
  Connect: function(t, ...e) {
    if (!(t = (t = "string" == typeof t && t || null) && (!t.includes("ws") && "ws://" + t.replace("://", "").replace("//", "") || t) || null)) return null;
    if (!socketConnections[t]) {
      var [n, o] = [null,
        {
          Emit: {},
          MethodEmit: {}
        }
      ];
      try {
        (n = new WebSocket(t, ...e)).onopen = function() {}, n.onclose = function() {}, n.onerror = function(t) {
          "function" == typeof o.Emit.error && o.Emit.error(t)
        }, n.onmessage = function(t) {
          let e;
          try {
            e = JSON.parse(t.data)
          } catch (n) {
            e = null
          }
          if ("object" == typeof e) {
            let [i, c] = [e.method, e.data];
            if (void 0 === i || null == i || void 0 === c || null == c) return !1;
            "function" == typeof o.MethodEmit[i] && o.MethodEmit[i](c)
          } else "function" == typeof o.Emit.message && o.Emit.message(e)
        }
      } catch (i) {
        return "Socket Failed to Connect\n~~~~~~~~~~~~~~~~~~~~~~~~\n" + i
      }
      return n ? (socketConnections[t] = {
        Socket: n,
        on: function(t, e) {
          return e = "function" == typeof e && e || null, !!(t = "string" == typeof t && t || null) && !!e && (o.Emit[t] = e, !0)
        },
        onMessage: function(t, e) {
          return e = "function" == typeof e && e || null, !!(t = "string" == typeof t && t || null) && !!e && ("message" == t ? `The name/first argument cannot be named 'message'. Please use this instead: 
          connection.on('message', function(content){
              console.log(content)
          }) // message will never be an object. For objects use 'onMessage'

          connection.onMessage('authenticate', function(data: anything){
            console.log(data)
          }) // Will trigger when the server sends { method: 'authenticate', data: (can be anything except for undefined and null) }
          ` : (o.MethodEmit[t] = e, !0))
        },
        emit: function(t, e) {
          if (!this.Socket) return !1;
          if ("string" != typeof t) return "Failed to send: event must be a string";
          if (void 0 === e) return "Data must be something other than undefined [ can be null, string, number, object, array, etc ]";
          let n;
          try {
            n = JSON.stringify({
              method: t,
              data: e
            })
          } catch (o) {
            return "Failed to send: " + o
          }
          return n ? (this.Socket.send(n), !0) : "Failed to send data"
        },
        disconnect: function(t = String) {
          if ("string" == typeof t) try {
            this.Socket.send(t)
          }
          catch (e) {}
          try {
            return this.Socket.close(), !0
          } catch (n) {
            return !1
          }
        }
      }, new Promise((e, i) => {
        let [c, s, r] = [!1, !1, !1], a;
        a = setInterval(async () => {
          n.readyState != WebSocket.OPEN || (c || (c = !0, e(socketConnections[t])), "function" != typeof o.Emit.connected || r || (r = !0, o.Emit.connected())), n.readyState != WebSocket.CLOSED && n.readyState != WebSocket.CLOSING || s || ("function" == typeof o.Emit.disconnect && o.Emit.disconnect(), socketConnections[t] = null, Connected = !1, s = !0, clearInterval(a))
        }, 100)
      })) : "Socket doesn't exist"
    }
  }
};
// Import this into ur html script with: <script src="https://reallinen.github.io/Modules/ws.js" type="text/javascript"></script>
