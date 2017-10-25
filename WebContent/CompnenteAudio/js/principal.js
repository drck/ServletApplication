 
document.oncontextmenu = function(){return false}



function showPage() {

    if (self == top) {
        document.getElementById('errorpage').style.display = 'none';
        document.getElementById('errorpage').style.visibility = 'hidden';
        document.getElementById('realpage').style.display = 'block';
        document.getElementById('realpage').style.visibility = 'visible';
    }
    else {
        top.location = self.location;
       document.getElementById('realpage').innerHTML= "Esta pagina requiere javascript.";
    }

}