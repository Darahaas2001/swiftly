const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

io.on('connection', (socket) => {
	console.log('A user connected');

	socket.on('joinRoom', (room) => {
		socket.join(room);
		console.log(`User joined room: ${room}`);
	});

	socket.on('chatMessage', ({ room, message, senderName }) => {
		io.emit('message', { text: message, senderName });
	});

	socket.on('disconnect', () => {
		console.log('User disconnected');
	});
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
