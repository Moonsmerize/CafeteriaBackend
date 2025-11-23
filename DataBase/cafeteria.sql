--
-- PostgreSQL database dump
--

\restrict CPVYAjuMxDBjKPjlRNha22P1HperbcodjGfgEXaTQdaIQfWKFzECXub8D1hsZUX

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-11-23 00:13:25

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
-- TOC entry 239 (class 1259 OID 16538)
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
-- TOC entry 238 (class 1259 OID 16537)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caja_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 238
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 237 (class 1259 OID 16529)
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
-- TOC entry 236 (class 1259 OID 16528)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 236
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- TOC entry 243 (class 1259 OID 16584)
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
-- TOC entry 242 (class 1259 OID 16583)
-- Name: detalle_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 242
-- Name: detalle_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_ticket_id_seq OWNED BY public.detalle_ticket.id;


--
-- TOC entry 229 (class 1259 OID 16460)
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
-- TOC entry 228 (class 1259 OID 16459)
-- Name: inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 228
-- Name: inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventario_id_seq OWNED BY public.inventario.id;


--
-- TOC entry 222 (class 1259 OID 16400)
-- Name: permiso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permiso (
    id bigint NOT NULL,
    nombre character varying(100) NOT NULL,
    codigo_interno character varying(50) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: permiso_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permiso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 221
-- Name: permiso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permiso_id_seq OWNED BY public.permiso.id;


--
-- TOC entry 233 (class 1259 OID 16494)
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
-- TOC entry 232 (class 1259 OID 16493)
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.producto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 232
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 227 (class 1259 OID 16450)
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
-- TOC entry 226 (class 1259 OID 16449)
-- Name: proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proveedor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 226
-- Name: proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.proveedor_id_seq OWNED BY public.proveedor.id;


--
-- TOC entry 235 (class 1259 OID 16508)
-- Name: receta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receta (
    id bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_inventario bigint NOT NULL,
    cantidad_requerida numeric(10,4) NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 16507)
-- Name: receta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 234
-- Name: receta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receta_id_seq OWNED BY public.receta.id;


--
-- TOC entry 231 (class 1259 OID 16474)
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
-- TOC entry 230 (class 1259 OID 16473)
-- Name: rel_proveedor_inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rel_proveedor_inventario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 230
-- Name: rel_proveedor_inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rel_proveedor_inventario_id_seq OWNED BY public.rel_proveedor_inventario.id;


--
-- TOC entry 220 (class 1259 OID 16389)
-- Name: rol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rol (
    id bigint NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(200)
);


--
-- TOC entry 219 (class 1259 OID 16388)
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 219
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- TOC entry 223 (class 1259 OID 16411)
-- Name: roles_permisos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles_permisos (
    id_rol bigint NOT NULL,
    id_permiso bigint NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 16555)
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
-- TOC entry 240 (class 1259 OID 16554)
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 240
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ticket_id_seq OWNED BY public.ticket.id;


--
-- TOC entry 225 (class 1259 OID 16429)
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
-- TOC entry 224 (class 1259 OID 16428)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 224
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 4832 (class 2604 OID 16541)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 4830 (class 2604 OID 16532)
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 16587)
-- Name: detalle_ticket id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket ALTER COLUMN id SET DEFAULT nextval('public.detalle_ticket_id_seq'::regclass);


--
-- TOC entry 4821 (class 2604 OID 16463)
-- Name: inventario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id SET DEFAULT nextval('public.inventario_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 16403)
-- Name: permiso id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso ALTER COLUMN id SET DEFAULT nextval('public.permiso_id_seq'::regclass);


--
-- TOC entry 4826 (class 2604 OID 16497)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 16453)
-- Name: proveedor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id SET DEFAULT nextval('public.proveedor_id_seq'::regclass);


--
-- TOC entry 4829 (class 2604 OID 16511)
-- Name: receta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta ALTER COLUMN id SET DEFAULT nextval('public.receta_id_seq'::regclass);


--
-- TOC entry 4825 (class 2604 OID 16477)
-- Name: rel_proveedor_inventario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario ALTER COLUMN id SET DEFAULT nextval('public.rel_proveedor_inventario_id_seq'::regclass);


--
-- TOC entry 4814 (class 2604 OID 16392)
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- TOC entry 4835 (class 2604 OID 16558)
-- Name: ticket id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket ALTER COLUMN id SET DEFAULT nextval('public.ticket_id_seq'::regclass);


--
-- TOC entry 4816 (class 2604 OID 16432)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 5055 (class 0 OID 16538)
-- Dependencies: 239
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.caja (id, id_usuario_apertura, id_usuario_cierre, fecha_apertura, fecha_cierre, monto_inicial, monto_final_sistema, monto_final_real, estado) FROM stdin;
\.


--
-- TOC entry 5053 (class 0 OID 16529)
-- Dependencies: 237
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cliente (id, nombre, telefono, email, nit_rfc, puntos_acumulados) FROM stdin;
\.


