'use strict';

let xmldom = require('xmldom');
let DOMImplementation = xmldom.DOMImplementation;
let XMLSerializer = xmldom.XMLSerializer;
let xmlSerializer = new XMLSerializer();
let document = new DOMImplementation().createDocument('http://www.w3.org/1999/xhtml', 'html', null);
const JsBarcode = require('jsbarcode');

/**
 * HTTP Cloud Function.
 *
 * @param {Object} req Cloud Function request context.
 *                     More info: https://expressjs.com/en/api.html#req
 * @param {Object} res Cloud Function response context.
 *                     More info: https://expressjs.com/en/api.html#res
 */
exports.convertBarcode = (req, res) => {

    // http://localhost:8080/?format=upc&value=123456789012
    // req.query.format
    // req.query.value
    let svgNode = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    JsBarcode(svgNode, req.query.value, {
        xmlDocument: document,
        format: req.query.format
    });

    let xml = xmlSerializer.serializeToString(svgNode);
    // console.info(xml)
    res.setHeader("content-type", "image/svg+xml");
    res.send(xml);

};