import QtQuick 2.0

ListModel {
    function indexOf(resolution) {
        for(var i=0; i<count; ++i) {
            if(get(i).resolution === resolution) return i;
        }
        return -1;
    }
    function getAsSize(i) {
        if(typeof i === 'undefined' || i<0 || i>=count) return Qt.size(-1,-1);
        var elt=get(i);
        if(!elt) return Qt.size(-1,-1);
        return Qt.size(elt.width, elt.height);
    }
    function appendSize(size) {
        append({"width": size.width, "height": size.height })
    }
    function insertSize(i, size) {
        insert(i, {"width": size.width, "height": size.height })
    }

    signal modelChanged()
}
