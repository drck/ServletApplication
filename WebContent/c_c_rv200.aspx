

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>

</title><meta http-equiv="cache-control" content="max-age=0" /><meta http-equiv="cache-control" content="no-cache" /><meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" /><meta http-equiv="pragma" content="no-cache" />

     <script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
    <script src="js/jquery.js" type="text/javascript"></script>

    <script src="js/principal.js" type="text/javascript"></script>   
    <link href="css/main.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/webcam.js"></script>

    <script src="js/cam.js" type="text/javascript"></script>
    <link href="css/camara.css" rel="stylesheet" type="text/css" />

    <script src="js/efectos_pantallas.js" type="text/javascript"></script>
    <link href="css/efectos_pantallas.css" rel="stylesheet" type="text/css" /></head>
<body >
    <form method="post" action="c_c_rv200.aspx" id="form1">
<div class="aspNetHidden">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="xB8dAtjMlhrAd+C6swaQ5hmD0WoBnjE6l+NB/03oXAnNOsvNUnubDuRcysSdbveFdMXdqlKZzxVuNdARBeYohZm5rlCweCHTqZVdMa3MeZ9/4kP66qBtWXlNMFyE74U/Pja95WQbJeIItySjF9LqQu0P9es3mRFaS8Pj4/hwPuzLbRqM+XHc7zXAqbDmgGEAJFrjfoZKCNnu0pXczrOKnDBoqErgO8aNh6lXjeap9ZtYGieIUmI4EHEZ9uJwCodEOTgtZnnRwUOzWaPubSU1RQJmRSNYcqHDKCgy8VNhiXtgyck+u2rx7+jUUNFxi+qevIPggaakBCDnb8nsxfs1yJ3jiiF4YaciJqfItd+v6S1xPC4tCHVjnqTal9++ZnDjXZn+MrXdx++JQq85lBEmNPCnYn3j/FlS8LLzYnu1lOxG5qvGII+qbFaPmNhz/ORATeAQCG2F0vjZCHLqgGQYtfb8sjYBFRb3om9I/9/A5dzeEUxZ5ORzSlKrXIsIH3D3tm0E2L5QF20/OZ9DPbgmyyHtc9B41rNZKZjDcQJ1s8PvHQKPIQm5upNQf+1E8XxFSKvOkA==" />
</div>

<div class="aspNetHidden">

	<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="02886FE5" />
	<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="asdhcuCWKTMyaBcCk5V89ak37hXYdKNvIQr2VUtxpa61XFA1J4PY60eefWFwHv6PPFk9QjUz9HXxWNFw3O5DKz2X4O/tP/Ym+k4hTPBT8IDX4XhaEQpy4B5g5ainKa09nDkHxnI2MBB0JLep" />
