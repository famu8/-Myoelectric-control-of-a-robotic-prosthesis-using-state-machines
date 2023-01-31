load('EMG_2_channel_Wrist_Flex_Ext_Proc.mat')




%CONEXIÓN CON COPPELIA
vrep=remApi('remoteApi'); % remote object called vrep
vrep.simxFinish(-1); % close previous connection
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5); % create a new connection
if (clientID>-1)
    disp('Conectado correctamente');

    vrep.simxAddStatusbarMessage(clientID,'Comunicacion con MATLAB correcta', vrep.simx_opmode_blocking);
    [returnCode,munyeca]=vrep.simxGetObjectHandle(clientID,'m',vrep.simx_opmode_blocking);
    [returnCode,antebrazo]=vrep.simxGetObjectHandle(clientID,'c',vrep.simx_opmode_blocking);
  
    [returnCode,pulgar1]=vrep.simxGetObjectHandle(clientID,'ad0',vrep.simx_opmode_blocking);
    [returnCode,pulgar2]=vrep.simxGetObjectHandle(clientID,'ad0f2',vrep.simx_opmode_blocking);
    [returnCode,pulgar3]=vrep.simxGetObjectHandle(clientID,'ad0f3',vrep.simx_opmode_blocking);
    
    [returnCode,d1f1]=vrep.simxGetObjectHandle(clientID,'ad1f1',vrep.simx_opmode_blocking);
    [returnCode,d1f2]=vrep.simxGetObjectHandle(clientID,'ad1f2',vrep.simx_opmode_blocking);
    [returnCode,d1f3]=vrep.simxGetObjectHandle(clientID,'ad1f3',vrep.simx_opmode_blocking);
    
    [returnCode,d2f1]=vrep.simxGetObjectHandle(clientID,'ad2f1',vrep.simx_opmode_blocking);
    [returnCode,d2f2]=vrep.simxGetObjectHandle(clientID,'ad2f2',vrep.simx_opmode_blocking);
    [returnCode,d2f3]=vrep.simxGetObjectHandle(clientID,'ad2f3',vrep.simx_opmode_blocking);
    
    [returnCode,d3f1]=vrep.simxGetObjectHandle(clientID,'ad3f1',vrep.simx_opmode_blocking);
    [returnCode,d3f2]=vrep.simxGetObjectHandle(clientID,'ad3f2',vrep.simx_opmode_blocking);
    [returnCode,d3f3]=vrep.simxGetObjectHandle(clientID,'ad3f3',vrep.simx_opmode_blocking);
    
    [returnCode,d4f1]=vrep.simxGetObjectHandle(clientID,'ad4f1',vrep.simx_opmode_blocking);
    [returnCode,d4f2]=vrep.simxGetObjectHandle(clientID,'ad4f2',vrep.simx_opmode_blocking);
    [returnCode,d4f3]=vrep.simxGetObjectHandle(clientID,'ad4f3',vrep.simx_opmode_blocking);
    
    %%posición inicial
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,antebrazo,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,munyeca,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar3,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f3,0,vrep.simx_opmode_oneshot);

    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f3,0,vrep.simx_opmode_oneshot);

    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f3,0,vrep.simx_opmode_oneshot);

    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f3,0,vrep.simx_opmode_oneshot);

end
%FIN CONEXIÓN COPPELIA

%TRATADO DE SEÑAL
%Explicación básica:
    %Lo que he realizado es que cada 100 puntos, coja el valor máximo y lo
    %incorpore a la gráfica
tiempo=Data{1};%tiempo
flex=Data{2};%se cogen los datos de flex
ext=Data{3};%se cogen los datos de ext
%FIN DE TRATADO DE SEÑAL




%REPLICADOR DE SEÑAL
flexor_comp=flex;%Segmento que contiene copia del vector flexor inicial
extensor_comp=ext;
incremento_t=tiempo(2,:);%El segundo valor contiene el incremento de la serie temporal
t_repeticion=tiempo(end,:);%Tomamos el ultimo valor de la serie temporal
final=3;%Numero de veces que se desea copiar la señal(Ultimo numero se inlcuye)

%Si quieres 4 repeticiones pones 3
%Si quieres 3 repeticiones pones 2...
if final>0
    for n=1:final
        flex=vertcat(flex,flexor_comp);%Se concatena la señal del flexor
        ext=vertcat(ext,extensor_comp);%Se concatena la señal del extensor
        t_inicial=tiempo(end,:);%Se toma el ultimo valor temporal del vector de tiempos como principio de la siguiente repeticion 
        t_final=t_inicial+t_repeticion;%Ultimo elemento del vector
        t_comp=t_inicial:incremento_t:t_final;%Creamos el vector
        t_comp=transpose(t_comp);%Trasponemos el vector
        tiempo=vertcat(tiempo,t_comp);%Concatenamos el vector de tiempos que teniamos previamente y el nuevo
    end
    MAX=max(tiempo);
end
%fIN DE REPLICACIÓN DE SEÑAL


%CREACIÓN DE SALIDA

