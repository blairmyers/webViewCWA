
function performDoubleClickAtPoint(x, y) {
    try {
        var elem = elementAtPoint(x, y);
        var msg = 'hello';
        console.log(msg);
        if (elem) {
            var clickEvt = new MouseEvent("click", {bubbles: true});
            elem.dispatchEvent(clickEvt);
            var dblClickEvt = new MouseEvent("dblclick", {bubbles: true});
            elem.dispatchEvent(dblClickEvt);
        }
    } catch (e) {
        postErrorMessage(e, arguments);
    } finally {
        if (elem) {
            return elem.toString();
        } else {
            return "null element";
        }
    }
}

function performShiftClickAtPoint(x, y) {
    try {
        var elem = elementAtPoint(x, y)
        if (elem) {
            var shiftClickEvt = new MouseEvent("click", {shiftKey: true, bubbles: true});
            elem.dispatchEvent(shiftClickEvt);
        }
    } catch (e) {
        postErrorMessage(e, arguments);
    }
}

function performCommandClickAtPoint(x, y) {
    try {
        var elem = elementAtPoint(x, y)
        if (elem) {
            var cmdClickEvt = new MouseEvent("click", {metaKey: true, bubbles: true});
            elem.dispatchEvent(cmdClickEvt);
        }
    } catch (e) {
        postErrorMessage(e, arguments);
    }
}

function elementAtPoint(x, y) {
    try {
        var elem;
        var doc;
        if (document) {
            doc = document;
        } else {
            doc = contentDocument;
        }
        elem = doc.elementFromPoint(x - scrollX, y - scrollY);
        if (!elem) {
            throw new ReferenceError('elementAtPoint function returned null object');
        }
        var tagName = elem.tagName.toUpperCase();
        while (tagName == 'FRAME' || tagName == 'IFRAME') {
            if (elem.contentDocument) {
                doc = elem.contentDocument;
            } else {
                doc = elem.document;
            }
            elem = doc.elementFromPoint(x, y);
            if (!elem) {
                throw new ReferenceError('in subframe elementAtPoint function returned null object');
            }
            tagName = elem.tagName.toUpperCase();
        }
        return elem;
    } catch (e) {
        postErrorMessage(e, arguments);
    }
    
}
