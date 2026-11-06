DROP DATABASE IF EXISTS purple_nail_studio;
CREATE DATABASE purple_nail_studio;
USE purple_nail_studio;

-- =====================================================================
-- DDL
-- =====================================================================

-- 1. TABLA CLIENTE
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

-- 2. TABLA EMPLEADO
CREATE TABLE empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    especialidad VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'Activo'
);

-- 3. TABLA SERVICIO
CREATE TABLE servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    duracion INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo'
);

-- 4. TABLA CITA
CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    observaciones VARCHAR(255),

    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado),

    FOREIGN KEY (id_servicio)
        REFERENCES servicio(id_servicio)
);

-- 5. TABLA HORARIO
CREATE TABLE horario (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    dia VARCHAR(15) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo',

    FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado)
);

-- 6. TABLA USUARIO
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL UNIQUE,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(30) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo',

    FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado)
);

-- =====================================================================
-- DML
-- =====================================================================

-- ---------------------------------------------------------------------
-- cliente (15)
-- ---------------------------------------------------------------------
INSERT INTO cliente (nombre, apellido, telefono, correo) VALUES
('María',     'López',     '3001234567', 'maria.lopez@email.com'),
('Laura',     'Pérez',     '3012345678', 'laura.perez@email.com'),
('Diana',     'García',    '3023456789', 'diana.garcia@email.com'),
('Carla',     'Muñoz',     '3034567890', 'carla.munoz@email.com'),
('Valentina', 'Ruiz',      '3045678901', 'valentina.ruiz@email.com'),
('Paula',     'Herrera',   '3056789012', 'paula.herrera@email.com'),
('Juliana',   'Castro',    '3067890123', 'juliana.castro@email.com'),
('Daniela',   'Ortiz',     '3078901234', 'daniela.ortiz@email.com'),
('Andrea',    'Vargas',    '3089012345', 'andrea.vargas@email.com'),
('Natalia',   'Mendoza',   '3090123456', 'natalia.mendoza@email.com'),
('Sara',      'Jiménez',   '3201234567', 'sara.jimenez@email.com'),
('Camila',    'Suárez',    '3212345678', 'camila.suarez@email.com'),
('Mariana',   'Torres',    '3223456789', 'mariana.torres@email.com'),
('Luisa',     'Fernández', '3234567890', 'luisa.fernandez@email.com'),
('Isabella',  'Rojas',     '3245678901', 'isabella.rojas@email.com');

-- ---------------------------------------------------------------------
-- empleado (15; 4 inactivas: ids 8, 9, 13 y 15)
-- ---------------------------------------------------------------------
INSERT INTO empleado (nombre, apellido, telefono, especialidad, estado) VALUES
('Ana',       'Torres',    '3101112233', 'Manicure y pedicure',          'Activo'),
('Sofía',     'Ramírez',   '3102223344', 'Uñas acrílicas',               'Activo'),
('Valeria',   'Gómez',     '3103334455', 'Diseño nail art',              'Activo'),
('Camila',    'Rojas',     '3104445566', 'Esmaltado semipermanente',     'Activo'),
('Mónica',    'Díaz',      '3105556677', 'Uñas en gel',                  'Activo'),
('Lucía',     'Navarro',   '3106667788', 'Manicure spa',                 'Activo'),
('Karen',     'Molina',    '3107778899', 'Pedicure spa',                 'Activo'),
('Tatiana',   'Quintero',  '3108889900', 'Retiro y mantenimiento',       'Inactivo'),
('Yuliana',   'Pérez',     '3109990011', 'Uñas press on',                'Inactivo'),
('Estefanía', 'Acosta',    '3111112222', 'Diseño nail art',              'Activo'),
('Gabriela',  'León',      '3112223333', 'Manicure y pedicure',          'Activo'),
('Marcela',   'Peña',      '3113334444', 'Uñas acrílicas',               'Activo'),
('Johana',    'Salcedo',   '3114445555', 'Esmaltado semipermanente',     'Inactivo'),
('Paola',     'Arias',     '3115556666', 'Uñas en gel',                  'Activo'),
('Lorena',    'Cárdenas',  '3116667777', 'Manicure spa',                 'Inactivo');

-- ---------------------------------------------------------------------
-- usuario (15, uno por empleado; los inactivos quedan bloqueados)
-- ---------------------------------------------------------------------
INSERT INTO usuario (id_empleado, nombre_usuario, contrasena, rol, estado) VALUES
(1,  'atorres',    'atorres123',    'Administrador', 'Activo'),
(2,  'sramirez',   'sramirez123',   'Empleado',      'Activo'),
(3,  'vgomez',     'vgomez123',     'Empleado',      'Activo'),
(4,  'crojas',     'crojas123',     'Empleado',      'Activo'),
(5,  'mdiaz',      'mdiaz123',      'Empleado',      'Activo'),
(6,  'lnavarro',   'lnavarro123',   'Empleado',      'Activo'),
(7,  'kmolina',    'kmolina123',    'Empleado',      'Activo'),
(8,  'tquintero',  'tquintero123',  'Empleado',      'Inactivo'),
(9,  'yperez',     'yperez123',     'Empleado',      'Inactivo'),
(10, 'eacosta',    'eacosta123',    'Empleado',      'Activo'),
(11, 'gleon',      'gleon123',      'Empleado',      'Activo'),
(12, 'mpena',      'mpena123',      'Empleado',      'Activo'),
(13, 'jsalcedo',   'jsalcedo123',   'Empleado',      'Inactivo'),
(14, 'parias',     'parias123',     'Empleado',      'Activo'),
(15, 'lcardenas',  'lcardenas123',  'Empleado',      'Inactivo');

