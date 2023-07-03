# linenws-server

An easy-to-use wrapper around the ws api for an express-like feel.
This is an modified version of "easy-websocket-server", this fixes the random crashes/bugs that are annoying

```sh
npm i linenws-server
```

## Examples

```js
const app = require('express')();
const server = require('http').createServer(app);
const LinenWS = require('linenws-server');

const { send, broadcastAll } = LinenWS.commands;
const socket = LinenWS(server);

// Listen for connections
socket.onConnection(id => console.log(`${id} just connected!`))

// Listen for someMethod messages
socket.onMessage(`someMethod`, (id, message) => {
    console.log(`${id} sent a message:`, message);
});

// Listen for otherMethod messages
socket.onMessage(`otherMethod`, (id, message) => {
    console.log(`${id} sent a message:`, message);
})

// Send a message to a particular client
send(`someId`, `someMethod`, { ok: true });

// Broadcast to all the clients
broadcastAll(`someMethod`, { ok: true });

server.listen(3000);
```

Using without express is exactly the same, except you just call:

```js
const server = require('http').createServer();
```

Instead of this:

```js
const server = require('http').createServer(app);
```

### Remotes

Using the built in remoteEngine (similar to using `express.Router()`);

```js
// index.js
const app = require('express')();
const server = require('http').createServer(app);
const socket = require('linenws-server')(server);
const createUser = require('./remotes/create-user');

socket.useRemote(`createUser`, createUser);

server.listen(3000);
```

```js
// ./remotes/create-user.js
const remote = require('linenws-server').remoteEngine();

remote.onMessage(id => {
    // ...
    console.log(`User created!`);
})

module.exports = remote;
```

There is a more thorough example in the `/test` directory.

## Sending messages from the client

All must messages from the client are recomended to have this format:

```json
{
	"method": "someMethod",
	"data": "Whatever you wish to send.  Can be a string, object, or array."
}
```

If a client sends up a message without a `method` property, you can assign to the message a `default` method.

```js
socket.use((id, message, next) => {
    if (!message.method) message.method = `default`;
    next();
})
```

Then you can handle the message like this:

```js
socket.onMessage(`default`, (id, message) => {
    // Do something...
})
```

## API

```js
const LinenWS = require('linenws-server');
```

- [`LinenWS`](#LinenWSserver)
    - [`onServerUpgrade`](#socketonserverupgradecallback-next-quit-request-socket-head--void)
    - [`onConnection`](#socketonconnectioncallback-id--void)
    - [`use`](#socketusecallback-id-message-next--void)
    - [`onMessage`](#socketonmessagemethod-string-callback-id-message--void)
    - [`onClose`](#socketonclosecallback-id-code--void)
    - [`useRemote`](#socketuseremotemethod-string-remote-remoteengine)
    - [`catchErrors`](#socketcatcherrorscallback-error-id-message--void)
- [`LinenWS.commands`](#LinenWScommands)
    - [`send`](#commandssendid-method-data)
    - [`broadcastAll`](#commandsbroadcastallmethod-data)
    - [`broadcastExclude`](#commandsbroadcastexclude)
    - [`close`](#commandscloseid)
    - [`getConnections`](#commandsgetconnections-object)
- [`LinenWS.remoteEngine`](#LinenWSremoteengine)
    - [`onMessage`](#remoteonmessagecallback-id-message--void)
- [`LinenWS.hasConnected`](#LinenWShasconnectedid-boolean)

### LinenWS(server)

```js
const socket = LinenWS(server);
```

The `server` should be a http/https server instance.

#### socket.onServerUpgrade(callback: (next, quit, request, socket, head) => void)

The `callback` is called every time when the server upgrades a http(s) request to a websocket.

To keep the request from executing further, call `quit()`, otherwise you can call `next()`.

Example:

```js
socket.onServerUpgrade((next, quit, request, socket, head) => {
    if (someCondition) next();
    else quit();
})
```

#### socket.onConnection(callback: id => void)

The `callback` is called everytime a new websocket connection is recieved.  If `quit` or `next` are not called in [`socket.onServerUpgrade`](#socketonserverupgradecallback-next-quit-request-socket-head--void), then this will happen right after `onServerUpgrade`.

The `id` is the random id assigned to the client.

#### socket.use(callback: (id, message, next) => void)

Custom middleware, just like `express.use()`

#### socket.onMessage(method: String, callback: (id, message) => void)

The `callback` is called everytime a message is recieved whose method property equals `method`.

#### socket.onClose(callback: (id, code) => void)

The `callback` is called whenever a websocket connection closes. `id` will be the id of the connection that closed.

#### socket.useRemote(method: String, remote: [remoteEngine]())

The `remote` is the remoteEngine to use for the given `method`.

Now LinenWS will call the `onMessage` method on the remote when the message's method property equals `method`.

Here is an [example](#remotes).

#### socket.catchErrors(callback: (error, id, message) => void)

The `callback` is called every time an unhandled error or promise rejection occurs in the message processing pipeline.  `message` and `id` are the message that was being processed when the error occured, and the id of the client that sent that message.

### LinenWS.commands

```js
const { commands } = LinenWS;
```

#### commands.send(id, method, data)

The `id` is the id of the client to send the message to.

The `method` is the method of the message.

The `data` is what is to me sent in the message.

#### commands.broadcastAll(method, data)

Same as [`commands.send`](#commandssendid-method-data), except that it broadcasts a message to all the clients.

#### commands.broadcastExclude()]

The `id` is the id of the client to exclude.

Otherwise, id is the same as [`commands.broadcastAll`](#commandsbroadcastallmethod-data).

#### commands.close(id?)

If and `id` is given, LinenWS will close only that connection, otherwise, it will close all the connections.

#### commands.getConnections(): Object

Returns an object of all the connections.  Here is an sample of what that might look like:

```json
{
    "socketId1568846090925": {
        "id": "socketId1568846090925",
        "incommingMessages": [
            {
                "method": "default",
                "data": "this is fake"
            }
        ],
        "outgoingMessages": [
            {
                "method": "someMethod",
                "data": "so is this"
            }
        ],
        "ip": "::1"
    }
}
```

### LinenWS.remoteEngine()

```js
const remote = require('linenws-server').remoteEngine();

// Do something...

module.exports = remote;
```

See this [example](#remotes).

#### remote.onMessage(callback: (id, message) => void)

The `callback` will be called when a message is recieved with a method that matches the `method` paramater in the `socket.useRemote` function.

### LinenWS.hasConnected(id?): Boolean

Checks if a connection exists.

The `id` is the id of the connection to check.  If no id is given, LinenWS will check for at least one connection.

## Thanks

Many thanks to [@websockets/ws](https://github.com/websockets/ws), the backbone of this package.

## License

[MIT](/LICENSE)