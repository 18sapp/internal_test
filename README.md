# Ejercicio de Refactorización - App de Gestión de Gastos

## Objetivo del Ejercicio

Este proyecto contiene una aplicación Flutter funcional para la gestión de gastos personales. Sin embargo, el código está intencionalmente mal estructurado, sin patrones de diseño, con múltiples problemas de arquitectura y malas prácticas.

**Tu tarea es refactorizar y optimizar este código aplicando patrones de diseño, separación de responsabilidades, y mejores prácticas de Flutter/Dart.**

## Funcionalidades de la App

La aplicación incluye las siguientes funcionalidades:

- **Dashboard**: Resumen de gastos del mes, gráficos de barras y pastel, alertas de presupuestos excedidos
- **Gestión de Gastos**: Lista de gastos con filtros múltiples (fecha, categoría, cuenta, monto), búsqueda por texto, crear/editar/eliminar gastos
- **Gestión de Categorías**: CRUD de categorías con colores e iconos
- **Gestión de Cuentas**: CRUD de cuentas/tarjetas (efectivo, tarjeta, banco)
- **Gestión de Presupuestos**: Asignar presupuestos a categorías con seguimiento de gastos
- **Exportación**: Exportar datos a JSON

## Problemas Identificados en el Código Actual

El código actual presenta los siguientes problemas (entre otros):

1. **Todo en un solo archivo** (`lib/main.dart`) - más de 1500 líneas
2. **Sin separación de responsabilidades** - lógica de negocio mezclada con UI
3. **Variables globales** para el estado de la aplicación
4. **Código duplicado** - misma lógica repetida en múltiples lugares
5. **Sin modelos de datos** - uso de `Map<String, dynamic>` en lugar de clases
6. **Sin servicios/repositorios** - lógica directa en widgets
7. **Validaciones hardcodeadas** en múltiples lugares
8. **Sin gestión de estado centralizada** - uso excesivo de `setState`
9. **Cálculos complejos en métodos `build()`** - afecta el rendimiento
10. **Sin manejo de errores** apropiado
11. **Nombres de variables poco descriptivos** en algunos lugares
12. **Sin tests unitarios**
13. **Sin persistencia real** - datos solo en memoria

## Tareas de Refactorización

### 1. Arquitectura y Estructura

- [ ] Separar el código en una estructura de carpetas apropiada:
  - `models/` - Modelos de datos
  - `screens/` - Pantallas
  - `widgets/` - Widgets reutilizables
  - `services/` - Servicios y lógica de negocio
  - `repositories/` - Repositorios para acceso a datos
  - `utils/` - Utilidades y helpers

### 2. Modelos de Datos

- [ ] Crear clases modelo para:
  - `Gasto`
  - `Categoria`
  - `Cuenta`
  - `Presupuesto`
- [ ] Implementar métodos `toJson()` y `fromJson()` para serialización

### 3. Gestión de Estado

- [ ] Implementar una solución de gestión de estado (Provider, BLoC, Riverpod, GetX, etc.)
- [ ] Separar la lógica de negocio de los widgets
- [ ] Evitar `setState` innecesarios y optimizar rebuilds

### 4. Servicios y Repositorios

- [ ] Crear servicios para:
  - Gestión de gastos
  - Gestión de categorías
  - Gestión de cuentas
  - Gestión de presupuestos
  - Cálculos y estadísticas
- [ ] Implementar repositorios para abstraer el acceso a datos
- [ ] Centralizar validaciones

### 5. Widgets Reutilizables

- [ ] Extraer widgets comunes a archivos separados
- [ ] Crear widgets personalizados para gráficos
- [ ] Reutilizar formularios y campos de entrada

### 6. Optimizaciones

- [ ] Mover cálculos pesados fuera de `build()`
- [ ] Usar `const` constructors donde sea posible

### 7. Manejo de Errores

- [ ] Agregar manejo de errores apropiado
- [ ] Mostrar mensajes de error al usuario
- [ ] Validar datos antes de procesarlos

### 8. Persistencia (Opcional - Bonus)

- [ ] Implementar persistencia local (SharedPreferences, SQLite, Hive, etc.)
- [ ] Guardar y cargar datos al iniciar la app

### 9. Documentación

- [ ] Agregar comentarios JSDoc donde sea necesario
- [ ] Documentar funciones complejas
- [ ] Actualizar este README con la nueva estructura

## Criterios de Evaluación

Se evaluará:

1. **Arquitectura**: Organización del código, separación de responsabilidades
2. **Patrones de Diseño**: Uso apropiado de patrones (Repository, Service, etc.)
3. **Calidad del Código**: Legibilidad, mantenibilidad, DRY (Don't Repeat Yourself)
4. **Rendimiento**: Optimizaciones aplicadas
5. **Buenas Prácticas**: Convenciones de Flutter/Dart, naming, estructura
6. **Funcionalidad**: La app debe seguir funcionando correctamente después de la refactorización

## Instrucciones

1. Clona o descarga este proyecto
2. Ejecuta `flutter pub get` para instalar dependencias
3. Revisa el código actual en `lib/main.dart`
4. Refactoriza el código siguiendo las tareas mencionadas
5. Asegúrate de que la app siga funcionando correctamente
6. Documenta los cambios realizados con commits

## Notas

- Puedes agregar dependencias adicionales si lo consideras necesario (gestión de estado, persistencia, etc.)
- El código debe compilar y ejecutarse sin errores
- Prioriza la claridad y mantenibilidad sobre la optimización prematura
- Si no completas todas las tareas, documenta qué hiciste y por qué

¡Buena suerte!