--
-- TOC entry 5059 (class 0 OID 16584)
-- Dependencies: 243
-- Data for Name: detalle_ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_ticket (id, id_ticket, id_producto, cantidad, precio_unitario, subtotal) FROM stdin;
\.


--
-- TOC entry 5045 (class 0 OID 16460)
-- Dependencies: 229
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventario (id, nombre, descripcion, stock_actual, stock_minimo, costo_promedio) FROM stdin;
\.


--
-- TOC entry 5038 (class 0 OID 16400)
-- Dependencies: 222
-- Data for Name: permiso; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permiso (id, nombre, codigo_interno) FROM stdin;
\.


--
-- TOC entry 5049 (class 0 OID 16494)
-- Dependencies: 233
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.producto (id, nombre, precio_venta, imagen_url, categoria, es_compuesto, activo) FROM stdin;
1	Café Americano	35.50	https://imgs.search.brave.com/EQd00rpPcsLOrWa6RzquKZ5LRFMstaSJzTszUARD0W0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zZW5z/b3JpYWwuY29mZmVl/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDI1/LzAyLzEwMi5qcGc	Bebidas Calientes	t	t
3	Cupcake	20.00	https://imgs.search.brave.com/Wymqgmv7uQCqhtanjyKeNgnjG_o1i2hePHqKrC5jRMY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvaGQvYmVz/dC1kZXNzZXJ0cy1i/YWNrZ3JvdW5kLTI3/MzIteC0yNzMyLW1o/MDRsa2x5aHA2cGdn/YWguanBn	Postres	t	t
2	Panque de chocolate	28.00	https://imgs.search.brave.com/5ZN1YfDVCX4Cwt-M-RWcDEm6JOA7ioA5C-Tucn4pLRU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/cmVjZXRhc25lc3Rs/ZS5jb20ubXgvc2l0/ZXMvZGVmYXVsdC9m/aWxlcy9zdHlsZXMv/Y3JvcHBlZF9yZWNp/cGVfY2FyZF9uZXcv/cHVibGljL3NyaF9y/ZWNpcGVzL2I3ZDQ3/ZDdkYmVmNTg4N2Nh/NTRhOWY5NTlhOWVi/ODAwLmpwZy53ZWJw/P2l0b2s9WGRuT1hX/MHY	Postres	t	t
4	Té de Matcha	37.00	https://imgs.search.brave.com/Ce5uIvGy0UZlLDuyPxFUm8WrRxnlORvlgeQ3woiUIUY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTg3/MDM4MTA3MC9waG90/by9kZWxpY2lvdXMt/bWF0Y2hhLWxhdHRl/LXBvd2Rlci1sZWFm/LWFuZC13aGlzay1v/bi13aGl0ZS10YWJs/ZS1mbGF0LWxheS5q/cGc_cz02MTJ4NjEy/Jnc9MCZrPTIwJmM9/WU5raVhZcEtOMkNG/LThaQ2hLUEZwWkND/OHFaeGFJN01oV3da/bDBMLXdzYz0	Bebidas Calientes	\N	t
\.


--
-- TOC entry 5043 (class 0 OID 16450)
-- Dependencies: 227
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.proveedor (id, nombre_empresa, nombre_contacto, telefono, email, activo) FROM stdin;
\.


--
-- TOC entry 5051 (class 0 OID 16508)
-- Dependencies: 235
-- Data for Name: receta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.receta (id, id_producto, id_inventario, cantidad_requerida) FROM stdin;
\.


--
-- TOC entry 5047 (class 0 OID 16474)
-- Dependencies: 231
-- Data for Name: rel_proveedor_inventario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rel_proveedor_inventario (id, id_proveedor, id_inventario, precio_ultimo_costo, codigo_catalogo_proveedor) FROM stdin;
\.


--
-- TOC entry 5036 (class 0 OID 16389)
-- Dependencies: 220
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rol (id, nombre, descripcion) FROM stdin;
1	Admin	Administrador del sistema
2	Empleado	Cajero y mesero
\.


--
-- TOC entry 5039 (class 0 OID 16411)
-- Dependencies: 223
-- Data for Name: roles_permisos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles_permisos (id_rol, id_permiso) FROM stdin;
\.


--
-- TOC entry 5057 (class 0 OID 16555)
-- Dependencies: 241
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ticket (id, id_caja, id_cliente, id_usuario, fecha_emision, total_venta, metodo_pago, estado) FROM stdin;
\.


--
-- TOC entry 5041 (class 0 OID 16429)
-- Dependencies: 225
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuario (id, id_rol, nombre_completo, email, password_hash, activo, fecha_creacion) FROM stdin;
1	1	Nestor Luna	admin@cafeteria.com	$2a$11$pbLGpQyKcZ0IBPvmXFbVhu/Xoap/xVh0CHcKQGT/yt7rVcBjey5vm	t	2025-11-22 18:33:23.51363
\.


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 238
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caja_id_seq', 1, false);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 236
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cliente_id_seq', 1, false);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 242
-- Name: detalle_ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_ticket_id_seq', 1, false);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 228
-- Name: inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventario_id_seq', 1, false);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 221
-- Name: permiso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.permiso_id_seq', 1, false);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 232
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.producto_id_seq', 4, true);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 226
-- Name: proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.proveedor_id_seq', 1, false);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 234
-- Name: receta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.receta_id_seq', 1, false);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 230
-- Name: rel_proveedor_inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rel_proveedor_inventario_id_seq', 1, false);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 219
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rol_id_seq', 3, true);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 240
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ticket_id_seq', 1, false);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 224
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_id_seq', 1, true);


