
var iniciado = 0;
function Init_Cam() {
console.log("Entrada Init_Cam");
   
    Webcam.set({

        width: 320,
        height: 480,
        dest_width:640,
        dest_height:720,
        image_format: 'jpeg',
        jpeg_quality: 90
    });
    Webcam.attach('#my_camera');
	

	
	
	
}

//function take_snapshot() 
//{
//    // take snapshot and get image data
//    Webcam.snap(function (data_uri) 
//    {
//        // display results in page
//        document.getElementById('results').innerHTML = '<img style="width:640px;height:480px;" src="' + data_uri + '"/>';
//    });
//}


function preview_snapshot() 
{
    var $loading = $("#loading");
    var $divblock = $("#div_blocked");


    $divblock.show();
    $loading.show();

    // freeze camera so user can preview pic
    Webcam.freeze();

    // swap button sets
    document.getElementById('pre_take_buttons').style.display = 'none';
    document.getElementById('post_take_buttons').style.display = 'block';

    $divblock.hide();
    $loading.hide();


}



function cancel_preview() 
{
    // cancel preview freeze and return to live camera feed
    Webcam.unfreeze();

    // swap buttons back
    document.getElementById('pre_take_buttons').style.display = 'block';
    document.getElementById('post_take_buttons').style.display = 'none';



}


function save_photo() 
{
    // actually snap photo (from preview freeze) and display it
    Webcam.snap(function (data_uri) {
        // display results in page
        //document.getElementById('results').innerHTML ='<img style="width:640px;height:480px;" src="' + data_uri + '"/>';


        var $loading = $("#loading");
        var $divblock = $("#div_blocked");


        $divblock.show();
        $loading.show();



        // swap buttons back       
        document.getElementById('pre_take_buttons').style.display = 'none';
        document.getElementById('post_take_buttons').style.display = 'none';
        //var res = encodeURI(data_uri);
        //   window.open(res);

        // document.getElementById('base').value = data_uri;

        // Check browser support
        if (typeof (Storage) !== "undefined") {

            // Store
            localStorage.setItem("lastname", data_uri.toString());
            // Retrieve
            //document.getElementById("result_imagen").innerHTML = document.getElementById("result_imagen").innerHTML + "<img   width='640px' height='720px' src='" + localStorage.getItem("lastname") + "'  /> ";
            //alert("guardado con exito");

        }
        else
        {
            document.getElementById("result_imagen").innerHTML = "Lo sentimos,tu navegador no soporta almacenamiento Web...";
        }


        // alert("inicia proceso de descarga");
        //var textoBase64 = data_uri.toString().replace("data:image/jpeg;base64,", "");
        var textoBase64 = data_uri.toString();

        // Convert the Base64 string back to text.
        //var byteString = atob(textoBase64);

        // Convert that text into a byte array.
        //var ab = new ArrayBuffer(byteString.length);
        //var ia = new Uint8Array(ab);
        //for (var i = 0; i < byteString.length; i++) {
        //    ia[i] = byteString.charCodeAt(i);
        //}

        //alert("array ia : " + ia.length.toString());

        // Blob for saving.
        //var blob = new Blob([ia], { type: "images/jpeg" });
        //alert("blob generado");

        // Tell the browser to save as report.pdf.
       // saveAs(blob, "imagen.jpg");

        //alert("Archivo generado con exito");

        // Alternatively, you could redirect to the blob to open it in the browser.
        //document.location.href = window.URL.createObjectURL(blob);

        //	           $.ajax({
        //	               type: "POST",
        //	               url: "download.aspx",
        //	               data: { base: res } ,
        //	               cache: false,
        //	               contentType: "application/x-www-form-urlencoded",
        //	               success: function (result) 
        //                   {
        //	                   alert(result);
        //	               }

        //	           });


        Webcam.unfreeze();

        var pic_actual = document.getElementById('pic_actual');
        var flg_tomada = document.getElementById('flg_tomada');
        var str_actual = document.getElementById('str_actual');
        var tit_nom_pic = document.getElementById('tit_nom_pic');
        var contenedor_texto = document.getElementById('contenedor_texto');
        var chk1 = document.getElementById('chk1');
        

        Cambiar_FLG_Doc(textoBase64);
        pic_actual.value = "";        
        tit_nom_pic.innerHTML = "";
        contenedor_texto.innerHTML = "";
        chk1.checked = false;
        //Webcam.reset();
        Request_inicial2();
        
        $divblock.hide();
        $loading.hide();



    });
}