[fila,columna]=size(flex);%Obtenemos las dimensiones de la matriz
[m,n]=size(flex);%Obtenemos las dimensiones de la matriz
umbrales=[35,20];%Establecemos los umbrales de forma externa de modo que sea mas sencillo modificarlos

estados_forzados=[1,3,5]%"flexion","pronacion","cierre"
estados_relax=[2,4,6]%"extension","supinacion","apertura"
estado=1;
pos=1;
while pos<=m
    if (flex(pos)>=umbrales(1) && ext(pos)>=umbrales(2))%Se comprueba si hay co-contraccion en la posicion especificada
        if (flex(pos+1)<umbrales(1) || ext(pos+1)<umbrales(2))%Se comprueba si en la siguiente posicion a la especificada no hay co-contraccion
            if estado==1%Si es asi se cambia de estado
                estado=2;
            elseif estado==2
                estado=3;
            elseif estado==3
                estado=1;
            end
        else%En caso contrario se ejecuta la accion correspondiente al estado de contraccion
            Estados(pos,1)=estados_forzados(estado);
        end
    else%En caso de no haber cocontraccion se comprueba qué accion se debe ejecutar
        if(flex(pos)>=umbrales(1) && ext(pos)<=umbrales(2))%Si hay contraccion en el flexor se realizará "flexion","pronacion","cierre" segun el estado
            Estados(pos,1)=estados_forzados(estado);
        elseif(flex(pos)<umbrales(1) && ext(pos)>=umbrales(2))%Si no hay contraccion de flexor se realizará "extension","supinacion" o "apertura" según el estado actual
            Estados(pos,1)=estados_relax(estado);
        else
            Estados(pos,1)=0;
        end
    end
    pos=pos+1;
end

%FIN CREACIÓN DE SALIDA

%CREACIÓN DE FIGURA
%se crea la figura la cual se modificará abajo cada x tiempo
fig(1)=figure('name','Monitor','menubar','none','position',[400 400 700 800], 'color',[0.6 0.8 0.4]);
    movegui(fig(1),'center');%se centra la figura al centro
    
        %se crea la gráfica1 (axe1) donde se incorporará los siguientes valores
        axe(1)=axes('parent',fig(1),'units','pixels','position',[120,300,400,200],'xlim',[0 120],'ylim',[-5 max(ext)],'xgrid','on','ygrid','on');
            set(get(axe(1),'YLabel'),'String','EMG Flex');
                lin(1)=line('parent',axe(1),'xdata',[],'ydata',[],'Color','r','LineWidth',0.1);
                
        %se crea la gráfica2 (axe2) donde se incorporará los siguientes valores
        axe(2)=axes('parent',fig(1),'units','pixels','position',[120,50,400,200],'xlim',[0 120],'ylim',[-5 max(ext)],'xgrid','on','ygrid','on');
            set(get(axe(2),'XLabel'),'String','Tiempo(Seg)');
            set(get(axe(2),'YLabel'),'String','EMG Ext');
                lin(2)=line('parent',axe(2),'xdata',[],'ydata',[],'Color','r','LineWidth',0.1);
                
        %se crea la gráfica1 (axe3) donde se incorporará los siguientes valores
        axe(3)=axes('parent',fig(1),'units','pixels','position',[120,550,400,200],'xlim',[0 120],'ylim',[-1 9],'xgrid','on','ygrid','on');
            set(get(axe(3),'YLabel'),'String','SALIDA');
                lin(3)=line('parent',axe(3),'xdata',[],'ydata',[],'Color','r','LineWidth',0.1);
 pause(15);               
    %CREACIÓN DE FIGURA

