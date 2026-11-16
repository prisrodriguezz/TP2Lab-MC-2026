
function resultado = interpolacionInversaLineal(X, Y, yObjetivo)

  % Inicializar estructura de resultado
  resultado.exito = false;
  resultado.mensaje = '';
  resultado.xInterpolado = NaN;
  resultado.yObjetivo = yObjetivo;
  resultado.puntosSeleccionados = [];
  resultado.h = NaN;
  resultado.deltaY = NaN;
  resultado.cociente = NaN;
  resultado.pasos = {};
  resultado.X = [];
  resultado.Y = [];
  resultado.diferencias = [];
  resultado.indiceIntervalo = 0;

  % Validar que X e Y sean vectores numericos
  if !isnumeric(X) || !isnumeric(Y) || ...
     !isvector(X) || !isvector(Y)

    resultado.mensaje = 'X e Y deben ser vectores numericos.';
    return;

  endif

  % Validar que el valor objetivo sea un escalar numerico
  if !isnumeric(yObjetivo) || !isscalar(yObjetivo)

    resultado.mensaje = 'El valor objetivo debe ser un numero escalar.';
    return;

  endif

  % Convertir vectores en columnas
  X = X(:);
  Y = Y(:);

  % Validar dimensiones
  if length(X) != length(Y)

    resultado.mensaje = 'Los vectores X e Y deben tener la misma cantidad de elementos.';
    return;

  endif

  % Validar cantidad de puntos
  if length(X) < 2

    resultado.mensaje = 'Se necesitan al menos dos puntos.';
    return;

  endif

  % Validar valores reales y finitos
  if !isreal(X) || !isreal(Y) || !isreal(yObjetivo) || ...
     any(!isfinite(X)) || any(!isfinite(Y)) || ...
     !isfinite(yObjetivo)

    resultado.mensaje = 'Todos los valores deben ser reales y finitos.';
    return;

  endif

  % Buscar dos puntos consecutivos que encierren yObjetivo
  indice = 0;

  for i = 1:length(Y)-1

    y0 = Y(i);
    y1 = Y(i+1);

    if (yObjetivo >= min(y0,y1)) && ...
       (yObjetivo <= max(y0,y1))

      indice = i;
      break;

    endif

  endfor

  % Verificar si se encontro un intervalo
  if indice == 0

    resultado.mensaje = 'No se encontro un intervalo que contenga el valor objetivo.';
    return;

  endif

  % Guardar datos originales y calcular primeras diferencias
  resultado.X = X;
  resultado.Y = Y;
  resultado.diferencias = diff(Y);

  % Obtener puntos seleccionados
  x0 = X(indice);
  x1 = X(indice+1);
  y0 = Y(indice);
  y1 = Y(indice+1);
  resultado.indiceIntervalo = indice;

  % Calcular incremento y primera diferencia
  h = x1 - x0;
  deltaY = y1 - y0;

  % Validar que las abscisas sean diferentes
  if h == 0

    resultado.mensaje = 'Las abscisas del intervalo deben ser diferentes.';
    return;

  endif

  % Validar que la diferencia entre valores Y no sea cero
  if deltaY == 0

    resultado.mensaje = 'No se puede interpolar: la diferencia entre los valores Y es cero.';
    return;

  endif

  % Calcular interpolacion inversa lineal
  cociente = (yObjetivo - y0) / deltaY;
  xInterpolado = x0 + h * cociente;

  % Guardar resultados
  resultado.puntosSeleccionados = [x0 y0; x1 y1];
  resultado.h = h;
  resultado.deltaY = deltaY;
  resultado.cociente = cociente;
  resultado.xInterpolado = xInterpolado;
  resultado.exito = true;
  resultado.mensaje = 'Interpolacion inversa lineal realizada correctamente.';

  % Guardar desarrollo del calculo
  resultado.pasos = {
    sprintf('Punto inicial: (%.6f, %.6f)', x0, y0);
    sprintf('Punto final: (%.6f, %.6f)', x1, y1);
    sprintf('Incremento h = x1 - x0 = %.6f', h);
    sprintf('Diferencia deltaY = y1 - y0 = %.6f', deltaY);
    sprintf('Cociente (yObjetivo - y0) / deltaY = %.6f', cociente);
    sprintf('x* = x0 + h * cociente = %.6f', xInterpolado)
  };

endfunction
