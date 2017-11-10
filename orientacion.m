function orientacion(terremoto,num_dia,lat1,long1,hora_menos_uno,minuto,segundo,dir_lista_terremotos)  


    %ORIENTACION DE OBS
    %tomo los datos de las tres componentes
    
    matriz_obs={'OBS01','OBS02','OBS03','OBS04','OBS05','OBS06'};
    fecha=datestr(num_dia,26);
    for k=1:6

        contador=0;
        fecha2=datestr(num_dia,26); 
        x=['WM.',matriz_obs{k},'..SHX.D.',terremoto];
        y=['WM.',matriz_obs{k},'..SHY.D.',terremoto];
        z=['WM.',matriz_obs{k},'..SHZ.D.',terremoto];
        
        obs=matriz_obs(k);
        
        for n=1:length(dir(dir_lista_terremotos)) %recorremos el directorio donde estan los ficheroscon los terremotos

            lista_directorio=dir(dir_lista_terremotos); %tenemos que hacer esto porque no se puede hacer dir.dir(n)     

 
               
                if (~isempty(strfind(lista_directorio(n).name,z))); %encontramos Z 

                    ds = datasource('miniseed',['C:\Users\USUARIO\Desktop\obs_orientacion\lista_terremotos\',z]);
                    scnl = scnlobject('WM', 'SHZ', obs, '--');
                    startTime = [fecha,' 01:00:00'];
                    endTime = [fecha,' 23:59:00'];
                    w = waveform(ds, scnl, startTime, endTime);
                    x1=get(w,'data');
                    contador=contador+1;

                end

                if (~isempty(strfind(lista_directorio(n).name,x))); %encontramos X 

                    ds = datasource('miniseed',['C:\Users\USUARIO\Desktop\obs_orientacion\lista_terremotos\',x]);
                    scnl = scnlobject('WM', 'SHX', obs, '--');
                    startTime = [fecha,' 01:00:00'];
                    endTime = [fecha,' 23:59:00'];
                    w = waveform(ds, scnl, startTime, endTime);
                    x3=get(w,'data');
                    contador=contador+1;

                end

                if (~isempty(strfind(lista_directorio(n).name,y))); %encontramos Y 

                    ds = datasource('miniseed',['C:\Users\USUARIO\Desktop\obs_orientacion\lista_terremotos\',y]);
                    scnl = scnlobject('WM', 'SHY', obs, '--');
                    startTime = [fecha,' 01:00:00'];
                    endTime = [fecha,' 23:59:00'];
                    w = waveform(ds, scnl, startTime, endTime);
                    x2=get(w,'data');
                    contador=contador+1;

                end
               
        end
       
        if contador==3
 
    
                %frecuencia de muestreo OBS/ESTACION
                fs=50;
                %------------------------------------------------------------------------
                %Calculo el azimuth y la distancia
                %insertar latitud y longitud de la fuente y luego de la estación

                fid_posicion_obs=fopen('posicion_obs.txt'); %abrimos fichero posicion

                while 1 %leemos el fichero 

                    linea_posicion = fgetl(fid_posicion_obs); %leemos una linea

                    if ~ischar(linea_posicion) %si es final del fichero
                        fclose(fid_posicion_obs); %cerramos los dos ficheros abiertos                                     
                        break; %salimos del bucle while 
                    end  

                    datos_posicion=textscan(linea_posicion,'%s','delimiter',' ','MultipleDelimsAsOne',1); %separamos los datos de la cuarta linea (H4) por espacio 
                    lat2=str2double(datos_posicion{1}{2});
                    long2=str2double(datos_posicion{1}{3});        

                end


                [ del , az ] = stadis2(lat2,long2,lat1,long1);

                %creo la ventana desde el origen del terremoto/(HORA-1)-MINUTO-SEGUNDO

                to=(hora_menos_uno*3600+minuto*60+segundo)*fs;
                tlim = 600; %increase to widen R1 window
                tlimp=tlim*0.1;
%               r1 = to+fs*((1.0 / 4.0)*del*111.111 - 30); % window start - assume Rayleigh slowness of 1/4 s/km
                r1 = to+fs*((1.0 / 4.0)*del*111.111 - tlimp);     
                %r2 = r1 + tlim*fs; %window finish
                r2 = r1 + tlim + tlimp;
                        r1=floor(r1);
                        r2=floor(r2);
                        %ventana de la señal
                        x1=x1(r1:r2);
                        x2=x2(r1:r2);
                        x3=x3(r1:r2);
                 %tratamiento de la señal primero la quito la tendencia y la media
                 x1=detrend(x1);
                 x2=detrend(x2);
                 x3=detrend(x3);
                 %Le aplico taper sin 10% [v]=taper(xi)
                 [v1]=taper(x1);
                 v1=v1';
                 [v2]=taper(x2);
                 v2=v2';
                 [v3]=taper(x3);
                 v3=v3';
                 x1=x1.*v1;
                 x2=x2.*v2;
                 x3=x3.*v1;
                 %Aplicar filtro
                 [b,a]=butter(2,[2*(0.02)/fs,2*(0.04)/fs],'stop');
                 x1=filter(b,a,x1);
                 x2=filter(b,a,x2);
                 x3=filter(b,a,x3);
                 %Comienza el algoritmo
                 vdat = imag(hilbert(x1)); %serie vertical
                 vdat0 = vdat / max(abs(vdat));

                     j=0;  
                        for ang = 0:1:359
                                rad  = ang * pi / 180.;
                                %convencion 1,x2 SHX, x3 SHY OBS01 OBS02
                                %OBS03 convencion2, x2 SHY, x3 SHX OBS05
                                %0BS06
                              
                                rdat = cos(rad) * x2 + sin(rad) * x3;
                                %rdat = cos(rad) * x2/max(abs(x2)) + sin(rad) * x1/max(abs(x1));
                                %rdat = cos(rad) * d1(n1:n2)/max(abs(d1(n1:n2))) + sin(rad) * d2(n1:n2)/max(abs(d2(n1:n2)));

                               
                                j = j + 1;
                %               
                                pow_rdat(j) = sum(rdat.^2)/length(rdat);


                                xc(j)  = sum(rdat .* vdat0) / sum(vdat0.^2);
                                xc2(j) = sum(rdat .* vdat0) / sqrt(sum(vdat0.^2) * sum(rdat.^2));
                                xa(j)  = ang;
                        end    
                        % pick the best angle, and the correlation at that angle
                            b=max(xc);
                            c=max(xc2);

                            angle=find(xc==b);
                            Ao=az-angle;


                    if Ao < 0; 

                        Ao = 360 + Ao;

                    end;
                    rad  = angle * pi / 180.;
                    rdatnorm=cos(rad) * x2 + sin(rad) * x1;
                    rdatnorm=rdat/ max(abs(rdat));

            %         plot(vdat/ max(abs(vdat)),'--r');
            %         hold on
            %         plot(rdatnorm,'b');

                imprimir_resultados(obs,fecha,Ao,b,c);   
        %     else
        %         msg=x;
        %         msg(13)='?';
        %         msgbox(['FALTAN COMPONENTES:  ',msg]);
        
        end
    end
end

        
   

 