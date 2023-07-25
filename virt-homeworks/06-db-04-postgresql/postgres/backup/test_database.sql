--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Debian 13.3-1.pgdg100+1)
-- Dumped by pg_dump version 13.3 (Debian 13.3-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_gt499; Type: TABLE; Schema: public; Owner: pgadmin
--

CREATE TABLE public.orders_gt499 (
    CONSTRAINT orders_gt499_price_check CHECK ((price > 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_gt499 OWNER TO pgadmin;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: orders_lt499; Type: TABLE; Schema: public; Owner: pgadmin
--

CREATE TABLE public.orders_lt499 (
    CONSTRAINT orders_lt499_price_check CHECK ((price <= 499))
)
INHERITS (public.orders);


ALTER TABLE public.orders_lt499 OWNER TO pgadmin;

--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_gt499 id; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_gt499 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_gt499 price; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_gt499 ALTER COLUMN price SET DEFAULT 0;


--
-- Name: orders_lt499 id; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_lt499 ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: orders_lt499 price; Type: DEFAULT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_lt499 ALTER COLUMN price SET DEFAULT 0;


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, title, price) FROM stdin;
\.


--
-- Data for Name: orders_gt499; Type: TABLE DATA; Schema: public; Owner: pgadmin
--

COPY public.orders_gt499 (id, title, price) FROM stdin;
2	My little database	500
6	WAL never lies	900
8	Dbiezdmin	501
\.


--
-- Data for Name: orders_lt499; Type: TABLE DATA; Schema: public; Owner: pgadmin
--

COPY public.orders_lt499 (id, title, price) FROM stdin;
1	War and peace	100
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
7	Me and my bash-pet	499
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 8, true);


--
-- Name: orders_gt499 orders_gt499__pkey; Type: CONSTRAINT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_gt499
    ADD CONSTRAINT orders_gt499__pkey PRIMARY KEY (id);


--
-- Name: orders_lt499 orders_lt499__pkey; Type: CONSTRAINT; Schema: public; Owner: pgadmin
--

ALTER TABLE ONLY public.orders_lt499
    ADD CONSTRAINT orders_lt499__pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: orders orders_insert_499_or_less; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE orders_insert_499_or_less AS
    ON INSERT TO public.orders
   WHERE (new.price <= 499) DO INSTEAD  INSERT INTO public.orders_lt499 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- Name: orders orders_insert_over_499; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE orders_insert_over_499 AS
    ON INSERT TO public.orders
   WHERE (new.price > 499) DO INSTEAD  INSERT INTO public.orders_gt499 (id, title, price)
  VALUES (new.id, new.title, new.price);


--
-- PostgreSQL database dump complete
--

