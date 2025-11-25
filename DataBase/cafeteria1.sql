--
-- PostgreSQL database dump
--

\restrict kWXBsSr0NRPn84XvuAwYEpTiGZk1MuKbCforyE2VM4zJcIhyM4pyYV29bUF5hPI

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-11-25 10:13:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16728)
-- Name: caja; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.caja (
    id bigint NOT NULL,
    id_usuario_apertura bigint NOT NULL,
    id_usuario_cierre bigint,
    fecha_apertura timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre timestamp without time zone,
    monto_inicial numeric(10,2) NOT NULL,
    monto_final_sistema numeric(10,2),
    monto_final_real numeric(10,2),
    estado character varying(20) DEFAULT 'ABIERTA'::character varying
);


--
-- TOC entry 220 (class 1259 OID 16736)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caja_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 220
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 221 (class 1259 OID 16737)
-- Name: cliente; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cliente (
    id bigint NOT NULL,
    nombre character varying(100),
    telefono character varying(20),
    email character varying(100),
    nit_rfc character varying(20),
    puntos_acumulados integer DEFAULT 0
);


--
-- TOC entry 222 (class 1259 OID 16742)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 222
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- TOC entry 223 (class 1259 OID 16743)
-- Name: detalle_ticket; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_ticket (
    id bigint NOT NULL,
    id_ticket bigint NOT NULL,
    id_producto bigint NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 16752)
-- Name: detalle_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 224
-- Name: detalle_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_ticket_id_seq OWNED BY public.detalle_ticket.id;


--
-- TOC entry 225 (class 1259 OID 16753)
-- Name: inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventario (
    id bigint NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion text,
    stock_actual numeric(10,4) DEFAULT 0,
    stock_minimo numeric(10,4) DEFAULT 5,
    costo_promedio numeric(10,2) DEFAULT 0
);


--
-- TOC entry 226 (class 1259 OID 16763)
-- Name: inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 226
-- Name: inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventario_id_seq OWNED BY public.inventario.id;


--
-- TOC entry 227 (class 1259 OID 16764)
-- Name: permiso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permiso (
    id bigint NOT NULL,
    nombre character varying(100) NOT NULL,
    codigo_interno character varying(50) NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 16770)
-- Name: permiso_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permiso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 228
-- Name: permiso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permiso_id_seq OWNED BY public.permiso.id;


--
-- TOC entry 229 (class 1259 OID 16771)
-- Name: producto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.producto (
    id bigint NOT NULL,
    nombre character varying(100) NOT NULL,
    precio_venta numeric(10,2) NOT NULL,
    imagen_url text,
    categoria character varying(50),
    es_compuesto boolean DEFAULT true,
    activo boolean DEFAULT true
);


--
-- TOC entry 230 (class 1259 OID 16781)
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.producto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 230
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 231 (class 1259 OID 16782)
-- Name: proveedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proveedor (
    id bigint NOT NULL,
    nombre_empresa character varying(100) NOT NULL,
    nombre_contacto character varying(100),
    telefono character varying(20),
    email character varying(100),
    activo boolean DEFAULT true
);


--
-- TOC entry 232 (class 1259 OID 16788)
-- Name: proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proveedor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 232
-- Name: proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.proveedor_id_seq OWNED BY public.proveedor.id;


--
-- TOC entry 233 (class 1259 OID 16789)
-- Name: receta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receta (
    id bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_inventario bigint NOT NULL,
    cantidad_requerida numeric(10,4) NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 16796)
-- Name: receta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 234
-- Name: receta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receta_id_seq OWNED BY public.receta.id;


--
-- TOC entry 235 (class 1259 OID 16797)
-- Name: rel_proveedor_inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rel_proveedor_inventario (
    id bigint NOT NULL,
    id_proveedor bigint NOT NULL,
    id_inventario bigint NOT NULL,
    precio_ultimo_costo numeric(10,2),
    codigo_catalogo_proveedor character varying(50)
);


--
-- TOC entry 236 (class 1259 OID 16803)
-- Name: rel_proveedor_inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rel_proveedor_inventario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 236
-- Name: rel_proveedor_inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rel_proveedor_inventario_id_seq OWNED BY public.rel_proveedor_inventario.id;


--
-- TOC entry 237 (class 1259 OID 16804)
-- Name: rol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rol (
    id bigint NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(200)
);


--
-- TOC entry 238 (class 1259 OID 16809)
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 238
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- TOC entry 239 (class 1259 OID 16810)
-- Name: roles_permisos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles_permisos (
    id_rol bigint NOT NULL,
    id_permiso bigint NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 16815)
