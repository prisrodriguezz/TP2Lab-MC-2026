
function graficarInterpolacion(ax,X,Y,yObjetivo,resultado)

  % Limpiar grafico anterior
  cla(ax);

  hold(ax,'on');
  grid(ax,'on');

  % Mostrar puntos tabulados
  plot(ax,X,Y,'ko', ...
    'MarkerFaceColor',[0.2 0.5 0.8], ...
    'MarkerSize',7);

  % Configurar ejes
  xlabel(ax,'X');
  ylabel(ax,'Y');

  title(ax,'Interpolacion inversa lineal');

  if resultado.exito

    % Recuperar puntos seleccionados
    puntos = resultado.puntosSeleccionados;

    % Dibujar segmento interpolador
    plot(ax,puntos(:,1),puntos(:,2), ...
      'b-','LineWidth',2);

    % Dibujar punto interpolado
    plot(ax,resultado.xInterpolado,yObjetivo, ...
      'rp','MarkerFaceColor','r', ...
      'MarkerSize',12);

    % Guias hacia los ejes
    limitesY = ylim(ax);
    limitesX = xlim(ax);

    plot(ax, ...
      [resultado.xInterpolado resultado.xInterpolado], ...
      limitesY,'r:');

    plot(ax, ...
      limitesX, ...
      [yObjetivo yObjetivo],'r:');

    text(ax,resultado.xInterpolado + 0.02*diff(limitesX), ...
      yObjetivo + 0.03*diff(limitesY), ...
      sprintf('P* = (%.4f; %.6f)',resultado.xInterpolado,yObjetivo));

    % Leyenda
    legend(ax, ...
      {'Puntos tabulados', ...
       'Segmento seleccionado', ...
       'Punto interpolado'}, ...
      'Location','best');

  else

    title(ax, ...
      ['No se pudo interpolar: ',resultado.mensaje]);

    legend(ax,{'Puntos tabulados'}, ...
      'Location','best');

  endif

  hold(ax,'off');

endfunction