--
-- TOC entry 4869 (class 2606 OID 16548)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 16536)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 4874 (class 2606 OID 16595)
-- Name: detalle_ticket detalle_ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket
    ADD CONSTRAINT detalle_ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4859 (class 2606 OID 16472)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 16410)
-- Name: permiso permiso_codigo_interno_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_codigo_interno_key UNIQUE (codigo_interno);


--
-- TOC entry 4847 (class 2606 OID 16408)
-- Name: permiso permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_pkey PRIMARY KEY (id);


--
-- TOC entry 4863 (class 2606 OID 16506)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4856 (class 2606 OID 16458)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 16517)
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 16482)
-- Name: rel_proveedor_inventario rel_proveedor_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario
    ADD CONSTRAINT rel_proveedor_inventario_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 16398)
-- Name: rol rol_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_nombre_key UNIQUE (nombre);


--
-- TOC entry 4843 (class 2606 OID 16396)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 16417)
-- Name: roles_permisos roles_permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_permisos
    ADD CONSTRAINT roles_permisos_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- TOC entry 4872 (class 2606 OID 16567)
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 16443)
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- TOC entry 4854 (class 2606 OID 16441)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 1259 OID 16608)
-- Name: idx_inventario_nombre; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_inventario_nombre ON public.inventario USING btree (nombre);


--
-- TOC entry 4870 (class 1259 OID 16607)
-- Name: idx_ticket_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ticket_fecha ON public.ticket USING btree (fecha_emision);


--
-- TOC entry 4850 (class 1259 OID 16606)
-- Name: idx_usuario_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_usuario_email ON public.usuario USING btree (email);


--
-- TOC entry 4882 (class 2606 OID 16549)
-- Name: caja fk_caja_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario FOREIGN KEY (id_usuario_apertura) REFERENCES public.usuario(id);


--
-- TOC entry 4886 (class 2606 OID 16601)
-- Name: detalle_ticket fk_detalle_producto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket
    ADD CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id);


--
-- TOC entry 4887 (class 2606 OID 16596)
-- Name: detalle_ticket fk_detalle_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ticket
    ADD CONSTRAINT fk_detalle_ticket FOREIGN KEY (id_ticket) REFERENCES public.ticket(id) ON DELETE CASCADE;


--
-- TOC entry 4880 (class 2606 OID 16523)
-- Name: receta fk_receta_inventario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_inventario FOREIGN KEY (id_inventario) REFERENCES public.inventario(id);


--
-- TOC entry 4881 (class 2606 OID 16518)
-- Name: receta fk_receta_producto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id) ON DELETE CASCADE;


--
-- TOC entry 4875 (class 2606 OID 16423)
-- Name: roles_permisos fk_rp_permiso; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_permisos
    ADD CONSTRAINT fk_rp_permiso FOREIGN KEY (id_permiso) REFERENCES public.permiso(id) ON DELETE CASCADE;


--
-- TOC entry 4876 (class 2606 OID 16418)
-- Name: roles_permisos fk_rp_rol; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_permisos
    ADD CONSTRAINT fk_rp_rol FOREIGN KEY (id_rol) REFERENCES public.rol(id) ON DELETE CASCADE;


--
-- TOC entry 4878 (class 2606 OID 16488)
-- Name: rel_proveedor_inventario fk_rpi_inventario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario
    ADD CONSTRAINT fk_rpi_inventario FOREIGN KEY (id_inventario) REFERENCES public.inventario(id);


--
-- TOC entry 4879 (class 2606 OID 16483)
-- Name: rel_proveedor_inventario fk_rpi_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rel_proveedor_inventario
    ADD CONSTRAINT fk_rpi_proveedor FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id);


--
-- TOC entry 4883 (class 2606 OID 16568)
-- Name: ticket fk_ticket_caja; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_caja FOREIGN KEY (id_caja) REFERENCES public.caja(id);


--
-- TOC entry 4884 (class 2606 OID 16573)
-- Name: ticket fk_ticket_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente(id);


--
-- TOC entry 4885 (class 2606 OID 16578)
-- Name: ticket fk_ticket_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id);


--
-- TOC entry 4877 (class 2606 OID 16444)
-- Name: usuario fk_usuario_rol; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES public.rol(id);


-- Completed on 2025-11-23 00:13:26

--
-- PostgreSQL database dump complete
--

\unrestrict CPVYAjuMxDBjKPjlRNha22P1HperbcodjGfgEXaTQdaIQfWKFzECXub8D1hsZUX

