function interfazMetodos()

  metodos = {'Gauss-Jordan', 'Interpolacion Inversa Lineal'};

  fig = figure('Name','Laboratorio de Metodos Computacionales - TP2', ...
    'NumberTitle','off', 'MenuBar','none', ...
    'Position',[60 40 1300 800], ...
    'Color',[0.94 0.94 0.94], ...
    'Resize','on');

  % =========================================================
  % PANEL IZQUIERDO: CONFIGURACION Y ENTRADAS
  % =========================================================
  p = uipanel(fig,'Title','Configuracion y datos de entrada', ...
    'Units','normalized','Position',[.01 .03 .29 .94]);

  uicontrol(p,'Style','text','String','METODO NUMERICO', ...
    'Units','normalized','Position',[.05 .94 .9 .035], ...
    'FontWeight','bold','HorizontalAlignment','left');

  h.metodo = uicontrol(p,'Style','popupmenu','String',metodos, ...
    'Value',1,'Units','normalized', ...
    'Position',[.05 .895 .9 .045], ...
    'Callback',@actualizarMetodo);

  % Panel dinamico de entradas
  h.panelEntrada = uipanel(p,'Title','Datos del metodo', ...
    'Units','normalized','Position',[.04 .20 .92 .67]);

  % Controles de Gauss-Jordan
  h.lblOrden = uicontrol(h.panelEntrada,'Style','text', ...
    'String','Orden del sistema (n)', ...
    'Units','normalized','Position',[.04 .91 .53 .055], ...
    'HorizontalAlignment','left');

  h.orden = uicontrol(h.panelEntrada,'Style','edit','String','4', ...
    'Units','normalized','Position',[.60 .91 .34 .06], ...
    'HorizontalAlignment','left');

  h.btnActualizar = uicontrol(h.panelEntrada,'Style','pushbutton', ...
    'String','Crear / actualizar tablas', ...
    'Units','normalized','Position',[.04 .83 .90 .065], ...
    'BackgroundColor',[0.88 0.91 0.96], ...
    'Callback',@crearTablaGauss);

  h.lblA = uicontrol(h.panelEntrada,'Style','text', ...
    'String','Matriz de coeficientes A', ...
    'Units','normalized','Position',[.04 .76 .90 .045], ...
    'FontWeight','bold','HorizontalAlignment','left');

  h.tablaA = uitable(h.panelEntrada, ...
    'Units','normalized','Position',[.04 .43 .90 .32], ...
    'Data',[
        80 15 35 60;
        28 72 57 25;
        20 20 12 20;
        50 10 20 60
    ], ...
    'ColumnName',{'x1','x2','x3', 'x4'}, ...
    'RowName',{'E1','E2','E3','E4'}, ...
    'ColumnEditable',true(1,4), ...
    'FontSize',10);

  h.lblB = uicontrol(h.panelEntrada,'Style','text', ...
    'String','Vector de terminos independientes b', ...
    'Units','normalized','Position',[.04 .36 .90 .05], ...
    'FontWeight','bold','HorizontalAlignment','left');

  h.tablaB = uitable(h.panelEntrada, ...
    'Units','normalized','Position',[.04 .04 .90 .31], ...
    'Data',[230;180;80;160], ...
    'ColumnName',{'b'}, ...
    'RowName',{'E1','E2','E3','E4'}, ...
    'ColumnEditable',true, ...
    'FontSize',10);

  % Controles de interpolacion inversa
  h.lblCantidad = uicontrol(h.panelEntrada,'Style','text', ...
    'String','Cantidad de puntos', ...
    'Units','normalized','Position',[.04 .91 .53 .055], ...
    'HorizontalAlignment','left');

  h.cantidad = uicontrol(h.panelEntrada,'Style','edit','String','6', ...
    'Units','normalized','Position',[.60 .91 .34 .06], ...
    'HorizontalAlignment','left');

  h.btnActualizarPuntos = uicontrol(h.panelEntrada,'Style','pushbutton', ...
    'String','Crear / actualizar tabla', ...
    'Units','normalized','Position',[.04 .83 .90 .065], ...
    'BackgroundColor',[0.88 0.91 0.96], ...
    'Callback',@crearTablaInterpolacion);

  h.lblXY = uicontrol(h.panelEntrada,'Style','text', ...
    'String','Pares de datos tabulados (x, y)', ...
    'Units','normalized','Position',[.04 .76 .90 .045], ...
    'FontWeight','bold','HorizontalAlignment','left');

  h.tablaXY = uitable(h.panelEntrada, ...
    'Units','normalized','Position',[.04 .37 .90 .38], ...
    'Data',{ ...
        '15','0,965926'; ...
        '25','0,906308'; ...
        '35','0,819152'; ...
        '45','0,707107'; ...
        '55','0,573576'; ...
        '65','0,422618' ...
    }, ...
    'ColumnName',{'X','Y'}, ...
    'RowName',[], ...
    'ColumnEditable',[true true], ...
    'ColumnFormat',{'char','char'}, ...
    'FontSize',10);

  h.lblObjetivo = uicontrol(h.panelEntrada,'Style','text', ...
    'String','Valor objetivo y*', ...
    'Units','normalized','Position',[.04 .25 .48 .06], ...
    'HorizontalAlignment','left');

  h.objetivo = uicontrol(h.panelEntrada,'Style','edit','String','0,90728517', ...
    'Units','normalized','Position',[.56 .25 .38 .065], ...
    'HorizontalAlignment','left');

  h.notaInterpolacion = uicontrol(h.panelEntrada,'Style','text', ...
    'Units','normalized','Position',[.04 .06 .90 .14], ...
    'HorizontalAlignment','left');

  % Botones principales
  uicontrol(p,'Style','pushbutton','String','Calcular', ...
    'Units','normalized','Position',[.04 .12 .44 .055], ...
    'BackgroundColor',[0.82 0.89 0.96], ...
    'FontWeight','bold','Callback',@calcular);

  uicontrol(p,'Style','pushbutton','String','Limpiar', ...
    'Units','normalized','Position',[.52 .12 .44 .055], ...
    'BackgroundColor',[0.90 0.90 0.90], ...
    'Callback',@limpiar);

  h.estado = uicontrol(p,'Style','text','String','Listo para ingresar datos.', ...
    'Units','normalized','Position',[.04 .035 .92 .055], ...
    'HorizontalAlignment','left');

  % =========================================================
  % PANEL DERECHO: RESULTADOS, PROCEDIMIENTO Y GRAFICO
  % =========================================================
  uicontrol(fig,'Style','pushbutton','String','Resultados y analisis', ...
    'Units','normalized','Position',[.32 .93 .21 .045], ...
    'BackgroundColor',[0.88 0.91 0.96], ...
    'Callback',@(s,e)mostrarPanel(1));

  uicontrol(fig,'Style','pushbutton','String','Procedimiento', ...
    'Units','normalized','Position',[.55 .93 .17 .045], ...
    'BackgroundColor',[0.88 0.91 0.96], ...
    'Callback',@(s,e)mostrarPanel(2));

  uicontrol(fig,'Style','pushbutton','String','Grafico', ...
    'Units','normalized','Position',[.74 .93 .17 .045], ...
    'BackgroundColor',[0.88 0.91 0.96], ...
    'Callback',@(s,e)mostrarPanel(3));

  h.paneles(1) = uipanel(fig,'Title','Resultados y analisis', ...
    'Units','normalized','Position',[.31 .03 .68 .89]);

  h.paneles(2) = uipanel(fig,'Title','Procedimiento paso a paso', ...
    'Units','normalized','Position',[.31 .03 .68 .89], ...
    'Visible','off');

  h.paneles(3) = uipanel(fig,'Title','Grafico de interpolacion', ...
    'Units','normalized','Position',[.31 .03 .68 .89], ...
    'Visible','off');

  % Panel de datos de entrada
  h.bloqueDatos = uipanel(h.paneles(1),'Title','Datos utilizados', ...
    'Units','normalized','Position',[.02 .68 .96 .29]);

  h.datos = uicontrol(h.bloqueDatos,'Style','edit', ...
    'Max',20,'Min',0,'Enable','inactive', ...
    'Units','normalized','Position',[.02 .05 .96 .85], ...
    'HorizontalAlignment','left','FontSize',11, ...
    'String','Los datos ingresados apareceran aqui.');

  % Panel de resultado numerico
  h.bloqueResultados = uipanel(h.paneles(1), ...
    'Title','Resultado numerico', ...
    'Units','normalized','Position',[.02 .36 .96 .29]);

  h.resumen = uicontrol(h.bloqueResultados,'Style','edit', ...
    'Max',20,'Min',0,'Enable','inactive', ...
    'Units','normalized','Position',[.02 .05 .96 .85], ...
    'HorizontalAlignment','left','FontSize',11, ...
    'String','El resultado del metodo aparecera aqui.');

  % Panel de analisis
  h.bloqueAnalisis = uipanel(h.paneles(1),'Title','Analisis', ...
    'Units','normalized','Position',[.02 .03 .96 .30]);

  h.analisis = uicontrol(h.bloqueAnalisis,'Style','edit', ...
    'Max',20,'Min',0,'Enable','inactive', ...
    'Units','normalized','Position',[.02 .05 .96 .85], ...
    'HorizontalAlignment','left','FontSize',11, ...
    'String','Aqui se explicaran las condiciones y observaciones del metodo.');

  % Tabla para operaciones o pasos del procedimiento
  h.tablaPasos = uitable(h.paneles(2), ...
    'Units','normalized','Position',[.02 .02 .96 .96], ...
    'Data',{},'ColumnName',{},'RowName',{}, ...
    'FontSize',10);
  
  h.procedimiento = uicontrol(h.paneles(2), ...
    'Style','edit', ...
    'Max',20,'Min',0, ...
    'Enable','inactive', ...
    'Units','normalized', ...
    'Position',[.02 .02 .96 .96], ...
    'HorizontalAlignment','left', ...
    'FontName','Courier New', ...
    'FontSize',11, ...
    'String','El procedimiento aparecera aqui.', ...
    'Visible','off');

  % Area de grafico
  h.axes = axes('Parent',h.paneles(3), ...
    'Units','normalized','Position',[.09 .10 .86 .82]);
  grid(h.axes,'on');
  xlabel(h.axes,'x');
  ylabel(h.axes,'y');

  % Estado interno
  h.metodos = metodos;
  h.resultado = [];
  h.ultimaEntrada = [];
  guidata(fig,h);

  actualizarMetodo();

  % =========================================================
  % FUNCIONES AUXILIARES
  % =========================================================

  function actualizarMetodo(~,~)
    q = guidata(fig);
    esGauss = get(q.metodo,'Value') == 1;

    controlesGauss = [q.lblOrden,q.orden,q.btnActualizar, ...
      q.lblA,q.tablaA,q.lblB,q.tablaB];

    controlesInterpolacion = [q.lblCantidad,q.cantidad, ...
      q.btnActualizarPuntos,q.lblXY,q.tablaXY, ...
      q.lblObjetivo,q.objetivo,q.notaInterpolacion];

    if esGauss
      set(controlesGauss,'Visible','on');
      set(controlesInterpolacion,'Visible','off');
      set(q.panelEntrada,'Title','Datos para Gauss-Jordan');
    else
      set(controlesGauss,'Visible','off');
      set(controlesInterpolacion,'Visible','on');
      set(q.panelEntrada,'Title','Datos para interpolacion inversa lineal');
    endif

    set(q.estado,'String','Ingrese los datos del metodo seleccionado.');
  endfunction

  function crearTablaGauss(~,~)
    try
      q = guidata(fig);
      n = leerEntero(q.orden,'orden del sistema',2,10);

      A = zeros(n,n);
      b = zeros(n,1);

      nombresColumnas = cell(1,n);
      nombresFilas = cell(1,n);
      for k = 1:n
        nombresColumnas{k} = sprintf('x%d',k);
        nombresFilas{k} = sprintf('E%d',k);
      endfor

      set(q.tablaA,'Data',A, ...
        'ColumnName',nombresColumnas, ...
        'RowName',nombresFilas, ...
        'ColumnEditable',true(1,n));

      set(q.tablaB,'Data',b, ...
        'ColumnName',{'b'}, ...
        'RowName',nombresFilas, ...
        'ColumnEditable',true);

      set(q.estado,'String',sprintf('Tablas creadas para un sistema de orden %d.',n));
    catch err
      q = guidata(fig);
      errordlg(err.message,'Error en las dimensiones');
      set(q.estado,'String',['Error: ',err.message]);
    end_try_catch
  endfunction

  function crearTablaInterpolacion(~,~)
    try
      q = guidata(fig);
      n = leerEntero(q.cantidad,'cantidad de puntos',2,100);

      datos = zeros(n,2);
      set(q.tablaXY,'Data',datos, ...
        'ColumnName',{'X','Y'}, ...
        'RowName',[], ...
        'ColumnEditable',[true true]);

      set(q.estado,'String',sprintf('Tabla creada para %d puntos.',n));
    catch err
      q = guidata(fig);
      errordlg(err.message,'Error en las dimensiones');
      set(q.estado,'String',['Error: ',err.message]);
    end_try_catch
  endfunction

  function n = leerEntero(control,nombre,minimo,maximo)
    s = strtrim(get(control,'String'));
    n = str2double(s);

    if isempty(s) || ~isscalar(n) || ~isfinite(n) || ...
       n ~= fix(n) || n < minimo || n > maximo
      error('%s debe ser un entero entre %d y %d.', ...
        nombre,minimo,maximo);
    endif
  endfunction

  function validarMatriz(A,b)

    if !isnumeric(A) || !isnumeric(b) || ...
        isempty(A) || isempty(b) || ...
        !ismatrix(A) || !isvector(b) || ...
        rows(A) != columns(A) || ...
        rows(A) != numel(b)

        error('La matriz A debe ser cuadrada y b debe tener la misma cantidad de elementos.');

    endif

    if !isreal(A) || !isreal(b) || ...
        any(!isfinite(A(:))) || any(!isfinite(b(:)))

        error('La matriz A y el vector b deben contener valores reales y finitos.');

    endif

    b = b(:);

    endfunction

  function validarPuntos(X,Y,objetivo)

    if !isvector(X) || !isvector(Y) || ...
        numel(X) != numel(Y)

        error('X e Y deben ser vectores con la misma cantidad de elementos.');

    endif

    if numel(X) < 2
        error('Se necesitan al menos dos puntos.');
    endif

    if !isreal(X) || !isreal(Y) || ...
        any(!isfinite(X(:))) || any(!isfinite(Y(:)))

        error('Los valores de X e Y deben ser reales y finitos.');

    endif

    if !isscalar(objetivo) || !isreal(objetivo) || ...
        !isfinite(objetivo)

        error('El valor objetivo y* debe ser un numero real y finito.');

    endif

    endfunction

  % =========================================================
  % CALCULAR
  % =========================================================
  
  function calcular(~,~)

    try
        q = guidata(fig);
        if get(q.metodo,'Value') == 1

        % ==========================================
        % GAUSS-JORDAN
        % ==========================================

        A = get(q.tablaA,'Data');
        b = get(q.tablaB,'Data');

        if iscell(A)
            A = cell2mat(A);
        endif

        if iscell(b)
            b = cell2mat(b);
        endif

        validarMatriz(A,b);

        b = b(:);

        tiempoInicio = tic;
        % Ejecutar metodo Gauss-Jordan
        r = gaussJordan(A,b);
        tiempoEjecucion = toc(tiempoInicio);

        q.resultado = r;

        q.ultimaEntrada = struct( 'metodo','Gauss-Jordan', 'A',A, 'b',b);

        % Mostrar datos utilizados
        set(q.datos,'String',formatearGauss(A,b));

        % Mostrar resultado
        textoResultado = {
            ['Estado: ',r.mensaje];
            ''
        };

        if r.exito

            textoResultado{end+1} = 'Solucion del sistema:';

            for i = 1:length(r.solucion)
                textoResultado{end+1} = sprintf('x%d = %.10g',i,r.solucion(i));
            endfor

            textoResultado{end+1} = '';
            textoResultado{end+1} = 'Matriz final:';
            for i = 1:rows(r.matrizFinal)
              fila = sprintf('%10.8g  ', r.matrizFinal(i,:));
              textoResultado{end+1} = ['[' fila ']'];
            endfor

            textoResultado{end+1} = '';
            textoResultado{end+1} = 'Verificacion A * X:';
            for i = 1:rows(r.verificacion)
              textoResultado{end+1} = sprintf('[ %g ]', r.verificacion(i));
            endfor

            textoResultado{end+1} = '';
            textoResultado{end+1} = ...
            sprintf('Norma del residuo: %.10g',norm(r.residuo,inf));

            textoResultado{end+1} = '';
            textoResultado{end+1} = ...
            sprintf('Tiempo de ejecucion: %.9f segundos',tiempoEjecucion);

        else

            textoResultado{end+1} = 'No se obtuvo una solucion mediante el procedimiento.';

            textoResultado{end+1} = '';
            textoResultado{end+1} = 'Matriz final:';
            for i = 1:rows(r.matrizFinal)
              textoResultado{end+1} = mat2str(r.matrizFinal(i,:),8);
            endfor

        endif

        set(q.resumen,'String',textoResultado);

        % =========================================================
        % MOSTRAR PROCEDIMIENTO GAUSS-JORDAN
        % =========================================================

        textoProcedimiento = {};

        % Matriz inicial
        textoProcedimiento{end+1} = 'MATRIZ AUMENTADA INICIAL';
        textoProcedimiento{end+1} = '';

        for i = 1:rows(r.matrizInicial)
            fila = sprintf('%10.5g ',r.matrizInicial(i,1:end-1));
            termino = sprintf('%10.5g',r.matrizInicial(i,end));

            textoProcedimiento{end+1} = ...
                ['[ ' fila '| ' termino ' ]'];
        endfor

        textoProcedimiento{end+1} = '';
        textoProcedimiento{end+1} = ...
            'FORMULAS GENERALES DEL PROCEDIMIENTO';
        textoProcedimiento{end+1} = ...
            'Eliminacion: Ei = Ei - (aik / a1k) * E1';
        textoProcedimiento{end+1} = ...
            'Normalizacion: E1 = E1 / a1k';
        textoProcedimiento{end+1} = '';

        % Mostrar cada iteracion
        for k = 1:numel(r.iteraciones)

            iteracion = r.iteraciones(k);

            textoProcedimiento{end+1} = ...
                sprintf('ITERACION %d - COLUMNA %d', ...
                        iteracion.numero,iteracion.numero);

            textoProcedimiento{end+1} = ...
                sprintf('Pivote utilizado: %.10g',iteracion.pivote);

            textoProcedimiento{end+1} = 'Matriz resultante:';

            M = iteracion.matriz;

            for i = 1:rows(M)
                fila = sprintf('%10.5g ',M(i,1:end-1));
                termino = sprintf('%10.5g',M(i,end));

                textoProcedimiento{end+1} = ...
                    ['[ ' fila '| ' termino ' ]'];
            endfor

            textoProcedimiento{end+1} = '';
        endfor

        set(q.procedimiento,'String',textoProcedimiento);
        set(q.procedimiento,'Visible','on');
        set(q.tablaPasos,'Visible','off');

        % Analisis
        textoAnalisis = {
            'Se aplico el metodo de Gauss-Jordan respetando:';
            '1. Seleccion del pivote.';
            '2. Eliminacion de las filas restantes.';
            '3. Normalizacion de la fila pivote.';
            '4. Rotacion ciclica de las filas.';
            ''
        };

        if r.exito
            textoAnalisis{end+1} = ...
            'El procedimiento obtuvo una matriz identidad.';
            textoAnalisis{end+1} = ...
            'La solucion se verifico mediante A * X = b.';
        else
            textoAnalisis{end+1} = r.mensaje;
        endif

        set(q.analisis,'String',textoAnalisis);

        cla(q.axes);
        grid(q.axes,'on');
        title(q.axes,'Grafico no disponible para Gauss-Jordan');

        set(q.estado,'String',r.mensaje);

        else

        % ==========================================
        % INTERPOLACION INVERSA LINEAL
        % ==========================================

        datos = get(q.tablaXY,'Data');

        if !iscell(datos)
            error('La tabla debe contener datos de texto.');
        endif

        datosNumericos = zeros(size(datos));

        for i = 1:rows(datos)
            for j = 1:columns(datos)

                valor = datos{i,j};

                if isnumeric(valor)
                    numero = valor;
                else
                    valor = strtrim(valor);
                    valor = strrep(valor,',','.');

                    numero = str2double(valor);
                endif

                if !isscalar(numero) || !isreal(numero) || !isfinite(numero)
                    error('Todos los datos de la tabla deben ser numeros reales y finitos.');
                endif

                datosNumericos(i,j) = numero;

            endfor
        endfor

        datos = datosNumericos;

        if columns(datos) != 2
            error('La tabla debe tener exactamente dos columnas: X e Y.');
        endif

        X = datos(:,1);
        Y = datos(:,2);

        objetivo = leerNumero(q.objetivo,'valor objetivo y*');

        validarPuntos(X,Y,objetivo);

        % IMPORTANTE:
        % Se conserva el orden de los puntos ingresados.
        % No se ordenan automaticamente.

        tiempoInicio = tic;
        % Ejecutar interpolacion inversa lineal
        r = interpolacionInversaLineal(X,Y,objetivo);
        tiempoEjecucion = toc(tiempoInicio);

        q.resultado = r;

        q.ultimaEntrada = struct( ...
            'metodo','Interpolacion Inversa Lineal', ...
            'X',X, ...
            'Y',Y, ...
            'objetivo',objetivo);

        % Mostrar datos utilizados
        set(q.datos,'String', ...
            formatearInterpolacion(X,Y,objetivo));

        % Mostrar resultado
        if r.exito

            puntos = r.puntosSeleccionados;

            textoResultado = {
            'Puntos seleccionados:';
            sprintf('(%.6f, %.6f)',puntos(1,1),puntos(1,2));
            sprintf('(%.6f, %.6f)',puntos(2,1),puntos(2,2));
            '';
            sprintf('Valor objetivo y* = %.10g',objetivo);
            sprintf('Resultado x* = %.10g',r.xInterpolado);
            '';
            sprintf('Tiempo de ejecucion: %.9f segundos',tiempoEjecucion);
            '';
            r.mensaje
            };

        else

            textoResultado = {
            'No se pudo obtener el resultado.';
            '';
            r.mensaje
            };

        endif

        set(q.resumen,'String',textoResultado);

        % =========================================================
        % MOSTRAR PROCEDIMIENTO INTERPOLACION INVERSA LINEAL
        % =========================================================

        textoProcedimiento = formatearProcedimientoInterpolacion( ...
            X,Y,objetivo,r);

        set(q.procedimiento,'String',textoProcedimiento);
        set(q.procedimiento,'Visible','on');
        set(q.tablaPasos,'Visible','off');

        % Analisis
        if r.exito

            textoAnalisis = {
                'Se aplico el metodo de interpolacion inversa lineal:';
                '1. Busqueda del intervalo que contiene el valor objetivo.';
                '2. Seleccion de dos puntos consecutivos.';
                '3. Calculo del incremento y la diferencia entre ordenadas.';
                '4. Despeje de la variable independiente.';
                ''
            };

            textoAnalisis{end+1} = 'Se obtuvo el valor interpolado de x* correctamente.';

        else

            textoAnalisis = {
              'No fue posible realizar la interpolacion inversa lineal.';
              '';
              r.mensaje
            };

        endif

        set(q.analisis,'String',textoAnalisis);

        % Generar grafico
        graficarInterpolacion(q.axes,X,Y,objetivo,r);

        set(q.estado,'String',r.mensaje);

        endif

        guidata(fig,q);

        mostrarPanel(1);

    catch err

        q = guidata(fig);

        errordlg(err.message,'Error de calculo');

        set(q.estado,'String',['Error: ',err.message]);

    end_try_catch

  endfunction

  
  function v = leerNumero(control, nombre)
    s = strtrim(get(control,'String'));
    s = strrep(s,',','.');
    v = str2double(s);
    if isempty(s) || ~isscalar(v) || ~isreal(v) || ~isfinite(v)
      error('%s debe ser un numero real y finito.',nombre);
    endif
  endfunction

  function texto = formatearGauss(A,b)
    texto = {'Metodo: Gauss-Jordan'; ...
             sprintf('Orden del sistema: %d',rows(A)); ...
             ''; 'Matriz aumentada inicial [A|b]:'};

    for i = 1:rows(A)
      fila = sprintf('%10.5g ',[A(i,:) b(i)]);
      texto{end+1} = ['E',num2str(i),':  [ ',fila,']'];
    endfor
  endfunction

  function texto = formatearInterpolacion(X,Y,objetivo)

      texto = {
          'Metodo: Interpolacion Inversa Lineal';
          sprintf('Cantidad de puntos: %d',length(X));
          '';
          'VALOR OBJETIVO';
          sprintf('y* = %.8f',objetivo);
          '';
          'DATOS TABULADOS';
          '-------------------------------------------'
          sprintf('%-6s %12s %16s','N.','X','Y');
          '-------------------------------------------'
      };

      for i = 1:length(X)

          texto{end+1} = sprintf( ...
              '%-6d %12.6f %16.6f', ...
              i,X(i),Y(i));

      endfor

  endfunction

  function texto = formatearProcedimientoInterpolacion(X,Y,objetivo,r)

      texto = {};

      % =====================================================
      % PASO 1: DATOS INGRESADOS
      % =====================================================

      texto{end+1} = '1. DATOS INGRESADOS';
      texto{end+1} = '';

      texto{end+1} = sprintf('Cantidad de puntos: %d',numel(X));
      texto{end+1} = sprintf('Valor objetivo y* = %.10g',objetivo);

      texto{end+1} = '';
      texto{end+1} = 'Vectores ingresados:';

      texto{end+1} = ['X = ',mat2str(X',6)];
      texto{end+1} = ['Y = ',mat2str(Y',6)];

      % =====================================================
      % PASO 2: TABLA DE DIFERENCIAS
      % =====================================================

      texto{end+1} = '';
      texto{end+1} = '2. TABLA DE PRIMERAS DIFERENCIAS';
      texto{end+1} = '';

      diferencias = diff(Y);

      texto{end+1} = sprintf( ...
          '%3s %12s %12s %12s', ...
          '', 'X', 'Y', 'Delta Y');

      for i = 1:numel(X)

          if i < numel(X)
              diferencia = sprintf('%.6g',diferencias(i));
          else
              diferencia = '-';
          endif

          if r.exito && i == r.indiceIntervalo
              marca = '>';
          elseif r.exito && i == r.indiceIntervalo + 1
              marca = '>';
          else
              marca = '';
          endif

          texto{end+1} = sprintf( ...
              '%3s %12.6g %12.6g %12s', ...
              marca,X(i),Y(i),diferencia);

      endfor

      texto{end+1} = '';
      texto{end+1} = '> Indica los puntos del intervalo seleccionado.';

      % Si no se encontro un intervalo, finalizar el procedimiento
      if !r.exito

          texto{end+1} = '';
          texto{end+1} = 'NO SE PUDO COMPLETAR EL PROCEDIMIENTO';
          texto{end+1} = r.mensaje;

          return;

      endif

      % =====================================================
      % PASO 3: SELECCION DEL INTERVALO
      % =====================================================

      puntos = r.puntosSeleccionados;

      x0 = puntos(1,1);
      y0 = puntos(1,2);

      x1 = puntos(2,1);
      y1 = puntos(2,2);

      texto{end+1} = '';
      texto{end+1} = '3. SELECCION DEL INTERVALO';
      texto{end+1} = '';

      texto{end+1} = sprintf('Punto inicial: (%.6g, %.6g)',x0,y0);
      texto{end+1} = sprintf('Punto siguiente: (%.6g, %.6g)',x1,y1);

      texto{end+1} = '';

      texto{end+1} = sprintf( ...
          'Incremento h = x1 - x0 = %.6g - %.6g = %.6g', ...
          x1,x0,r.h);

      texto{end+1} = sprintf( ...
          'Diferencia Delta Y = y1 - y0 = %.6g - %.6g = %.6g', ...
          y1,y0,r.deltaY);

      % =====================================================
      % PASO 4: FORMULA Y DESPEJE
      % =====================================================

      texto{end+1} = '';
      texto{end+1} = '4. INTERPOLACION INVERSA LINEAL';
      texto{end+1} = '';

      texto{end+1} = 'Formula general:';

      texto{end+1} = ...
          'P(x) = y0 + (Delta Y / h) * (x - x0)';

      texto{end+1} = '';

      texto{end+1} = 'Igualando al valor objetivo:';

      texto{end+1} = sprintf( ...
          '%.6g = %.6g + (%.6g / %.6g) * (x - %.6g)', ...
          objetivo,y0,r.deltaY,r.h,x0);

      texto{end+1} = '';

      texto{end+1} = 'Despejando x*:';

      texto{end+1} = ...
          'x* = x0 + ((y* - y0) / Delta Y) * h';

      texto{end+1} = '';

      texto{end+1} = sprintf( ...
          'x* = %.6g + ((%.6g - %.6g) / %.6g) * %.6g', ...
          x0,objetivo,y0,r.deltaY,r.h);

      texto{end+1} = sprintf( ...
          'x* = %.10g',r.xInterpolado);

      % =====================================================
      % PASO 5: RESULTADO
      % =====================================================

      texto{end+1} = '';
      texto{end+1} = '5. RESULTADO FINAL';
      texto{end+1} = '';

      texto{end+1} = sprintf( ...
          'Valor interpolado: x* = %.10g',r.xInterpolado);

      texto{end+1} = '';
      texto{end+1} = r.mensaje;

  endfunction

  % =========================================================
  % NAVEGACION ENTRE PANELES
  % =========================================================
  function mostrarPanel(indice)
    q = guidata(fig);
    set(q.paneles,'Visible','off');
    set(q.paneles(indice),'Visible','on');
  endfunction

  % =========================================================
  % LIMPIAR
  % =========================================================
  function limpiar(~,~)
    q = guidata(fig);

    if get(q.metodo,'Value') == 1
      set(q.orden,'String','3');
      set(q.tablaA,'Data',zeros(3,3), ...
        'ColumnName',{'x1','x2','x3'}, ...
        'RowName',{'E1','E2','E3'});
      set(q.tablaB,'Data',[1;2;3], ...
        'RowName',{'E1','E2','E3'});
    else
      set(q.cantidad,'String','4');
      set(q.tablaXY,'Data',[0 1;1 3;2 5;3 7]);
      set(q.objetivo,'String','4');
    endif

    set(q.datos,'String','Los datos ingresados apareceran aqui.');
    set(q.resumen,'String','El resultado del metodo aparecera aqui.');
    set(q.analisis,'String','Aqui se mostrara el analisis del metodo.');
    set(q.tablaPasos,'Data',{},'ColumnName',{},'RowName',{});
    set(q.procedimiento,'String','El procedimiento aparecera aqui.');
    cla(q.axes);
    grid(q.axes,'on');
    xlabel(q.axes,'x');
    ylabel(q.axes,'y');

    q.resultado = [];
    q.ultimaEntrada = [];
    guidata(fig,q);

    set(q.estado,'String','Campos y resultados limpiados.');
    mostrarPanel(1);
  endfunction

endfunction