-- ---------------------------------------------------------------------
-- horario (15; los horarios de empleadas inactivas quedan inactivos)
-- ---------------------------------------------------------------------
INSERT INTO horario (id_empleado, dia, hora_inicio, hora_fin, estado) VALUES
(1,  'Lunes',     '08:00:00', '17:00:00', 'Activo'),
(2,  'Martes',    '08:00:00', '17:00:00', 'Activo'),
(3,  'Miércoles', '09:00:00', '18:00:00', 'Activo'),
(4,  'Jueves',    '09:00:00', '18:00:00', 'Activo'),
(5,  'Viernes',   '08:00:00', '16:00:00', 'Activo'),
(6,  'Sábado',    '09:00:00', '14:00:00', 'Activo'),
(7,  'Lunes',     '10:00:00', '18:00:00', 'Activo'),
(8,  'Martes',    '10:00:00', '18:00:00', 'Inactivo'),
(9,  'Miércoles', '08:00:00', '16:00:00', 'Inactivo'),
(10, 'Jueves',    '08:00:00', '16:00:00', 'Activo'),
(11, 'Viernes',   '09:00:00', '17:00:00', 'Activo'),
(12, 'Sábado',    '08:00:00', '13:00:00', 'Activo'),
(13, 'Lunes',     '07:00:00', '15:00:00', 'Inactivo'),
(14, 'Martes',    '07:00:00', '15:00:00', 'Activo'),
(15, 'Miércoles', '12:00:00', '18:00:00', 'Inactivo');

-- ---------------------------------------------------------------------
-- servicio (15; 2 inactivos: 'Press On Nails' y 'Baño de Parafina')
-- ---------------------------------------------------------------------
INSERT INTO servicio (nombre_servicio, descripcion, duracion, precio, estado) VALUES
('Manicure',                 'Limpieza, limado y esmaltado de manos',   45,  35000, 'Activo'),
('Pedicure',                 'Limpieza, limado y esmaltado de pies',    60,  45000, 'Activo'),
('Uñas Acrílicas',           'Aplicación de uñas acrílicas',           120,  90000, 'Activo'),
('Diseño Nail Art',          'Decoración artística de uñas',            60,  40000, 'Activo'),
('Esmaltado Semipermanente', 'Esmalte semipermanente con lámpara',      60,  38000, 'Activo'),
('Retiro de Acrílico',       'Retiro seguro de uñas acrílicas',         30,  20000, 'Activo'),
('Manicure Spa',             'Manicure con exfoliación e hidratación',  75,  55000, 'Activo'),
('Pedicure Spa',             'Pedicure con exfoliación y masaje',       90,  65000, 'Activo'),
('Uñas en Gel',              'Aplicación de uñas en gel',              100,  80000, 'Activo'),
('Press On Nails',           'Uñas postizas personalizadas',            90,  70000, 'Inactivo'),
('Reparación de Uña',        'Reparación de una uña rota',              20,  10000, 'Activo'),
('Baño de Parafina',         'Tratamiento hidratante para manos',       30,  25000, 'Inactivo'),
('Decoración con Pedrería',  'Aplicación de pedrería en las uñas',      30,  15000, 'Activo'),
('Francés Clásico',          'Esmaltado con diseño francés',            50,  42000, 'Activo'),
('Mantenimiento Acrílico',   'Relleno y mantenimiento de acrílico',     90,  60000, 'Activo');

-- ---------------------------------------------------------------------
-- cita (15; cada cita incluye un servicio)
-- Completada: 6 | Confirmada: 2 | Pendiente (sin confirmar): 4 | Cancelada: 3
-- ---------------------------------------------------------------------
INSERT INTO cita (id_cliente, id_empleado, id_servicio, fecha, hora, estado, observaciones) VALUES
(1,  1,  5,  '2026-10-05', '09:00:00', 'Completada', 'Color rojo cereza'),
(2,  2,  3,  '2026-10-06', '11:00:00', 'Completada', 'La cliente llegó 10 minutos tarde. Forma almendra, largo medio'),
(3,  8,  6,  '2026-10-06', '14:00:00', 'Completada', 'Última cita atendida por la empleada antes de su retiro'),
(1,  3,  4,  '2026-10-07', '10:00:00', 'Completada', 'Diseño floral con pedrería solo en el dedo anular'),
(4,  4,  5,  '2026-10-08', '15:00:00', 'Completada', 'Cliente alérgica a la acetona: usar removedor sin acetona'),
(5,  5,  3,  '2026-10-09', '09:30:00', 'Cancelada',  'Cancelada por la cliente: calamidad familiar'),
(6,  1,  1,  '2026-10-12', '16:00:00', 'Cancelada',  'La cliente no asistió ni avisó'),
(7,  3,  10, '2026-10-14', '10:00:00', 'Completada', 'Pidió cambiar el color a último momento'),
(8,  1,  7,  '2026-10-19', '09:00:00', 'Confirmada', NULL),
(9,  7,  15, '2026-10-19', '11:00:00', 'Cancelada',  'Cancelada por la empleada: incapacidad médica, falta reprogramar'),
(1,  2,  2,  '2026-10-20', '14:00:00', 'Confirmada', 'La cliente pidió llegar 15 minutos antes'),
(10, 3,  8,  '2026-10-21', '10:30:00', 'Pendiente',  'Falta confirmar con la cliente por llamada'),
(11, 4,  4,  '2026-10-22', '15:00:00', 'Pendiente',  'Diseño minimalista'),
(12, 5,  14, '2026-10-23', '09:00:00', 'Pendiente',  NULL),
(14, 8,  6,  '2026-10-27', '13:00:00', 'Pendiente',  'Empleada inactiva: reasignar la cita');
