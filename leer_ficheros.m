
    clear all;
    clc;   
    warning('off','all')
    dir_lista_terremotos='lista_terremotos\'; % directorio con los ficheros de los terremotos
    
    catalogo='C:\Users\USUARIO\Desktop\obs_orientacion\catalogo.txt'; 
    fid_resultados=fopen('resultados.txt','wt+');
    fclose(fid_resultados);
  
    
    if ~isempty(dir(catalogo))
        
        fid_catalogo=fopen(catalogo);

        fgetl(fid_catalogo); %leemos una linea

        while 1 %leemos el fichero 

            linea = fgetl(fid_catalogo); %leemos una linea

            if ~ischar(linea) %si es final del fichero
                fclose(fid_catalogo); %cerramos los dos ficheros abiertos                                     
                break; %salimos del bucle while 
            end  

            datos=textscan(linea,'%s','delimiter',[':','|'],'MultipleDelimsAsOne',1); %separamos los datos de la cuarta linea (H4) por espacio 
            fecha=datos{1}{2};
            year=fecha(1:4); %yyyy
            mes=fecha(6:7); %mm           
            dia=fecha(9:10);%dd
            hora=fecha(12:13);%hh
            hora_menos_uno=str2double(hora)-1;
            minuto=str2double(datos{1}{3}); %mm
            segundo=str2double(datos{1}{4}); %ss
            num_dia=datenum(str2double(year),str2double(mes),str2double(dia));
            uno_enero=datenum(str2double(year),1,1);
            dia_juliano=num_dia-uno_enero+1;
            dia_juliano_string=sprintf('%03d',dia_juliano);
            terremoto=[year,'.',dia_juliano_string];
            
            lat1=str2double(datos{1}{5});
            long1=str2double(datos{1}{6});    
            orientacion(terremoto,num_dia,long1,lat1,hora_menos_uno,minuto,segundo,dir_lista_terremotos);
            
       
         end
        
    else
        msgbox('NO SE HA ENCONTRADO EL FICHERO CATALOGO');
      
    end
    
    
   

                            

 
 
   
