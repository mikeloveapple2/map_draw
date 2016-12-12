import QtQuick 2.0


Rectangle {
    id : root
    width : 480
    height : 360
    radius:  8
    color : "#7f000000"

    border {
        width: 3
        color : "#7f555555"
    }

    property var debug : false;

    function log(str){
        if(debug){
            print(str);
        }
    }

    Canvas {
        id: canvas
        anchors {
            left: parent.left
            right: parent.right
            top : parent.top
            bottom: parent.bottom
            margins: 8
        }
        property real lastX
        property real lastY
        property color color : "orange"
        property var needToClear : false

        onPaint: {
            var ctx = getContext('2d')
            if(needToClear){
                needToClear = false;
                ctx.clearRect(0, 0, canvas.width, canvas.height);
            }else{
                ctx.lineWidth = 1.5
                ctx.strokeStyle = canvas.color
                ctx.beginPath()
                ctx.moveTo(lastX, lastY)
                lastX = area.mouseX
                lastY = area.mouseY
                ctx.lineTo(lastX, lastY)
                ctx.stroke()
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent

            property var tmp_x
            property var tmp_y
            property var pathArray : []
            property var diff : 10

            onPressed: {
                canvas.lastX = mouseX
                canvas.lastY = mouseY
            }

            onReleased: {
                print("\n \x1b[42m------------- onReleased ---------------\x1b[0m");

                var lastOne = getLastPoint();
                if(typeof(lastOne) != "undefined"){
                    lastOne.y = mouseY;
                    lastOne.x = mouseX;
                }
                displayArray();
            }

            onPositionChanged: {
                canvas.requestPaint()

                updatePoint(mouseX, mouseY);

            }// onPositionChanged

            function updatePoint(mouseX, mouseY){
                if(pathArray.length < 2){
                    addPoint(mouseX, mouseY);
                }

                var lastOne = getLastPoint();

                if(typeof(lastOne) == "undefined"){
                    print("\x1b[41m getLastPoint error\x1b[0m");
                }

                var diff_x = false;
                if(lastOne.x != mouseX){
                    var diff_nums = mouseX - lastOne.x;
                    diff_nums = Math.abs(diff_nums);
                    if(diff_nums > diff){
                        log("\x1b[32m diffX : " + diff_nums + "\x1b[0m");
                        log("mouseX", mouseX, "lastX", lastOne.x);
                        diff_x = true;
                    }
                }

                var diff_y = false;
                if(lastOne.y != mouseY){
                    var diff_nums = mouseY - lastOne.y;
                    diff_nums = Math.abs(diff_nums);
                    if(diff_nums > diff){
                        log("\x1b[32m diffY : " + diff_nums + "\x1b[0m");
                        log("mouseY", mouseY, "lastY", lastOne.y);
                        diff_y = true;
                    }
                }
                if( diff_x && diff_y ){
                    print("\x1b[31m old :" + lastOne.x + ", " + lastOne.y + " \x1b[32m new :" +
                          mouseX + ", " + mouseY + "\x1b[0m");
                    addPoint(mouseX, mouseY);
                    displayArray();
                }
            }

            function getLastPoint(){
                var length = pathArray.length;
                if(length){
                    return pathArray[ length -1 ];
                }else{
                    return undefined;
                }
            }

            function addPoint(x, y){
                var point = {};
                point.x = x;
                point.y = y;
                pathArray.push(point);
            }

            function displayArray(){
                for(var i = 0; i < pathArray.length; ++i){
                    var obj = pathArray[i];
                    print(i, obj.x, obj.y);
                }
            }
        }// area

        function clearArray(){
            area.pathArray = [];
        }
    }

}