-- Name: ticket; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ticket (
    id bigint NOT NULL,
    id_caja bigint NOT NULL,
    id_cliente bigint,
    id_usuario bigint NOT NULL,
    fecha_emision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_venta numeric(10,2) NOT NULL,
    metodo_pago character varying(50) DEFAULT 'EFECTIVO'::character varying,
    estado character varying(20) DEFAULT 'PAGADO'::character varying
);


--
-- TOC entry 241 (class 1259 OID 16825)
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 241
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ticket_id_seq OWNED BY public.ticket.id;


--
-- TOC entry 242 (class 1259 OID 16826)
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id bigint NOT NULL,
    id_rol bigint NOT NULL,
    nombre_completo character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    activo boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 243 (class 1259 OID 16836)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 243
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 4915 (class 2604 OID 16961)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 4918 (class 2604 OID 16962)
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16963)
-- Name: detalle_ticket id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket ALTER COLUMN id SET DEFAULT nextval('public.detalle_ticket_id_seq'::regclass);


--
-- TOC entry 4921 (class 2604 OID 16964)
-- Name: inventario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id SET DEFAULT nextval('public.inventario_id_seq'::regclass);


--
-- TOC entry 4925 (class 2604 OID 16965)
-- Name: permiso id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso ALTER COLUMN id SET DEFAULT nextval('public.permiso_id_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 16966)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 4929 (class 2604 OID 16967)
-- Name: proveedor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id SET DEFAULT nextval('public.proveedor_id_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 16968)
-- Name: receta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta ALTER COLUMN id SET DEFAULT nextval('public.receta_id_seq'::regclass);


--
-- TOC entry 4932 (class 2604 OID 16969)
-- Name: rel_proveedor_inventario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario ALTER COLUMN id SET DEFAULT nextval('public.rel_proveedor_inventario_id_seq'::regclass);


--
-- TOC entry 4933 (class 2604 OID 16970)
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- TOC entry 4934 (class 2604 OID 16971)
-- Name: ticket id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket ALTER COLUMN id SET DEFAULT nextval('public.ticket_id_seq'::regclass);


--
-- TOC entry 4938 (class 2604 OID 16972)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 5136 (class 0 OID 16728)
-- Dependencies: 219
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.caja (id, id_usuario_apertura, id_usuario_cierre, fecha_apertura, fecha_cierre, monto_inicial, monto_final_sistema, monto_final_real, estado) FROM stdin;
1	3	\N	2025-11-25 10:00:04.72145	\N	500.00	\N	\N	ABIERTA
\.


--
-- TOC entry 5138 (class 0 OID 16737)
-- Dependencies: 221
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cliente (id, nombre, telefono, email, nit_rfc, puntos_acumulados) FROM stdin;
\.


--
-- TOC entry 5140 (class 0 OID 16743)
-- Dependencies: 223
-- Data for Name: detalle_ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_ticket (id, id_ticket, id_producto, cantidad, precio_unitario, subtotal) FROM stdin;
1	1	1	2	35.50	71.00
\.


--
-- TOC entry 5142 (class 0 OID 16753)
-- Dependencies: 225
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventario (id, nombre, descripcion, stock_actual, stock_minimo, costo_promedio) FROM stdin;
2	Leche entera Lt	Leche entera (Litros)	19.4000	5.0000	25.00
3	Azucar	Azucar refinada (Kg)	7.0100	7.0000	45.00
1	Grano de cafe	Cafe premium (kg)	49.8000	5.0000	100.00
\.


--
-- TOC entry 5144 (class 0 OID 16764)
-- Dependencies: 227
-- Data for Name: permiso; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permiso (id, nombre, codigo_interno) FROM stdin;
\.


--
-- TOC entry 5146 (class 0 OID 16771)
-- Dependencies: 229
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.producto (id, nombre, precio_venta, imagen_url, categoria, es_compuesto, activo) FROM stdin;
1	Café Americano	35.50	https://imgs.search.brave.com/EQd00rpPcsLOrWa6RzquKZ5LRFMstaSJzTszUARD0W0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zZW5z/b3JpYWwuY29mZmVl/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDI1/LzAyLzEwMi5qcGc	Bebidas Calientes	t	t
3	Cupcake	20.00	https://imgs.search.brave.com/Wymqgmv7uQCqhtanjyKeNgnjG_o1i2hePHqKrC5jRMY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvaGQvYmVz/dC1kZXNzZXJ0cy1i/YWNrZ3JvdW5kLTI3/MzIteC0yNzMyLW1o/MDRsa2x5aHA2cGdn/YWguanBn	Postres	t	t
2	Panque de chocolate	28.00	https://imgs.search.brave.com/5ZN1YfDVCX4Cwt-M-RWcDEm6JOA7ioA5C-Tucn4pLRU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/cmVjZXRhc25lc3Rs/ZS5jb20ubXgvc2l0/ZXMvZGVmYXVsdC9m/aWxlcy9zdHlsZXMv/Y3JvcHBlZF9yZWNp/cGVfY2FyZF9uZXcv/cHVibGljL3NyaF9y/ZWNpcGVzL2I3ZDQ3/ZDdkYmVmNTg4N2Nh/NTRhOWY5NTlhOWVi/ODAwLmpwZy53ZWJw/P2l0b2s9WGRuT1hX/MHY	Postres	t	t
4	Té de Matcha	37.00	https://imgs.search.brave.com/Ce5uIvGy0UZlLDuyPxFUm8WrRxnlORvlgeQ3woiUIUY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTg3/MDM4MTA3MC9waG90/by9kZWxpY2lvdXMt/bWF0Y2hhLWxhdHRl/LXBvd2Rlci1sZWFm/LWFuZC13aGlzay1v/bi13aGl0ZS10YWJs/ZS1mbGF0LWxheS5q/cGc_cz02MTJ4NjEy/Jnc9MCZrPTIwJmM9/WU5raVhZcEtOMkNG/LThaQ2hLUEZwWkND/OHFaeGFJN01oV3da/bDBMLXdzYz0	Bebidas Calientes	\N	t
\.


--
-- TOC entry 5148 (class 0 OID 16782)
-- Dependencies: 231
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proveedor (id, nombre_empresa, nombre_contacto, telefono, email, activo) FROM stdin;
1	Nescafe	\N	\N	proveedor1@cafeteria.com	t
\.


--
-- TOC entry 5150 (class 0 OID 16789)
-- Dependencies: 233
-- Data for Name: receta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.receta (id, id_producto, id_inventario, cantidad_requerida) FROM stdin;
1	1	1	0.1000
2	1	2	0.3000
3	1	3	0.1000
\.


--
-- TOC entry 5152 (class 0 OID 16797)
-- Dependencies: 235
-- Data for Name: rel_proveedor_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rel_proveedor_inventario (id, id_proveedor, id_inventario, precio_ultimo_costo, codigo_catalogo_proveedor) FROM stdin;
1	1	1	150.00	
\.


--
-- TOC entry 5154 (class 0 OID 16804)
-- Dependencies: 237
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rol (id, nombre, descripcion) FROM stdin;
1	Admin	Administrador del sistema
2	Empleado	Cajero y mesero
3	Proveedor	Acceso limitado al inventario
4	Cajero	Cajero 
5	Cocinero	Cocina
\.


--
-- TOC entry 5156 (class 0 OID 16810)
-- Dependencies: 239
-- Data for Name: roles_permisos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles_permisos (id_rol, id_permiso) FROM stdin;
\.


--
-- TOC entry 5157 (class 0 OID 16815)
-- Dependencies: 240
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ticket (id, id_caja, id_cliente, id_usuario, fecha_emision, total_venta, metodo_pago, estado) FROM stdin;
1	1	\N	1	2025-11-25 10:08:14.476781	71.00	EFECTIVO	PAGADO
\.


--
-- TOC entry 5159 (class 0 OID 16826)
-- Dependencies: 242
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuario (id, id_rol, nombre_completo, email, password_hash, activo, fecha_creacion) FROM stdin;
1	1	Nestor Luna	admin@cafeteria.com	$2a$11$pbLGpQyKcZ0IBPvmXFbVhu/Xoap/xVh0CHcKQGT/yt7rVcBjey5vm	t	2025-11-22 18:33:23.51363
2	3	proveedor	proveedor1@cafeteria.com	$2a$11$wHswAtNnE42gPUsK7zcsIuI92nJ6QN3nkolTD0GLWvjY2lyI0KiIS	t	2025-11-23 18:00:36.92501
3	4	Empleado1	Empleado1@cafeteria.com	$2a$11$feq/E0jYWop/T50V1sfqiumjQY1NF6l93/9Z1LN9GpRAIs8H.3Z7q	t	2025-11-25 09:43:14.380576
\.


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 220
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caja_id_seq', 1, true);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 222
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cliente_id_seq', 1, false);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 224
-- Name: detalle_ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_ticket_id_seq', 1, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 226
-- Name: inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventario_id_seq', 3, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 228
-- Name: permiso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.permiso_id_seq', 1, false);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 230
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.producto_id_seq', 4, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 232
-- Name: proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.proveedor_id_seq', 1, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 234
-- Name: receta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.receta_id_seq', 3, true);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 236
-- Name: rel_proveedor_inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rel_proveedor_inventario_id_seq', 1, false);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 238
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rol_id_seq', 3, true);


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 241
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ticket_id_seq', 1, true);


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 243
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_seq', 15, true);


--
-- TOC entry 4942 (class 2606 OID 16850)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4944 (class 2606 OID 16852)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 4946 (class 2606 OID 16854)
-- Name: detalle_ticket detalle_ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket
    ADD CONSTRAINT detalle_ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4949 (class 2606 OID 16856)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id);


--
-- TOC entry 4951 (class 2606 OID 16858)
-- Name: permiso permiso_codigo_interno_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_codigo_interno_key UNIQUE (codigo_interno);


--
-- TOC entry 4953 (class 2606 OID 16860)
-- Name: permiso permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_pkey PRIMARY KEY (id);


--
-- TOC entry 4955 (class 2606 OID 16862)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4957 (class 2606 OID 16864)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id);