function Request_inicial() {


    var jsn1 = document.getElementById('jsn1');
    var pic_actual = document.getElementById('pic_actual');
    var flg_tomada = document.getElementById('flg_tomada');
    var str_actual = document.getElementById('str_actual');
    var tit_nom_pic = document.getElementById('tit_nom_pic');
    var contenedor_texto = document.getElementById('contenedor_texto');
    var esta_grupo = document.getElementById('esta_grupo');
    

    var str1 = jsn1.value;    
    var inf = JSON.parse(str1);
    //alert(inf.docs_camara.length.toString());
    var keep_taken = 0;

    
    for (var i = 0; i < inf.docs_camara.length;i++)
    {


        console.log("*******************************************************");
        console.log("inf.docs_camara[i].id_doc:" + inf.docs_camara[i].id_doc);
        console.log("inf.docs_camara[i].nom:" + inf.docs_camara[i].nom);
        console.log("inf.docs_camara[i].tomada:" + inf.docs_camara[i].tomada);
        console.log("inf.docs_camara[i].mandatoria:" + inf.docs_camara[i].mandatoria);
        console.log("inf.docs_camara[i].grupo:" + inf.docs_camara[i].grupo);
        console.log("inf.docs_camara[i].cabeza_grupo:" + inf.docs_camara[i].cabeza_grupo);
        console.log("inf.docs_camara[i].obliga_imagen:" + inf.docs_camara[i].obliga_imagen);
        console.log("*******************************************************");


        if (inf.docs_camara[i].mandatoria == "S")
         {


             if (inf.docs_camara[i].tomada == "0" && inf.docs_camara[i].grupo == "0") 
             {


                 if (inf.docs_camara[i].cubre_a != "0") {
                     document.getElementById('contenedor_checkbox').style.display = 'block';
                 }
                 else {
                     document.getElementById('contenedor_checkbox').style.display = 'none';

                 }

                 esta_grupo.value = inf.docs_camara[i].grupo;
                 pic_actual.value = inf.docs_camara[i].id_doc;
                 tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
                 contenedor_texto.innerHTML = inf.docs_camara[i].coments;

                 //if(iniciado == 0){
					//console.log(" var iniciado:"+iniciado.toString());
					  Init_Cam();
					//iniciado = 1;					
			     //}console.log("var iniciado:"+iniciado.toString());
				 
				 
                 document.getElementById('pre_take_buttons').style.display = 'block';
                 keep_taken++;
                 break;

             }


         } else {

            var flg_grupo_tomada =0;

            if (inf.docs_camara[i].tomada == "0" && inf.docs_camara[i].grupo != "0" && inf.docs_camara[i].cabeza_grupo == "1") {


                for(var c=0;c <  inf.docs_camara.length;c++)
                {
                    if (inf.docs_camara[c].tomada == "1" && inf.docs_camara[i].grupo == inf.docs_camara[c].grupo)
                    {
                        flg_grupo_tomada++;
                    }
             
                }


                if (flg_grupo_tomada == 0)
                {
                                       

                        if (inf.docs_camara[i].cubre_a != "0") {
                            document.getElementById('contenedor_checkbox').style.display = 'block';
                        }
                        else {
                            document.getElementById('contenedor_checkbox').style.display = 'none';
                        }

                        //pic_actual.value = inf.docs_camara[i].id_doc;

                        var contador_items = 0;
                        var cadena = "";

                        cadena += "<select id='list_docs' onchange='Set_item_selected();'>";


                        contador_items++;

                        cadena += "<option value='" + inf.docs_camara[i].id_doc + "'>" + inf.docs_camara[i].nom + "</option>";

                        for (var j = 0; j < inf.docs_camara.length; j++) {

                            if (inf.docs_camara[j].obliga_imagen == "0" && inf.docs_camara[j].cabeza_grupo == "0" && inf.docs_camara[i].grupo == inf.docs_camara[j].grupo) {

                                cadena += "<option value='" + inf.docs_camara[j].id_doc + "'>" + inf.docs_camara[j].nom + "</option>";
                                contador_items++;

                            }

                        }

                        cadena += "</select>";

                        if (contador_items > 0) {
                            tit_nom_pic.innerHTML = cadena;
                        }
                        else {
                            tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
                        }
                        pic_actual.value = inf.docs_camara[i].id_doc;
                        esta_grupo.value = inf.docs_camara[i].grupo;
                        contenedor_texto.innerHTML = inf.docs_camara[i].coments;

                        Init_Cam();
                        document.getElementById('pre_take_buttons').style.display = 'block';

                        keep_taken++;
                        break;

            }




         }
         else 
         {


             var flg_tomar = 0;

             for (var x = 0; x < inf.docs_camara.length; x++) 
			 {

                 if (inf.docs_camara[i].tomada == "0" && inf.docs_camara[x].obliga_imagen == inf.docs_camara[i].id_doc && inf.docs_camara[x].tomada == "1") {
                     flg_tomar = 1;
                 }

               }
         
            
                     if (flg_tomar >0 )
                     {

                             if (inf.docs_camara[i].cubre_a != "0") 
							 {
                                 document.getElementById('contenedor_checkbox').style.display = 'block';
                             }
                             else 
							 {
                                 document.getElementById('contenedor_checkbox').style.display = 'none';

                             }

                             esta_grupo.value = inf.docs_camara[i].grupo;
                             pic_actual.value = inf.docs_camara[i].id_doc;
                             tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
                             contenedor_texto.innerHTML = inf.docs_camara[i].coments;

                              Init_Cam();
                             document.getElementById('pre_take_buttons').style.display = 'block';
                             keep_taken++;
                             break;

                     }
         
            }

         }
            
    }


    if (keep_taken > 0) {
        document.getElementById('imgcontinuar').style.display = 'none';
    }
    else
    {
	    
        document.getElementById('imgcontinuar').style.display = 'block';
    }
      

    //var aux_grupos =  inf.grupos.toString().split(";");
    //var aux_valor = "";      

    //for (var i = 0; i < inf.docs_camara.length; i++) {

    //    for (var j = 0; j < aux_grupos.length; j++)
    //    {

    //        if (inf.docs_camara[i].grupo == aux_grupos[i])
    //       {

    //             if (inf.docs_camara[i].tomada == "0") 
    //             {

    //                    pic_actual.value = inf.docs_camara[i].id_doc;
    //                    tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
    //                    contenedor_texto.innerHTML = inf.docs_camara[i].coments;

    //                    Init_Cam();
    //                    document.getElementById('pre_take_buttons').style.display = 'block';
    //                    break;


    //            }


    //        }

    //     } 

    // }
    

}



