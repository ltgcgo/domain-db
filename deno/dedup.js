"use strict";

import TextReader from "https://jsr.io/@ltgc/rochelle/0.2.8/dist/textRead.mjs";

let instanceConfig = JSON.parse(await Deno.readTextFile("./deno/config.json"));
//console.debug(instanceConfig);

let TreeNode = class TreeNode {
	terminate = false;
	children = new Map();
};

for (let target in instanceConfig) {
	// Define a root node
	let rootNode = new TreeNode();
	// Build a tree
	for (let sourceId of instanceConfig[target]) {
		let sourceFileHandle = await Deno.open(`./intermediate/${sourceId}`);
		let lineNo = 0;
		for await (let line of TextReader.line(sourceFileHandle.readable)) {
			//console.debug(`${sourceId} :: ${line}`);
			lineNo ++;
			if (line.indexOf("domain:") === 0) {
				let domainArray = line.substring(7).split(".").reverse();
				//console.debug(domainArray);
				let focusedNode = rootNode;
				for (let i = 0; i < domainArray.length; i ++) {
					let nibble = domainArray[i];
					if (!focusedNode.children.has(nibble)) {
						let newNode = new TreeNode();
						newNode.data = domainArray.slice(0, i + 1);
						focusedNode.children.set(nibble, newNode);
					};
					focusedNode = focusedNode.children.get(nibble);
				};
				focusedNode.terminate = true;
			} else {
				console.debug(`"${target}": "${sourceId}", line ${lineNo} ignored.`);
			};
		};
		console.debug(`"${target}": "${sourceId}", read ${lineNo} line(s).`);
	};
	//console.debug(rootNode);
	// Traverse the tree and emit
	let resultArray = [];
	let encoderStream = new TextEncoderStream();
	let encoderStreamWriter = encoderStream.writable.getWriter();
	let targetFileHandle = await Deno.open(`./data/${target}`, {
		write: true, truncate: true, create: true
	});
	encoderStream.readable.pipeTo(targetFileHandle.writable);
	let iterateOneLevel = async (node) => {
		if (node.terminate) {
			return;
		};
		for (let kvPair of node.children) {
			if (kvPair[1].terminate) {
				//console.debug(kvPair[1].data);
				resultArray.push(kvPair[1].data.reverse().join("."));
			} else {
				await iterateOneLevel(kvPair[1]);
			};
		};
	};
	await iterateOneLevel(rootNode);
	resultArray.sort();
	encoderStreamWriter.write(`# Deduplicated.\n`);
	for (let line of resultArray) {
		await encoderStreamWriter.ready;
		encoderStreamWriter.write(`domain:${line}\n`);
	};
	console.debug(`"${target}": wrote ${resultArray.length} line(s).`);
	encoderStreamWriter.close();
	await encoderStreamWriter.closed;
	targetFileHandle.close();
};