</div>
      
     <div id="div_blocked"></div>
    <div id="loading"  style="display:none;" >
      <div class="contenedor_img_reloj"> <img src="css/img/enEspera.JPG" /></div>    
       <span>Realizando Consulta</span>
    </div>
     <div id="errorpage">                
     </div>

   

      
        <img src='css/img/menu3.png'  class='barra_progreso'  />           
        <script>   $(document).ready(function(){  Request_inicial(); });  </script>    
          
          <div id="previa_foto">
            <p>La fotografía debe ser clara, sin lentes, gorra o sombrero. Pide al cliente que no cierre los ojos y toma la foto en un lugar iluminado para que no salga obscura.</p>
                     <div class="centro_prev_foto"><img src="css/img/prev1_foto.png" />  </div>           
                              <div id="contenedor_btn_activar" >                                   
                                   <div   class="btn_img_activar"  onclick="hide_previa_cam();" ></div> 
                              </div>  
            </div>

          <div id="realpage" > 

          <div id="front1">
          
          
        <div id="tit_nom_pic" class="tit_pic"></div>
        <div id="contenedor_subtit" class="contenedor_subtit">
        <div id="contenedor_checkbox" class="contenedor_checkbox">
             <input type="checkbox" id="chk1"  />
        </div>
        <div id="contenedor_texto" class="contenedor_texto"></div> 
        </div>
       <div  id="my_camera"></div>

       <!-- A button for taking snaps -->

        <div class="contenedor_button_preview">	
		   
			<div id="pre_take_buttons"  >				 
                <div class="toma_fotografia_button"  onclick="preview_snapshot()" ></div> 
			</div>

			<div id="post_take_buttons" >
               <div class="titulo_disclaimer_fotografia">FOTOGRAFIA</div>    
               <div class="preg">¿La fotografia es clara?</div>       
           
                <div class="contenedor_button_SI_NO">
                       <div id="Div1" class="aceptar_SI_button"  onclick="save_photo()"></div> 
                        <div id="Div2" class="cancelar_NO_button"  onclick="cancel_preview()" ></div> 
				 </div>
			</div>
			
            <div id="contenedor_btn_continuar" >                                   
                   <div id="imgcontinuar" class="btn_img_continuar"  onclick="return false;" ></div> 
            </div> 

	    </div>
	
 
    <div style="float:left;">
	<div id="results" style="width:640px;height:480px;" ></div>	 
	</div>
	
    <input style="display:none;" type="text" id="base" />
	

 	<div style="width:100%;float:left">
     <p style="width:100px;height:100px;">  </p>	
	</div>

    <div style="width:100%;float:left">
	<div id="result_imagen"> </div>
	 </div>
	

    <input id="esta_grupo" type="hidden" value="0"   />
    <input id="pic_actual" type="hidden" value="0"   />
    <input id="str_actual" type="hidden" value=""   />
    <input id="flg_tomada" type="hidden" value="0"   />
         <input name="jsn1" type="hidden" id="jsn1" value="{&quot;docs_camara&quot;:[{&quot;id_doc&quot;:&quot;19&quot;,&quot;nom&quot;:&quot;Fotografía del Solicitante&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;1&quot;,&quot;mandatoria&quot;:&quot;S&quot;,&quot;grupo&quot;:&quot;0&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;0&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;},{&quot;id_doc&quot;:&quot;2&quot;,&quot;nom&quot;:&quot;Credencial de IFE (Anverso)&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;2&quot;,&quot;mandatoria&quot;:&quot;N&quot;,&quot;grupo&quot;:&quot;1&quot;,&quot;coments&quot;:&quot;Si la ID tiene el mismo domicilio que la solicitud de Afore da clic para que sea utilizada como comprobante de domicilio.&quot;,&quot;obliga_imagen&quot;:&quot;3&quot;,&quot;cubre_a&quot;:&quot;8&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;1&quot;},{&quot;id_doc&quot;:&quot;3&quot;,&quot;nom&quot;:&quot;Credencial de IFE (Reverso)&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;3&quot;,&quot;mandatoria&quot;:&quot;N&quot;,&quot;grupo&quot;:&quot;1&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;2&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;},{&quot;id_doc&quot;:&quot;7&quot;,&quot;nom&quot;:&quot;Documento migratorio&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;4&quot;,&quot;mandatoria&quot;:&quot;N&quot;,&quot;grupo&quot;:&quot;1&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;0&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;},{&quot;id_doc&quot;:&quot;8&quot;,&quot;nom&quot;:&quot;Comprobante de domicilio&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;5&quot;,&quot;mandatoria&quot;:&quot;S&quot;,&quot;grupo&quot;:&quot;0&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;0&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;},{&quot;id_doc&quot;:&quot;9&quot;,&quot;nom&quot;:&quot;Identificación de menor de edad&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;6&quot;,&quot;mandatoria&quot;:&quot;N&quot;,&quot;grupo&quot;:&quot;1&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;0&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;},{&quot;id_doc&quot;:&quot;11&quot;,&quot;nom&quot;:&quot;Pasaporte&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;7&quot;,&quot;mandatoria&quot;:&quot;N&quot;,&quot;grupo&quot;:&quot;1&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;0&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;},{&quot;id_doc&quot;:&quot;10&quot;,&quot;nom&quot;:&quot;CURP&quot;,&quot;tomada&quot;:&quot;0&quot;,&quot;orden&quot;:&quot;8&quot;,&quot;mandatoria&quot;:&quot;S&quot;,&quot;grupo&quot;:&quot;0&quot;,&quot;coments&quot;:&quot;&quot;,&quot;obliga_imagen&quot;:&quot;0&quot;,&quot;cubre_a&quot;:&quot;0&quot;,&quot;string64&quot;:&quot;&quot;,&quot;ext&quot;:&quot;&quot;,&quot;cabeza_grupo&quot;:&quot;0&quot;}],&quot;total_documentos&quot;:&quot;4&quot;,&quot;grupo_obligatorio&quot;:&quot;1&quot;,&quot;grupos&quot;:&quot;1&quot;}" />
         </div>
    </div>
    </form>
</body>
</html>
