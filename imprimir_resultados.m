
function imprimir_resultados(obs,fecha,Ao,b,c)

obs=char(obs);

    fid_resultados=fopen('resultados.txt','a+');             
    fprintf(fid_resultados,[obs,' ',fecha,' ',num2str(Ao),' ',num2str(b),' ',num2str(c)]);
    fprintf(fid_resultados,'\n'); 
    fclose(fid_resultados);
    
end

 
 
   