function Cambiar_FLG_Doc(str)
{
    

    var jsn1 = document.getElementById('jsn1');
    var pic_actual2 = document.getElementById('pic_actual');
    var flg_tomada = document.getElementById('flg_tomada');
    var str_actual = document.getElementById('str_actual');
    var tit_nom_pic = document.getElementById('tit_nom_pic');
    var contenedor_texto = document.getElementById('contenedor_texto');
    var chk1 = document.getElementById('chk1');

    var str1 = jsn1.value;
    var inf = JSON.parse(str1);
    //alert(inf.docs_camara.length.toString());

    for (var i = 0; i < inf.docs_camara.length; i++)
    {
        if (inf.docs_camara[i].id_doc == pic_actual2.value)
        {
            
            if (chk1.checked)
            {            
                for (var r = 0; r < inf.docs_camara.length;r++)
                {
                
                    if (inf.docs_camara[i].cubre_a == inf.docs_camara[r].id_doc)
                    {
                        inf.docs_camara[r].tomada = "1";
                        inf.docs_camara[r].string64 = str;
                    }
                }
            }


            inf.docs_camara[i].tomada = "1";
            inf.docs_camara[i].string64 = str;
            jsn1.value = JSON.stringify(inf);

                break;            
        }

    }




    }






function Set_item_selected() 
{


    var contenedor_texto = document.getElementById('contenedor_texto');
    var list = document.getElementById('list_docs');

    if(list != null)
    {
    
        //if (list.selected == true) {
     

    var pic_actual3 = document.getElementById('pic_actual');
    pic_actual3.value = list.value;
   // alert(pic_actual3.value);
    var jsn1 = document.getElementById('jsn1');    
    var str1 = jsn1.value;
    var inf = JSON.parse(str1);
    contenedor_texto.innerHTML = "";


    for (var i = 0; i < inf.docs_camara.length; i++)
    {

        if (inf.docs_camara[i].id_doc == pic_actual3.value) {

            contenedor_texto.innerHTML = inf.docs_camara[i].coments;
            if (inf.docs_camara[i].cubre_a != "0") {
                document.getElementById('contenedor_checkbox').style.display = 'block';
            }
            else {
                document.getElementById('contenedor_checkbox').style.display = 'none';
            }


            break;

        }

    }

        //}

    }



}