talla=size(tiempo);%tamaño de la muestra
lote=fix((talla/(100)));
x1=[0];%vectores sup /flex
x2=[0];%vectores sup /ext
tt=[0];%vectores sup /tiempo
tpi=100/(MAX);
S=[0];
apert=0;
cierre=0;
proc=0;
sup=0;
flexion_munyeca=0;
extens_munyeca=0;
pos_munyeca=0;
pos_antebrazo=0;
    %Aquí se buscará la señal de salida hacia el robot
    for t=1:1500:talla-1500%bucle que recorrerá de 100 en 100 puntos con el fin de ir creando ese movimiento continuo en la gráfica
        tic% se cronometra el tiempo de ejecución que tarda desde tic a toc
        %Aquí se implementará el código de mandar señales al robot
        %se resolveran los problemas de ejecución mediante lo siguiente:
        %se creará un bucle que irá de punto en punto del vector Estados
        %evaluando en que variable se le suma, según sea 1,2,3,4,5 o 6 si
        %es cero, se mantendrá en reposo
        
        %Datos hacia coppelia:
         for i=t:1500+t
            if Estados(i)==1
                flexion_munyeca=flexion_munyeca+1;
                apert=0;
                cierre=0;
                proc=0;
                sup=0;
                extens_munyeca=0;
                %cuando empieza una acción las otras se vuelven a cero, es
                %decir para que rote un ángulo tienen que ser x puntos
                %seguidos y si empieza otro puntos se reinicia.

            elseif Estados(i)==2
                extens_munyeca=extens_munyeca+1;
                apert=0;
                cierre=0;
                proc=0;
                sup=0;
                flexion_munyeca=0;

            elseif Estados(i)==3
                proc=proc+1;
                apert=0;
                cierre=0;
                sup=0;
                flexion_munyeca=0;
                extens_munyeca=0;
            elseif Estados(i)==4
                sup=sup+1;
                apert=0;
                cierre=0;
                proc=0;
                flexion_munyeca=0;
                extens_munyeca=0;
            elseif Estados(i)==5
                apert=apert+1;
                cierre=0;
                proc=0;
                sup=0;
                flexion_munyeca=0;
                extens_munyeca=0;
            elseif Estados(i)==6
                cierre=cierre+1;
                apert=0;
                proc=0;
                sup=0;
                flexion_munyeca=0;
                extens_munyeca=0;
                
                
            end
            if cierre==150
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f1,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f2,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f3,2,vrep.simx_opmode_oneshot);
          
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f1,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f2,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f3,2.2,vrep.simx_opmode_oneshot);
             
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f1,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f2,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f3,2.2,vrep.simx_opmode_oneshot);
                
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f1,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f2,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f3,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxPauseCommunication(clientID,0.2);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar1,2.2,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar2,1,vrep.simx_opmode_oneshot);
                apert=0;
                
                
            end
            if apert==150 
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar1,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar2,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxPauseCommunication(clientID,0.2);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f1,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f2,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f3,0,vrep.simx_opmode_oneshot);
          
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f1,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f2,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f3,0,vrep.simx_opmode_oneshot);
             
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f1,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f2,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f3,0,vrep.simx_opmode_oneshot);
                
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f1,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f2,0,vrep.simx_opmode_oneshot);
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f3,0,vrep.simx_opmode_oneshot);
                 
               cierre=0;
            end
                if flexion_munyeca==150
                    if pos_munyeca<0
                        pos_munyeca=0;
                    end
                    pos_munyeca=pos_munyeca+0.1;
                    [returnCod]=vrep.simxSetJointTargetPosition(clientID,munyeca,pos_munyeca,vrep.simx_opmode_oneshot);
                    flexion_munyeca=0;
                end
            if extens_munyeca==150
                if pos_munyeca>0
                    pos_munyeca=0;
                end
                pos_munyeca=pos_munyeca-0.05;
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,munyeca,pos_munyeca,vrep.simx_opmode_oneshot);
                extens_munyeca=0;
            end
            if proc==150
                pos_antebrazo=pos_antebrazo+0.05;
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,antebrazo,pos_antebrazo,vrep.simx_opmode_oneshot);
                proc=0;
            end
            if sup==150
                 pos_antebrazo=pos_antebrazo-0.1;
                [returnCod]=vrep.simxSetJointTargetPosition(clientID,antebrazo,pos_antebrazo,vrep.simx_opmode_oneshot);
                sup=0;
            end
            disp(Estados(i));
         end
            %se añaden a x1 los valores de flex en los vectores sup
            x1=[x1 max(flex(t))];
            x2=[x2 max(ext(t))];
            tt=[tt,fix(tiempo(t))];
            F=max(Estados(t:1500+t))%creación de salida
            S=[S,F];
            %se añaden a la gráfica
           set(lin(1),'xdata',tt(2:end),'ydata',x1(2:end));%se agrega a a la linea 1 dichos datos
           set(lin(2),'xdata',tt(2:end),'ydata',x2(2:end));% igual pero a la linea 2
           set(lin(3),'xdata',tt(2:end),'ydata',S(2:end));% en la linea de salida
           %Algoritmo para el tiempo de espera entre cada iteración para simular un electromiograma vivo
           pause(1-toc);
    end
    %%posición final
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,antebrazo,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,munyeca,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar3,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f3,0,vrep.simx_opmode_oneshot);

    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f3,0,vrep.simx_opmode_oneshot);

    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f3,0,vrep.simx_opmode_oneshot);

    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f3,0,vrep.simx_opmode_oneshot);
    pause(2);
    %%posición todo OK
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar1,1.8,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar2,0.5,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar3,1,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f1,1.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f2,1,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f3,0.5,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f1,-0.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f1,-0.3,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f1,-0.4,vrep.simx_opmode_oneshot);
    pause(2);
    %%posicion visto bueno
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f1,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f2,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d1f3,2.2,vrep.simx_opmode_oneshot);
    
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f1,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f2,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d2f3,2.2,vrep.simx_opmode_oneshot);
    
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f1,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f2,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d3f3,2.2,vrep.simx_opmode_oneshot);
    
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f1,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f2,2.2,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,d4f3,2.2,vrep.simx_opmode_oneshot); 
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar1,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar2,0,vrep.simx_opmode_oneshot);
    [returnCod]=vrep.simxSetJointTargetPosition(clientID,pulgar3,-0.2,vrep.simx_opmode_oneshot);
    pause(2);
pause(5);
vrep.simxFinish(clientID);
vrep.delete();