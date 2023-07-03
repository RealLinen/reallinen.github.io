const joi = require('@hapi/joi');

module.exports.method = value => {
	const type = typeof value;
	if (type !== 'string') throw new TypeError(`method should be a string.  Recieved type ${type}.`);
	if (value.length < 1) throw new Error(`method id not allowed to be empty.`)
}
module.exports.id = value => {
	const type = typeof value;
	if (type !== 'string') throw new TypeError(`id should be a string.  Recieved type ${type}.`);
}
module.exports.cb = value => {
	const type = typeof value;
	if (type !== 'function') throw new TypeError(`callback should be a string.  Recieved type ${type}.`);
}
module.exports.remote = value => {
	const { error } = joi.object({
		calls: joi.array().required(),
		onMessage: joi.func().required(),
	}).validate(value);

	if (error) throw new Error(`remote must be a valid remoteEngine`);
}
module.exports.messageData = value => {
	try {
		JSON.stringify([value]);
	} catch (e) {
		throw new Error(`data should be a valid string, object, or array.  JSON.stringify() failed: `, e.message);
	}
}