function hide_previa_cam()
{
    document.getElementById('previa_foto').style.display = 'none';
    document.getElementById('front1').style.display = 'block'; 

    Request_inicial();
    GetWindowSize();
    GetPortraitLandscape();
   


}


$(document).ready(function () {

 
    $(window).on('orientationchange resize', function () {
        GetWindowSize();
        GetPortraitLandscape();
    });

});



function GetWindowSize() {
    $('#dimensions').html('Height: ' + $(window).height() + '<br>Width: ' + $(window).width());
    //alert('Height: ' + $(window).height() + '<br>Width: ' + $(window).width() );
}

function GetPortraitLandscape() {
    if ($(window).height() < $(window).width()) {
        // alert('Landscape');
       // document.getElementById('my_camera').style.width = '320px';
       // document.getElementById('my_camera').style.height = '480px';

    } 
    else 
    {
        // alert('Portrait');

        //document.getElementById('my_camera').style.width = '640px';
        //document.getElementById('my_camera').style.height = '960px';
     
    }
}



function Request_inicial2() {


    var jsn1 = document.getElementById('jsn1');
    var pic_actual = document.getElementById('pic_actual');
    var flg_tomada = document.getElementById('flg_tomada');
    var str_actual = document.getElementById('str_actual');
    var tit_nom_pic = document.getElementById('tit_nom_pic');
    var contenedor_texto = document.getElementById('contenedor_texto');
    var esta_grupo = document.getElementById('esta_grupo');
    

    var str1 = jsn1.value;    
    var inf = JSON.parse(str1);
    //alert(inf.docs_camara.length.toString());
    var keep_taken = 0;

    
    for (var i = 0; i < inf.docs_camara.length;i++)
    {


        console.log("*******************************************************");
        console.log("inf.docs_camara[i].id_doc:" + inf.docs_camara[i].id_doc);
        console.log("inf.docs_camara[i].nom:" + inf.docs_camara[i].nom);
        console.log("inf.docs_camara[i].tomada:" + inf.docs_camara[i].tomada);
        console.log("inf.docs_camara[i].mandatoria:" + inf.docs_camara[i].mandatoria);
        console.log("inf.docs_camara[i].grupo:" + inf.docs_camara[i].grupo);
        console.log("inf.docs_camara[i].cabeza_grupo:" + inf.docs_camara[i].cabeza_grupo);
        console.log("inf.docs_camara[i].obliga_imagen:" + inf.docs_camara[i].obliga_imagen);
        console.log("*******************************************************");


        if (inf.docs_camara[i].mandatoria == "S")
         {


             if (inf.docs_camara[i].tomada == "0" && inf.docs_camara[i].grupo == "0") 
             {


                 if (inf.docs_camara[i].cubre_a != "0") {
                     document.getElementById('contenedor_checkbox').style.display = 'block';
                 }
                 else {
                     document.getElementById('contenedor_checkbox').style.display = 'none';

                 }

                 esta_grupo.value = inf.docs_camara[i].grupo;
                 pic_actual.value = inf.docs_camara[i].id_doc;
                 tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
                 contenedor_texto.innerHTML = inf.docs_camara[i].coments;

					  //Init_Cam();
						 
                 document.getElementById('pre_take_buttons').style.display = 'block';
                 keep_taken++;
                 break;

             }


         } else {

            var flg_grupo_tomada =0;

            if (inf.docs_camara[i].tomada == "0" && inf.docs_camara[i].grupo != "0" && inf.docs_camara[i].cabeza_grupo == "1") {


                for(var c=0;c <  inf.docs_camara.length;c++)
                {
                    if (inf.docs_camara[c].tomada == "1" && inf.docs_camara[i].grupo == inf.docs_camara[c].grupo)
                    {
                        flg_grupo_tomada++;
                    }
             
                }


                if (flg_grupo_tomada == 0)
                {
                                       

                        if (inf.docs_camara[i].cubre_a != "0") {
                            document.getElementById('contenedor_checkbox').style.display = 'block';
                        }
                        else {
                            document.getElementById('contenedor_checkbox').style.display = 'none';
                        }

                        //pic_actual.value = inf.docs_camara[i].id_doc;

                        var contador_items = 0;
                        var cadena = "";

                        cadena += "<select id='list_docs' onchange='Set_item_selected();'>";


                        contador_items++;

                        cadena += "<option value='" + inf.docs_camara[i].id_doc + "'>" + inf.docs_camara[i].nom + "</option>";

                        for (var j = 0; j < inf.docs_camara.length; j++) {

                            if (inf.docs_camara[j].obliga_imagen == "0" && inf.docs_camara[j].cabeza_grupo == "0" && inf.docs_camara[i].grupo == inf.docs_camara[j].grupo) {

                                cadena += "<option value='" + inf.docs_camara[j].id_doc + "'>" + inf.docs_camara[j].nom + "</option>";
                                contador_items++;

                            }

                        }

                        cadena += "</select>";

                        if (contador_items > 0) {
                            tit_nom_pic.innerHTML = cadena;
                        }
                        else {
                            tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
                        }
                        pic_actual.value = inf.docs_camara[i].id_doc;
                        esta_grupo.value = inf.docs_camara[i].grupo;
                        contenedor_texto.innerHTML = inf.docs_camara[i].coments;

                        //Init_Cam();
                        document.getElementById('pre_take_buttons').style.display = 'block';

                        keep_taken++;
                        break;

            }




         }
         else 
         {


             var flg_tomar = 0;

             for (var x = 0; x < inf.docs_camara.length; x++) 
			 {

                 if (inf.docs_camara[i].tomada == "0" && inf.docs_camara[x].obliga_imagen == inf.docs_camara[i].id_doc && inf.docs_camara[x].tomada == "1") {
                     flg_tomar = 1;
                 }

               }
         
            
                     if (flg_tomar >0 )
                     {

                             if (inf.docs_camara[i].cubre_a != "0") 
							 {
                                 document.getElementById('contenedor_checkbox').style.display = 'block';
                             }
                             else 
							 {
                                 document.getElementById('contenedor_checkbox').style.display = 'none';

                             }

                             esta_grupo.value = inf.docs_camara[i].grupo;
                             pic_actual.value = inf.docs_camara[i].id_doc;
                             tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
                             contenedor_texto.innerHTML = inf.docs_camara[i].coments;

                              //Init_Cam();
                             document.getElementById('pre_take_buttons').style.display = 'block';
                             keep_taken++;
                             break;

                     }
         
            }

         }
            
    }


    if (keep_taken > 0) {
        document.getElementById('imgcontinuar').style.display = 'none';
    }
    else
    {
	     Webcam.reset();
        document.getElementById('imgcontinuar').style.display = 'block';
    }
      

    //var aux_grupos =  inf.grupos.toString().split(";");
    //var aux_valor = "";      

    //for (var i = 0; i < inf.docs_camara.length; i++) {

    //    for (var j = 0; j < aux_grupos.length; j++)
    //    {

    //        if (inf.docs_camara[i].grupo == aux_grupos[i])
    //       {

    //             if (inf.docs_camara[i].tomada == "0") 
    //             {

    //                    pic_actual.value = inf.docs_camara[i].id_doc;
    //                    tit_nom_pic.innerHTML = inf.docs_camara[i].nom;
    //                    contenedor_texto.innerHTML = inf.docs_camara[i].coments;

    //                    Init_Cam();
    //                    document.getElementById('pre_take_buttons').style.display = 'block';
    //                    break;


    //            }


    //        }

    //     } 

    // }
    

}







