function resultado = gaussJordan(A, b)

  % ---------------------------------------------------------
  % VALIDACION DE ENTRADAS
  % ---------------------------------------------------------
  if nargin ~= 2
    error('La funcion requiere dos argumentos: A y b.');
  endif

  if ~isnumeric(A) || ~isnumeric(b) || isempty(A) || isempty(b)
    error('A y b deben ser arreglos numericos no vacios.');
  endif

  if ~ismatrix(A) || rows(A) ~= columns(A)
    error('La matriz A debe ser cuadrada.');
  endif

  n = rows(A);

  if numel(b) ~= n
    error('El vector b debe contener exactamente %d elementos.', n);
  endif

  if any(~isfinite(A(:))) || any(~isfinite(b(:)))
    error('Todos los elementos de A y b deben ser finitos.');
  endif

  if ~isreal(A) || ~isreal(b)
    error('El metodo requiere datos reales.');
  endif

  % Trabajar con double y convertir b en columna.
  A = double(A);
  b = double(b(:));

  matrizAumentada = [A, b];

  % Tolerancia numerica para detectar pivotes nulos.
  tolerancia = eps * max(1, norm(A, inf)) * max(1, n);

  % ---------------------------------------------------------
  % INICIALIZAR REGISTRO
  % ---------------------------------------------------------
  resultado = struct();
  resultado.matrizInicial = matrizAumentada;
  resultado.matrizFinal = [];
  resultado.solucion = [];
  resultado.verificacion = [];
  resultado.residuo = [];
  resultado.pasos = struct('descripcion', {}, 'matriz', {});
  resultado.iteraciones = struct( ...
    'numero', {}, ...
    'pivote', {}, ...
    'matriz', {});
  resultado.exito = false;
  resultado.mensaje = '';

  M = matrizAumentada;

  resultado = registrarPaso(resultado, ...
    'Matriz aumentada inicial [A | b].', M);

  % ---------------------------------------------------------
  % PROCEDIMIENTO
  % ---------------------------------------------------------
  for etapa = 1:n

    filasActivas = n - etapa + 1;

    % -------------------------------------------------------
    % PIVOTEO PARCIAL: seleccionar el mayor pivote disponible.
    % -------------------------------------------------------
    [mayorValor, indiceFila] = ...
      max(abs(M(1:filasActivas, etapa)));

    if mayorValor <= tolerancia

      if filasActivas == 1
        resultado.mensaje = ...
          'El sistema no tiene un pivote valido: matriz singular.';
        resultado.matrizFinal = M;
        return;
      endif

      resultado.mensaje = sprintf( ...
        ['No existe un pivote valido en la etapa %d. ', ...
         'La matriz es singular o el sistema no tiene solucion unica.'], ...
        etapa);
      resultado.matrizFinal = M;
      return;
    endif

    if indiceFila != 1
      M([1, indiceFila], :) = M([indiceFila, 1], :);

      resultado = registrarPaso(resultado, ...
        sprintf(['Etapa %d: intercambio de filas. ', ...
                 'Se coloca en la primera fila el mayor pivote disponible.'], ...
                 etapa), M);
    endif

    pivote = M(1, etapa);

    % -------------------------------------------------------
    % ELIMINACION EN TODAS LAS FILAS RESTANTES
    % -------------------------------------------------------
    for fila = 2:n

      factor = M(fila, etapa) / pivote;

      M(fila, :) = M(fila, :) - factor * M(1, :);

      % Fijar el cero teorico para evitar residuos de redondeo.
      M(fila, etapa) = 0;

      resultado = registrarPaso(resultado, ...
        sprintf(['Etapa %d: E%d = E%d - (%.12g) * E1.'], ...
                etapa, fila, fila, factor), M);
    endfor

    % -------------------------------------------------------
    % NORMALIZACION DE LA PRIMERA FILA
    % -------------------------------------------------------
    M(1, :) = M(1, :) / pivote;
    M(1, etapa) = 1;

    resultado = registrarPaso(resultado, ...
      sprintf(['Etapa %d: normalizar la primera fila ', ...
               'dividiendo todos sus elementos por el pivote %.12g.'], ...
              etapa, pivote), M);

    % -------------------------------------------------------
    % ROTACION CICLICA DE FILAS
    % E2 -> E1, E3 -> E2, ..., E1 -> En.
    % Se realiza despues de eliminar y normalizar.
    % -------------------------------------------------------
    if n > 1
      M = M([2:n, 1], :);
    endif

    resultado = registrarPaso(resultado, ...
      sprintf(['Etapa %d: rotacion ciclica de filas. ', ...
               'La primera fila pasa al final y las restantes avanzan.'], ...
              etapa), M);
    
    % Guardar el resultado de la iteracion
    k = numel(resultado.iteraciones) + 1;

    resultado.iteraciones(k).numero = etapa;
    resultado.iteraciones(k).pivote = pivote;
    resultado.iteraciones(k).matriz = M;

  endfor

  % ---------------------------------------------------------
  % RESULTADO Y VERIFICACION
  % ---------------------------------------------------------
  resultado.matrizFinal = M;

  % Al completar las n rotaciones, las columnas de coeficientes
  % deben formar la identidad, por lo que la ultima columna es X.
  identidad = eye(n);

  if norm(M(:, 1:n) - identidad, inf) > 100 * tolerancia
    resultado.mensaje = ...
      ['El procedimiento termino, pero no se obtuvo la matriz identidad. ', ...
       'Revise la condicion del sistema y su estabilidad numerica.'];
    return;
  endif

  X = M(:, n + 1);

  resultado.solucion = X;
  resultado.verificacion = A * X;
  resultado.residuo = A * X - b;
  resultado.exito = true;
  resultado.mensaje = 'Sistema resuelto correctamente.';

  resultado = registrarPaso(resultado, ...
    'Resultado final: la matriz de coeficientes es la identidad.', M);

endfunction


% =========================================================
% FUNCION AUXILIAR: REGISTRAR CADA PASO DEL PROCEDIMIENTO
% =========================================================
function resultado = registrarPaso(resultado, descripcion, matriz)

  k = numel(resultado.pasos) + 1;

  resultado.pasos(k).descripcion = descripcion;
  resultado.pasos(k).matriz = matriz;

endfunction
