<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>WebSocket Tester</title>
    <script language="javascript" type="text/javascript"
            src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
    <script language="javascript" type="text/javascript">
        var ping;
        var websocket;
        jQuery(function ($) {
            function writePing(message) {
                $('#pingOutput').append(message + '\n');
            }

            function writeStatus(message) {
                $("#statusOutput").val($("#statusOutput").val() + message + '\n');
            }

            function writeMessage(message) {
                $('#message0utput').append(message + '\n')
            }

            $('#connect').click(function doConnect() {
                websocket = new WebSocket($("#target").val());
                websocket.onopen = function (evt) {
                    writeStatus("CONNECTED");
                    var ping = setinterval(function () {
                        if (websocket != "undefined") websocket.send("ping");
                    }, 3000);
                };
                websocket.onclose = function (evt) {
                    writeStatus("DISCONNECTED");
                };
                websocket.onmessage = function (evt) {
                    if (evt.data === "ping") writePing(evt.data);
                    else writeMessage('ECHO:  ' + evt.data);
                };
                websocket.onerror = function (evt) {
                    onError(writeStatus('ERROR:' + evt.data))
                };
            });
            $('#disconnect').click(function () {
                if (typeof  websocket != 'undefined') {
                    websocket.close();
                    websocket = undefined;
                } else alert("Not  connected.");
            });
            $('#send').click(function () {
                if (typeof websocket != 'undefined') websocket.send($('#message').val());
                else alert("Not connected.");
            });
        });
    </script>
</head>
<body>
<h2>WebSocket Tester</h2>
Target:
<input type="text" id="target" size="40" value="ws://localhost:8080/websocket-api/echoHandler"/>
<br/>
<button id="connect">Connect</button>
<button id="disconnect">Disconnect</button>
<br/>
<br/>Message:
<input type="text" id="message" value=""/>
<button id="send">Send</button>
<br/>
<p>Status output:</p>
<pre><textarea id="statusOutput" rows="10" cols="80"></textarea></pre>
<p>Message output:</p>
<pre><textarea id="messageOutput" rows="10" cols="80"></textarea></pre>
<p>Ping output:</p>
<pre><textarea id="pingOutput" rows="10" cols="50"></textarea></pre>
</body>
</html>