--
-- TOC entry 4959 (class 2606 OID 16866)
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (id);


--
-- TOC entry 4961 (class 2606 OID 16868)
-- Name: rel_proveedor_inventario rel_proveedor_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario
    ADD CONSTRAINT rel_proveedor_inventario_pkey PRIMARY KEY (id);


--
-- TOC entry 4963 (class 2606 OID 16870)
-- Name: rol rol_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_nombre_key UNIQUE (nombre);


--
-- TOC entry 4965 (class 2606 OID 16872)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 4967 (class 2606 OID 16874)
-- Name: roles_permisos roles_permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_permisos
    ADD CONSTRAINT roles_permisos_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- TOC entry 4970 (class 2606 OID 16876)
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4973 (class 2606 OID 16878)
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- TOC entry 4975 (class 2606 OID 16880)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4947 (class 1259 OID 16881)
-- Name: idx_inventario_nombre; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_inventario_nombre ON public.inventario USING btree (nombre);


--
-- TOC entry 4968 (class 1259 OID 16882)
-- Name: idx_ticket_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ticket_fecha ON public.ticket USING btree (fecha_emision);


--
-- TOC entry 4971 (class 1259 OID 16883)
-- Name: idx_usuario_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usuario_email ON public.usuario USING btree (email);


