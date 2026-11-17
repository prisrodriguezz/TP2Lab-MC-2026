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

  % Escala de cada ecuacion para trabajar con filas comparables.
  escalasFilas = max(abs(A), [], 2);
  toleranciaRedondeo = eps * max(1, n)^2;

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

  if any(escalasFilas == 0)
    resultado.mensaje = ...
      'El sistema contiene una fila sin coeficientes: no tiene solucion unica.';
    resultado.matrizFinal = M;
    return;
  endif

  % El escalado por filas es una operacion elemental que conserva
  % las soluciones y evita mezclar ecuaciones de magnitudes diferentes.
  M = M ./ escalasFilas;

  if any(~isfinite(M(:)))
    resultado.mensaje = ...
      ['El escalado produjo valores no finitos. ', ...
       'El sistema no puede resolverse de forma confiable en doble precision.'];
    resultado.matrizFinal = M;
    return;
  endif

  resultado = registrarPaso(resultado, ...
    'Escalado inicial de cada ecuacion por su mayor coeficiente.', M);

  % Equilibrar tambien las columnas. Si Cj es la escala de la columna j,
  % el sistema se resuelve en variables Yj = Cj * Xj.
  escalasColumnas = max(abs(M(:, 1:n)), [], 1);

  if any(escalasColumnas == 0)
    resultado.mensaje = ...
      'El sistema contiene una columna sin coeficientes: no tiene solucion unica.';
    resultado.matrizFinal = M;
    return;
  endif

  M(:, 1:n) = M(:, 1:n) ./ escalasColumnas;

  if any(~isfinite(M(:)))
    resultado.mensaje = ...
      ['El equilibrado produjo valores no finitos. ', ...
       'El sistema no puede resolverse de forma confiable en doble precision.'];
    resultado.matrizFinal = M;
    return;
  endif

  resultado = registrarPaso(resultado, ...
    ['Escalado de columnas con variables auxiliares ', ...
     'Yj = escalaColumna(j) * Xj.'], M);

  condicionReciproca = rcond(M(:, 1:n));

  if ~isfinite(condicionReciproca) || ...
      condicionReciproca <= toleranciaRedondeo
    resultado.mensaje = ...
      ['La matriz es singular o esta numericamente demasiado cerca ', ...
       'de serlo para obtener una solucion unica confiable.'];
    resultado.matrizFinal = M;
    return;
  endif

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

    escalaActiva = ...
      max(1, norm(M(1:filasActivas, 1:n), inf));
    toleranciaPivote = toleranciaRedondeo * escalaActiva;

    if mayorValor <= toleranciaPivote

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

    if any(~isfinite(M(:)))
      resultado.mensaje = ...
        ['Las operaciones produjeron valores no finitos. ', ...
         'El sistema no puede resolverse de forma confiable en doble precision.'];
      resultado.matrizFinal = M;
      return;
    endif

    % -------------------------------------------------------
    % NORMALIZACION DE LA PRIMERA FILA
    % -------------------------------------------------------
    M(1, :) = M(1, :) / pivote;
    M(1, etapa) = 1;

    if any(~isfinite(M(:)))
      resultado.mensaje = ...
        ['La normalizacion produjo valores no finitos. ', ...
         'El sistema no puede resolverse de forma confiable en doble precision.'];
      resultado.matrizFinal = M;
      return;
    endif

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
  % deben formar la identidad y la ultima columna contiene Y.
  identidad = eye(n);
  errorIdentidad = norm(M(:, 1:n) - identidad, inf);

  if ~isfinite(errorIdentidad) || ...
      errorIdentidad > 100 * toleranciaRedondeo
    resultado.mensaje = ...
      ['El procedimiento termino, pero no se obtuvo la matriz identidad. ', ...
       'Revise la condicion del sistema y su estabilidad numerica.'];
    return;
  endif

  Y = M(:, n + 1);
  X = Y ./ escalasColumnas(:);

  verificacion = A * X;
  residuo = verificacion - b;

  if any(~isfinite(X)) || any(~isfinite(verificacion)) || ...
      any(~isfinite(residuo))
    resultado.mensaje = ...
      ['El resultado contiene valores no finitos. ', ...
       'El sistema no puede resolverse de forma confiable en doble precision.'];
    return;
  endif

  % Residuo relativo calculado con escalado para evitar desbordamientos.
  escalaSistema = max(abs([A(:); b(:)]));
  AEscalada = A / escalaSistema;
  bEscalado = b / escalaSistema;
  normaX = norm(X, inf);
  factorX = max(1, normaX);
  residuoNormalizado = ...
    AEscalada * (X / factorX) - bEscalado / factorX;
  denominador = norm(AEscalada, inf) * (normaX / factorX) + ...
    norm(bEscalado, inf) / factorX;

  if denominador == 0
    residuoEscalado = norm(residuoNormalizado, inf);
  else
    residuoEscalado = norm(residuoNormalizado, inf) / denominador;
  endif

  if ~isfinite(residuoEscalado) || ...
      residuoEscalado > 100 * toleranciaRedondeo
    resultado.mensaje = ...
      ['La solucion obtenida no satisface el sistema con precision suficiente. ', ...
       'El calculo no se considera confiable.'];
    return;
  endif

  resultado.solucion = X;
  resultado.verificacion = verificacion;
  resultado.residuo = residuo;
  resultado.matrizFinal(:, n + 1) = X;
  resultado.exito = true;
  resultado.mensaje = 'Sistema resuelto correctamente.';

  resultado = registrarPaso(resultado, ...
    'Recuperacion de las variables originales Xj = Yj / escalaColumna(j).', ...
    resultado.matrizFinal);

  resultado = registrarPaso(resultado, ...
    'Resultado final: la matriz de coeficientes es la identidad.', ...
    resultado.matrizFinal);

endfunction


% =========================================================
% FUNCION AUXILIAR: REGISTRAR CADA PASO DEL PROCEDIMIENTO
% =========================================================
function resultado = registrarPaso(resultado, descripcion, matriz)

  k = numel(resultado.pasos) + 1;

  resultado.pasos(k).descripcion = descripcion;
  resultado.pasos(k).matriz = matriz;

endfunction