--
-- TOC entry 4976 (class 2606 OID 16884)
-- Name: caja fk_caja_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario FOREIGN KEY (id_usuario_apertura) REFERENCES public.usuario(id);


--
-- TOC entry 4977 (class 2606 OID 16889)
-- Name: detalle_ticket fk_detalle_producto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket
    ADD CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id);


--
-- TOC entry 4978 (class 2606 OID 16894)
-- Name: detalle_ticket fk_detalle_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket
    ADD CONSTRAINT fk_detalle_ticket FOREIGN KEY (id_ticket) REFERENCES public.ticket(id) ON DELETE CASCADE;


--
-- TOC entry 4979 (class 2606 OID 16899)
-- Name: receta fk_receta_inventario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_inventario FOREIGN KEY (id_inventario) REFERENCES public.inventario(id);


--
-- TOC entry 4980 (class 2606 OID 16904)
-- Name: receta fk_receta_producto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id) ON DELETE CASCADE;


--
-- TOC entry 4983 (class 2606 OID 16909)
-- Name: roles_permisos fk_rp_permiso; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_permisos
    ADD CONSTRAINT fk_rp_permiso FOREIGN KEY (id_permiso) REFERENCES public.permiso(id) ON DELETE CASCADE;


--
-- TOC entry 4984 (class 2606 OID 16914)
-- Name: roles_permisos fk_rp_rol; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_permisos
    ADD CONSTRAINT fk_rp_rol FOREIGN KEY (id_rol) REFERENCES public.rol(id) ON DELETE CASCADE;


--
-- TOC entry 4981 (class 2606 OID 16919)
-- Name: rel_proveedor_inventario fk_rpi_inventario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario
    ADD CONSTRAINT fk_rpi_inventario FOREIGN KEY (id_inventario) REFERENCES public.inventario(id);


--
-- TOC entry 4982 (class 2606 OID 16924)
-- Name: rel_proveedor_inventario fk_rpi_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario
    ADD CONSTRAINT fk_rpi_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id);


--
-- TOC entry 4985 (class 2606 OID 16929)
-- Name: ticket fk_ticket_caja; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_caja FOREIGN KEY (id_caja) REFERENCES public.caja(id);


--
-- TOC entry 4986 (class 2606 OID 16934)
-- Name: ticket fk_ticket_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente(id);


--
-- TOC entry 4987 (class 2606 OID 16939)
-- Name: ticket fk_ticket_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id);


--
-- TOC entry 4988 (class 2606 OID 16944)
-- Name: usuario fk_usuario_rol; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES public.rol(id);


-- Completed on 2025-11-25 10:13:43

--
-- PostgreSQL database dump complete
--

\unrestrict kWXBsSr0NRPn84XvuAwYEpTiGZk1MuKbCforyE2VM4zJcIhyM4pyYV29bUF5hPI

